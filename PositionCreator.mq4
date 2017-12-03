// Desphilboy Position Creator
#property copyright "Iman Dezfuly"
#property link      "http://www.Iman.ir"
#define version      "20171201"

#include "./desphilboy.mqh"
enum DoTradesToggler {YesDoTheTrdes, DoTheTradesYes };

extern DoTradesToggler DoTrades = YesDoTheTrdes;
DoTradesToggler doTradesTogglerCopy = DoTheTradesYes;

extern TradeActs    Action = NoAction;

extern double  BuyLots = 0.01;
extern double  SellLots = 0.01;
extern double  BuyStartingPrice = 0.0;
extern double  SellStartingPrice = 0.0;


extern string     PIPsToStartI   = "1050,1200,1800,2400,2850,3000,3600,3750";
extern string     PIPsToStartUS  = "300,1650,2250,2700";
extern string     PIPsToStartVS  = "450,1500,2100,2550";
extern string     PIPsToStartS   = "150,1350,1950";
extern string     PIPsToStartM   = "900,3450";
extern string     PIPsToStartL   = "800,3350";
extern string     PIPsToStartVL  = "700,3250";
extern string     PIPsToStartUL  = "600,3150";

extern int     TradeSpacing = 95;

extern bool    CreateBuys = true;
extern bool    CreateSells = true;

extern bool PaintPositions = true;

extern color UltraLongTermColour = clrDeepPink;
extern color VeryLongTermColour = clrBlanchedAlmond;
extern color LongTermColour = clrAqua;
extern color MediumTermColour = clrGreen;
extern color ShortTermColour = clrRed;
extern color VeryShortTermColour = clrBlue;
extern color UltraShortTermColour = clrOrange;
extern color InstantTermColour = clrSienna;

extern int StopLossUltraLong = 0;
extern int TakeProfitUltraLong = 0;
extern int StopLossVeryLong = 0;
extern int TakeProfitVeryLong = 0;
extern int StopLossLong = 0;
extern int TakeProfitLong = 0;
extern int StopLossMedium = 0;
extern int TakeProfitMedium = 0;
extern int StopLossShort = 0;
extern int TakeProfitShort = 0;
extern int StopLossVeryShort = 0;
extern int TakeProfitVeryShort = 0;
extern int StopLossUltraShort = 0;
extern int TakeProfitUltraShort = 0;
extern int StopLossInstant = 0;
extern int TakeProfitInstant = 0;

extern int Slippage = 50;

extern int TradesExpireAfterHours = 0;





static bool askUserToDoPositions = false;
static bool doPositionsOnce = false;

#define TIMERDELAYSECONDS 10
#define DELAY 100

bool isDoPositionsToggled() {
   if(doTradesTogglerCopy != DoTrades) {
      doTradesTogglerCopy = DoTrades;
      return true;
   }
   
   return false;
}


void init()
{
   Print("Desphilboy position creator ",version, " on ", Symbol());

   if (PaintPositions) paintPositions();

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
   
   if(PaintPositions) {
      paintPositions();
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
 
   if ( CreateBuys ) {
         numTrades= StringSplit(PIPsToStartUL, ',', distances);
         for(int i=0; i< numTrades; ++i) {
                  createBuyStop(
                  Symbol(),
                   BuyStartingPrice,
                   0,
                   StrToInteger(distances[i]),
                   StopLossUltraLong,
                   TakeProfitUltraLong,
                   UltraLongTerm,
                   0,
                   BuyLots,
                   Slippage,
                   TradesExpireAfterHours,
                   TradeSpacing
                   );
                   Sleep(DELAY);
               }

         numTrades= StringSplit(PIPsToStartVL, ',', distances);
         for(int i=0; i< numTrades; ++i) {
                  createBuyStop(
                  Symbol(),
                   BuyStartingPrice,
                   0,
                   StrToInteger(distances[i]),
                   StopLossVeryLong,
                   TakeProfitVeryLong,
                   VeryLongTerm,
                   0,
                   BuyLots,
                   Slippage,
                   TradesExpireAfterHours,
                   TradeSpacing
                   );
                   Sleep(DELAY);
               }

         numTrades= StringSplit(PIPsToStartL, ',', distances);
         for(int i=0; i< numTrades; ++i) {
                  createBuyStop(
                  Symbol(),
                   BuyStartingPrice,
                   0,
                   StrToInteger(distances[i]),
                   StopLossLong,
                   TakeProfitLong,
                   LongTerm,
                   0,
                   BuyLots,
                   Slippage,
                   TradesExpireAfterHours,
                   TradeSpacing
                   );
                   Sleep(DELAY);
               }

         numTrades= StringSplit(PIPsToStartM, ',', distances);
         for(int i=0; i< numTrades; ++i) {
                  createBuyStop(
                  Symbol(),
                   BuyStartingPrice,
                   0,
                   StrToInteger(distances[i]),
                   StopLossMedium,
                   TakeProfitMedium,
                   MediumTerm,
                   0,
                   BuyLots,
                   Slippage,
                   TradesExpireAfterHours,
                   TradeSpacing
                   );
                   Sleep(DELAY);
               }

         numTrades= StringSplit(PIPsToStartS, ',', distances);
         for(int i=0; i< numTrades; ++i) {
                  createBuyStop(
                  Symbol(),
                   BuyStartingPrice,
                   0,
                   StrToInteger(distances[i]),
                   StopLossShort,
                   TakeProfitShort,
                   ShortTerm,
                   0,
                   BuyLots,
                   Slippage,
                   TradesExpireAfterHours,
                   TradeSpacing
                   );
                   Sleep(DELAY);
               }

         numTrades= StringSplit(PIPsToStartVS, ',', distances);
         for(int i=0; i< numTrades; ++i) {
                  createBuyStop(
                  Symbol(),
                   BuyStartingPrice,
                   0,
                   StrToInteger(distances[i]),
                   StopLossVeryShort,
                   TakeProfitVeryShort,
                   VeryShortTerm,
                   0,
                   BuyLots,
                   Slippage,
                   TradesExpireAfterHours,
                   TradeSpacing
                   );
                   Sleep(DELAY);
               }

         numTrades= StringSplit(PIPsToStartUS, ',', distances);
         for(int i=0; i< numTrades; ++i) {
                  createBuyStop(
                  Symbol(),
                   BuyStartingPrice,
                   0,
                   StrToInteger(distances[i]),
                   StopLossUltraShort,
                   TakeProfitUltraShort,
                   UltraShortTerm,
                   0,
                   BuyLots,
                   Slippage,
                   TradesExpireAfterHours,
                   TradeSpacing
                   );
                   Sleep(DELAY);
               }

         numTrades= StringSplit(PIPsToStartI, ',', distances);
         for(int i=0; i< numTrades; ++i) {
                  createBuyStop(
                  Symbol(),
                   BuyStartingPrice,
                   0,
                   StrToInteger(distances[i]),
                   StopLossInstant,
                   TakeProfitInstant,
                   InstantTerm,
                   0,
                   BuyLots,
                   Slippage,
                   TradesExpireAfterHours,
                   TradeSpacing
                   );
                   Sleep(DELAY);
               }

       }

   if ( CreateSells ) {

            numTrades= StringSplit(PIPsToStartUL, ',', distances);
            for(int i=0; i< numTrades; ++i) {
                  createSellStop(
                  Symbol(),
                   SellStartingPrice,
                   0,
                   StrToInteger(distances[i]),
                   StopLossUltraLong,
                   TakeProfitUltraLong,
                   UltraLongTerm,
                   0,
                   SellLots,
                   Slippage,
                   TradesExpireAfterHours,
                   TradeSpacing);
                   Sleep(DELAY);
               }

            numTrades= StringSplit(PIPsToStartVL, ',', distances);
            for(int i=0; i< numTrades; ++i) {
                  createSellStop(
                  Symbol(),
                   SellStartingPrice,
                   0,
                   StrToInteger(distances[i]),
                   StopLossVeryLong,
                   TakeProfitVeryLong,
                   VeryLongTerm,
                   0,
                   SellLots,
                   Slippage,
                   TradesExpireAfterHours,
                   TradeSpacing);
                   Sleep(DELAY);
               }

            numTrades= StringSplit(PIPsToStartL, ',', distances);
            for(int i=0; i< numTrades; ++i) {
                  createSellStop(
                  Symbol(),
                   SellStartingPrice,
                   0,
                   StrToInteger(distances[i]),
                   StopLossLong,
                   TakeProfitLong,
                   LongTerm,
                   0,
                   SellLots,
                   Slippage,
                   TradesExpireAfterHours,
                   TradeSpacing);
                   Sleep(DELAY);
               }

            numTrades= StringSplit(PIPsToStartM, ',', distances);
            for(int i=0; i< numTrades; ++i) {
                  createSellStop(
                  Symbol(),
                   SellStartingPrice,
                   0,
                   StrToInteger(distances[i]),
                   StopLossMedium,
                   TakeProfitMedium,
                   MediumTerm,
                   0,
                   SellLots,
                   Slippage,
                   TradesExpireAfterHours,
                   TradeSpacing);
                   Sleep(DELAY);
               }

            numTrades= StringSplit(PIPsToStartS, ',', distances);
            for(int i=0; i< numTrades; ++i) {
                  createSellStop(
                  Symbol(),
                   SellStartingPrice,
                   0,
                   StrToInteger(distances[i]),
                   StopLossShort,
                   TakeProfitShort,
                   ShortTerm,
                   0,
                   SellLots,
                   Slippage,
                   TradesExpireAfterHours,
                   TradeSpacing);
                   Sleep(DELAY);
               }

            numTrades= StringSplit(PIPsToStartVS, ',', distances);
            for(int i=0; i< numTrades; ++i) {
                  createSellStop(
                  Symbol(),
                   SellStartingPrice,
                   0,
                   StrToInteger(distances[i]),
                   StopLossVeryShort,
                   TakeProfitVeryShort,
                   VeryShortTerm,
                   0,
                   SellLots,
                   Slippage,
                   TradesExpireAfterHours,
                   TradeSpacing);
                   Sleep(DELAY);
               }
            numTrades= StringSplit(PIPsToStartUS, ',', distances);
            for(int i=0; i< numTrades; ++i) {
                  createSellStop(
                  Symbol(),
                   SellStartingPrice,
                   0,
                   StrToInteger(distances[i]),
                   StopLossUltraShort,
                   TakeProfitUltraShort,
                   UltraShortTerm,
                   0,
                   SellLots,
                   Slippage,
                   TradesExpireAfterHours,
                   TradeSpacing);
                   Sleep(DELAY);
               }
numTrades= StringSplit(PIPsToStartI, ',', distances);
            for(int i=0; i< numTrades; ++i) {
                  createSellStop(
                  Symbol(),
                   SellStartingPrice,
                   0,
                   StrToInteger(distances[i]),
                   StopLossInstant,
                   TakeProfitInstant,
                   InstantTerm,
                   0,
                   SellLots,
                   Slippage,
                   TradesExpireAfterHours,
                   TradeSpacing);
                   Sleep(DELAY);
               }
       }

   return(0);
}






int paintPositions()
{

color  colour;
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
   x = (int) (ChartWidthInPixels() * 0.9);

   if(ChartXYToTimePrice(
   ChartID(),     // Chart ID
   x,            // The X coordinate on the chart
   0,            // The Y coordinate on the chart
   subwindow,   // The number of the subwindow
   xdatetime,         // Time on the chart
   yprice         // Price on the chart
   ))
   {
      // Print( "colouring positions");
   }
   else return 0;

  ObjectsDeleteAll(chartId,0, OBJ_ARROW);

  for(int i=0; i<OrdersTotal(); i++) {

      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
         if(OrderSymbol() == symbol) {

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
                              chartId
                              , name
                              , OBJ_ARROW_BUY
                              , 0
                              , xdatetime
                              , OrderOpenPrice());
            if(!bResult){
               Print (" could not paint arrow for position", OrderTicket());
            } else {
                  ObjectSetInteger(chartId, name, OBJPROP_COLOR, colour);
              }
           }
      }
   }

   return(0);
}

int ChartWidthInPixels(const long chart_ID=0)
  {
//--- prepare the variable to get the property value
   long result=-1;
//--- reset the error value
   ResetLastError();
//--- receive the property value
   if(!ChartGetInteger(chart_ID,CHART_WIDTH_IN_PIXELS,0,result))
     {
      //--- display the error message in Experts journal
      Print(__FUNCTION__+", Error Code = ",GetLastError());
     }
//--- return the value of the chart property
   return((int)result);
  }


int clearPositions( bool all=false, int slippage =35, bool buys = true, bool sells = true)
{
bool foundAnyTrades = true;
while(foundAnyTrades) {
foundAnyTrades = false;
for(int i=0; i<OrdersTotal(); i++) {

        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {

           if ( OrderSymbol()==Symbol()) {

               if (all || OrderType() == OP_BUYSTOP || OrderType() == OP_SELLSTOP) {
                     int result = false;
                     if(OrderType() == OP_BUY && buys) {
                              result = OrderClose(OrderTicket(),OrderLots(),Bid,slippage);
                              foundAnyTrades = true;
                              }
                     if(OrderType() == OP_SELL && sells) {
                               result = OrderClose(OrderTicket(),OrderLots(),Ask,slippage);
                               foundAnyTrades = true;
                               }
                     if((OrderType() == OP_SELLSTOP && sells )|| (OrderType() == OP_BUYSTOP && buys)) {
                               result = OrderDelete(OrderTicket());
                               foundAnyTrades = true;
                                       }
                     if( !result ) {
                        Print( "Order ", OrderTicket(), " delete failed.");
                       }

               }
            }
         }
      }
   }

return 0;
}
