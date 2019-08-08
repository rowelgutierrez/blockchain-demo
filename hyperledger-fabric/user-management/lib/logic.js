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

'use strict';
/**
 * Write your transction processor functions here
 */

/**
 * Sample transaction
 * @param {dev.rowelgutierrez.hyperledgerfabric.usermanagement.Invite} tx
 * @transaction
 */
async function invite(tx) {
    // const NS = 'dev.rowelgutierrez.hyperledgerfabric.usermanagement';

    // Add new participant/user
    let user = getFactory().newResource('dev.rowelgutierrez.hyperledgerfabric.usermanagement', 'User', tx.email);
    user.firstName = tx.firstName;
    user.lastName = tx.lastName;
    await getParticipantRegistry('dev.rowelgutierrez.hyperledgerfabric.usermanagement').add(user);

    // Create new wallet for the new user
    let newUserWallet = getFactory().newResource('dev.rowelgutierrez.hyperledgerfabric.usermanagement', 'Wallet', tx.email);
    newUserWallet.user = user;
    newUserWallet.balance = 0.0;

    // Update the wallet of the inviter
    tx.inviterWallet.balance += 10.0;

    // Add/Update assets
    return getAssetRegistry('dev.rowelgutierrez.hyperledgerfabric.usermanagement.Wallet')
    .then(function (assetRegistry) {
        return assetRegistry.add(newUserWallet);
    })
    .then(function () {
        return getAssetRegistry('dev.rowelgutierrez.hyperledgerfabric.usermanagement.Wallet');
    })
    .then(function (assetRegistry) {
        return assetRegistry.update(tx.inviterWallet);
    })

    // // Save the old value of the asset.
    // const oldValue = tx.asset.value;

    // // Update the asset with the new value.
    // tx.asset.value = tx.newValue;

    // // Get the asset registry for the asset.
    // const assetRegistry = await getAssetRegistry('dev.rowelgutierrez.hyperledgerfabric.usermanagement.SampleAsset');
    // // Update the asset in the asset registry.
    // await assetRegistry.update(tx.asset);

    // // Emit an event for the modified asset.
    // let event = getFactory().newEvent('dev.rowelgutierrez.hyperledgerfabric.usermanagement', 'SampleEvent');
    // event.asset = tx.asset;
    // event.oldValue = oldValue;
    // event.newValue = tx.newValue;
    // emit(event);
}
