const jwt = require('jsonwebtoken');
const prisma = require('../config/db');

const JWT_SECRET = process.env.JWT_SECRET || 'secret';

module.exports = async (req, res, next) => {
  const auth = req.headers.authorization;
  if (!auth || !auth.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'Unauthorized' });
  }

  const token = auth.split(' ')[1];
  try {
    const payload = jwt.verify(token, JWT_SECRET);
    // payload contains uid and id and role from token creation
    // fetch fresh user to attach integer id and role
    const user = await prisma.user.findUnique({ where: { uid: payload.uid } });
    if (!user) return res.status(401).json({ error: 'Unauthorized' });

    // attach minimal public info and internal id
    req.user = { id: user.id, uid: user.uid, role: user.role };
    next();
  } catch (err) {
    return res.status(401).json({ error: 'Invalid token' });
  }
};
