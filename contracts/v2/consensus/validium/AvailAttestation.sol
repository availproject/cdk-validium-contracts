// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.25;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {IAvailBridge} from "../../interfaces/IAvailBridge.sol";
import {IVectorx} from "../../interfaces/IVectorx.sol";
import {IDataAvailabilityProtocol} from "../../interfaces/IDataAvailabilityProtocol.sol";
import {AvailAttestationLib} from "../../lib/AvailAttestationLib.sol";

contract AvailAttestation is OwnableUpgradeable, IDataAvailabilityProtocol, AvailAttestationLib {
    constructor() {
        _disableInitializers();
    }

    function initialize(IAvailBridge bridge) external initializer {
        __AvailAttestation_init(bridge);
        __Ownable_init_unchained();
    }

    function getProcotolName() external pure override returns (string memory) {
        return "Avail";
    }

    function verifyMessage(
        bytes32,
        IAvailBridge.MerkleProofInput calldata dataAvailabilityMessage
    ) external {
        _attest(dataAvailabilityMessage);
    }

    function verifyMessage(
        bytes32,
        bytes calldata
    ) external pure {
        revert();
    }
}
