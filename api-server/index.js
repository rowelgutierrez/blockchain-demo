const express = require('express');
const bodyParser = require('body-parser');
const userRoutes = require('./routers/userRouter');

const app = express();

app.use(bodyParser.json());

app.use('/user', userRoutes.router);

app.listen(8081, () => {
    console.log('Listening on port 8081');
});