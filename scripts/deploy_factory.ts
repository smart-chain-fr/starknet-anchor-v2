import { Provider, Contract, Account, ec, json, constants, CallData, RawCalldata } from "starknet";
import { saveContractAddress } from "./helpers";
import * as dotenv from "dotenv";
import path from "path";
import fs from "fs";

// Read environment variables from .env file
dotenv.config({ path: path.join(__dirname, "..", ".env") });


console.log("connect wallet")

// initialize provider
const provider = new Provider({ sequencer: { network: constants.NetworkName.SN_GOERLI } })
// const provider = new Provider({ sequencer: { baseUrl:"http://127.0.0.1:5050"  } });

const privateKey = process.env.ACCOUNT_PRIVKEY;
const accountAddress = process.env.ACCOUNT_ADDRESS;

const account = new Account(provider, accountAddress, privateKey);

console.log(account)

// Get the factory address from argument, fallback to saved address
const factory_class_hash = async () => {
    const args = process.argv.slice(2);
    const address = args[0];
  
    return address !== undefined
      ? address
      : (await import("../deployments/factory_class_hash")).default;
};

const anchoring_class_hash = async () => {
    return (await import("../deployments/anchoring_class_hash")).default;
};

const deploy = async () => {
    try {
        // retrieve Factory class hash from file (../deployments/factory_class_hash) or argument
        const FACTORY_CLASS_HASH = await factory_class_hash();
        const ANCHORING_CLASS_HASH = await anchoring_class_hash();

        // read abi of Test contract
        const { abi: contractAbi } = await provider.getClassByHash(FACTORY_CLASS_HASH);
        if (contractAbi === undefined) { throw new Error("no abi.") };
        console.log("contractAbi", contractAbi);
        const contractCallData: CallData = new CallData(contractAbi);
        console.log("contractCallData", contractCallData);
        const params: RawCalldata = [accountAddress, ANCHORING_CLASS_HASH];
        const contractConstructor = CallData.compile(params);

        console.log("contractConstructor", contractConstructor);
        const deployResponse = await account.deployContract({ 
            classHash: FACTORY_CLASS_HASH,
            constructorCalldata: contractConstructor });
        console.log('Waiting for Factory Contract deployement', deployResponse.transaction_hash);
        await provider.waitForTransaction(deployResponse.transaction_hash);

        console.log('✅ Factory Contract deployed at =', deployResponse.contract_address);
        saveContractAddress("factory", deployResponse.contract_address);

    } catch (e) {
        // Aborted while using ledger
        if (e.statusText === "CONDITIONS_OF_USE_NOT_SATISFIED") {
            console.log("Aborted.");
        } else {
            console.log(e);
        }
    }
};

deploy();