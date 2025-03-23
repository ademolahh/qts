// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import { Test } from "forge-std/Test.sol";
import { QTS } from "../src/QTS.sol";

contract QTSTest is Test {
    QTS qts;

    function setUp() public {
        qts = new QTS();
        qts.initialize();
    }
}
