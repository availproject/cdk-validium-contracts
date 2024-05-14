// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import {IAvailBridge} from "../../interfaces/IAvailBridge.sol";
import {IVectorx} from "../../interfaces/IVectorx.sol";
import {IDataAvailabilityProtocol} from "../../interfaces/IDataAvailabilityProtocol.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract AvailAttestation is IDataAvailabilityProtocol, OwnableUpgradeable {
    IAvailBridge public avail;
    IVectorx public vectorx;

    error BadHash();
    error InvalidMerkleProof();

    struct BatchDAData {
        uint256 blockNumber;
        uint256 leafIndex;
    }

    mapping(bytes32 => BatchDAData) public attestations;

    constructor() {
        _disableInitializers();
    }

    function initialize(IAvailBridge _avail, IVectorx _vectorx) external initializer {
        avail = _avail;
        vectorx = _vectorx;
        __Ownable_init_unchained();
    }

    function getProcotolName() external pure override returns (string memory) {
        return "Avail";
    }

    function verifyMessage(
        bytes32 hash,
        bytes calldata dataAvailabilityMessage
    ) external {
        // todo: fix flow later! external -> external view
        IAvailBridge.MerkleProofInput memory proof = abi.decode(dataAvailabilityMessage, (IAvailBridge.MerkleProofInput));
        if (hash != proof.leaf) revert BadHash();
        if (!avail.verifyBlobLeaf(proof)) revert InvalidMerkleProof();

        attestations[hash] = BatchDAData({
            blockNumber: vectorx.rangeStartBlocks(proof.rangeHash) + proof.dataRootIndex,
            leafIndex: proof.leafIndex
        });
    }
}
