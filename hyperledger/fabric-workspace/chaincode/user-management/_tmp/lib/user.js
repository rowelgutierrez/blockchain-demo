/*
SPDX-License-Identifier: Apache-2.0
*/

'use strict';

// Utility class for ledger state
const State = require('./../ledger-api/state.js');

// Enumerate user state values
const cpState = {
    INVITED: 1,
    REGISTERED: 2,
    // ONBOARDED: 3
};

/**
 * User class extends State class
 * Class will be used by application and smart contract to define a user
 */
class User extends State {

    constructor(obj) {
        super(User.getClass(), [obj.emailAddr]);
        Object.assign(this, obj);
    }

    /**
     * Basic getters and setters
    */

    getInviter() {
        return this.inviterEmailAddr;
    }

    setInviter(inviterEmailAddr) {
        this.inviterEmailAddr = inviterEmailAddr;
        this.currentState = cpState.INVITED;
    }

    getFullname() {
        return this.fullname;
    }

    setFullname(fullname) {
        this.fullname = fullname;
    }

    /**
     * Useful methods to encapsulate commercial user states
     */
    updateWallet(amount) {
        if(this.walletAmount) {
            this.walletAmount += Number(amount).toFixed(2);
        } else {
            this.walletAmount = Number(0).toFixed(2);
        }
    }

    setRegistered() {
        this.currentState = cpState.REGISTERED;
    }

    isInvited() {
        return this.currentState === cpState.INVITED;
    }

    isRegistered() {
        return this.currentState === cpState.REGISTERED;
    }

    static fromBuffer(buffer) {
        return User.deserialize(Buffer.from(JSON.parse(buffer)));
    }

    toBuffer() {
        return Buffer.from(JSON.stringify(this));
    }

    /**
     * Deserialize a state data to user
     * @param {Buffer} data to form back into the object
     */
    static deserialize(data) {
        return State.deserializeClass(data, User);
    }

    /**
     * Factory method to create a user object
     */
    static createInstance(emailAddress, fullname) {
        return new User({ emailAddress, fullname });
    }

    static getClass() {
        return 'com.imfreemobile.user';
    }
}

module.exports = User;
