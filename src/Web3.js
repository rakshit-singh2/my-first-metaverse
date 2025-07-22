const CONTRACT_ADDRESS = "0x85879110E68b32589c58564f1c5497428F2c85D8";

const BSC_TESTNET_PARAMS = {
    chainId: "0x61",
    chainName: "Binance Smart Chain Testnet",
    nativeCurrency: {
        name: "BNB",
        symbol: "tBNB",
        decimals: 18
    },
    rpcUrls: ["https://data-seed-prebsc-1-s1.binance.org:8545/"],
    blockExplorerUrls: ["https://testnet.bscscan.com/"]
};

async function switchToBSC() {
    if (!window.ethereum) throw new Error("You should install Metamask to use it!");

    const currentChainId = await window.ethereum.request({ method: "eth_chainId" });

    if (currentChainId !== BSC_TESTNET_PARAMS.chainId) {
        try {
            await window.ethereum.request({
                method: "wallet_switchEthereumChain",
                params: [{ chainId: BSC_TESTNET_PARAMS.chainId }]
            });
        } catch (error) {
            if (error.code === 4902) {
                await window.ethereum.request({
                    method: "wallet_addEthereumChain",
                    params: [BSC_TESTNET_PARAMS]
                });
            } else {
                throw error;
            }
        }
    }
}

const blockchain = new Promise(async (res, rej) => {
    try {
        await switchToBSC();

        const web3 = new Web3(window.ethereum);

        const response = await fetch('./src/abi/abi.json'); // Fetching position wrt index.html not current file
        const metaverseAbi = await response.json();

        const contract = new web3.eth.Contract(metaverseAbi, CONTRACT_ADDRESS);
        const accounts = await web3.eth.requestAccounts();

        console.log("-> My account is: ", accounts[0]);

        const totalSupply = await contract.methods.totalSupply().call({ from: accounts[0] });
        console.log("-> Current supply of NFT Tokens is: ", totalSupply);

        const maxSupply = await contract.methods.maxSupply().call({ from: accounts[0] });
        console.log("-> Maximum supply of NFT Tokens is: ", maxSupply);

        const yourBuildings = await contract.methods.getOwnerBuildings().call({ from: accounts[0] });
        console.log("-> Your buildings: ", yourBuildings);

        const allBuildings = await contract.methods.getBuildings().call({ from: accounts[0] });

        res({
            totalSupply: totalSupply,
            maxSupply: maxSupply,
            yourBuildings: yourBuildings,
            allBuildings: allBuildings
        });

    } catch (err) {
        rej(err.message);
    }
});

export default blockchain;
