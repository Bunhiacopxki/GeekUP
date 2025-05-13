const TestRouter = require('./TestRouter');
const OrderRouter = require('./OrderRouter');
const UserRouter = require('./UserRouter');
const ProductRouter = require('./ProductRouter');

const routes = (app) => {
    app.use('/test', TestRouter);
    app.use('/order', OrderRouter);
    app.use('/user', UserRouter);
    app.use('/product', ProductRouter);
}

module.exports = routes;