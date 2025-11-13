const express = require("express");
const router = express.Router();
const auth = require("../middlewares/authMiddleware");
const controller = require("../controllers/visitController");

const multer = require("multer");
const storage = multer.memoryStorage();
const upload = multer({ storage });

router.use(auth);

// CRUD
router.post("/plan", controller.planVisit);
router.get("/", controller.listVisits);
router.get("/:id", controller.getVisit);
router.put("/:id", controller.updateVisit);
router.delete("/:id", controller.deleteVisit);

// Start / End Visit (multipart)
router.post("/start", upload.single("entryImage"), controller.startVisit);
router.post("/end", upload.single("exitImage"), controller.endVisit);

module.exports = router;

