// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title StableVault
 * @author MarkAuditLab
 * @notice Хранилище для обеспечения безопасности и доходности стейблкоинов.
 * @dev Реализует стандарты безопасности OpenZeppelin для защиты активов.
 */
contract StableVault is ReentrancyGuard, Pausable, Ownable {
    using SafeERC20 for IERC20;

    IERC20 public immutable token;

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    /**
     * @param _token Адрес ERC-20 токена, который будет храниться в хранилище.
     */
    constructor(address _token) {
        token = IERC20(_token);
    }

    /**
     * @notice Вносит активы в хранилище.
     * @dev Использует nonReentrant для предотвращения атак повторного входа.
     * @param amount Количество токенов для внесения.
     */
    function deposit(uint256 amount) external nonReentrant whenNotPaused {
        require(amount > 0, "Amount must be > 0");
        token.safeTransferFrom(msg.sender, address(this), amount);
        emit Deposited(msg.sender, amount);
    }

    /**
     * @notice Останавливает все операции при угрозе безопасности.
     */
    function pause() external onlyOwner {
        _pause();
    }
}
