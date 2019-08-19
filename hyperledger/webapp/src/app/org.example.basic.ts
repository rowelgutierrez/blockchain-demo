import {Asset} from './org.hyperledger.composer.system';
import {Participant} from './org.hyperledger.composer.system';
import {Transaction} from './org.hyperledger.composer.system';
import {Event} from './org.hyperledger.composer.system';
// export namespace org.example.basic{
   export class User extends Participant {
      email: string;
      firstName: string;
      lastName: string;
   }
   export class Wallet extends Asset {
      walletId: string;
      user: User;
      balance: number;
   }
   export class Invite extends Transaction {
      inviterWallet: Wallet;
      firstName: string;
      lastName: string;
      email: string;
      reward: number;
   }
// }
