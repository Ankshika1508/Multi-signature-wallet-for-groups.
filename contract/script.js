const contractAddress = "0xf3Ad9c383F31642cA12522736e2072d00fB9ba54";
const abi = [
	{
		"inputs": [],
		"name": "getProjectDescription",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getProjectTitle",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "projectDescription",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "projectTitle",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "newDescription",
				"type": "string"
			}
		],
		"name": "setProjectDescription",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	}
];

async function loadBlockchainData() {
    try {
        if (window.ethereum) {
            const web3 = new Web3(window.ethereum);
            await window.ethereum.request({ method: "eth_requestAccounts" });
            const contract = new web3.eth.Contract(abi, contractAddress);
            
            // Fetch title and description
            const title = await contract.methods.getProjectTitle().call();
            const description = await contract.methods.getProjectDescription().call();

            // Set data in UI
            document.getElementById("projectTitle").innerText = title;
            document.getElementById("projectDescription").innerText = description;
        } else {
            showMessage("🛑 Please install MetaMask!", "red");
        }
    } catch (error) {
        console.error(error);
        showMessage("⚠️ Error fetching data!", "red");
    }
}

async function updateDescription() {
    try {
        if (window.ethereum) {
            const web3 = new Web3(window.ethereum);
            const accounts = await web3.eth.getAccounts();
            const contract = new web3.eth.Contract(abi, contractAddress);
            const newDesc = document.getElementById("newDescription").value;

            if (newDesc.trim() !== "") {
                showMessage("⏳ Updating description...", "yellow");
                await contract.methods.setProjectDescription(newDesc).send({ from: accounts[0] });

                document.getElementById("projectDescription").innerText = newDesc;
                showMessage("✅ Description updated successfully!", "green");
            } else {
                showMessage("⚠️ Please enter a valid description.", "red");
            }
        }
    } catch (error) {
        console.error(error);
        showMessage("⚠️ Transaction failed!", "red");
    }
}

function showMessage(message, color) {
    const statusMessage = document.getElementById("statusMessage");
    statusMessage.innerText = message;
    statusMessage.style.color = color;
}

window.onload = loadBlockchainData;
