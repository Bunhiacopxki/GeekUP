const path = require('path');
const express = require('express');
const cors = require('cors');
const routes = require('./routes');
const cookieParser = require('cookie-parser');
const app = express();
const port = process.env.PORT;
const session = require('express-session');
require('dotenv').config();

app.use(cors({
  origin: "*",
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: true
}));

app.use(express.static(path.join(__dirname, 'public')));
app.use(express.json());
app.use(cookieParser());
app.use(session({
  secret: 'abcxyz',
  resave: false,
  saveUninitialized: true,
  cookie: { 
    secure: false, 
    maxAge: 30 * 24 * 60 * 60 * 1000
  } 
}));

routes(app);

app.listen(port, () => {
  console.log('Server is running on port ' + port);
});