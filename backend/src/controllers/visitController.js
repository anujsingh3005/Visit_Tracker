const prisma = require("../config/db");
const cloudinary = require("../config/cloudinary");
const { extractExifData, softValidate } = require("../utils/exifUtils");
const streamifier = require("streamifier");

// ---------- CREATE (PLAN VISIT) ----------
exports.planVisit = async (req, res, next) => {
  try {
    const {
      clientName,
      contactPersonName,
      clientPhone,
      clientAddress,
      clientDetails,
    } = req.body;

    const visit = await prisma.visit.create({
      data: {
        salespersonId: req.user.id,
        clientName,
        contactPersonName,
        clientPhone,
        clientAddress,
        clientDetails,
        status: "planned",
      },
    });

    res.status(201).json(visit);
  } catch (err) {
    next(err);
  }
};

// ---------- READ ALL ----------
exports.listVisits = async (req, res, next) => {
  try {
    const { status } = req.query; // optional filter
    const where = { salespersonId: req.user.id };
    if (status) where.status = status;

    const visits = await prisma.visit.findMany({
      where,
      orderBy: { createdAt: "desc" },
    });

    res.json(visits);
  } catch (err) {
    next(err);
  }
};

// ---------- READ ONE ----------
exports.getVisit = async (req, res, next) => {
  try {
    const { id } = req.params;
    const visit = await prisma.visit.findUnique({
      where: { id: Number(id) },
    });

    if (!visit) return res.status(404).json({ error: "Visit not found" });
    if (visit.salespersonId !== req.user.id)
      return res.status(403).json({ error: "Unauthorized" });

    res.json(visit);
  } catch (err) {
    next(err);
  }
};

// ---------- UPDATE (EDIT PLANNED VISIT) ----------
exports.updateVisit = async (req, res, next) => {
  try {
    const { id } = req.params;
    const visit = await prisma.visit.findUnique({ where: { id: Number(id) } });

    if (!visit) return res.status(404).json({ error: "Visit not found" });
    if (visit.salespersonId !== req.user.id)
      return res.status(403).json({ error: "Unauthorized" });
    if (visit.status !== "planned")
      return res.status(400).json({ error: "Cannot edit after start" });

    const updated = await prisma.visit.update({
      where: { id: Number(id) },
      data: req.body,
    });

    res.json(updated);
  } catch (err) {
    next(err);
  }
};

// ---------- DELETE (CANCEL PLANNED VISIT) ----------
exports.deleteVisit = async (req, res, next) => {
  try {
    const { id } = req.params;
    const visit = await prisma.visit.findUnique({ where: { id: Number(id) } });

    if (!visit) return res.status(404).json({ error: "Visit not found" });
    if (visit.salespersonId !== req.user.id)
      return res.status(403).json({ error: "Unauthorized" });
    if (visit.status !== "planned")
      return res.status(400).json({ error: "Cannot delete after start" });

    await prisma.visit.delete({ where: { id: Number(id) } });
    res.json({ ok: true, message: "Visit deleted successfully" });
  } catch (err) {
    next(err);
  }
};

// ---------- START VISIT ----------
exports.startVisit = async (req, res, next) => {
  try {
    const { visitId, startLat, startLong } = req.body;
    const fileBuffer = req.file.buffer;

    const visit = await prisma.visit.findUnique({
      where: { id: Number(visitId) },
    });

    if (!visit) return res.status(404).json({ error: "Visit not found" });
    if (visit.salespersonId !== req.user.id)
      return res.status(403).json({ error: "Unauthorized" });
    if (visit.status !== "planned")
      return res.status(400).json({ error: "Visit already started or done" });

    const uploadStream = cloudinary.uploader.upload_stream(
      { folder: "visit-tracking/entry" },
      async (error, result) => {
        if (error) return next(error);

        const exif = await extractExifData(fileBuffer);
        const flags = softValidate(
          { lat: parseFloat(startLat), long: parseFloat(startLong) },
          exif
        );

        const updated = await prisma.visit.update({
          where: { id: Number(visitId) },
          data: {
            status: "in-progress",
            startTime: new Date(),
            startLat: parseFloat(startLat),
            startLong: parseFloat(startLong),
            entryImageUrl: result.secure_url,
            suspiciousFlags: flags,
          },
        });

        res.json(updated);
      }
    );

    streamifier.createReadStream(fileBuffer).pipe(uploadStream);
  } catch (err) {
    next(err);
  }
};

// ---------- END VISIT ----------
exports.endVisit = async (req, res, next) => {
  try {
    const { visitId, endLat, endLong } = req.body;
    const fileBuffer = req.file.buffer;

    const visit = await prisma.visit.findUnique({
      where: { id: Number(visitId) },
    });

    if (!visit) return res.status(404).json({ error: "Visit not found" });
    if (visit.salespersonId !== req.user.id)
      return res.status(403).json({ error: "Unauthorized" });
    if (visit.status !== "in-progress")
      return res.status(400).json({ error: "Visit not in progress" });

    const uploadStream = cloudinary.uploader.upload_stream(
      { folder: "visit-tracking/exit" },
      async (error, result) => {
        if (error) return next(error);

        const exif = await extractExifData(fileBuffer);
        const flags = softValidate(
          { lat: parseFloat(endLat), long: parseFloat(endLong) },
          exif
        );

        const combinedFlags = [...(visit.suspiciousFlags || []), ...flags];

        const updated = await prisma.visit.update({
          where: { id: Number(visitId) },
          data: {
            status: "done",
            endTime: new Date(),
            endLat: parseFloat(endLat),
            endLong: parseFloat(endLong),
            exitImageUrl: result.secure_url,
            suspiciousFlags: combinedFlags,
          },
        });

        res.json(updated);
      }
    );

    streamifier.createReadStream(fileBuffer).pipe(uploadStream);
  } catch (err) {
    next(err);
  }
};
