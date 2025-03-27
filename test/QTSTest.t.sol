// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import { Test } from "forge-std/Test.sol";
import { QTS } from "../src/QTS.sol";

contract QTSTest is Test {
    QTS qts;

    address admin = address(1);
    address minter = address(2);
    address burner = address(3);

    function setUp() public {
        vm.startPrank(admin);
        qts = new QTS();
        qts.initialize();
        qts.grantRole(qts.MINTER_ROLE(), minter);
        qts.grantRole(qts.BURNER_ROLE(), burner);
        vm.stopPrank();
    }

    function testMint() public {
        uint256 amount = 100_000 ether;

        vm.prank(minter);
        qts.mint(msg.sender, amount);

        assertEq(qts.balanceOf(msg.sender), amount);
        assertEq(qts.totalSupply(), amount);
    }

    function testBurn() public {
        uint256 amount = 100_000 ether;
        uint256 amountToBurnt = amount / 2;

        vm.prank(minter);
        qts.mint(burner, amount);

        uint256 balanceBefore = qts.balanceOf(burner);
        uint256 tsBefore = qts.totalSupply();

        vm.prank(burner);
        qts.burn(burner, amountToBurnt);

        uint256 balanceAfter = qts.balanceOf(burner);
        uint256 tsAfter = qts.totalSupply();

        assertEq(balanceAfter, balanceBefore - amountToBurnt);
        assertEq(tsAfter, tsBefore - amountToBurnt);
    }

    function testPausableControls() public {
        uint256 amount = 100_000 ether;
        uint256 amountToBurnt = amount / 2;

        vm.prank(admin);
        qts.pause();

        vm.expectRevert();
        vm.prank(minter);
        qts.mint(burner, amount);

        vm.expectRevert();
        vm.prank(burner);
        qts.burn(burner, amountToBurnt);

        vm.expectRevert();
        vm.prank(burner);
        qts.transfer(minter, 100 ether);

        vm.expectRevert();
        vm.prank(burner);
        qts.transferFrom(burner, admin, 100 ether);

        vm.prank(admin);
        qts.unpause();

        vm.prank(minter);
        qts.mint(burner, amount);
        assertEq(qts.balanceOf(burner), amount);
    }
}
