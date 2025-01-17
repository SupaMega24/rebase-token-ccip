# Cross-chain Rebase Token

1. Create protocol allowing users to deposit into a vault and receice rebase tokens representing the underlying balance.

2. Create balanceOf function to show changing balance over time.
   1. balance increases linearly with time.
   2. mint tokens to users when they mint, burn, transfer, or bridge.

3. Define interest rate.
   1. set individual user rates based on global rate of protocol at time of the user's deposit.
   2. global rate can only decrease to reward and incentivise early adodpters. 
   3. goal is to increase token adoption.