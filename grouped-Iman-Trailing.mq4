// simple trailing stop
#property copyright "Iman Dezfuly"
#property link      "http://www.Iman.ir"

#define version      "20171202"

#include "./desphilboy.mqh"

extern bool   AllPositions  =True;
extern int    TrailingStopUL=550,TrailingStopVL = 500, TrailingStopL = 450, TrailingStopM = 400,
TrailingStopS=350,TrailingStopVS=300,TrailingStopUS=250,TrailingStopI=200;

extern int    TrailingStepUL=30,TrailingStepVL=30,TrailingStepL=30,TrailingStepM=30,
TrailingStepS=30,TrailingStepVS=30,TrailingStepUS=30,TrailingStepI=30;

extern FiboRetrace  RetraceFactorUL=WholeRetrace,RetraceFactorVL=WholeRetrace,RetraceFactorL=AlmostWholeRetrace,RetraceFactorM=MaxRetrace,
RetraceFactorS=HalfRetrace,RetraceFactorVS=LowRetrace,RetraceFactorUS=MinRetrace,RetraceFactorI=PaniclyRetrace;

extern LifeTimes TimeFrameUL=SixteenHours,TimeFrameVL=EightHours,TimeFrameL=FourHours,TimeFrameM=TwoHours,
TimeFrameS=OneHour,TimeFrameVS=HalfHour,TimeFrameUS=Quarter,TimeFrameI=OneMinute;
extern bool ContinueLifeTimeAfterFirstSL=True;
extern ENUM_TIMEFRAMES PanicTimeFrame=PERIOD_M15;
extern int PanicPIPS = 1000;
extern int PanicStop = 50;
extern FiboRetrace PanicRetrace=PaniclyRetrace;
extern bool SpikeTrading=false;
extern int SpikeHeight=1500;
extern Groups SpikeTradesGroup= InstantTerm;
extern ENUM_TIMEFRAMES SpikeTimeFrame=PERIOD_H1;

extern bool ActiveTrading=false;
extern int ActiveTradingGap=1500;
extern Groups ActiveTradesGroup= UltraShortTerm;

extern int SpikeAndActiveTradeSpacing=150;
extern int ActiveAndSpikeTradesDistance=200;
extern double ActiveAndSpikeLots=0.01;
extern int ActiveAndSpikeTradeStopLoss = 0;
extern int MaximumNetPositions=3;
extern int MaximumAbsolutePositions=4;

extern string AllowedPairNames="USDJPY,GBPJPY,EURJPY,USDCAD,AUDUSD,XAUUSD";
extern bool AllowedPairNamesOnly=true;
extern int TimerSeconds=10;
extern bool ShowLoopingSpeed=false;
extern bool verboseLogging = false;
extern bool ShowVolumeBallances = false;

long loopCounter=0;
long speedCounter=0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int fillTrailingInfo(int &tinfo[][])
  {
   tinfo[gid_NoGroup][0]=tinfo[gid_NoGroup][1]=tinfo[gid_NoGroup][2]=tinfo[gid_NoGroup][3]=0;
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
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   Print("Grouped trailing stop version ",version);
   Print("stops(UL,VL,L,M,S,VS,US,I):",TrailingStopUL,",",TrailingStopVL,",",TrailingStopL,",",TrailingStopM,",",TrailingStopS,",",TrailingStopVS,",",TrailingStopUS,",",TrailingStopI);
   Print("steps(UL,VL,L,M,S,VS,US,I):",TrailingStepUL,",",TrailingStepVL,",",TrailingStepL,",",TrailingStepM,",",TrailingStepS,",",TrailingStepVS,",",TrailingStepUS,",",TrailingStepI);
   Print("Retraces(UL,VL,L,M,S,VS,US,I):",Fibo[RetraceFactorUL],",",Fibo[RetraceFactorVL],",",Fibo[RetraceFactorL],",",Fibo[RetraceFactorM],",",Fibo[RetraceFactorS],",",Fibo[RetraceFactorVS],Fibo[RetraceFactorUS],",",Fibo[RetraceFactorI]);
   Print("LifeTimes(UL,VL,L,M,S,VS,US,I):",TimeFrameUL,",",TimeFrameVL,",",TimeFrameL,",",TimeFrameM,",",TimeFrameS,",",TimeFrameVS,",",TimeFrameUS,",",TimeFrameI);
   string pairNames[100];
   int numPairs=StringSplit(AllowedPairNames,',',pairNames);
   for(int i=0; i<numPairs;++i) 
     {
      Print("Pair ",i," name is: ",pairNames[i]);
     }
   fillTrailingInfo(TrailingInfo);
   EventSetTimer(TimerSeconds);
   
   beVerbose = verboseLogging;

   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer() 
  {
   if(AllowedPairNamesOnly) 
     {
      filterOutTradesNotIn(AllowedPairNames);
     }

   if(ActiveTrading && (loopCounter % 20) == 0) 
     {

      string pairNames[100];

      int numPairs=StringSplit(AllowedPairNames,',',pairNames);
      for(int i=0; i<numPairs;++i) 
        {
         if(CreateBuysCondition(pairNames[i],ActiveTradingGap,MaximumNetPositions * ActiveAndSpikeLots, MaximumAbsolutePositions * ActiveAndSpikeLots)) 
           {
            Print("Creating active trading buystops on ",pairNames[i]);
            appendBuyStops(pairNames[i],ActiveAndSpikeTradesDistance,SpikeAndActiveTradeSpacing,ActiveAndSpikeLots,ActiveAndSpikeTradeStopLoss,ActiveTradesGroup);
           }

         if(CreateSellsCondition(pairNames[i],ActiveTradingGap,MaximumNetPositions * ActiveAndSpikeLots, MaximumAbsolutePositions * ActiveAndSpikeLots)) 
           {
            Print("Creating active trading sellstops on ",pairNames[i]);
            appendSellStops(pairNames[i],ActiveAndSpikeTradesDistance,SpikeAndActiveTradeSpacing,ActiveAndSpikeLots,ActiveAndSpikeTradeStopLoss,ActiveTradesGroup);
           }
        }
     }
     
     
  long numLoops = loopCounter - speedCounter;
   speedCounter = loopCounter;
   if(ShowLoopingSpeed)
     { 
      Print("Looping Speed is:",(int)((60* numLoops)/TimerSeconds)," per minute.");
     }
     
   if(ShowVolumeBallances) {
      string pairNames[100];
      int numPairs=StringSplit(AllowedPairNames,',',pairNames);
      for(int i=0; i<numPairs;++i) 
        {
         Print("Volume of all sells for ", pairNames[i], " is:", getVolBallance(pairNames[i], OP_SELL));
         Print("Volume of all sellstops for ", pairNames[i], " is:", getVolBallance(pairNames[i], OP_SELLSTOP));
         Print("Volume of Unsafe sells for ", pairNames[i], " is:", getUnsafeSells(pairNames[i]));
         
         Print("Volume of all buys for ", pairNames[i], " is:", getVolBallance(pairNames[i], OP_BUY));
         Print("Volume of all buystops for ", pairNames[i], " is:", getVolBallance(pairNames[i], OP_BUYSTOP));
         Print("Volume of Unsafe buys for ", pairNames[i], " is:", getUnsafeBuys(pairNames[i]));
         
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
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if((AllPositions || OrderSymbol()==Symbol()) && (OrderType()==OP_BUY || OrderType()==OP_SELL))
           {
            if(isUltraLongTerm(OrderMagicNumber())) {TrailingPositions(getCurrentTrailingStop(OrderTicket(),TrailingInfo,ContinueLifeTimeAfterFirstSL,isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)),TrailingStepUL,getCurrentRetrace(OrderTicket(),TrailingInfo,ContinueLifeTimeAfterFirstSL,isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)));}
            else if(isVeryLongTerm(OrderMagicNumber())) {TrailingPositions(getCurrentTrailingStop(OrderTicket(),TrailingInfo,ContinueLifeTimeAfterFirstSL,isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)),TrailingStepVL,getCurrentRetrace(OrderTicket(),TrailingInfo,ContinueLifeTimeAfterFirstSL,isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)));}
            else if(isLongTerm(OrderMagicNumber())) {TrailingPositions(getCurrentTrailingStop(OrderTicket(),TrailingInfo,ContinueLifeTimeAfterFirstSL,isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)),TrailingStepL,getCurrentRetrace(OrderTicket(),TrailingInfo,ContinueLifeTimeAfterFirstSL,isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)));}
            else if(isMediumTerm(OrderMagicNumber())){TrailingPositions(getCurrentTrailingStop(OrderTicket(),TrailingInfo,ContinueLifeTimeAfterFirstSL,isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)),TrailingStepM,getCurrentRetrace(OrderTicket(),TrailingInfo,ContinueLifeTimeAfterFirstSL,isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)));}
            else if(isShortTerm(OrderMagicNumber())){TrailingPositions(getCurrentTrailingStop(OrderTicket(),TrailingInfo,ContinueLifeTimeAfterFirstSL,isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)),TrailingStepS,getCurrentRetrace(OrderTicket(),TrailingInfo,ContinueLifeTimeAfterFirstSL,isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)));}
            else if(isVeryShort(OrderMagicNumber())){TrailingPositions(getCurrentTrailingStop(OrderTicket(),TrailingInfo,ContinueLifeTimeAfterFirstSL,isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)),TrailingStepVS,getCurrentRetrace(OrderTicket(),TrailingInfo,ContinueLifeTimeAfterFirstSL,isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)));}
            else if(isUltraShort(OrderMagicNumber())){TrailingPositions(getCurrentTrailingStop(OrderTicket(),TrailingInfo, ContinueLifeTimeAfterFirstSL, isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)), TrailingStepUS, getCurrentRetrace(OrderTicket(),TrailingInfo, ContinueLifeTimeAfterFirstSL, isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)));}
            else if(isInstant(OrderMagicNumber())){TrailingPositions(getCurrentTrailingStop(OrderTicket(),TrailingInfo, ContinueLifeTimeAfterFirstSL, isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)), TrailingStepI, getCurrentRetrace(OrderTicket(),TrailingInfo, ContinueLifeTimeAfterFirstSL, isPanic(OrderSymbol(),PanicTimeFrame,PanicPIPS)));}
           }
        }
     }

   if(ActiveTrading && (loopCounter % MAHMARAZA_RAHVARA_ID) == 0) 
     {

      string pairNames[100];

      int numPairs=StringSplit(AllowedPairNames,',',pairNames);
      for(int i=0; i<numPairs;++i) 
        {
         if(CreateBuysCondition(pairNames[i],ActiveTradingGap,MaximumNetPositions * ActiveAndSpikeLots, MaximumAbsolutePositions * ActiveAndSpikeLots)) 
           {
            Print("Creating active trading buystops on ",pairNames[i]);
            appendBuyStops(pairNames[i],ActiveAndSpikeTradesDistance,SpikeAndActiveTradeSpacing,ActiveAndSpikeLots,ActiveAndSpikeTradeStopLoss,ActiveTradesGroup);
           }

         if(CreateSellsCondition(pairNames[i],ActiveTradingGap,MaximumNetPositions * ActiveAndSpikeLots, MaximumAbsolutePositions * ActiveAndSpikeLots)) 
           {
            Print("Creating active trading sellstops on ",pairNames[i]);
            appendSellStops(pairNames[i],ActiveAndSpikeTradesDistance,SpikeAndActiveTradeSpacing,ActiveAndSpikeLots,ActiveAndSpikeTradeStopLoss,ActiveTradesGroup);
           }
        }
   
     }


   if(SpikeTrading) 
     {
      string pairNames[100];
      int numPairs=StringSplit(AllowedPairNames,',',pairNames);
      for(int i=0; i<numPairs;++i) 
        {
         if(isPanic(pairNames[i],SpikeTimeFrame,SpikeHeight)) 
           {
            appendTradesIfAppropriate(pairNames[i],ActiveAndSpikeTradesDistance,SpikeAndActiveTradeSpacing,SpikeHeight,ActiveAndSpikeLots,MaximumNetPositions*ActiveAndSpikeLots,MaximumAbsolutePositions*ActiveAndSpikeLots,ActiveAndSpikeTradeStopLoss,SpikeTradesGroup);
           }
       }
     }

   loopCounter++;
  }
//+------------------------------------------------------------------+
//|This function trails the position which is selected.                        |
//+------------------------------------------------------------------+
void TrailingPositions(int TrailingStop,int TrailingStep,double RetraceFactor)
  {
   double pBid,pAsk,pp,pDiff,pRef,pStep,pRetraceTrail,pDirectTrail;
//----

   double RetraceValue=RetraceFactor;
   if(beVerbose) Print("Retrace factor is: ", RetraceFactor , " for ", OrderTicket());
   pp=MarketInfo(OrderSymbol(),MODE_POINT);
   if(beVerbose) Print(OrderSymbol()," Point value is: ",pp);
   pDirectTrail=TrailingStop*pp;
   if(beVerbose) Print(OrderTicket()," DirectTrail value is: ",pDirectTrail);
   pStep=TrailingStep*pp;
   if(beVerbose) Print(OrderTicket()," Step value is: ",pStep);
   
   if(OrderType()==OP_BUY)
     {
      pBid=MarketInfo(OrderSymbol(),MODE_BID);
      pDiff=pBid-OrderOpenPrice();
      pRetraceTrail=pDiff>pDirectTrail ?(pDiff-pDirectTrail)*RetraceValue : 0;
      if(beVerbose) Print(OrderTicket()," RetraceTrail value is: ",pRetraceTrail);
      pRef=pBid-pDirectTrail-pRetraceTrail;
      if(beVerbose) Print(OrderTicket()," Ref value is: ",pRef);

      if(pRef-OrderOpenPrice()>0)
        {// order is in profit.
         if((OrderStopLoss()!=0.0 && pRef-OrderStopLoss()>pStep && pRef-OrderOpenPrice()>pStep) || (OrderStopLoss()==0.0 && pRef-OrderOpenPrice()>pStep))
           {
            ModifyStopLoss(pRef);
            return;
           }
        }
     }

   if(OrderType()==OP_SELL)
     {
      pAsk=MarketInfo(OrderSymbol(),MODE_ASK);
      pDiff=OrderOpenPrice()-pAsk;
      pRetraceTrail=pDiff>pDirectTrail ?(pDiff-pDirectTrail)*RetraceValue : 0;
      pRef=pAsk+pDirectTrail+pRetraceTrail;

      if(OrderOpenPrice()-pRef>0)
        {// order is in profit.
         if((OrderStopLoss()!=0.0 && OrderStopLoss()-pRef>pStep && OrderOpenPrice()-pRef>pStep) || (OrderStopLoss()==0.0 && OrderOpenPrice()-pRef>pStep))
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

   if(fm)
     {
      Print("Order ",OrderTicket()," modified to Stoploss=",ldStopLoss," group:",getGroupName(OrderMagicNumber()));
        } else{
      Print("could not modify order:",OrderTicket()," group:",getGroupName(OrderMagicNumber()));
     }
  }
//+------------------------------------------------------------------+
