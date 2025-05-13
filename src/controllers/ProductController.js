const ProductService = require('../services/ProductService')

class ProductController {
    Churn = async (req, res) => {
        try {
            const result = await ProductService.Churn(req.body);
            return res.status(200).send(result);
        } catch(err) {
            return res.status(404).json(err);
        }
    }

    CategoryList = async (req, res) => {
        try {
            const result = await ProductService.CategoryList(req.body);
            return res.status(200).send(result);
        } catch(err) {
            return res.status(404).json(err);
        }
    }

    CategoryProduct = async (req, res) => {
        try {
            const result = await ProductService.CategoryProduct(req.body);
            return res.status(200).send(result);
        } catch(err) {
            return res.status(404).json(err);
        }
    }

    Search = async (req, res) => {
        try {
            const result = await ProductService.Search(req.body);
            return res.status(200).send(result);
        } catch(err) {
            return res.status(404).json(err);
        }
    }
}

module.exports = new ProductController