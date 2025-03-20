// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title MultiSigWallet
 * @dev A simple contract that stores project details for a multi-signature wallet.
 */
contract MultiSigWallet {
    string public projectTitle = "Multi-signature wallet for groups";
    string public projectDescription = "A wallet that requires multiple approvals for transactions.";

    /**
     * @dev Returns the project title.
     */
    function getProjectTitle() public view returns (string memory) {
        return projectTitle;
    }

    /**
     * @dev Returns the project description.
     */
    function getProjectDescription() public view returns (string memory) {
        return projectDescription;
    }

    /**
     * @dev Updates the project description (only for demonstration, should have access control in real use).
     */
    function setProjectDescription(string memory newDescription) public {
        projectDescription = newDescription;
    }
}
