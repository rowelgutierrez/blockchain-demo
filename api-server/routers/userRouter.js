const express = require('express');
const { getUser, inviteUser, registerUser } = require('../controllers/userController');

const router = express.Router();

router.get('/:email', async (req, res, next) => {
    const user = await getUser(req.params.emailAddr);
    res.setHeader('Content-Type', 'application/json');
    res.status(200).json(user);
});

router.post('/invite', async (req, res, next) => {
    const user = {
        emailAddr: req.body.emailAddr,
        fullname: req.body.fullname,
        inviterEmailAddr: req.body.inviterEmailAddr
    };

    await inviteUser(user);

    res.setHeader('Content-Type', 'application/json');
    res.status(200).json({message: 'User successfully invited'});
});

router.post('/register', async (req, res, next) => {
    const user = {
        emailAddr: req.body.emailAddr,
        fullname: req.body.fullname
    };

    await registerUser(user);

    res.setHeader('Content-Type', 'application/json');
    res.status(200).json({message: 'User successfully registered'});
});

exports.router = router;