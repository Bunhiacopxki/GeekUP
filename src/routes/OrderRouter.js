const express = require("express");
const router = express.Router();
const OrderController = require('../controllers/OrderController');

router.post('/order', OrderController.Order)
router.get('/value', OrderController.Value)
router.post('/payment', OrderController.Payment)
router.get('/bank', OrderController.Bank)


module.exports = router