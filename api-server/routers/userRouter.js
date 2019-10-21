const express = require('express');
const { getUser, inviteUser, registerUser } = require('../controllers/userController');

const router = express.Router();

router.get('/:id', async (req, res) => {
    const user = await getUser(req.params.id);
    res.setHeader('Content-Type', 'application/json');

    if (user) {
        res.status(200).json(user);
    } else {
        res.status(200).json({
            "msg": "User not found"
        });
    }
});

router.post('/invite', async (req, res) => {
    const user = {
        id: req.body.id,
        emailAddr: req.body.emailAddr,
        fullname: req.body.fullname,
        inviter: req.body.inviter
    };

    await inviteUser(user);

    res.setHeader('Content-Type', 'application/json');
    res.status(200).json({message: 'User successfully invited'});
});

router.post('/register', async (req, res) => {
    const user = {
        id: req.body.id,
        emailAddr: req.body.emailAddr,
        fullname: req.body.fullname
    };

    await registerUser(user);

    res.setHeader('Content-Type', 'application/json');
    res.status(200).json({message: 'User successfully registered'});
});

exports.router = router;