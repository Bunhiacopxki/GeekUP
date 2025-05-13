const express = require("express");
const router = express.Router();
const UserController = require('../controllers/UserController');

router.get('/churn', UserController.Churn)

module.exports = router