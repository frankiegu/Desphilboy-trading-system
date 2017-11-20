// Desphilboy Position Creator
#property copyright "Iman Dezfuly"
#property link      "http://www.Iman.ir"
#define version      "201710021"

#include "./desphilboy.mqh"

extern TradeActs    Action = NoAction;

extern double  BuyLots = 0.01;
extern double  SellLots = 0.01;
extern double  BuyStartingPrice = 0.0;
extern double  SellStartingPrice = 0.0;

extern string     PIPsToStartU = 1200;
extern string     PIPsToStartS = 950;
extern string     PIPsToStartM = 700;
extern string     PIPsToStartL = 450;
extern string     PIPsToStartVL = 200;

extern int     VeryLongTermSpacing = 190;
extern int     LongTermSpacing = 180;
extern int     MediumTermSpacing = 160;
extern int     ShortTermSpacing = 140;
extern int     VeryShortSpacing = 120;

extern bool    CreateBuys = true;
extern bool    CreateSells = true;

extern int    VeryShortBuys = 2;
extern int    ShortTermBuys = 2;
extern int    MediumTermBuys = 2;
extern int    LongTermBuys = 2;
extern int    VeryLongTermBuys = 2;

extern int    VeryShortSells = 2;
extern int    ShortTermSells = 2;
extern int    MediumTermSells = 2;
extern int    LongTermSells = 2;
extern int    VeryLongTermSells = 2;

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

#define delaySecondsBeforeConfirm 5
#define DELAY 500

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
 spacings[gid_ShortTerm] = ShortTermSpacing; spacings[gid_VeryShort] = VeryShortSpacing;
   if ( CreateBuys ) {
            for(int i=0; i< VeryLongTermBuys; ++i) {
                  createBuyStop(
                  Symbol(),
                   BuyStartingPrice,
                   i,
                   PIPsToStartVL,
                   StopLossVeryLong,
                   TakeProfitVeryLong,
                   VeryLongTerm,
                   VeryLongTermDistance,
                   BuyLots,
                   Slippage,
                   TradesExpireAfterHours,
                   spacings
                   );
                   Sleep(DELAY);
               }
               for(int i=0; i< LongTermBuys; ++i) {
                  createBuyStop(
                  Symbol(),
                   BuyStartingPrice,
                   i,
                   PIPsToStartL,
                   StopLossLong,
                   TakeProfitLong,
                   LongTerm,
                   LongTermDistance,
                   BuyLots,
                   Slippage,
                   TradesExpireAfterHours,
                   spacings);
                   Sleep(DELAY);
               }
               for(int i=0; i< MediumTermBuys; ++i) {
                  createBuyStop(
                  Symbol(),
                   BuyStartingPrice,
                   i,
                   PIPsToStartM,
                   StopLossMedium,
                   TakeProfitMedium,
                   MediumTerm,
                   MediumTermDistance,
                   BuyLots,
                   Slippage,
                   TradesExpireAfterHours,
                   spacings);
                   Sleep(DELAY);
               }
               for(int i=0; i< ShortTermBuys; ++i) {
                  createBuyStop(
                  Symbol(),
                   BuyStartingPrice,
                   i,
                   PIPsToStartS,
                   StopLossShort,
                   TakeProfitShort,
                   ShortTerm,
                   ShortTermDistance,
                   BuyLots,
                   Slippage,
                   TradesExpireAfterHours,
                   spacings);
                   Sleep(DELAY);
               }
               for(int i=0; i< VeryShortBuys; ++i) {
                  createBuyStop(
                  Symbol(),
                   BuyStartingPrice,
                   i,
                   PIPsToStartU,
                   StopLossVeryShort,
                   TakeProfitVeryShort,
                   VeryShort,
                   VeryShortDistance,
                   BuyLots,
                   Slippage,
                   TradesExpireAfterHours,
                   spacings);
                   Sleep(DELAY);
               }
       }

   if ( CreateSells ) {
            for(int i=0; i< VeryLongTermSells; ++i) {
                  createSellStop(
                  Symbol(),
                   SellStartingPrice,
                   i,
                   PIPsToStartVL,
                   StopLossVeryLong,
                   TakeProfitVeryLong,
                   VeryLongTerm,
                   VeryLongTermDistance,
                   SellLots,
                   Slippage,
                   TradesExpireAfterHours,
                   spacings);
                   Sleep(DELAY);
               }
               for(int i=0; i< LongTermSells; ++i) {
                  createSellStop(
                  Symbol(),
                  SellStartingPrice,
                   i,
                   PIPsToStartL,
                   StopLossLong,
                   TakeProfitLong,
                   LongTerm,
                   LongTermDistance,
                   SellLots,
                   Slippage,
                   TradesExpireAfterHours,
                   spacings);
                   Sleep(DELAY);
               }
               for(int i=0; i< MediumTermSells; ++i) {
                  createSellStop(
                  Symbol(),
                  SellStartingPrice,
                   i,
                   PIPsToStartM,
                   StopLossMedium,
                   TakeProfitMedium,
                   MediumTerm,
                   MediumTermDistance,
                   SellLots,
                   Slippage,
                   TradesExpireAfterHours,
                   spacings);
                   Sleep(DELAY);
               }
               for(int i=0; i< ShortTermSells; ++i) {
                  createSellStop(
                  Symbol(),
                  SellStartingPrice,
                   i,
                   PIPsToStartS,
                   StopLossShort,
                   TakeProfitShort,
                   ShortTerm,
                   ShortTermDistance,
                   SellLots,
                   Slippage,
                   TradesExpireAfterHours,
                   spacings);
                   Sleep(DELAY);
               }
               for(int i=0; i< VeryShortSells; ++i) {
                  createSellStop(
                  Symbol(),
                  SellStartingPrice,
                   i,
                   PIPsToStartU,
                   StopLossVeryShort,
                   TakeProfitVeryShort,
                   VeryShort,
                   VeryShortDistance,
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

             if(getGroup(OrderMagicNumber()) == VeryShort ) { colour = VeryShortColour; }
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
