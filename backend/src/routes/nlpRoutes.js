const router = require("express").Router();
const auth = require("../middlewares/authMiddleware");
const controller = require("../controllers/NLPcontroller");

router.post("/query", auth, controller.query);

module.exports = router;
