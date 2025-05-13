const mysql = require('mysql2');
require('dotenv').config();
const { DB_PAS, DB_USER } = process.env

const connection = mysql.createConnection({
    host: "localhost",
    user: DB_USER,
    password: DB_PAS,
    database: "cv"
}).promise();

connection.connect((err) => {
    if (err) {
        console.error('Error connecting to MySQL database:', err.stack);
        return;
    }
    console.log('Connected to MySQL database as id ' + connection.threadId);
});

module.exports = connection;