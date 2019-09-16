/*
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const { Contract } = require('fabric-contract-api');

class User extends Contract {

    async initLedger(ctx) {
        // console.info('============= START : Initialize Ledger ===========');
        // const cars = [
        //     {
        //         color: 'blue',
        //         make: 'Toyota',
        //         model: 'Prius',
        //         owner: 'Tomoko',
        //     },
        //     {
        //         color: 'red',
        //         make: 'Ford',
        //         model: 'Mustang',
        //         owner: 'Brad',
        //     },
        //     {
        //         color: 'green',
        //         make: 'Hyundai',
        //         model: 'Tucson',
        //         owner: 'Jin Soo',
        //     },
        //     {
        //         color: 'yellow',
        //         make: 'Volkswagen',
        //         model: 'Passat',
        //         owner: 'Max',
        //     },
        //     {
        //         color: 'black',
        //         make: 'Tesla',
        //         model: 'S',
        //         owner: 'Adriana',
        //     },
        //     {
        //         color: 'purple',
        //         make: 'Peugeot',
        //         model: '205',
        //         owner: 'Michel',
        //     },
        //     {
        //         color: 'white',
        //         make: 'Chery',
        //         model: 'S22L',
        //         owner: 'Aarav',
        //     },
        //     {
        //         color: 'violet',
        //         make: 'Fiat',
        //         model: 'Punto',
        //         owner: 'Pari',
        //     },
        //     {
        //         color: 'indigo',
        //         make: 'Tata',
        //         model: 'Nano',
        //         owner: 'Valeria',
        //     },
        //     {
        //         color: 'brown',
        //         make: 'Holden',
        //         model: 'Barina',
        //         owner: 'Shotaro',
        //     },
        // ];

        // for (let i = 0; i < cars.length; i++) {
        //     cars[i].docType = 'car';
        //     await ctx.stub.putState('CAR' + i, Buffer.from(JSON.stringify(cars[i])));
        //     console.info('Added <--> ', cars[i]);
        // }
        // console.info('============= END : Initialize Ledger ===========');
    }

    async queryCar(ctx, carNumber) {
        const carAsBytes = await ctx.stub.getState(carNumber); // get the car from chaincode state
        if (!carAsBytes || carAsBytes.length === 0) {
            throw new Error(`${carNumber} does not exist`);
        }
        console.log(carAsBytes.toString());
        return carAsBytes.toString();
    }

}

module.exports = User;
