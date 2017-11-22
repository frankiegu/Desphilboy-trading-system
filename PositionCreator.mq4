// Desphilboy Position Creator
#property copyright "Iman Dezfuly"
#property link      "http://www.Iman.ir"
#define version      "201711101"

#include "./desphilboy.mqh"

extern TradeActs    Action = NoAction;

extern double  BuyLots = 0.01;
extern double  SellLots = 0.01;
extern double  BuyStartingPrice = 0.0;
extern double  SellStartingPrice = 0.0;

extern string     PIPsToStartVS  = "100,1100,1900,2500,3500";
extern string     PIPsToStartS   = "900,1700,2300,3300";
extern string     PIPsToStartM   = "700,1500,2100,3100";
extern string     PIPsToStartL   = "500,1300,2900";
extern string     PIPsToStartVL  = "300,2700";

extern int     VeryLongTermSpacing = 190;
extern int     LongTermSpacing = 180;
extern int     MediumTermSpacing = 160;
extern int     ShortTermSpacing = 140;
extern int     VeryShortSpacing = 120;

extern bool    CreateBuys = true;
extern bool    CreateSells = true;

extern bool PaintPositions = true;

extern color VeryLongTermColour = clrBlanchedAlmond;
extern color LongTermColour = clrAqua;
extern color MediumTermColour = clrGreen;
extern color ShortTermColour = clrOrangeRed;
extern color VeryShortColour = clrBlue;

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

extern int Slippage = 50;

extern int TradesExpireAfterHours = 0;





static bool once = false;

#define delaySecondsBeforeConfirm 8
#define DELAY 600

void init()
{
   Print("Desphilboy position creator ",version, " on ", Symbol());

   if (PaintPositions) paintPositions();

   if ( Action != NoAction ) {
      EventSetTimer(delaySecondsBeforeConfirm);
      }




return;
}


void OnTimer() {
   EventKillTimer();
   int result = MessageBox("Are you sure you want to Alter " + Symbol() +" positions according to params?",
                              "Confirm creation of positions:",
                              MB_OKCANCEL + MB_ICONWARNING +MB_DEFBUTTON2
                              );
   if( result == IDOK){
      once = true;
   }
}



//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
void start()
{

  if(once) {
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

      once = false;
      if (PaintPositions) {
            paintPositions();
         }
  return;
}

int doInitialize() {
clearPositions(false, Slippage, CreateBuys, CreateSells);
Sleep(10 * DELAY);
clearPositions(false, Slippage, CreateBuys, CreateSells);
Sleep(10 * DELAY);
doPositions();

return 0;
}

int doRepair() {
clearPositions(false, Slippage, CreateBuys, CreateSells);
Sleep(5 * DELAY);
clearPositions(false, Slippage, CreateBuys, CreateSells);
Sleep(5 * DELAY);
doPositions();

return 0;
}

int doAppend() {
doPositions();

return 0;
}

int doTerminate() {
clearPositions(false, Slippage,CreateBuys, CreateSells);
Sleep(5 * DELAY);
clearPositions(false, Slippage,CreateBuys, CreateSells);
Sleep(5 * DELAY);
clearPositions(false, Slippage,CreateBuys, CreateSells);
Sleep(5 * DELAY);
clearPositions(false, Slippage,CreateBuys, CreateSells);

return 0;
}


int doPositions()
{
int spacings[gid_Panic +1];
 spacings[gid_VeryLongTerm] =  VeryLongTermSpacing; spacings[gid_LongTerm] = LongTermSpacing; spacings[gid_MediumTerm] = MediumTermSpacing;
 spacings[gid_ShortTerm] = ShortTermSpacing; spacings[gid_VeryShortTerm] = VeryShortSpacing;
 string distances[100];
 int numTrades= StringSplit(PIPsToStartVL, ',', distances);
   if ( CreateBuys ) {
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
                   spacings
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
                   spacings
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
                   spacings
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
                   spacings
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
                   spacings
                   );
                   Sleep(DELAY);
               }

       }

   if ( CreateSells ) {

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
                   spacings);
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
                   spacings);
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
                   spacings);
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
                   spacings);
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
                   spacings);
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
      Print( "colouring positions");
   }
   else return 0;

  ObjectsDeleteAll(chartId,0, OBJ_ARROW);

  for(int i=0; i<OrdersTotal(); i++) {

      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
         if(OrderSymbol() == symbol) {

             if(getGroup(OrderMagicNumber()) == VeryShortTerm ) { colour = VeryShortColour; }
               else if(getGroup(OrderMagicNumber()) == ShortTerm ) { colour = ShortTermColour; }
                     else if(getGroup(OrderMagicNumber()) == MediumTerm ) { colour = MediumTermColour; }
                           else if(getGroup(OrderMagicNumber()) == LongTerm ) { colour = LongTermColour; }
                                 else if(getGroup(OrderMagicNumber()) == VeryLongTerm ) { colour = VeryLongTermColour; }
                                       else {
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


  int array_returning_function( int &intarray[])
  {
  intarray[0]=0;
  intarray[1]=1;
  return 2;
  }



int clearPositions( bool all=false, int slippage =35, bool buys = true, bool sells = true)
{

for(int i=0; i<OrdersTotal(); i++) {

        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {

           if ( OrderSymbol()==Symbol()) {

               if (all || OrderType() == OP_BUYSTOP || OrderType() == OP_SELLSTOP) {
                     int result = false;
                     if(OrderType() == OP_BUY && buys) {
                              result = OrderClose(OrderTicket(),OrderLots(),Bid,slippage);
                              }
                     if(OrderType() == OP_SELL && sells) {
                               result = OrderClose(OrderTicket(),OrderLots(),Ask,slippage);
                               }
                     if((OrderType() == OP_SELLSTOP && sells )|| (OrderType() == OP_BUYSTOP && buys)) {
                               result = OrderDelete(OrderTicket());
                                       }
                     if( !result ) {
                        Print( "Order ", OrderTicket(), " delete failed.");
                       }

               }
            }
         }
      }

return 0;
}
