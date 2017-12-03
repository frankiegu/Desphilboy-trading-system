// simple trailing stop
#property copyright "Iman Dezfuly"
#property link      "http://www.Iman.ir"

#define version      "20171201"

#include "./desphilboy.mqh"

extern bool   AllPositions  =True;
extern int    TrailingStopUL=850,TrailingStopVL = 800, TrailingStopL = 750, TrailingStopM = 700,
 TrailingStopS = 650, TrailingStopVS = 600,TrailingStopUS = 550, TrailingStopI = 500;

extern int    TrailingStepUL = 30, TrailingStepVL  =30, TrailingStepL  =30, TrailingStepM = 30,
 TrailingStepS = 30, TrailingStepVS = 30, TrailingStepUS = 30, TrailingStepI = 30;
 
extern FiboRetrace  RetraceFactorUL=WholeRetrace,RetraceFactorVL=WholeRetrace, RetraceFactorL=WholeRetrace, RetraceFactorM =AlmostWholeRetrace,
 RetraceFactorS = MaxRetrace, RetraceFactorVS = HalfRetrace, RetraceFactorUS=LowRetrace, RetraceFactorI=MinRetrace;

extern LifeTimes TimeFrameUL=ThreeDays, TimeFrameVL=ThirtyTwoHours, TimeFrameL=SixteenHours, TimeFrameM=EightHours,
 TimeFrameS=FourHours, TimeFrameVS=TwoHours, TimeFrameUS=OneHour, TimeFrameI=HalfHour;
extern bool ContinueLifeTimeAfterFirstSL=True;
extern ENUM_TIMEFRAMES PanicTimeFrame = PERIOD_M15;
extern int PanicPIPS = 1000;
extern int PanicStop = 50;
extern FiboRetrace PanicRetrace = PaniclyRetrace;
extern bool SpikeTrading = false;
extern bool ActiveTrading = false;
extern ENUM_TIMEFRAMES ActiveTradingTimeFrame = PERIOD_D1;
extern ENUM_TIMEFRAMES SpikeTimeFrame = PERIOD_H1;
extern int SpikeHeightAndActiveTradingDistance = @1500;
extern int SpikeAndActiveTradeSpacing = 150;  
extern int ActiveAndSpikeTradesSeparationDistance = 200;     
extern double ActiveAndSpikeLots = 0.01;
extern Groups ActiveAndSpikeTradesGroup = InstantTerm;
extern int ActiveAndSpikeTradeStopLoss = 1500;
extern int MaximumNetPositions = 3;
extern int MaximumAbsolutePositions = 4;
extern string AllowedPairNames = "USDJPY,GBPJPY,EURJPY,USDCAD,AUDUSD";
extern bool AllowedPairNamesOnly = true;
extern int TimerSeconds = 10;
extern bool ShowLoopingSpeed = false;

bool     activeMessageFlags[100];
bool     panicMessageFlags[100];

int loopCounter=0;



int fillTrailingInfo( int& tinfo[][])
{
tinfo[gid_NoGroup][0] = tinfo[gid_NoGroup][1] = tinfo[gid_NoGroup][2] = tinfo[gid_NoGroup][3] = 0;
tinfo[gid_UltraLongTerm][TrailingStop]=TrailingStopUL; tinfo[gid_UltraLongTerm][Step]=TrailingStepUL; tinfo[gid_UltraLongTerm][Retrace]=RetraceFactorUL; tinfo[gid_UltraLongTerm][LifePeriod]=TimeFrameUL;
tinfo[gid_VeryLongTerm][TrailingStop]=TrailingStopVL; tinfo[gid_VeryLongTerm][Step]=TrailingStepVL; tinfo[gid_VeryLongTerm][Retrace]=RetraceFactorVL; tinfo[gid_VeryLongTerm][LifePeriod]=TimeFrameVL;
tinfo[gid_LongTerm][TrailingStop]=TrailingStopL; tinfo[gid_LongTerm][Step]=TrailingStepL; tinfo[gid_LongTerm][Retrace]=RetraceFactorL; tinfo[gid_LongTerm][LifePeriod]=TimeFrameL;
tinfo[gid_MediumTerm][TrailingStop]=TrailingStopM; tinfo[gid_MediumTerm][Step]=TrailingStepM; tinfo[gid_MediumTerm][Retrace]=RetraceFactorM; tinfo[gid_MediumTerm][LifePeriod]=TimeFrameM;
tinfo[gid_ShortTerm][TrailingStop]=TrailingStopS; tinfo[gid_ShortTerm][Step]=TrailingStepS; tinfo[gid_ShortTerm][Retrace]=RetraceFactorS; tinfo[gid_ShortTerm][LifePeriod]=TimeFrameS;
tinfo[gid_VeryShortTerm][TrailingStop]=TrailingStopVS; tinfo[gid_VeryShortTerm][Step]=TrailingStepVS; tinfo[gid_VeryShortTerm][Retrace]=RetraceFactorVS; tinfo[gid_VeryShortTerm][LifePeriod]=TimeFrameVS;
tinfo[gid_UltraShortTerm][TrailingStop]=TrailingStopUS; tinfo[gid_UltraShortTerm][Step]=TrailingStepUS; tinfo[gid_UltraShortTerm][Retrace]=RetraceFactorUS; tinfo[gid_UltraShortTerm][LifePeriod]=TimeFrameUS;
tinfo[gid_InstantTerm][TrailingStop]=TrailingStopI; tinfo[gid_InstantTerm][Step]=TrailingStepI; tinfo[gid_InstantTerm][Retrace]=RetraceFactorI; tinfo[gid_InstantTerm][LifePeriod]=TimeFrameI;

tinfo[gid_Panic][TrailingStop]=PanicStop; tinfo[gid_Panic][Step]=TrailingStepVS; tinfo[gid_Panic][Retrace]=PanicRetrace; tinfo[gid_Panic][LifePeriod]=PanicTimeFrame;
return 0;
}


int init()
{
  Print("Grouped trailing stop version ",version);
  Print("stops(UL,VL,L,M,S,VS,US,I):", TrailingStopUL, ",", TrailingStopVL, ",",TrailingStopL, ",", TrailingStopM, ",", TrailingStopS, ",", TrailingStopVS, ",", TrailingStopUS, ",", TrailingStopI);
  Print("steps(UL,VL,L,M,S,VS,US,I):", TrailingStepUL, ",", TrailingStepVL, ",", TrailingStepL, ",", TrailingStepM, ",", TrailingStepS, ",", TrailingStepVS, ",", TrailingStepUS, ",", TrailingStepI);
  Print("Retraces(UL,VL,L,M,S,VS,US,I):", Fibo[RetraceFactorUL], ",", Fibo[RetraceFactorVL], ",", Fibo[RetraceFactorL], ",", Fibo[RetraceFactorM], ",", Fibo[RetraceFactorS], ",", Fibo[RetraceFactorVS], Fibo[RetraceFactorUS], ",", Fibo[RetraceFactorI]);
  Print("LifeTimes(UL,VL,L,M,S,VS,US,I):", TimeFrameUL, ",", TimeFrameVL, ",", TimeFrameL, ",", TimeFrameM, ",", TimeFrameS, ",", TimeFrameVS, ",", TimeFrameUS, ",", TimeFrameI);
  string pairNames[100];
         int numPairs= StringSplit(AllowedPairNames, ',', pairNames);
         for( int i=0; i<numPairs; ++i) {
          Print("Pair ", i, " name is: ", pairNames[i]);
         }
  fillTrailingInfo(TrailingInfo);
  EventSetTimer(TimerSeconds);

  for(int i=0; i<100; activeMessageFlags[i++]=false);
  for(int i=0; i<100; panicMessageFlags[i++]=false);

  return(0);
}

void OnTimer() {
if(AllowedPairNamesOnly) {
   filterOutTradesNotIn(AllowedPairNames);
}

if(ActiveTrading && loopCounter % 20 == 0) {

         string pairNames[100];

         int numPairs= StringSplit(AllowedPairNames, ',', pairNames);
         for( int i=0; i<numPairs; ++i) {
               if(isPanic(pairNames[i],ActiveTradingTimeFrame ,SpikeHeightAndActiveTradingDistance)) {
                  if(!activeMessageFlags[i]) {
                     Print("Active trading conditions detected on ", pairNames[i]);
                     activeMessageFlags[i] = true;
                  }
                  appendTradesIfAppropriate(pairNames[i],ActiveAndSpikeTradesSeparationDistance, SpikeAndActiveTradeSpacing, SpikeHeightAndActiveTradingDistance, ActiveAndSpikeLots, MaximumNetPositions * ActiveAndSpikeLots, MaximumAbsolutePositions * ActiveAndSpikeLots, ActiveAndSpikeTradeStopLoss, ActiveAndSpikeTradesGroup);
               } else {
                        activeMessageFlags[i] = false;
                        }
         }
      }

if (ShowLoopingSpeed) Print( "Looping Speed is:", (int) ((60 * loopCounter) / TimerSeconds), " per minute.");
loopCounter = 0;
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
           if(isUltraLongTerm(OrderMagicNumber())) {TrailingPositions(getCurrentTrailingStop(OrderTicket(),TrailingInfo, ContinueLifeTimeAfterFirstSL, isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)), TrailingStepUL, getCurrentRetrace(OrderTicket(),TrailingInfo, ContinueLifeTimeAfterFirstSL, isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)));}
               else if(isVeryLongTerm(OrderMagicNumber())) {TrailingPositions(getCurrentTrailingStop(OrderTicket(),TrailingInfo, ContinueLifeTimeAfterFirstSL, isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)), TrailingStepVL, getCurrentRetrace(OrderTicket(),TrailingInfo, ContinueLifeTimeAfterFirstSL, isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)));}
                  else if(isLongTerm(OrderMagicNumber())) {TrailingPositions(getCurrentTrailingStop(OrderTicket(),TrailingInfo, ContinueLifeTimeAfterFirstSL, isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)), TrailingStepL, getCurrentRetrace(OrderTicket(),TrailingInfo, ContinueLifeTimeAfterFirstSL, isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)));}
                        else if(isMediumTerm(OrderMagicNumber())){TrailingPositions(getCurrentTrailingStop(OrderTicket(),TrailingInfo, ContinueLifeTimeAfterFirstSL, isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)), TrailingStepM, getCurrentRetrace(OrderTicket(),TrailingInfo, ContinueLifeTimeAfterFirstSL, isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)));}
                            else if(isShortTerm(OrderMagicNumber())){TrailingPositions(getCurrentTrailingStop(OrderTicket(),TrailingInfo, ContinueLifeTimeAfterFirstSL, isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)), TrailingStepS, getCurrentRetrace(OrderTicket(),TrailingInfo, ContinueLifeTimeAfterFirstSL, isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)));}
                                 else if(isVeryShort(OrderMagicNumber())){TrailingPositions(getCurrentTrailingStop(OrderTicket(),TrailingInfo, ContinueLifeTimeAfterFirstSL, isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)), TrailingStepVS, getCurrentRetrace(OrderTicket(),TrailingInfo, ContinueLifeTimeAfterFirstSL, isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)));}
                                    else if(isUltraShort(OrderMagicNumber())){TrailingPositions(getCurrentTrailingStop(OrderTicket(),TrailingInfo, ContinueLifeTimeAfterFirstSL, isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)), TrailingStepUS, getCurrentRetrace(OrderTicket(),TrailingInfo, ContinueLifeTimeAfterFirstSL, isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)));}
                                       else if(isInstant(OrderMagicNumber())){TrailingPositions(getCurrentTrailingStop(OrderTicket(),TrailingInfo, ContinueLifeTimeAfterFirstSL, isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)), TrailingStepI, getCurrentRetrace(OrderTicket(),TrailingInfo, ContinueLifeTimeAfterFirstSL, isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)));}
           }
        }
     }

     if(SpikeTrading) {

         string pairNames[100];
         int numPairs= StringSplit(AllowedPairNames, ',', pairNames);
         for( int i=0; i<numPairs; ++i) {
               if(isPanic(pairNames[i],SpikeTimeFrame,SpikeHeightAndActiveTradingDistance)) {
                  if(!panicMessageFlags[i]) {
                     Print("Active Spike trading conditions detected on ", pairNames[i]);
                     panicMessageFlags[i] = true;
                     }
                  appendTradesIfAppropriate(pairNames[i],ActiveAndSpikeTradesSeparationDistance, SpikeAndActiveTradeSpacing, SpikeHeightAndActiveTradingDistance,ActiveAndSpikeLots,MaximumNetPositions * ActiveAndSpikeLots,MaximumAbsolutePositions * ActiveAndSpikeLots, ActiveAndSpikeTradeStopLoss, ActiveAndSpikeTradesGroup);
               } else {
                        panicMessageFlags[i] = false;
                     }
         }
      }

      loopCounter++;
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


