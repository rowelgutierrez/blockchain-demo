'use strict';

const { FileSystemWallet, Gateway } = require('fabric-network');
const fs = require('fs');
const path = require('path');
const process = require('process');
const walletPath = path.join('/', 'var', 'hyperledger', 'wallet');

exports.UserModel = class UserModel {
    constructor() {}

    gatewayConnect = async () => {
        if (!this.ccp) {
            let ccpPath = process.env['JSON_CONNECTION_PROFILE'];
            const ccpJSON = fs.readFileSync(ccpPath, 'utf8');
            this.ccp = JSON.parse(ccpJSON);
        }

        if (!this.wallet) {
            this.wallet = new FileSystemWallet(walletPath);
            console.log(`Wallet path: ${walletPath}`);
    
            // Check to see if we've already enrolled the user.
            const userExists = await this.wallet.exists('user1');

            if (!userExists) {
                // throw new Error(`User "user1" does not exist`)
                console.error(`User "user1" does not exist`);
            }
        }

        // Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();
        await gateway.connect(this.ccp, { wallet: this.wallet, identity: 'user1', discovery: { enabled: false } });
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
        let gateway;
        let result;

        try {
            gateway = await this.gatewayConnect();
            const contract = await this.getContract(gateway);

            result = await contract.evaluateTransaction('queryUser', userId);
        } catch (error) {
            console.error(`Failed to query user details: ${error}`);
        } finally {
            if (gateway) {
                await gateway.disconnect();
            }
        }
        
        return result? JSON.parse(result.toString()) : null;
    }

    invite = async (userId, emailAddr, fullname, inviterId) => {
        let gateway;

        try {
            gateway = await this.gatewayConnect();
            const contract = await this.getContract(gateway);

            await contract.submitTransaction('inviteUser', userId, emailAddr, fullname, inviterId);
        } catch (error) {
            console.error(`Failed to invite user: ${error}`);
        } finally {
            if (gateway) {
                await gateway.disconnect();
            }
        }
    }

    register = async (userId, emailAddr, fullname) => {
        let gateway;

        try {
            gateway = await this.gatewayConnect();
            const contract = await this.getContract(gateway);

            await contract.submitTransaction('registerUser', userId, emailAddr, fullname);
        } catch (error) {
            console.error(`Failed to register user: ${error}`);
        } finally {
            if (gateway) {
                await gateway.disconnect();
            }
        }
    }
}