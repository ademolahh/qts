// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.28;

import { PausableUpgradeable } from
    "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";
import { ERC20Upgradeable } from
    "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import { AccessControlUpgradeable } from
    "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

contract QTS is ERC20Upgradeable, PausableUpgradeable, AccessControlUpgradeable {
    string constant NAME = "QTS";
    string constant SYMBOL = "QTS";

    function initialize() external initializer {
        __Pausable_init();
        __ERC20_init(NAME, SYMBOL);
    }

    function mint(address _to, uint256 _amount) external whenNotPaused {
        _mint(_to, _amount);
    }

    function burn(address _from, uint256 _amount) external whenNotPaused {
        _burn(_from, _amount);
    }

    function transfer(address _to, uint256 _value) public override whenNotPaused returns (bool) {
        super.transfer(_to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value)
        public
        override
        whenNotPaused
        returns (bool)
    {
        super.transferFrom(_from, _to, _value);
        return true;
    }

    function pause() external {
        _pause();
    }

    function unpause() external {
        _unpause();
    }
}
