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
    error RebaseToken__InterestRateCanOnlyDecrease(
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
    mapping(address => uint256) private s_userLastUpdatedTimestamp;

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

    /**
     * @notice Mint new tokens to the user when they deposit into the vault
     * @param _to The user to mint tokent to
     * @param _amount The amount of tokens to mint
     */
    function mint(address _to, uint256 _amount) external {
        s_userInterestRate[_to] = s_interestRate;
        _mint(_to, _amount);
    }

    function _mintAccruedInterest(address _user) internal {
        // #1 - find their current balance of rebase tokens that have been minted to the user
        // #2 - calculate their current balance including any interest that has accrued -> balanceOf
        // calculate number of tokens need to be minted to the user -> #2 - #1
        // call _mint to mint tokens
        // set user's last updated timestamp
        s_userLastUpdatedTimestamp[_user] = block.timestamp;
    }

    /**
     * @notice Calculate the balance of th user, including accrued interest
     * principal balance + accrued interest
     * @param _user The user to calculate balance for
     */
    function balanceOf(address _user) public view override returns (uint256) {
        // get principal balance (number of actually minted tokens to user)
        // multiply principal by accumulated interest since last update
        return
            (super.balanceOf(_user) *
                _calculateUserAccumulatedInterestSinceLastUpdate(_user)) /
            PRECISION_FACTOR;
    }

    /**
     * @notice Calculate the interest that has accrued since the last update
     * @param _user The user to calculate interest for
     * @return linearInterest The interest accumulated since last update
     */
    function _calculateUserAccumulatedInterestSinceLastUpdate(
        address _user
    ) internal view returns (uint256 linearInterest) {
        // get the time since the last update
        // calculate the interest that has accumulated since the last update
        // this is going to be linear growth with time
        //1. calculate the time since the last update
        //2. calculate the amount of linear growth
        //3. return the amount of linear growth
        // (principal) + (principal * user interest rate * time elapsed)
        uint256 timeElapsed = block.timestamp -
            s_userLastUpdatedTimestamp[_user];
        linearInterest =
            PRECISION_FACTOR +
            (s_userInterestRate[_user] * timeElapsed);
    }

    /**
     * @notice Get the interest rate for the user
     * @param _user The user to get the interest rate for
     * @return The interest rate for the user
     */
    function getUserInterestRate(
        address _user
    ) external view returns (uint256) {
        return s_userInterestRate[_user];
    }
}

// That's all for now!
