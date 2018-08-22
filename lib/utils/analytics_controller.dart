import 'dart:core';
import 'package:trade_buddy/utils/settings_controller.dart';
import 'dart:math' as math;
import 'package:trade_buddy/utils/trades_controller.dart';

class AnalyticsController{

  static double netProfit;
  static double profitFactor;
  static int tradesAmount;

  static double grossProfit;
  static double expectedProfit;
  static double maxDrawdownMoney;
  static double maxDrawdownPercent;
  static int sellTradesAmount;
  static double sellTradesPercent;
  static int wonTradesAmount;
  static double wonTradesPercent;
  static double biggestProfit;
  static double averageProfit;
  static int maxWinRowAmount;
  static double maxWinRowMoney;

  static double grossLoss;
  static int buyTradesAmount;
  static double buyTradesPercent;
  static int lostTradesAmount;
  static double lostTradesPercent;
  static double biggestLoss;
  static double averageLoss;
  static int maxLossRowAmount;
  static double maxLossRowMoney;

  static void calcNumbers(){
    double profit = 0.0, wonTradesProfit = 0.0, lostTradesLoss = 0.0;
    double maxDrawdown = 0.0, maxDrawdownInPercent = 0.0, maxProfit = 0.0, tempDrawdown = 0.0;
    int tradesCounter = 0, sellPositions = 0, sellPositionsWon = 0, buyPositions = 0, buyPositionsWon = 0;
    int wonTrades = 0, lostTrades = 0;
    double biggestWonTrade = 0.0, biggestLostTrade = 0.0;
    int maxWinRow = 0, maxLooseRow = 0, tempWinRow = 0, tempLooseRow = 0;
    double tempWinRowProfit = 0.0, tempLooseRowProfit = 0.0, maxWinRowProfit = 0.0, maxLooseRowProfit = 0.0;

    //calclate maxDD and profit
    double maxAccountBalance = SettingsController.balance;
    double tempDrawdownAccountBalance = SettingsController.balance;
    TradesController.trades.forEach((t){
      profit += (t.profit + t.commission + t.swap);
      if(profit >= maxProfit){
        maxProfit = profit;
        tempDrawdown = profit;
        maxAccountBalance = SettingsController.balance + profit;
        tempDrawdownAccountBalance = SettingsController.balance + profit;
      }
      else{
        tempDrawdown += profit;
        tempDrawdownAccountBalance += profit;
        if(maxAccountBalance != 0){
          double drawdownInPercent = ((maxAccountBalance-tempDrawdownAccountBalance) / maxAccountBalance) * 100;
          maxDrawdownInPercent = math.max(drawdownInPercent, maxDrawdownInPercent);
        }
        if(tempDrawdown <= maxProfit - maxDrawdown) maxDrawdown = maxProfit - tempDrawdown;
      }

      //calculate other numbers
      //calculate profit, profitBuy, profitSell
      if(profit >= 0) wonTradesProfit += profit;
      else lostTradesLoss += profit;

      //calculate amount of trades
      tradesCounter++;
      if(profit >= 0) wonTrades++;
      else lostTrades++;
      if(t.type == "buy"){
        buyPositions++;
        if(profit >= 0){
          buyPositionsWon++;
        }
      }else{
        sellPositions++;
        if(profit >= 0){
          sellPositionsWon++;
        }
      }

      //calculate biggest win and biggest loss
      if(profit > biggestWonTrade) biggestWonTrade = profit;
      if(profit < biggestLostTrade) biggestLostTrade = profit;

      //calculate max win streak
      if(profit >= 0){
        tempWinRow++;
        tempWinRowProfit += profit;
        maxWinRowProfit = math.max(tempWinRowProfit,maxWinRowProfit);
        maxWinRow = math.max(tempWinRow, maxWinRow);
      }else{
        tempWinRow = 0;
        tempWinRowProfit = 0.0;
      }
      if(profit<= 0){
        tempLooseRow++;
        tempLooseRowProfit += profit;
        maxLooseRowProfit = math.min(tempLooseRowProfit,maxLooseRowProfit);
        maxLooseRow = math.max(tempLooseRow, maxLooseRow);
      }else{
        tempLooseRow = 0;
        tempLooseRowProfit = 0.0;
      }
    });
    if(SettingsController.balance == 0) maxDrawdownInPercent = 99.99;

    //update numbers
    netProfit = profit;
    profitFactor = wonTradesProfit / lostTradesLoss;
    tradesAmount = tradesCounter;

    grossProfit = wonTradesProfit;
    expectedProfit = profit / tradesCounter;
    maxDrawdownMoney = maxDrawdown;
    maxDrawdownPercent = maxDrawdownInPercent;
    sellTradesAmount = sellPositions;
    sellTradesPercent = sellPositionsWon/sellPositions;
    wonTradesAmount = buyPositionsWon+sellPositionsWon;
    wonTradesPercent = wonTradesAmount/tradesCounter*100;
    biggestProfit = biggestWonTrade;
    averageProfit = wonTradesProfit/wonTrades;
    maxWinRowAmount = maxWinRow;
    maxWinRowMoney = maxWinRowProfit;

    grossLoss = lostTradesLoss;
    buyTradesAmount = buyPositions;
    buyTradesPercent = buyPositionsWon/buyPositions;
    lostTradesAmount = tradesCounter-buyPositionsWon-sellPositionsWon;
    lostTradesPercent = lostTradesAmount/tradesCounter*100;
    biggestLoss = biggestLostTrade;
    averageLoss = lostTradesLoss/lostTrades;
    maxLossRowAmount = maxLooseRow;
    maxLossRowMoney = maxLooseRowProfit;
  }
}