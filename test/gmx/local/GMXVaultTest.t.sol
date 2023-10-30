// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;
import { console, console2 } from "forge-std/Test.sol";
import { TestUtils } from "../../helpers/TestUtils.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { GMXMockVaultSetup } from "./GMXMockVaultSetup.t.sol";
import { GMXTypes } from "../../../contracts/strategy/gmx/GMXTypes.sol";
import { GMXTestHelper } from "./GMXTestHelper.sol";

import { IDeposit } from "../../../contracts/interfaces/protocols/gmx/IDeposit.sol";
import { IEvent } from "../../../contracts/interfaces/protocols/gmx/IEvent.sol";

contract GMXVaultTest is GMXMockVaultSetup, GMXTestHelper, TestUtils {

  function test_receiveAndWithdrawNative() external {
    vm.deal(owner, 1000000000 ether);
    vm.startPrank(owner);
    


    _amount = 1e18;//31249687500000000001; // 1e18; // !!!!!!!!!!!!!!REMOVE THIS!!!!!!!!!!!!!!
    depositParams.token = address(WETH); // WETH
    depositParams.amt = _amount; // amt
    depositParams.minSharesAmt = 0;
    depositParams.slippage = SLIPPAGE;
    depositParams.executionFee = 0.001e18; // EXECUTION_FEE;



    vault.depositNative{value: depositParams.executionFee + _amount}(depositParams);


    console.log("bal : ", IERC20(address(vault)).balanceOf(owner));
    skip(30 seconds);
    
    mockExchangeRouter.executeDeposit(address(WETH), address(USDC), address(vault), address(callback));

    console.log("bal : ", IERC20(address(vault)).balanceOf(owner));

    GMXTypes.Store memory _store = vault.store();

    console.log("");
    console.log("status : ", uint256(_store.status));
    console.log("");

    // _createAndExecuteDeposit(
    //   address(WETH),
    //   address(USDC),
    //   address(WETH),
    //   1e18,
    //   0,
    //   SLIPPAGE,
    //   EXECUTION_FEE
    // );

    

    // state before
    uint256 ethBalanceBefore = owner.balance;

    assertTrue(vault.store().refundee == address(owner), "refundee should be owner");

    // receive ETH
    vm.startPrank(address(mockExchangeRouter));
    deal(address(mockExchangeRouter), 1 ether);
    (bool s, ) = address(vault).call{value: 1 ether}("");
    assertTrue(s, "receive ETH should succeed");

    // state after
    uint256 ethBalanceAfter = owner.balance;
    // assertEq(ethBalanceAfter, ethBalanceBefore + 1 ether, "eth balance should be +1 ether");
    // revert();

    console.log("bal : ", IERC20(address(vault)).balanceOf(owner));
    // revert();
  }

  function test_receive(uint256 _amount) external {
    vm.assume(_amount >= 9e16 && _amount <= 1000 ether);
    vm.deal(owner, 1000000000 ether);
    vm.startPrank(owner);
    // setup refundee
    // address tokenA, address tokenB, address depositToken, uint256 amt, uint256 minSharesAmt, uint256 slippage, uint256 executionFee
    // _createAndExecuteDeposit(
    //   address(WETH), // tokenA
    //   address(USDC), // tokenB
    //   address(WETH), // depositToken
    //   _amount, // amt
    //   0, // minSharesAmt
    //   SLIPPAGE, // slippage
    //   EXECUTION_FEE // executionFee
    // );

    

    // _createAndExecuteDeposit(
    //   address(WETH),
    //   address(USDC),
    //   address(WETH),
    //   90000000000000000,
    //   0,
    //   SLIPPAGE,
    //   EXECUTION_FEE
    // );

    // console.log(_amount);

    _amount = 1e18;//31249687500000000001; // 1e18; // !!!!!!!!!!!!!!REMOVE THIS!!!!!!!!!!!!!!
    console.log("weth : ", address(WETH));
    depositParams.token = address(WETH); // WETH
    depositParams.amt = _amount; // amt
    depositParams.minSharesAmt = 0;
    depositParams.slippage = SLIPPAGE;
    depositParams.executionFee = 0.001e18; // EXECUTION_FEE;

    // mockLendingVaultUSDC.deposit(100_000e6, 0);


    vault.depositNative{value: depositParams.executionFee + _amount}(depositParams);

    // mockLendingVaultUSDC.withdraw(mockLendingVaultUSDC.balanceOf(owner) / 2, 0);

    console.log("bal : ", IERC20(address(vault)).balanceOf(owner));
    skip(30 seconds);
    
    mockExchangeRouter.executeDeposit(address(WETH), address(USDC), address(vault), address(callback));

    console.log("bal : ", IERC20(address(vault)).balanceOf(owner));

    GMXTypes.Store memory _store = vault.store();

    console.log("");
    console.log("status : ", uint256(_store.status));
    console.log("");

    // _createAndExecuteDeposit(
    //   address(WETH),
    //   address(USDC),
    //   address(WETH),
    //   1e18,
    //   0,
    //   SLIPPAGE,
    //   EXECUTION_FEE
    // );

    

    // state before
    uint256 ethBalanceBefore = owner.balance;

    assertTrue(vault.store().refundee == address(owner), "refundee should be owner");

    // receive ETH
    vm.startPrank(address(mockExchangeRouter));
    deal(address(mockExchangeRouter), 1 ether);
    (bool s, ) = address(vault).call{value: 1 ether}("");
    assertTrue(s, "receive ETH should succeed");

    // state after
    uint256 ethBalanceAfter = owner.balance;
    // assertEq(ethBalanceAfter, ethBalanceBefore + 1 ether, "eth balance should be +1 ether");
    // revert();

    console.log("bal : ", IERC20(address(vault)).balanceOf(owner));
    // revert();
  }





  // function test_overwriteStorageData() external {
  //   // address token, uint256 amt, uint256 minSharesAmt, uint256 slippage, uint256 executionFee)
  //   // _createDeposit(depositToken, amt, minSharesAmt, slippage, executionFee);
  //   depositParams.token = token; // WETH
  //   depositParams.amt = amt; // amt
  //   depositParams.minSharesAmt = minSharesAmt;
  //   depositParams.slippage = slippage;
  //   depositParams.executionFee = executionFee;

  //   vault.deposit{value: depositParams.executionFee}(depositParams);

  //   skip(30 seconds);

  //   mockExchangeRouter.executeDeposit(tokenA, tokenB, address(vault), address(callback));
  // }

}
