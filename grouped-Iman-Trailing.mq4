// simple trailing stop
#property copyright "Iman Dezfuly"
#property link      "http://www.Iman.ir"

#define version      "201704171"

#include "./desphilboy.mqh"

extern bool   AllPositions  =True;         
extern int    TrailingStopVL = 380, TrailingStopL = 400, TrailingStopM = 420, TrailingStopS = 440, TrailingStopU = 460;            
extern int    TrailingStepVL  =30, TrailingStepL  =30, TrailingStepM = 30, TrailingStepS = 20, TrailingStepU = 20;             
extern FiboRetrace  RetraceFactorVL=MaxRetrace, RetraceFactorL=MaxRetrace, RetraceFactorM = HalfRetrace, RetraceFactorS = LowRetrace, RetraceFactorU = MinRetrace;
extern LifeTimes TimeFrameVL=SixteenHours, TimeFrameL=EightHours, TimeFrameM=FourHours, TimeFrameS=TwoHours, TimeFrameU=Hour;
extern bool ContinueLifeTimeAfterFirstSL=True;
extern ENUM_TIMEFRAMES PanicTimeFrame = PERIOD_M1;
extern int PanicPIPS = 1500;
extern int PanicStop = 30;
extern FiboRetrace PanicRetrace = NoRetrace;
extern bool ActiveSpikeTrading = false;
extern ENUM_TIMEFRAMES SpikeTimeFrame = PERIOD_H1;
extern int SpikePIPS = 1500;
extern int SpikeMarginPIPs = 350;
extern double SpikeTradeLots = 0.01;
extern double MaximumNetPositionLots = 0.02;
extern string AllowedPairNames = "USDJPY,GBPJPY,EURJPY,USDCAD,AUDUSD";
extern bool AllowedPairNamesOnly = true;
extern int TimerSeconds = 10;
extern bool ActiveTrading = false;
extern ENUM_TIMEFRAMES ActiveTradingTimeFrame = PERIOD_D1;

int fillTrailingInfo( int& tinfo[][])
{
tinfo[gid_NoGroup][0] = tinfo[gid_NoGroup][1] = tinfo[gid_NoGroup][2] = tinfo[gid_NoGroup][3] = 0;
tinfo[gid_VeryLongTerm][TrailingStop]=TrailingStopVL; tinfo[gid_VeryLongTerm][Step]=TrailingStepVL; tinfo[gid_VeryLongTerm][Retrace]=RetraceFactorVL; tinfo[gid_VeryLongTerm][LifePeriod]=TimeFrameVL;
tinfo[gid_LongTerm][TrailingStop]=TrailingStopL; tinfo[gid_LongTerm][Step]=TrailingStepL; tinfo[gid_LongTerm][Retrace]=RetraceFactorL; tinfo[gid_LongTerm][LifePeriod]=TimeFrameL;
tinfo[gid_MediumTerm][TrailingStop]=TrailingStopM; tinfo[gid_MediumTerm][Step]=TrailingStepM; tinfo[gid_MediumTerm][Retrace]=RetraceFactorM; tinfo[gid_MediumTerm][LifePeriod]=TimeFrameM;
tinfo[gid_ShortTerm][TrailingStop]=TrailingStopS; tinfo[gid_ShortTerm][Step]=TrailingStepS; tinfo[gid_ShortTerm][Retrace]=RetraceFactorS; tinfo[gid_ShortTerm][LifePeriod]=TimeFrameS;
tinfo[gid_UserGroup][TrailingStop]=TrailingStopU; tinfo[gid_UserGroup][Step]=TrailingStepU; tinfo[gid_UserGroup][Retrace]=RetraceFactorU; tinfo[gid_UserGroup][LifePeriod]=TimeFrameU;
tinfo[gid_Panic][TrailingStop]=PanicStop; tinfo[gid_Panic][Step]=TrailingStepU; tinfo[gid_Panic][Retrace]=PanicRetrace; tinfo[gid_Panic][LifePeriod]=PanicTimeFrame;
return 0;
}


int init()
{
  Print("Grouped trailing stop version ",version);
  Print("stops(VL,L,M,S,U):", TrailingStopVL, ",",TrailingStopL, ",", TrailingStopM, ",", TrailingStopS, ",", TrailingStopU); 
  Print("steps(VL,L,M,S,U):", TrailingStepVL, ",", TrailingStepL, ",", TrailingStepM, ",", TrailingStepS, ",", TrailingStepU);
  Print("Retraces(VL,L,M,S,U):", RetraceFactorVL, ",", RetraceFactorL, ",", RetraceFactorM, ",", RetraceFactorS, ",", RetraceFactorU);
  Print("LifeTimes(VL,L,M,S,U):", TimeFrameVL, ",", TimeFrameL, ",", TimeFrameM, ",", TimeFrameS, ",", TimeFrameU);
  fillTrailingInfo(TrailingInfo);
  EventSetTimer(TimerSeconds); 
  return(0); 
}

void OnTimer() {
if(AllowedPairNamesOnly) {
   filterOutTradesNotIn(AllowedPairNames);
}

if(ActiveTrading) {
         int spikeSpacing[7];
         for( int i = 0; i < 7; ++i) spikeSpacing[i] = SpikeMarginPIPs;

         string pairNames[100];
         int numPairs= StringSplit(AllowedPairNames, ',', pairNames);
         for( int i=0; i<numPairs; ++i) {
               if(isPanic(pairNames[i],ActiveTradingTimeFrame ,SpikePIPS)) {
                  appendTradesIfAppropriate(pairNames[i],SpikeMarginPIPs, spikeSpacing,SpikePIPS,SpikeTradeLots,MaximumNetPositionLots);
               }
         }
      }

return;
}

//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
  void start() 
  {
     for(int i=0; i<OrdersTotal(); i++) 
     {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) 
        {
           if ((AllPositions || OrderSymbol()==Symbol()) && (OrderType() == OP_BUY || OrderType() == OP_SELL)) 
           {
           if(isVeryLongTerm(OrderMagicNumber())) {TrailingPositions(getCurrentTrailingStop(OrderTicket(),TrailingInfo, ContinueLifeTimeAfterFirstSL, isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)), TrailingStepVL, getCurrentRetrace(OrderTicket(),TrailingInfo, ContinueLifeTimeAfterFirstSL, isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)));}
                  else if(isLongTerm(OrderMagicNumber())) {TrailingPositions(getCurrentTrailingStop(OrderTicket(),TrailingInfo, ContinueLifeTimeAfterFirstSL, isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)), TrailingStepL, getCurrentRetrace(OrderTicket(),TrailingInfo, ContinueLifeTimeAfterFirstSL, isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)));}
                        else if(isMediumTerm(OrderMagicNumber())){TrailingPositions(getCurrentTrailingStop(OrderTicket(),TrailingInfo, ContinueLifeTimeAfterFirstSL, isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)), TrailingStepM, getCurrentRetrace(OrderTicket(),TrailingInfo, ContinueLifeTimeAfterFirstSL, isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)));}
                            else if(isShortTerm(OrderMagicNumber())){TrailingPositions(getCurrentTrailingStop(OrderTicket(),TrailingInfo, ContinueLifeTimeAfterFirstSL, isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)), TrailingStepS, getCurrentRetrace(OrderTicket(),TrailingInfo, ContinueLifeTimeAfterFirstSL, isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)));}
                                 else if(isUserGroup(OrderMagicNumber())){TrailingPositions(getCurrentTrailingStop(OrderTicket(),TrailingInfo, ContinueLifeTimeAfterFirstSL, isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)), TrailingStepU, getCurrentRetrace(OrderTicket(),TrailingInfo, ContinueLifeTimeAfterFirstSL, isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)));}
           }
        }
     }
     
     if(ActiveSpikeTrading) {
         int spikeSpacing[7];
         for( int i = 0; i < 7; ++i) spikeSpacing[i] = SpikeMarginPIPs;

         string pairNames[100];
         int numPairs= StringSplit(AllowedPairNames, ',', pairNames);
         for( int i=0; i<numPairs; ++i) {
               if(isPanic(pairNames[i],SpikeTimeFrame,SpikePIPS)) {
                  appendTradesIfAppropriate(pairNames[i],SpikeMarginPIPs, spikeSpacing,SpikePIPS,SpikeTradeLots,MaximumNetPositionLots);
               }
         }
      }
  }
  
   
//+------------------------------------------------------------------+
//|This function trails the position which is selected.                        |
//+------------------------------------------------------------------+
  void TrailingPositions(int TrailingStop, int TrailingStep,double RetraceFactor) 
  {
   double pBid, pAsk, pp, pDiff, pRef, pStep, pRetraceTrail, pDirectTrail;
//----

   double RetraceValue= RetraceFactor;
   pp=MarketInfo(OrderSymbol(), MODE_POINT);
   pDirectTrail = TrailingStop * pp;
   pStep = TrailingStep * pp;
   
     if (OrderType()==OP_BUY) 
     {
      pBid = MarketInfo(OrderSymbol(), MODE_BID);
      pDiff = pBid - OrderOpenPrice();
      pRetraceTrail = pDiff > pDirectTrail ? (pDiff - pDirectTrail) * RetraceValue : 0;
      pRef = pBid - pDirectTrail - pRetraceTrail; 
      
        if (pRef - OrderOpenPrice() > 0 ) 
        {// order is in profit.
           if ((OrderStopLoss() != 0.0 && pRef - OrderStopLoss() > pStep && pRef - OrderOpenPrice() > pStep)  || (OrderStopLoss() == 0.0 && pRef - OrderOpenPrice() > pStep)) 
           {
            ModifyStopLoss(pRef);
            return;
           }
        }
     }
     
     if (OrderType()==OP_SELL) 
     {
      pAsk = MarketInfo(OrderSymbol(), MODE_ASK);
      pDiff = OrderOpenPrice() - pAsk;
      pRetraceTrail = pDiff > pDirectTrail ? (pDiff - pDirectTrail) * RetraceValue : 0;
      pRef = pAsk + pDirectTrail + pRetraceTrail; 
      
        if (OrderOpenPrice()- pRef > 0) 
        {// order is in profit.
           if ((OrderStopLoss() != 0.0 && OrderStopLoss() - pRef > pStep && OrderOpenPrice() - pRef > pStep) || (OrderStopLoss() == 0.0 && OrderOpenPrice() - pRef > pStep))
           {
            ModifyStopLoss(pRef);
            return;
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|   this modifies a selected order and chages its stoploss                                      |
//|                                           
//|   Params: ldStopLoss  , double is the new value for stoploss                          
//+------------------------------------------------------------------+
  void ModifyStopLoss(double ldStopLoss) 
  {
   bool fm;
   fm=OrderModify(OrderTicket(),OrderOpenPrice(),ldStopLoss,OrderTakeProfit(),0,CLR_NONE);
   
   if (fm){
   Print("Order ", OrderTicket(), " modified to Stoploss=",ldStopLoss," group:", getGroupName(OrderMagicNumber()));
   } else{
   Print("could not modify order:",OrderTicket(), " group:", getGroupName(OrderMagicNumber()));
   }
  }
//+------------------------------------------------------------------+


