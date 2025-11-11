const prisma = require('../config/db');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { v4: uuidv4 } = require('uuid');

const JWT_SECRET = process.env.JWT_SECRET || 'secret';

function publicUser(user) {
  return {
    uid: user.uid,
    email: user.email,
    name: user.name,
    role: user.role,
    phone: user.phone,
    address: user.address,
    designation: user.designation,
    profileImageUrl: user.profileImageUrl,
  };
}

exports.signup = async (req, res, next) => {
  try {
    const { name, email, password, role = 'salesperson', phone = '', address = '', designation = '', profileImageUrl } = req.body;
    if (!email || !password || !name) return res.status(400).json({ error: 'name, email and password required' });

    const existing = await prisma.user.findUnique({ where: { email } });
    if (existing) return res.status(400).json({ error: 'email already in use' });

    const hashed = await bcrypt.hash(password, 10);
    const uid = uuidv4();

    const user = await prisma.user.create({
      data: {
        uid,
        name,
        email,
        password: hashed,
        role,
        phone,
        address,
        designation,
        profileImageUrl
      }
    });

    const token = jwt.sign({ uid: user.uid, id: user.id, role: user.role }, JWT_SECRET, { expiresIn: '7d' });
    res.status(201).json({ token, user: publicUser(user) });
  } catch (err) {
    next(err);
  }
};

exports.login = async (req, res, next) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) return res.status(400).json({ error: 'email and password required' });

    const user = await prisma.user.findUnique({ where: { email } });
    if (!user) return res.status(400).json({ error: 'invalid credentials' });

    const ok = await bcrypt.compare(password, user.password);
    if (!ok) return res.status(400).json({ error: 'invalid credentials' });

    const token = jwt.sign({ uid: user.uid, id: user.id, role: user.role }, JWT_SECRET, { expiresIn: '7d' });
    res.json({ token, user: publicUser(user) });
  } catch (err) {
    next(err);
  }
};
