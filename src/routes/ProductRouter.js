const express = require("express");
const router = express.Router();
const ProductController = require('../controllers/ProductController');

router.get('/category_list', ProductController.CategoryList);
router.post('/category_product', ProductController.CategoryProduct);
router.post('/search_product', ProductController.Search);

module.exports = router