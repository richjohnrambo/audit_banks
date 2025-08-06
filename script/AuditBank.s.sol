// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/AuditBank.sol";

contract AuditBankScript is Script {
    function run() external returns (AuditBank) {
        // 设置 upkeepThreshold 为 0.01 ether
        uint256 upkeepThreshold = 0.01 ether;
        
        vm.startBroadcast();

        // 部署 Bank 合约，并将 upkeepThreshold 作为构造函数的参数
        AuditBank bank = new AuditBank(upkeepThreshold);

        vm.stopBroadcast();

        // 打印部署的合约地址
        console.log("Bank contract deployed at:", address(bank));
        console.log("Upkeep threshold set to:", upkeepThreshold);

        return bank;
    }
}