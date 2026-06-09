// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract StableVault is ReentrancyGuard, Pausable, Ownable {
    using SafeERC20 for IERC20;
    IERC20 public immutable asset;

    constructor(address _asset) Ownable(msg.sender) {
        asset = IERC20(_asset);
    }

    function deposit(uint256 amount) external nonReentrant whenNotPaused {
        asset.safeTransferFrom(msg.sender, address(this), amount);
    }
}
