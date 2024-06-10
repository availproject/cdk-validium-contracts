// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.25;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {IVectorx} from "../interfaces/IVectorx.sol";
import {IAvailBridge} from "../interfaces/IAvailBridge.sol";

abstract contract AvailAttestationLib is Initializable {
    struct AttestationData {
        uint32 blockNumber;
        uint128 leafIndex;
    }

    IAvailBridge public bridge;
    IVectorx public vectorx;

    mapping(bytes32 => AttestationData) public attestations;

    error InvalidAttestationProof();

    // slither-disable-next-line naming-convention,dead-code
    function __AvailAttestation_init(IAvailBridge _bridge) internal virtual onlyInitializing {
        bridge = _bridge;
        vectorx = bridge.vectorx();
    }

    function _attest(IAvailBridge.MerkleProofInput calldata input) internal virtual {
        if (!bridge.verifyBlobLeaf(input)) revert InvalidAttestationProof();
        attestations[input.leaf] = AttestationData(
            vectorx.rangeStartBlocks(input.rangeHash) + uint32(input.dataRootIndex) + 1, uint128(input.leafIndex)
        );
    }
}
