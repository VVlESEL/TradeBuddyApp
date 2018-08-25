import 'dart:core';
import 'package:trade_buddy/utils/settings_controller.dart';
import 'dart:math' as math;
import 'package:trade_buddy/utils/trades_controller.dart';

class AnalyticsController{

  /*
  //
  //
  //Could calculate analytics graphic data hashmap here, saves one iteration
  //
  //
  //
   */


  static num netProfit = 0;
  static num profitFactor;
  static num tradesAmount = 0;

  static num grossProfit;
  static num expectedProfit;
  static num maxDrawdownMoney;
  static num maxDrawdownPercent;
  static num sellTradesAmount;
  static num sellTradesPercent;
  static num wonTradesAmount;
  static num wonTradesPercent;
  static num biggestProfit;
  static num averageProfit;
  static num maxWinRowAmount;
  static num maxWinRowMoney;

  static num grossLoss;
  static num buyTradesAmount;
  static num buyTradesPercent;
  static num lostTradesAmount;
  static num lostTradesPercent;
  static num biggestLoss;
  static num averageLoss;
  static num maxLossRowAmount;
  static num maxLossRowMoney;

  static void calcNumbers(){
    netProfit = 0;
    tradesAmount = 0;
    grossProfit = 0;
    grossLoss = 0;
    maxDrawdownMoney = 0;
    maxDrawdownPercent = 0;
    sellTradesAmount = 0;
    biggestProfit = 0;
    maxWinRowAmount = 0;
    maxWinRowMoney = 0;
    buyTradesAmount = 0;
    biggestLoss = 0;
    maxLossRowAmount = 0;
    maxLossRowMoney = 0;

    num maxProfit = 0, tempDrawdown = 0;
    num sellPositionsWon = 0,  buyPositionsWon = 0;
    num profit = 0, wonTrades = 0, lostTrades = 0;
    num tempWinRow = 0, tempLooseRow = 0;
    num tempWinRowProfit = 0, tempLooseRowProfit = 0;

    //calclate maxDD and profit
    num maxAccountBalance = SettingsController.balance;

    TradesController.trades.forEach((t){
      profit = t.profit + t.commission + t.swap;
      netProfit += profit;
      if(netProfit >= maxProfit){
        maxProfit = netProfit;
        tempDrawdown = 0;
        maxAccountBalance = SettingsController.balance + netProfit;
      }
      else{
        tempDrawdown += profit;
        if(maxAccountBalance != 0){
          num drawdownInPercent = tempDrawdown / maxAccountBalance * 100;
          maxDrawdownPercent = math.min(drawdownInPercent, maxDrawdownPercent);
        }
        if(tempDrawdown <= maxDrawdownMoney) maxDrawdownMoney = tempDrawdown;
      }

      //calculate other numbers
      //calculate profit, profitBuy, profitSell
      tradesAmount++;
      if(t.type == "buy") buyTradesAmount++;
      else sellTradesAmount++;

      if(profit >= 0){
        wonTrades++;
        grossProfit += profit;
        if(profit > biggestProfit) biggestProfit = profit;

        if(t.type == "buy"){
          buyPositionsWon++;
        }else{
          sellPositionsWon++;
        }

        tempWinRow++;
        tempWinRowProfit += profit;
        maxWinRowMoney = math.max(tempWinRowProfit,maxWinRowMoney);
        maxWinRowAmount = math.max(tempWinRow, maxWinRowAmount);

        tempLooseRow = 0;
        tempLooseRowProfit = 0;
      }
      else {
        lostTrades++;
        grossLoss += profit;
        if(profit < biggestLoss) biggestLoss = profit;

        tempLooseRow++;
        tempLooseRowProfit += profit;
        maxLossRowMoney = math.min(tempLooseRowProfit,maxLossRowMoney);
        maxLossRowAmount = math.max(tempLooseRow, maxLossRowAmount);

        tempWinRow = 0;
        tempWinRowProfit = 0;
      }
    });

    //update numbers
    if(SettingsController.balance == 0) maxDrawdownPercent = 99.99;

    profitFactor = (grossProfit / grossLoss).abs();

    expectedProfit = netProfit / tradesAmount;
    sellTradesPercent = sellPositionsWon/sellTradesAmount*100;
    wonTradesAmount = buyPositionsWon+sellPositionsWon;
    wonTradesPercent = wonTradesAmount/tradesAmount*100;
    averageProfit = grossProfit/wonTrades;

    buyTradesPercent = buyPositionsWon/buyTradesAmount*100;
    lostTradesAmount = tradesAmount-buyPositionsWon-sellPositionsWon;
    lostTradesPercent = lostTradesAmount/tradesAmount*100;
    averageLoss = grossLoss/lostTrades;
  }
}