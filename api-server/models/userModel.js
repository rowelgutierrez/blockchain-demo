'use strict';

const { FileSystemWallet, Gateway } = require('fabric-network');
const fs = require('fs');
const path = require('path');
const process = require('process');
const walletPath = path.join('/', 'var', 'hyperledger', 'wallet');

exports.UserModel = class UserModel {
    constructor() {
        this.ccp = this.getConnectionProfile();
        this.wallet = await this.getWallet();
    }

    getConnectionProfile = () => {
        let ccpPath = process.env['JSON_CONNECTION_PROFILE'];
        const ccpJSON = fs.readFileSync(ccpPath, 'utf8');
        return JSON.parse(ccpJSON);
    }

    getWallet = async () => {
        const wallet = new FileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

        // Check to see if we've already enrolled the user.
        const userExists = await wallet.exists('user1');

        return wallet;
    }

    gatewayConnect = async (ccp, wallet) => {
        // Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'user1', discovery: { enabled: false } });
        return gateway;
    }

    getContract = async (gateway) => {
        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('userschannel');

        // Get the contract from the network.
        // const contract = await network.getContract('userm', 'com.imfreemobile.user');
        const contract = await network.getContract('userm');

        return contract;
    }

    get = async (userId) => {
        const gateway = await this.gatewayConnect(this.ccp, this.wallet);
        const contract = await this.getContract(gateway);

        const result = await contract.evaluateTransaction('queryUser', userId);
        
        await gateway.disconnect();

        return result;
    }

    invite = async (userId, emailAddr, fullname, inviterId) => {
        const gateway = await this.gatewayConnect(this.ccp, this.wallet);
        const contract = await this.getContract(gateway);
        
        await contract.submitTransaction('inviteUser', userId, emailAddr, fullname, inviterId);
        
        await gateway.disconnect();
    }

    register = async (userId, emailAddr, fullname) => {
        const gateway = await this.gatewayConnect(this.ccp, this.wallet);
        const contract = await this.getContract(gateway);
        
        await contract.submitTransaction('registerUser', userId, emailAddr, fullname);
        
        await gateway.disconnect();
    }
}