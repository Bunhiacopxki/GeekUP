const UserService = require('../services/UserService')

class UserController {
    Churn = async (req, res) => {
        try {
            const result = await UserService.Churn();
            return res.status(200).send(result);
        } catch(err) {
            return res.status(404).json(err);
        }
    }
}

module.exports = new UserController