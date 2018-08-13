import 'dart:core';
import 'dart:math' as math;

void calcNumbers(){
  double profit = 0.0, wonTradesProfit = 0.0, lostTradesLoss = 0.0;
  double maxDrawdown = 0.0, maxDrawdownInPercent = 0.0, maxProfit = 0.0, tempDrawdown = 0.0;
  int tradesCounter = 0, sellPositions = 0, sellPositionsWon = 0, buyPositions = 0, buyPositionsWon = 0;
  int wonTrades = 0, lostTrades = 0;
  double biggestWonTrade = 0.0, biggestLostTrade = 0.0;
  int maxWinRow = 0, maxLooseRow = 0, tempWinRow = 0, tempLooseRow = 0;
  double tempWinRowProfit = 0.0, tempLooseRowProfit = 0.0, maxWinRowProfit = 0.0, maxLooseRowProfit = 0.0;

  //calclate maxDD and profit
  double maxAccountBalance = Settings.account;
  double tempDrawdownAccountBalance = Settings.account;
  for(Trade t : Controller.trades){
    profit += (t.getGewinn() + t.getKommission() + t.getSwap());
    if(profit >= maxProfit){
      maxProfit = profit;
      tempDrawdown = profit;
      maxAccountBalance = Settings.account + profit;
      tempDrawdownAccountBalance = Settings.account + profit;
    }
    else{
      tempDrawdown += t.getGewinn();
      tempDrawdownAccountBalance += t.getGewinn();
      if(maxAccountBalance != 0){
        double drawdownInPercent = ((maxAccountBalance-tempDrawdownAccountBalance) / maxAccountBalance) * 100;
        maxDrawdownInPercent = .max(drawdownInPercent, maxDrawdownInPercent);
      }
      if(tempDrawdown <= maxProfit - maxDrawdown) maxDrawdown = maxProfit - tempDrawdown;
    }
  }
  if(Settings.account == 0) maxDrawdownInPercent = 99.99;

  //calculate other numbers
  for(Trade t : Controller.trades){
    double tradeProfit = t.getGewinn() + t.getKommission() + t.getSwap();

    //calculate profit, profitBuy, profitSell 
    if(tradeProfit >= 0) wonTradesProfit += tradeProfit;
    else lostTradesLoss += tradeProfit;

    //calculate amount of trades
    tradesCounter++;
    if(tradeProfit >= 0) wonTrades++;
    else lostTrades++;
    if(t.getTypEinstieg().equals("Long")){
      buyPositions++;
      if(tradeProfit >= 0){
        buyPositionsWon++;
      }
    }else{
      sellPositions++;
      if(tradeProfit >= 0){
        sellPositionsWon++;
      }
    }

    //calculate biggest win and biggest loss
    if(tradeProfit > biggestWonTrade) biggestWonTrade = tradeProfit;
    if(tradeProfit < biggestLostTrade) biggestLostTrade = tradeProfit;

    //calculate max win streak
    if(tradeProfit >= 0){
      tempWinRow++;
      tempWinRowProfit += tradeProfit;
      maxWinRowProfit = math.max(tempWinRowProfit,maxWinRowProfit);
      maxWinRow = math.max(tempWinRow, maxWinRow);
    }else{
      tempWinRow = 0;
      tempWinRowProfit = 0;
    }
    if(tradeProfit <= 0){
      tempLooseRow++;
      tempLooseRowProfit += tradeProfit;
      maxLooseRowProfit = math.min(tempLooseRowProfit,maxLooseRowProfit);
      maxLooseRow = math.max(tempLooseRow, maxLooseRow);
    }else{
      tempLooseRow = 0;
      tempLooseRowProfit = 0;
    }
  }

  //profit factor
  labelProfitfaktor.setText(String.valueOf(math.abs(round(wonTradesProfit/lostTradesLoss,2))));

  //expectedProfit
  labelErwartetesErgebnis.setText(String.valueOf(round(profit/tradesCounter,2)));
  //max Drawdown in percent
  labelMaximalerRueckgangInProzent.setText(String.valueOf(math.abs(round(maxDrawdownInPercent,2))) + "%");
  //sellPositions and won
  double percent =  round((sellPositionsWon/(double)sellPositions)*100,2);
  labelSellTrades.setText(String.valueOf(sellPositions) + " (" + percent + "%)");
  //win trades and percent of all 
  percent = round((buyPositionsWon+sellPositionsWon)/(double)tradesCounter*100,2);
  labelGewinntrades.setText(String.valueOf(buyPositionsWon+sellPositionsWon) + " (" + String.valueOf((double)percent) + "%)");
  //avg win
  labelDurchschnittGewinntrade.setText(String.valueOf(round(wonTradesProfit/wonTrades,2)));
  //buyPositins and won
  percent = round((buyPositionsWon/(double)buyPositions)*100,2);
  labelBuyTrades.setText(String.valueOf(buyPositions) + " (" + String.valueOf(percent) + "%)");
  //lost trades and percent of all
  percent = round((tradesCounter-buyPositionsWon-sellPositionsWon)/(double)tradesCounter*100,2);
  labelVerlusttrades.setText(String.valueOf(tradesCounter-buyPositionsWon-sellPositionsWon) + " (" + String.valueOf(percent) + "%)");
  //avg loss
  labelDurchschnittVerlusttrade.setText(String.valueOf(round(lostTradesLoss/lostTrades,2)));
}