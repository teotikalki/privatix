import { firstLogin } from './first-login.spec';
import { secondLogin } from './second-login.spec';
import { backupPrivateKey } from './backup-private-key.spec';
import { getEthPrix } from './get-eth-prix.spec';
import { transferPrix } from './transfer-prix.spec';
import { offeringPopup } from './offering-popup.spec';
import { createOffering } from './create-offering.spec';

export const smokeAutoTests = [firstLogin, secondLogin, backupPrivateKey, getEthPrix, transferPrix, offeringPopup, createOffering];
