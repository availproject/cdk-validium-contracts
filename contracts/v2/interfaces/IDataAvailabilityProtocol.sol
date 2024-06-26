// SPDX-License-Identifier: AGPL-3.0

pragma solidity ^0.8.20;

import "./IAvailBridge.sol";

interface IDataAvailabilityProtocol {
    function getProcotolName() external view returns (string memory);

    function verifyMessage(
        bytes32 hash,
        IAvailBridge.MerkleProofInput calldata dataAvailabilityMessage
    ) external;

    function verifyMessage(
        bytes32 hash,
        bytes calldata dataAvailabilityMessage
    ) external;
}
