// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

/// @title Love
/// @author Christian Reyes
/// @notice Does My girlfriend love me? This is a simple contract for testing purposes with Foundry.
/// @dev The answer is always yes.

contract KatyaLovesChristian {
    /// @notice A boolean state variable that indicates whether Katya loves Christian.
    /// @dev The initial value is set to true.
    bool public katyaLovesChristian = true;

    /// @notice Function to check if Katya loves Christian based on the input.
    /// @dev If the input is false, it will be set to true and a specific message will be returned.
    /// @param doYou A boolean input that should indicate whether Katya loves Christian.
    /// @return answer A string message that confirms whether Katya loves Christian.
    function doesKatyaLoveChristian(bool doYou) public returns(string memory answer) {
        // If the input is false, set it to true and return a specific message.
        if (!doYou) {
            doYou = true;
            answer = "Yes, Katya loves Christian but her typing is a bit retarded at the moment";
            return(answer); 
        }
        // If the input is true, set the state variable to true and return a confirmation message.
        if (doYou) {
            katyaLovesChristian = true;
            answer = "Yes, Katya loves Christian";
            return(answer); 
        }
    }
}
