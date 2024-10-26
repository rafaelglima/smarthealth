'use strict';

const express = require('express');
const bodyParser = require('body-parser');
const serverless = require("serverless-http")

const app = express();
app.use(bodyParser.json());

// Setting for Hyperledger Fabric
const { Wallet, Wallets, Gateway, GatewayOptions } = require('fabric-network');
const FabricCAServices = require('fabric-ca-client');
const fs = require('fs');
const path = require('path');
const ccpPath = path.resolve(__dirname, '.',  'connection-org1.json');

const { buildCAClient, registerAndEnrollUser, enrollAdmin } = require('./CAUtil.js');
const { buildCCPOrg1, buildWallet } = require('./AppUtil.js');


// Variaveis
const channelName = 'mychannel';
const chaincodeName = 'mycc';
const mspOrg1 = 'm-YUMWZW4DJNGV5K2MJ6PPUUNB7Y'; //memberid
const org1UserId = 'appUser';

app.get('/queryallmeasurements', async function (req, res) {
    try {
        let ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));
        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), 'wallet');
    	const wallet = await buildWallet(Wallets, walletPath);    
        
        //build ca client
        const caClient = buildCAClient(FabricCAServices, ccp, 'ca.m-yumwzw4djngv5k2mj6ppuunb7y.n-5ldyibq45vhapchemzvkilage4.managedblockchain.us-east-1.amazonaws.com');
        
        //apos ter as identidades na pasta da wallet
        const identity = await wallet.get('appUser');

        // Criação e conexão do gateway
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'appUser', discovery: { enabled: false, asLocalhost: true } });

        // Acesso ao canal (network)
        const network = await gateway.getNetwork('mychannel');

        // Acesso ao contrato (smart contract)
        const contract = network.getContract('mycc');

        // Avaliação da transação especificada
        const result = await contract.evaluateTransaction('queryAllSensorMeasurements');
        console.log(`Transaction has been evaluated, result is: ${result.toString()}`);

        // Envio do resultado da transação como resposta
        res.send(`Resultado: ${result.toString()}`);

        // Desconexão do gateway
        await gateway.disconnect();

    } catch (error) {
        console.error(`Failed to evaluate transaction: ${error}`);
        res.status(500).json({ error: error.toString() });
    }
});

app.get('/queryallfiles', async function (req, res) {
       try {
        let ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));
        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), 'wallet');
    	const wallet = await buildWallet(Wallets, walletPath);    
        
        //build ca client
        const caClient = buildCAClient(FabricCAServices, ccp, 'ca.m-yumwzw4djngv5k2mj6ppuunb7y.n-5ldyibq45vhapchemzvkilage4.managedblockchain.us-east-1.amazonaws.com');
        
        //apos ter as identidades na pasta da wallet
        const identity = await wallet.get('appUser');

        // Criação e conexão do gateway
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'appUser', discovery: { enabled: false, asLocalhost: true } });

        // Acesso ao canal (network)
        const network = await gateway.getNetwork('mychannel');

        // Obter o contrato da rede
        const contract = network.getContract('mycc');

        // Avaliar a transação especificada
        const result = await contract.evaluateTransaction('queryAllFiles');
        console.log(`Transação foi avaliada, o resultado é: ${result.toString()}`);
        res.status(200).json({ response: result.toString() });

        // Desconectar do gateway
        await gateway.disconnect();

    } catch (error) {
        console.error(`Falha ao avaliar a transação: ${error}`);
        res.status(500).json({ error: error.message });
    }
});

app.get('/querymeasurement/:measurement_index', async function (req, res) {
    try {

        let ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));
        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        //console.log(`Wallet path: ${walletPath}`);

	const caClient = buildCAClient(FabricCAServices, ccp, 'ca.m-yumwzw4djngv5k2mj6ppuunb7y.n-5ldyibq45vhapchemzvkilage4.managedblockchain.us-east-1.amazonaws.com');

        // Check to see if we've already enrolled the user.
        const identity = await wallet.get('appUser');

        // Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'appUser', discovery: { enabled: false, asLocalhost: true } });

        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('mychannel');

        // Get the contract from the network.
        const contract = network.getContract('mycc');

        const result = await contract.evaluateTransaction('querySensorMeasurement', req.params.measurement_index);
        
        res.send(`Resultado: ${result.toString()}`);

        // Disconnect from the gateway.
        await gateway.disconnect();

    } catch (error) {
        console.error(`Failed to evaluate transaction: ${error}`);
        res.status(500).json({error: error});
        process.exit(1);
    }
});

app.get('/queryfile/:file_index', async function (req, res) {
    try {

        let ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));
        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        //console.log(`Wallet path: ${walletPath}`);

	const caClient = buildCAClient(FabricCAServices, ccp, 'ca.m-yumwzw4djngv5k2mj6ppuunb7y.n-5ldyibq45vhapchemzvkilage4.managedblockchain.us-east-1.amazonaws.com');

        // Check to see if we've already enrolled the user.
        const identity = await wallet.get('appUser');

        // Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'appUser', discovery: { enabled: false, asLocalhost: true } });

        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('mychannel');

        // Get the contract from the network.
        const contract = network.getContract('mycc');

	// Submit the specified transaction.
        const result = await contract.evaluateTransaction('queryFile', req.params.file_index);
        console.log(`Transaction has been evaluated, result is: ${result.toString()}`);
        res.status(200).json({response: result.toString()});

        // Disconnect from the gateway.
        await gateway.disconnect();

    } catch (error) {
        console.error(`Failed to evaluate transaction: ${error}`);
        res.status(500).json({error: error});
        process.exit(1);
    }
});

app.post('/addmeasurement/', async function (req, res) {
    try {
        let ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));
        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), 'wallet');
    	const wallet = await buildWallet(Wallets, walletPath);    
        
        //build ca client
        const caClient = buildCAClient(FabricCAServices, ccp, 'ca.m-yumwzw4djngv5k2mj6ppuunb7y.n-5ldyibq45vhapchemzvkilage4.managedblockchain.us-east-1.amazonaws.com');
        
        //apos ter as identidades na pasta da wallet
        const identity = await wallet.get('appUser');

        // Criação e conexão do gateway
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'appUser', discovery: { enabled: false, asLocalhost: true } });

        // Acesso ao canal (network)
        const network = await gateway.getNetwork('mychannel');

        // Get the contract from the network.
        const contract = network.getContract('mycc');

        // Submit the specified transaction.
        await contract.submitTransaction('createSensorMeasurement', req.body.id, req.body.deviceId, req.body.patientId, req.body.unit, req.body.value1, req.body.value2, req.body.value3, req.body.timestamp);
        //req.body.deviceType,
        console.log('Transaction has been submitted');
        res.send('Transaction has been submitted');

        // Disconnect from the gateway.
        await gateway.disconnect();

    } catch (error) {
        console.error(`Failed to submit transaction: ${error}`);
        process.exit(1);
    }
})

app.post('/addfile/', async function (req, res) {
    try {
        let ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));
        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), 'wallet');
    	const wallet = await buildWallet(Wallets, walletPath);    
        
        //build ca client
        const caClient = buildCAClient(FabricCAServices, ccp, 'ca.m-yumwzw4djngv5k2mj6ppuunb7y.n-5ldyibq45vhapchemzvkilage4.managedblockchain.us-east-1.amazonaws.com');
        
        //apos ter as identidades na pasta da wallet
        const identity = await wallet.get('appUser');

        // Criação e conexão do gateway
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'appUser', discovery: { enabled: false, asLocalhost: true } });

        // Acesso ao canal (network)
        const network = await gateway.getNetwork('mychannel');

        // Get the contract from the network.
        const contract = network.getContract('mycc');

        // Submit the specified transaction.
        await contract.submitTransaction('createFile', req.body.fileid, req.body.hash, req.body.filename, req.body.filetype, req.body.timestamp);
        console.log('Transaction has been submitted');
        res.send('Transaction has been submitted');

        // Disconnect from the gateway.
        await gateway.disconnect();

    } catch (error) {
        console.error(`Failed to submit transaction: ${error}`);
        process.exit(1);
    }
})

module.exports.handle = serverless(app);
