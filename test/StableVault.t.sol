// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "forge-std/Test.sol";
import "../StableVault.sol"; // Проверь путь, если файл в корне, то просто "../StableVault.sol"
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Фейковый токен для теста
contract MockToken is ERC20 {
    constructor() ERC20("Mock", "MCK") { _mint(msg.sender, 1000 ether); }
}

contract StableVaultTest is Test {
    StableVault vault;
    MockToken token;
    address user = address(1);

    function setUp() public {
        token = new MockToken();
        vault = new StableVault(address(token));
    }

    function testDeposit() public {
        vm.startPrank(user);
        token.approve(address(vault), 100 ether);
        vault.deposit(100 ether);
        assertEq(token.balanceOf(address(vault)), 100 ether);
        vm.stopPrank();
    }

    function testPauseFunctionality() public {
        vault.pause();
        vm.expectRevert(); // Ожидаем ошибку при попытке депозита
        vault.deposit(100 ether);
    }
}
