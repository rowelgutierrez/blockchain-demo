'use strict';

const { FileSystemWallet, Gateway } = require('fabric-network');
const fs = require('fs');
const path = require('path');
const process = require('process');
const walletPath = path.join('/', 'var', 'hyperledger', 'wallet');

exports.UserModel = class UserModel {
    constructor() {}

    getConnectionProfile = () => {
        const devMode = process.env['DEV_MODE'];
        let ccpPath;

        if(devMode === 'true') {
            ccpPath = process.env['JSON_DEV_CONNECTION'];
        } else {
            ccpPath = path.join(process.env['JSON_CONNECTION_DIR'], 'connection.json');
        }

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

    getContract = async () => {
        const ccp = this.getConnectionProfile();
        const wallet = await this.getWallet();
        const gateway = await this.gatewayConnect(ccp, wallet);
        
        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('userschannel');

        // Get the contract from the network.
        // const contract = await network.getContract('userm', 'com.imfreemobile.user');
        const contract = await network.getContract('userm');

        return contract;
    }

    get = async (emailAddr) => {
        const contract = await this.getContract();
        const result = await contract.evaluateTransaction('getUserByEmail', emailAddr);
        
        await gateway.disconnect();

        return result;
    }

    invite = async (emailAddr, fullname, inviterEmailAddr) => {
        const contract = await this.getContract();
        // const result = 
        await contract.submitTransaction('invite', emailAddr, fullname, inviterEmailAddr);
        
        await gateway.disconnect();

        // return result;
    }

    register = async (emailAddr, fullname) => {
        const contract = await this.getContract();
        // const result = 
        await contract.submitTransaction('register', emailAddr, fullname);
        
        await gateway.disconnect();

        // return result;
    }
}