/*
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const { Contract } = require('fabric-contract-api');

class User extends Contract {

    async getUser(ctx, userId) {
        const userAsBytes = await ctx.stub.getState(userId); // get the car from chaincode state
        if (userAsBytes && userAsBytes.length > 0) {
            return JSON.parse(userAsBytes.toString());
        }
        
        return null;
    }

    async queryUser(ctx, userId) {
        const user = await this.getUser(ctx, userId);

        if(!user) {
            throw new Error(`${userId} does not exist`);
        }

        return JSON.stringify(user);
    }

    async inviteUser(ctx, userId, emailAddr, fullname, inviterId) {
        const user = {
            emailAddr,
            fullname,
            inviterId,
            status: 'INVITED',
            wallet: 0
        };

        await ctx.stub.putState(userId, Buffer.from(JSON.stringify(user)));
    }

    async registerUser(ctx, userId, emailAddr, fullname) {
        const newUser = await this.getUser(ctx, userId);

        if(!newUser) {
            return;
        }

        newUser.emailAddr = emailAddr;
        newUser.fullname = fullname;
        newUser.status = 'REGISTERED';
        newUser.wallet = 0;

        const inviterId = newUser.inviterId;

        if(inviterId) {
            await this.updateWallet(ctx, inviterId, 10);
        }

        await ctx.stub.putState(userId, Buffer.from(JSON.stringify(newUser)));
    }

    async updateWallet(ctx, userId, amount) {
        const user = await this.getUser(ctx, userId);
        user.wallet += amount;

        await ctx.stub.putState(userId, Buffer.from(JSON.stringify(user)));
    }

}

module.exports = User;
