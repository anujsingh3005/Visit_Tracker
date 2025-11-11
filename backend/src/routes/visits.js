const express = require('express');
const router = express.Router();
const auth = require('../middlewares/authMiddleware');
const controller = require('../controllers/visitController');

router.use(auth);

// CRUD
router.get('/', controller.listVisits);
router.get('/summary/:salespersonUid', controller.summary); // manager or same salesperson only
router.post('/', controller.createVisit);
router.get('/:id', controller.getVisit);
router.put('/:id', controller.updateVisit);
router.delete('/:id', controller.deleteVisit);

module.exports = router;
