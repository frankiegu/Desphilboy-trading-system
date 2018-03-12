// Desphilboy Position Creator
#property copyright "Iman Dezfuly"
#property link      "http://www.Iman.ir"
#define version      "20171202"

#include "./desphilboy.mqh"

#define TIMERDELAYSECONDS 10
#define DELAY 100

enum DoTradesToggler {
    YesDoTheTrdes, DoTheTradesYes
};

extern DoTradesToggler DoTrades = YesDoTheTrdes;
DoTradesToggler doTradesTogglerCopy = DoTrades;

extern TradeActs Action = NoAction;
TradeActs actionCopy = Action;

extern double BuyLots = 0.01;
extern double SellLots = 0.01;
extern double BuyStartingPrice = 0.0;
extern double SellStartingPrice = 0.0;
extern int TradesDistance = 150;

extern string PIPsToStartI = "8,16";
extern string PIPsToStartUS = "7,15";
extern string PIPsToStartVS = "6,14";
extern string PIPsToStartS = "5,13";
extern string PIPsToStartM = "4,12";
extern string PIPsToStartL = "3,11";
extern string PIPsToStartVL = "2,10";
extern string PIPsToStartUL = "1,9";

extern int TradeSpacing = 90;

extern bool CreateBuys = true;
extern bool CreateSells = true;

extern bool PaintPositions = true;

extern color UltraLongTermColour = clrDarkViolet;
extern color VeryLongTermColour = clrMaroon;
extern color LongTermColour = clrAqua;
extern color MediumTermColour = clrGreen;
extern color ShortTermColour = clrRed;
extern color VeryShortTermColour = clrBlue;
extern color UltraShortTermColour = clrDarkOrange;
extern color InstantTermColour = clrSienna;

extern int TradesStopLoss = 0;
extern int TradesTakeProfit = 0;

extern int Slippage = 50;

extern int TradesExpireAfterHours = 0;
extern double BuyTradesDistanceCoefficient = 1.0;
extern double SellTradesDistanceCoefficient = 1.0;
extern int InitialPIPsToStart = 300;

static bool askUserToDoPositions = false;
static bool doPositionsOnce = false;


bool isDoPositionsToggled() {
   if(doTradesTogglerCopy != DoTrades || actionCopy != Action) {
      doTradesTogglerCopy = DoTrades;
      actionCopy = Action;
      return true;
   }

   return false;
}


void init()
{
   Print("Desphilboy position creator ",version, " on ", Symbol());
   EventSetTimer(TIMERDELAYSECONDS);

return;
}


void OnTimer() {
   if(isDoPositionsToggled() && Action != NoAction) {
      int result = MessageBox("Are you sure you want to Alter " + Symbol() +" positions according to params?",
                              "Confirm creation of positions:",
                              MB_OKCANCEL + MB_ICONWARNING +MB_DEFBUTTON2
                              );
      if( result == IDOK){
         doPositionsOnce = true;
      }
   }
   EventKillTimer();
}


void OnChartEvent(const int id,         // Event identifier
                  const long& lparam,   // Event parameter of long type
                  const double& dparam, // Event parameter of double type
                  const string& sparam) // Event parameter of string type
  {
if( id ==CHARTEVENT_CLICK || id == CHARTEVENT_CHART_CHANGE ) {
      if(PaintPositions) {
         paintPositions();
      }
   }
}

//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
void start()
{
  if(doPositionsOnce) {
      if ( Action == Initialize ) {
            doInitialize();
         } else if ( Action == Repair ) {
                        doRepair();
                     } else if ( Action == Append ) {
                                    doAppend();
                                 } else if ( Action == Terminate ) {
                                                doTerminate();
                                             }
        if(PaintPositions) {
         paintPositions();
        }

        }

  doPositionsOnce = false;
  return;
}


int doInitialize() {
clearPositions(false, Slippage, CreateBuys, CreateSells);
Sleep(DELAY);
doPositions();

return 0;
}

int doRepair() {
clearPositions(false, Slippage, CreateBuys, CreateSells);
Sleep(DELAY);
doPositions();

return 0;
}

int doAppend() {
doPositions();

return 0;
}

int doTerminate() {
clearPositions(false, Slippage,CreateBuys, CreateSells);

return 0;
}


int doPositions()
{
int spacings[gid_Panic +1];

 string distances[100];
 int numTrades;

 /* createBuyStop(
    string symbol,
    double startingPrice,
    int index,
    int PIPsToStart,
    int StopLossBuys,
    int TakeProfitBuys,
    Groups BuyStopsGroup,
    int distance,
    double buyLots,
    int slippage,
    int tradesExpireAfterHours,
    int spacing) */

   if ( CreateBuys ) {
         numTrades= StringSplit(PIPsToStartUL, ',', distances);
         for(int i=0; i< numTrades; ++i) {
                  createBuyStop(
                  Symbol(),
                   BuyStartingPrice,
                   StrToInteger(distances[i]),
                   InitialPIPsToStart,
                   TradesStopLoss,
                   TradesTakeProfit,
                   UltraLongTerm,
                   (int) (TradesDistance * BuyTradesDistanceCoefficient),
                   BuyLots,
                   Slippage,
                   TradesExpireAfterHours,
                   TradeSpacing
                   );
               }

         numTrades= StringSplit(PIPsToStartVL, ',', distances);
         for(int i=0; i< numTrades; ++i) {
                  createBuyStop(
                  Symbol(),
                   BuyStartingPrice,
                   StrToInteger(distances[i]),
                   InitialPIPsToStart,
                   TradesStopLoss,
                   TradesTakeProfit,
                   VeryLongTerm,
                   (int) (TradesDistance * BuyTradesDistanceCoefficient),
                   BuyLots,
                   Slippage,
                   TradesExpireAfterHours,
                   TradeSpacing
                   );
               }

         numTrades= StringSplit(PIPsToStartL, ',', distances);
         for(int i=0; i< numTrades; ++i) {
                  createBuyStop(
                  Symbol(),
                   BuyStartingPrice,
                   StrToInteger(distances[i]),
                   InitialPIPsToStart,
                   TradesStopLoss,
                   TradesTakeProfit,
                   LongTerm,
                   (int) (TradesDistance * BuyTradesDistanceCoefficient),
                   BuyLots,
                   Slippage,
                   TradesExpireAfterHours,
                   TradeSpacing
                   );
               }

         numTrades= StringSplit(PIPsToStartM, ',', distances);
         for(int i=0; i< numTrades; ++i) {
                createBuyStop(
                  Symbol(),
                   BuyStartingPrice,
                   StrToInteger(distances[i]),
                   InitialPIPsToStart,
                   TradesStopLoss,
                   TradesTakeProfit,
                   MediumTerm,
                   (int) (TradesDistance * BuyTradesDistanceCoefficient),
                   BuyLots,
                   Slippage,
                   TradesExpireAfterHours,
                   TradeSpacing
                   );
               }

         numTrades= StringSplit(PIPsToStartS, ',', distances);
         for(int i=0; i< numTrades; ++i) {
                createBuyStop(
                  Symbol(),
                   BuyStartingPrice,
                   StrToInteger(distances[i]),
                   InitialPIPsToStart,
                   TradesStopLoss,
                   TradesTakeProfit,
                   ShortTerm,
                   (int) (TradesDistance * BuyTradesDistanceCoefficient),
                   BuyLots,
                   Slippage,
                   TradesExpireAfterHours,
                   TradeSpacing
                   );
               }

         numTrades= StringSplit(PIPsToStartVS, ',', distances);
         for(int i=0; i< numTrades; ++i) {
                createBuyStop(
                  Symbol(),
                   BuyStartingPrice,
                   StrToInteger(distances[i]),
                   InitialPIPsToStart,
                   TradesStopLoss,
                   TradesTakeProfit,
                   VeryShortTerm,
                   (int) (TradesDistance * BuyTradesDistanceCoefficient),
                   BuyLots,
                   Slippage,
                   TradesExpireAfterHours,
                   TradeSpacing
                   );
               }

         numTrades= StringSplit(PIPsToStartUS, ',', distances);
         for(int i=0; i< numTrades; ++i) {
                 createBuyStop(
                  Symbol(),
                   BuyStartingPrice,
                   StrToInteger(distances[i]),
                   InitialPIPsToStart,
                   TradesStopLoss,
                   TradesTakeProfit,
                   UltraShortTerm,
                   (int) (TradesDistance * BuyTradesDistanceCoefficient),
                   BuyLots,
                   Slippage,
                   TradesExpireAfterHours,
                   TradeSpacing
                   );
               }

         numTrades= StringSplit(PIPsToStartI, ',', distances);
         for(int i=0; i< numTrades; ++i) {
                  createBuyStop(
                  Symbol(),
                   BuyStartingPrice,
                   StrToInteger(distances[i]),
                   InitialPIPsToStart,
                   TradesStopLoss,
                   TradesTakeProfit,
                   InstantTerm,
                   (int) (TradesDistance * BuyTradesDistanceCoefficient),
                   BuyLots,
                   Slippage,
                   TradesExpireAfterHours,
                   TradeSpacing
                   );
               }

       }

   if ( CreateSells ) {

            numTrades= StringSplit(PIPsToStartUL, ',', distances);
            for(int i=0; i< numTrades; ++i) {
                  createSellStop(
                  Symbol(),
                   SellStartingPrice,
                   StrToInteger(distances[i]),
                   InitialPIPsToStart,
                   TradesStopLoss,
                   TradesTakeProfit,
                   UltraLongTerm,
                   (int) (TradesDistance * SellTradesDistanceCoefficient),
                   SellLots,
                   Slippage,
                   TradesExpireAfterHours,
                   TradeSpacing
                   );
               }

            numTrades= StringSplit(PIPsToStartVL, ',', distances);
            for(int i=0; i< numTrades; ++i) {
                  createSellStop(
                  Symbol(),
                   SellStartingPrice,
                   StrToInteger(distances[i]),
                   InitialPIPsToStart,
                   TradesStopLoss,
                   TradesTakeProfit,
                   VeryLongTerm,
                   (int) (TradesDistance * SellTradesDistanceCoefficient),
                   SellLots,
                   Slippage,
                   TradesExpireAfterHours,
                   TradeSpacing
                   );
               }

            numTrades= StringSplit(PIPsToStartL, ',', distances);
            for(int i=0; i< numTrades; ++i) {
                 createSellStop(
                  Symbol(),
                   SellStartingPrice,
                   StrToInteger(distances[i]),
                   InitialPIPsToStart,
                   TradesStopLoss,
                   TradesTakeProfit,
                   LongTerm,
                   (int) (TradesDistance * SellTradesDistanceCoefficient),
                   SellLots,
                   Slippage,
                   TradesExpireAfterHours,
                   TradeSpacing
                   );
               }

            numTrades= StringSplit(PIPsToStartM, ',', distances);
            for(int i=0; i< numTrades; ++i) {
                  createSellStop(
                  Symbol(),
                   SellStartingPrice,
                   StrToInteger(distances[i]),
                   InitialPIPsToStart,
                   TradesStopLoss,
                   TradesTakeProfit,
                   MediumTerm,
                   (int) (TradesDistance * SellTradesDistanceCoefficient),
                   SellLots,
                   Slippage,
                   TradesExpireAfterHours,
                   TradeSpacing
                   );
               }

            numTrades= StringSplit(PIPsToStartS, ',', distances);
            for(int i=0; i< numTrades; ++i) {
                 createSellStop(
                  Symbol(),
                   SellStartingPrice,
                   StrToInteger(distances[i]),
                   InitialPIPsToStart,
                   TradesStopLoss,
                   TradesTakeProfit,
                   ShortTerm,
                   (int) (TradesDistance * SellTradesDistanceCoefficient),
                   SellLots,
                   Slippage,
                   TradesExpireAfterHours,
                   TradeSpacing
                   );
               }

            numTrades= StringSplit(PIPsToStartVS, ',', distances);
            for(int i=0; i< numTrades; ++i) {
                createSellStop(
                  Symbol(),
                   SellStartingPrice,
                   StrToInteger(distances[i]),
                   InitialPIPsToStart,
                   TradesStopLoss,
                   TradesTakeProfit,
                   VeryShortTerm,
                   (int) (TradesDistance * SellTradesDistanceCoefficient),
                   SellLots,
                   Slippage,
                   TradesExpireAfterHours,
                   TradeSpacing
                   );
               }
            numTrades= StringSplit(PIPsToStartUS, ',', distances);
            for(int i=0; i< numTrades; ++i) {
                  createSellStop(
                  Symbol(),
                   SellStartingPrice,
                   StrToInteger(distances[i]),
                   InitialPIPsToStart,
                   TradesStopLoss,
                   TradesTakeProfit,
                   UltraShortTerm,
                   (int) (TradesDistance * SellTradesDistanceCoefficient),
                   SellLots,
                   Slippage,
                   TradesExpireAfterHours,
                   TradeSpacing
                   );
               }
numTrades= StringSplit(PIPsToStartI, ',', distances);
            for(int i=0; i< numTrades; ++i) {
                  createSellStop(
                  Symbol(),
                   SellStartingPrice,
                   StrToInteger(distances[i]),
                   InitialPIPsToStart,
                   TradesStopLoss,
                   TradesTakeProfit,
                   InstantTerm,
                   (int) (TradesDistance * SellTradesDistanceCoefficient),
                   SellLots,
                   Slippage,
                   TradesExpireAfterHours,
                   TradeSpacing
                   );
                   Sleep(DELAY);
               }
       }

   return(0);
}






int paintPositions() {

    color colour;
    string name;
    string symbol;
    long chartId;
    int subwindow = -1;
    datetime xdatetime;
    double yprice;
    int x;

    x = 500;
    chartId = ChartID();
    symbol = Symbol();
    x = (int)(ChartWidthInPixels() * 0.9);

    if (ChartXYToTimePrice(
        ChartID(), // Chart ID
        x, // The X coordinate on the chart
        0, // The Y coordinate on the chart
        subwindow, // The number of the subwindow
        xdatetime, // Time on the chart
        yprice // Price on the chart
    )) {
        // Print( "colouring positions");
    } else return 0;

    ObjectsDeleteAll(chartId, 0, OBJ_ARROW);

    for (int i = 0; i < OrdersTotal(); i++) {

        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol) {

                if (getGroup(OrderMagicNumber()) == InstantTerm) {
                    colour = InstantTermColour;
                } else if (getGroup(OrderMagicNumber()) == UltraShortTerm) {
                    colour = UltraShortTermColour;
                } else if (getGroup(OrderMagicNumber()) == VeryShortTerm) {
                    colour = VeryShortTermColour;
                } else if (getGroup(OrderMagicNumber()) == ShortTerm) {
                    colour = ShortTermColour;
                } else if (getGroup(OrderMagicNumber()) == MediumTerm) {
                    colour = MediumTermColour;
                } else if (getGroup(OrderMagicNumber()) == LongTerm) {
                    colour = LongTermColour;
                } else if (getGroup(OrderMagicNumber()) == VeryLongTerm) {
                    colour = VeryLongTermColour;
                } else if (getGroup(OrderMagicNumber()) == UltraLongTerm) {
                    colour = UltraLongTermColour;
                } else {
                    colour = clrNONE;
                }

                name = Symbol() + "-" + getGroupName(OrderMagicNumber()) + "-" + IntegerToString(i);
                bool bResult = ObjectCreate(
                    chartId, name, OBJ_ARROW_BUY, 0, xdatetime, OrderOpenPrice());
                if (!bResult) {
                    Print(" could not paint arrow for position", OrderTicket());
                } else {
                    ObjectSetInteger(chartId, name, OBJPROP_COLOR, colour);
                }
            }
        }
    }

    return (0);
}

int ChartWidthInPixels(const long chart_ID = 0) {
    //--- prepare the variable to get the property value
    long result = -1;
    //--- reset the error value
    ResetLastError();
    //--- receive the property value
    if (!ChartGetInteger(chart_ID, CHART_WIDTH_IN_PIXELS, 0, result)) {
        //--- display the error message in Experts journal
        Print(__FUNCTION__ + ", Error Code = ", GetLastError());
    }
    //--- return the value of the chart property
    return ((int) result);
}

int clearPositions(bool all = false, int slippage = 35, bool buys = true, bool sells = true) {
    int loopTimeout = 30;
    int clearLoopCounter = 0;
    bool foundAnyTrades = true;
    while (foundAnyTrades && clearLoopCounter < loopTimeout) {
        foundAnyTrades = false;
        for (int i = 0; i < OrdersTotal(); i++) {

            if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {

                if (OrderSymbol() == Symbol()) {

                    if (all || OrderType() == OP_BUYSTOP || OrderType() == OP_SELLSTOP) {
                        int result = false;
                        if (OrderType() == OP_BUY && buys) {
                            result = OrderClose(OrderTicket(), OrderLots(), Bid, slippage);
                            foundAnyTrades = true;
                        }
                        if (OrderType() == OP_SELL && sells) {
                            result = OrderClose(OrderTicket(), OrderLots(), Ask, slippage);
                            foundAnyTrades = true;
                        }
                        if ((OrderType() == OP_SELLSTOP && sells) || (OrderType() == OP_BUYSTOP && buys)) {
                            result = OrderDelete(OrderTicket());
                            foundAnyTrades = true;
                        }
                        if (!result) {
                            Print("Order ", OrderTicket(), " delete failed.");
                        }

                    }
                }
            }
        }
        clearLoopCounter++;
    }

    return 0;
}
