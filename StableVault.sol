// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "forge-std/Test.sol";
import "../src/StableVault.sol"; 
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title StableVault
 * @notice Профессиональное хранилище с защитой и экстренным управлением.
 */
contract StableVault is ReentrancyGuard, Ownable, Pausable {
    using SafeERC20 for IERC20;

    IERC20 public immutable asset;

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    constructor(address _asset) Ownable(msg.sender) {
        require(_asset != address(0), "StableVault: asset is zero address");
        asset = IERC20(_asset);
    }

    function deposit(uint256 amount) external nonReentrant whenNotPaused {
        require(amount > 0, "StableVault: amount must be > 0");
        asset.safeTransferFrom(msg.sender, address(this), amount);
        emit Deposited(msg.sender, amount);
    }

    function withdraw(uint256 amount) external nonReentrant {
        require(amount > 0, "StableVault: amount must be > 0");
        asset.safeTransfer(msg.sender, amount);
        emit Withdrawn(msg.sender, amount);
    }

    // Экстренный вывод любых токенов владельцем
    function emergencyWithdraw(address _token) external onlyOwner {
        uint256 balance = IERC20(_token).balanceOf(address(this));
        IERC20(_token).safeTransfer(msg.sender, balance);
    }

    // Функции для администратора: заморозка контракта в случае опасности
    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }
}
