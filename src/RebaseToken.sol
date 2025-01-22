// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/*
 * @title RebaseToken
 * @author Charles Jones
 * @dev A simple ERC20 token with a name, symbol, and 18 decimals.
 */

contract RebaseToken is ERC20 {
    // *** Errors ***
    error InterestRateCanOnlyDecrease(
        uint256 oldInterestRate,
        uint256 newInterestRate
    );

    // *** State variables ***
    uint256 private constant PRECISION_FACTOR = 1e18;
    uint256 private s_interestRate = 5e10;

    // *** Events ***
    event InterestRateSet(uint256 _newInterestRate);

    // *** Mappings ***
    mapping(address => uint256) private s_userInterestRate;
    mapping(address => uint256) private s_lastUpdatedTimestamp;

    constructor() ERC20("Rebase Token", "RBT") {}

    /**
     * @notice Set the interest rate for the RebaseToken
     * @param _newInterestRate The new interest rate to set
     * @dev The interest rate can only decrease
     */
    function setInterestRate(uint256 _newInterestRate) external {
        // set interest rate
        if (_newInterestRate < s_interestRate) {
            revert RebaseToken__InterestRateCanOnlyDecrease(
                s_interestRate,
                _newInterestRate
            );
        }
        s_interestRate = _newInterestRate;
        emit InterestRateSet(_newInterestRate);
    }

    function _mintAccruedInterest(address _user) internal view {
        // find their current balance of rebase tokens that have been minted to the user
        // calculate their current balance including any interest that has accrued
    }

    function balanceOf(address user) public view virtual returns (uint256) {
        return _balances[account];
    }

    function _calculateUserAccumulatedInterestSinceLastUpdate(
        address _user
    ) internal view returns (uint256) {
        // get the time since the last update
        // calculate the interest that has accumulated since the last update
        // this is going to be linear growth with time
        //1. calculate the time since the last update
        //2. calculate the amount of linear growth
        //3. return the amount of linear growth
    }
}
