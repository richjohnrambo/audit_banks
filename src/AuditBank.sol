// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;

import "@chainlink/contracts/src/v0.8/automation/interfaces/AutomationCompatibleInterface.sol";


contract AuditBank is AutomationCompatibleInterface {

    // 合约的 owner，拥有特殊权限（如接收自动化转账）
    address public owner;

    // 存款达到此阈值时，自动化任务将被触发
    uint256 public upkeepThreshold;

    constructor(uint256 _upkeepThreshold) {
        owner = msg.sender;
        upkeepThreshold = _upkeepThreshold;
    }

    /// @notice 允许用户向合约存入 ETH。
    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");
    }

    /// @notice 检查合约余额是否超过阈值，以决定是否执行自动化任务。
    /// @dev 这是 Chainlink Automation 的核心函数之一。
    /// @param checkData 允许在自动化注册时传递额外数据（此处未使用）。
    /// @return upkeepNeeded 返回 true 表示需要执行任务。
    /// @return performData 传递给 performUpkeep 的数据（此处未使用）。
    function checkUpkeep(bytes calldata checkData)
        external
        view
        override
        returns (bool upkeepNeeded, bytes memory performData)
    {
        // 如果合约余额超过了阈值，则返回 true
        upkeepNeeded = address(this).balance > upkeepThreshold;
        // 传递空数据，因为 performUpkeep 不需要额外信息
        performData = "";
    }

    /// @notice Chainlink Keeper 会调用此函数来执行任务。
    /// @dev 该函数只能由 Chainlink Keeper 调用。
    /// @param performData 由 checkUpkeep 返回的数据。
    function performUpkeep(bytes calldata performData)
        external
        override
    {
        bool upkeepNeeded = address(this).balance > upkeepThreshold;

        require(upkeepNeeded, "Upkeep not needed");

        // 现在执行你的业务逻辑
        uint256 amountToTransfer = address(this).balance / 2;
        
        (bool success, ) = owner.call{value: amountToTransfer}("");
        require(success, "Transfer failed");
    }
}
