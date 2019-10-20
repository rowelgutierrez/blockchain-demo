/*
SPDX-License-Identifier: Apache-2.0
*/

'use strict';

// Fabric smart contract classes
const { Contract, Context } = require('fabric-contract-api');

// Chaincode schema definition
const User = require('./user.js');
const UserList = require('./userlist.js');

/**
 * A custom context provides easy access to list of all users
 */
class UserContext extends Context {

    constructor() {
        super();
        // All users are held in a list of users
        this.userList = new UserList(this);
    }

}

/**
 * Define user smart contract by extending Fabric Contract class
 *
 */
class UserContract extends Contract {

    constructor() {
        // Unique namespace when multiple contracts per chaincode file
        super('com.imfreemobile.user');
    }

    /**
     * Define a custom context for user
    */
    createContext() {
        return new UserContext();
    }

    /**
     * Instantiate to perform any setup of the ledger that might be required.
     * @param {Context} ctx the transaction context
     */
    async instantiate(ctx) {
        // No implementation required with this example
        // It could be where data migration is performed, if necessary
        console.log('Instantiate the contract');
    }

    /**
     * Invite user
     *
     * @param {Context} ctx the transaction context
     * @param {String} emailAddr the email address of the user
     * @param {String} fullname the full name of the user
     * @param {String} inviterEmailAddr the email address who invited the potential user
    */
    async invite(ctx, emailAddr, fullname, inviterEmailAddr) {

        // create an instance of the user
        const newUser = User.createInstance(emailAddr, fullname);
        newUser.setInviter(inviterEmailAddr);
        await ctx.userList.addUser(newUser);

        // Must return a serialized paper to caller of smart contract
        // return newUser.toBuffer();
        return newUser.toString();
    }

    /**
     * Register user
     *
     * @param {Context} ctx the transaction context
     * @param {String} emailAddr the email address of the user
     * @param {String} fullname the full name of the user
    */
    async register(ctx, emailAddr, fullname) {

        // Retrieve the current user using key fields provided
        let userKey = User.makeKey([emailAddr]);
        let newUser = await ctx.userList.getUser(userKey);

        if(newUser) {
            // Register user
            newUser.setFullname(fullname);
            newUser.setRegistered();
            await ctx.userList.updateUser(newUser);

            // Add reward to inviter
            const inviterEmailAddr = newUser.getInviter();
            const inviterKey = User.makeKey([inviterEmailAddr]);
            const inviter = await ctx.userList.getUser(inviterKey);
            inviter.updateWallet(10);
            await ctx.userList.updateUser(inviter);
        } else {
            // create an instance of the user
            const newUser = User.createInstance(emailAddr, fullname);
            newUser.setRegistered();
            await ctx.userList.addUser(newUser);
        }

        // return newUser.toBuffer();
        return newUser.toString();
    }
    
    /**
     * Get user by email address
     */
    async getUserByEmail(ctx, emailAddr) {
        // Retrieve the current user using key fields provided
        let userKey = User.makeKey([emailAddr]);
        let user = await ctx.userList.getUser(userKey);

        if(newUser) {
            // return user.toBuffer();
            return user.toString();
        } else {
            return null;
        }
    }

}

module.exports = UserContract;
