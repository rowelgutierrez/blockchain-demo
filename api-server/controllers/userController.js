const { UserModel } = require('../models/userModel');
const userModel = new UserModel();

exports.getUser = async (emailAddr) => {
    return await userModel.get(emailAddr);
}

exports.inviteUser = async (user) => {
    await userModel.invite(user.emailAddr, user.fullname, user.inviter);
}

exports.registerUser = async (user) => {
    await userModel.register(user.emailAddr, user.fullname);
}