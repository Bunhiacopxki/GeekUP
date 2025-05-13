const express = require("express");
const router = express.Router();
const TestController = require('../controllers/TestController');

router.get('/a', TestController.test)

module.exports = router