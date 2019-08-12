/*
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/* global getAssetRegistry getFactory emit */

/**
 * Sample transaction processor function.
 * @param {org.example.basic.Invite} tx The sample transaction instance.
 * @transaction
 */
async function sampleTransaction(tx) {  // eslint-disable-line no-unused-vars

    const uniqueId = () => {
        const firstItem = {
            value: "0"
        };
        /*length can be increased for lists with more items.*/
        let counter = "123456789".split('')
            .reduce((acc, curValue, curIndex, arr) => {
                const curObj = {};
                curObj.value = curValue;
                curObj.prev = acc;

                return curObj;
            }, firstItem);
        firstItem.prev = counter;

        return function () {
            let now = Date.now();
            if (typeof performance === "object" && typeof performance.now === "function") {
                now = performance.now().toString().replace('.', '');
            }
            counter = counter.prev;
            return `${now}${Math.random().toString(16).substr(2)}${counter.value}`;
        }
    };

    // Add new participant/user
    let user = getFactory().newResource('org.example.basic', 'User', tx.email);
    user.firstName = tx.firstName;
    user.lastName = tx.lastName;
    let participantReg = await getParticipantRegistry('org.example.basic.User');
    await participantReg.add(user);

    // Create new wallet for the new user
    let newUserWallet = getFactory().newResource('org.example.basic', 'Wallet', uniqueId()());
    newUserWallet.user = user;
    newUserWallet.balance = 0.0;

    // Update the wallet of the inviter
    tx.inviterWallet.balance += 10.0;

    // Add/Update assets
    return getAssetRegistry('org.example.basic.Wallet')
    .then(function (assetRegistry) {
        return assetRegistry.add(newUserWallet);
    })
    .then(function () {
        return getAssetRegistry('org.example.basic.Wallet');
    })
    .then(function (assetRegistry) {
        return assetRegistry.update(tx.inviterWallet);
    });
}
