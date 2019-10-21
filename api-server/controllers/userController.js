const { UserModel } = require('../models/userModel');
const userModel = new UserModel();

exports.getUser = async (id) => {
    return await userModel.get(id);
}

exports.inviteUser = async (user) => {
    await userModel.invite(user.id, user.emailAddr, user.fullname, user.inviter);
}

exports.registerUser = async (user) => {
    await userModel.register(user.id, user.emailAddr, user.fullname);
}