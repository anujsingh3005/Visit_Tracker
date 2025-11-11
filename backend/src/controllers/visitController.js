const prisma = require('../config/db');

/**
 * Helper to map a user's uid to internal integer id.
 * If salespersonUid is undefined, and reqUser exists, use reqUser.id.
 */
async function resolveSalespersonId(salespersonUid, reqUser) {
  if (salespersonUid) {
    const u = await prisma.user.findUnique({ where: { uid: salespersonUid } });
    if (!u) throw { status: 400, message: 'Invalid salespersonUid' };
    return u.id;
  }
  if (reqUser) return reqUser.id;
  throw { status: 400, message: 'salesperson not specified' };
}

exports.createVisit = async (req, res, next) => {
  try {
    // Accept salespersonUid (string) or use authenticated user
    const {
      salespersonUid,
      clientName,
      contactPersonName,
      clientPhone,
      clientAddress,
      clientDetails,
      startTime,
      endTime,
      status = 'pending'
    } = req.body;

    const salespersonId = await resolveSalespersonId(salespersonUid, req.user);
    if (!clientName || !contactPersonName) return res.status(400).json({ error: 'clientName and contactPersonName required' });

    const visit = await prisma.visit.create({
      data: {
        salespersonId,
        clientName,
        contactPersonName,
        clientPhone,
        clientAddress,
        clientDetails,
        startTime: new Date(startTime),
        endTime: endTime ? new Date(endTime) : null,
        status
      }
    });

    // Attach uid on response for frontend convenience
    const sp = await prisma.user.findUnique({ where: { id: salespersonId } });

    res.status(201).json({
      ...visit,
      salespersonUid: sp.uid
    });
  } catch (err) {
    next(err);
  }
};

exports.listVisits = async (req, res, next) => {
  try {
    // If manager: allow query param ?salespersonUid=... to filter, else return all.
    // If salesperson: return only their visits.
    const requester = req.user;
    const { salespersonUid } = req.query;

    let where = {};
    if (requester.role === 'salesperson') {
      where = { salespersonId: requester.id };
    } else {
      if (salespersonUid) {
        const u = await prisma.user.findUnique({ where: { uid: salespersonUid } });
        if (!u) return res.status(400).json({ error: 'invalid salespersonUid' });
        where = { salespersonId: u.id };
      } else {
        // no filter => all visits
        where = {};
      }
    }

    const visits = await prisma.visit.findMany({
      where,
      orderBy: { startTime: 'desc' },
      include: { salesperson: true }
    });

    // map salespersonUid in response
    const mapped = visits.map(v => ({
      id: v.id,
      salespersonUid: v.salesperson.uid,
      clientName: v.clientName,
      contactPersonName: v.contactPersonName,
      clientPhone: v.clientPhone,
      clientAddress: v.clientAddress,
      clientDetails: v.clientDetails,
      startTime: v.startTime,
      endTime: v.endTime,
      status: v.status,
      createdAt: v.createdAt
    }));

    res.json(mapped);
  } catch (err) {
    next(err);
  }
};

exports.getVisit = async (req, res, next) => {
  try {
    const { id } = req.params;
    const requester = req.user;
    const visit = await prisma.visit.findUnique({ where: { id: Number(id) }, include: { salesperson: true } });
    if (!visit) return res.status(404).json({ error: 'not found' });

    // Access control: salesperson only can access own visit
    if (requester.role === 'salesperson' && visit.salespersonId !== requester.id) {
      return res.status(403).json({ error: 'forbidden' });
    }

    res.json({
      id: visit.id,
      salespersonUid: visit.salesperson.uid,
      clientName: visit.clientName,
      contactPersonName: visit.contactPersonName,
      clientPhone: visit.clientPhone,
      clientAddress: visit.clientAddress,
      clientDetails: visit.clientDetails,
      startTime: visit.startTime,
      endTime: visit.endTime,
      status: visit.status,
      createdAt: visit.createdAt
    });
  } catch (err) {
    next(err);
  }
};

exports.updateVisit = async (req, res, next) => {
  try {
    const { id } = req.params;
    const requester = req.user;
    const payload = req.body;

    // Ensure visit exists
    const visit = await prisma.visit.findUnique({ where: { id: Number(id) } });
    if (!visit) return res.status(404).json({ error: 'not found' });

    if (requester.role === 'salesperson' && visit.salespersonId !== requester.id) {
      return res.status(403).json({ error: 'forbidden' });
    }

    const data = {};
    if (payload.clientName !== undefined) data.clientName = payload.clientName;
    if (payload.contactPersonName !== undefined) data.contactPersonName = payload.contactPersonName;
    if (payload.clientPhone !== undefined) data.clientPhone = payload.clientPhone;
    if (payload.clientAddress !== undefined) data.clientAddress = payload.clientAddress;
    if (payload.clientDetails !== undefined) data.clientDetails = payload.clientDetails;
    if (payload.startTime !== undefined) data.startTime = new Date(payload.startTime);
    if (payload.endTime !== undefined) data.endTime = payload.endTime ? new Date(payload.endTime) : null;
    if (payload.status !== undefined) data.status = payload.status;

    await prisma.visit.update({
      where: { id: Number(id) },
      data
    });

    // return updated
    const updated = await prisma.visit.findUnique({ where: { id: Number(id) }, include: { salesperson: true } });
    res.json({
      id: updated.id,
      salespersonUid: updated.salesperson.uid,
      clientName: updated.clientName,
      contactPersonName: updated.contactPersonName,
      clientPhone: updated.clientPhone,
      clientAddress: updated.clientAddress,
      clientDetails: updated.clientDetails,
      startTime: updated.startTime,
      endTime: updated.endTime,
      status: updated.status,
      createdAt: updated.createdAt
    });
  } catch (err) {
    next(err);
  }
};

exports.deleteVisit = async (req, res, next) => {
  try {
    const { id } = req.params;
    const requester = req.user;
    const visit = await prisma.visit.findUnique({ where: { id: Number(id) } });
    if (!visit) return res.status(404).json({ error: 'not found' });

    if (requester.role === 'salesperson' && visit.salespersonId !== requester.id) {
      return res.status(403).json({ error: 'forbidden' });
    }

    await prisma.visit.delete({ where: { id: Number(id) } });
    res.json({ ok: true });
  } catch (err) {
    next(err);
  }
};

/**
 * Summary endpoint: GET /api/visits/summary/:salespersonUid
 * Returns { planned: X, completed: Y }
 */
exports.summary = async (req, res, next) => {
  try {
    const { salespersonUid } = req.params;
    const requester = req.user;

    // Manager can request for any salespersonUid; salesperson can request their own only.
    if (requester.role === 'salesperson' && requester.uid !== salespersonUid) {
      return res.status(403).json({ error: 'forbidden' });
    }

    const user = await prisma.user.findUnique({ where: { uid: salespersonUid } });
    if (!user) return res.status(400).json({ error: 'invalid salespersonUid' });

    const planned = await prisma.visit.count({ where: { salespersonId: user.id, status: 'pending' } });
    const completed = await prisma.visit.count({ where: { salespersonId: user.id, status: 'done' } });

    res.json({ planned, completed });
  } catch (err) {
    next(err);
  }
};
