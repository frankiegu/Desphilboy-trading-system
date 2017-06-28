// Desphilboy Position Creator
#property copyright "Iman Dezfuly"
#property link      "http://www.Iman.ir"
#define version      "201706021"

#include "./desphilboy.mqh"

extern TradeActs    Action = NoAction;

extern double  BuyLots = 0.01;
extern double  SellLots = 0.01;
extern double  StartingPrice = 0.0;

extern int     PIPsToStartVL = 1100;
extern int     PIPsToStartL = 730;
extern int     PIPsToStartM = 460;
extern int     PIPsToStartS = 280;
extern int     PIPsToStartU = 140;

extern int     VeryLongTermDistance = 2000;
extern int     LongTermDistance = 1000;
extern int     MediumTermDistance = 500;
extern int     ShortTermDistance = 250;
extern int     UserGroupDistance = 120;

extern int     VeryLongTermSpacing = 450;
extern int     LongTermSpacing = 350;
extern int     MediumTermSpacing = 250;
extern int     ShortTermSpacing = 150;
extern int     UserGroupSpacing = 100;

extern bool    CreateBuys = true;
extern bool    CreateSells = true;

extern int    UserGroupBuys = 11;
extern int    ShortTermBuys = 6;
extern int    MediumTermBuys = 3;
extern int    LongTermBuys = 1;
extern int    VeryLongTermBuys = 1;

extern int    UserGroupSells = 11;
extern int    ShortTermSells = 6;
extern int    MediumTermSells = 3;
extern int    LongTermSells = 1;
extern int    VeryLongTermSells = 1;

extern bool PaintPositions = true;

extern color VeryLongTermColour = clrBlanchedAlmond;
extern color LongTermColour = clrAqua;
extern color MediumTermColour = clrGreen;
extern color ShortTermColour = clrOrangeRed;
extern color UserGroupColour = clrBlue;

extern int StopLossVeryLong = 0;
extern int TakeProfitVeryLong = 0;
extern int StopLossLong = 0;
extern int TakeProfitLong = 0;
extern int StopLossMedium = 0;
extern int TakeProfitMedium = 0;
extern int StopLossShort = 0;
extern int TakeProfitShort = 0;
extern int StopLossUser = 0;
extern int TakeProfitUser = 0;

extern bool SpaceExistingPositions = true;

extern bool CheckOnlySameGroupSpacing = false;

extern int Slippage = 30;

extern int TradesExpireAfterHours = 0;





static bool once = false;

#define delaySecondsBeforeConfirm 5
#define DELAY 300

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
clearPositions(true);
Sleep(10 * DELAY);
doPositions();

return 0;
}
 
int doRepair() {
clearPositions(false);
Sleep(10 * DELAY);
doPositions();

return 0;
}
                    
int doAppend() {
doPositions();

return 0;
}

int doTerminate() {
clearPositions();
Sleep(10 * DELAY);
clearPositions();
return 0;
}


int doPositions()
{
   if ( CreateBuys ) {
            for(int i=0; i< VeryLongTermBuys; ++i) {
                  createBuyStop(
                   StartingPrice,
                   i,
                   PIPsToStartVL,
                   StopLossVeryLong,
                   TakeProfitVeryLong,
                   VeryLongTerm,
                   VeryLongTermDistance,
                   BuyLots,
                   Slippage,
                   TradesExpireAfterHours);
                   Sleep(DELAY);
               }
               for(int i=0; i< LongTermBuys; ++i) {
                  createBuyStop(
                   StartingPrice,
                   i,
                   PIPsToStartL,
                   StopLossLong,
                   TakeProfitLong,
                   LongTerm,
                   LongTermDistance,
                   BuyLots,
                   Slippage,
                   TradesExpireAfterHours);
                   Sleep(DELAY);
               }
               for(int i=0; i< MediumTermBuys; ++i) {
                  createBuyStop(
                   StartingPrice,
                   i,
                   PIPsToStartM,
                   StopLossMedium,
                   TakeProfitMedium,
                   MediumTerm,
                   MediumTermDistance,
                   BuyLots,
                   Slippage,
                   TradesExpireAfterHours);
                   Sleep(DELAY);
               }
               for(int i=0; i< ShortTermBuys; ++i) {
                  createBuyStop(
                   StartingPrice,
                   i,
                   PIPsToStartS,
                   StopLossShort,
                   TakeProfitShort,
                   ShortTerm,
                   ShortTermDistance,
                   BuyLots,
                   Slippage,
                   TradesExpireAfterHours);
                   Sleep(DELAY);
               }
               for(int i=0; i< UserGroupBuys; ++i) {
                  createBuyStop(
                   StartingPrice,
                   i,
                   PIPsToStartU,
                   StopLossUser,
                   TakeProfitUser,
                   UserGroup,
                   UserGroupDistance,
                   BuyLots,
                   Slippage,
                   TradesExpireAfterHours);
                   Sleep(DELAY);
               }
       }

   if ( CreateSells ) {
            for(int i=0; i< VeryLongTermSells; ++i) {
                  createSellStop(
                   StartingPrice,
                   i,
                   PIPsToStartVL,
                   StopLossVeryLong,
                   TakeProfitVeryLong,
                   VeryLongTerm,
                   VeryLongTermDistance,
                   SellLots,
                   Slippage,
                   TradesExpireAfterHours);
                   Sleep(DELAY);
               }
               for(int i=0; i< LongTermSells; ++i) {
                  createSellStop(
                  StartingPrice,
                   i,
                   PIPsToStartL,
                   StopLossLong,
                   TakeProfitLong,
                   LongTerm,
                   LongTermDistance,
                   SellLots,
                   Slippage,
                   TradesExpireAfterHours);
                   Sleep(DELAY);
               }
               for(int i=0; i< MediumTermSells; ++i) {
                  createSellStop(
                  StartingPrice,
                   i,
                   PIPsToStartM,
                   StopLossMedium,
                   TakeProfitMedium,
                   MediumTerm,
                   MediumTermDistance,
                   SellLots,
                   Slippage,
                   TradesExpireAfterHours);
                   Sleep(DELAY);
               }
               for(int i=0; i< ShortTermSells; ++i) {
                  createSellStop(
                  StartingPrice,
                   i,
                   PIPsToStartS,
                   StopLossShort,
                   TakeProfitShort,
                   ShortTerm,
                   ShortTermDistance,
                   SellLots,
                   Slippage,
                   TradesExpireAfterHours);
                   Sleep(DELAY);
               }
               for(int i=0; i< UserGroupSells; ++i) {
                  createSellStop(
                  StartingPrice,
                   i,
                   PIPsToStartU,
                   StopLossUser,
                   TakeProfitUser,
                   UserGroup,
                   UserGroupDistance,
                   SellLots,
                   Slippage,
                   TradesExpireAfterHours);
                   Sleep(DELAY);
               }
       }

   return(0); 
}





int createBuyStop( double startingPrice,
                    int index, 
                    int PIPsToStart,
                    int StopLossBuys,
                    int TakeProfitBuys,
                    Groups BuyStopsGroup,
                    int distance,
                    double buyLots,
                    int slippage,
                    int tradesExpireAfterHours)
{
datetime now = TimeCurrent();
datetime expiry = tradesExpireAfterHours != 0 ? now + tradesExpireAfterHours * 3600 : 0;
double baseprice = startingPrice == 0.0 ? Ask : startingPrice;
double pip = MarketInfo(Symbol(), MODE_POINT);
double price = baseprice + ( distance * index + PIPsToStart) * pip;
double stopLoss = StopLossBuys !=0 ? price - StopLossBuys * pip : 0;
double takeProfit = TakeProfitBuys != 0 ? price + TakeProfitBuys * pip : 0;


   bool spaceAvailable = false;
   if(CheckOnlySameGroupSpacing){
      spaceAvailable = checkSpaceForPosition(price,OP_BUYSTOP, BuyStopsGroup);   
   } else {
      spaceAvailable = clearSpaceForPosition(price,OP_BUYSTOP, BuyStopsGroup);
   }
   
   if( !spaceAvailable) {
      Print( "Space not available for SellStop at ", price, " with group ", getGroupName(createMagicNumber(DAPositionCreator_ID, BuyStopsGroup)));
   return -1;
   }


int result = OrderSend(
                        Symbol(),                   // symbol
                        OP_BUYSTOP,                 // operation
                        buyLots,                    // volume   
                        price,                      // price
                        slippage,                   // slippage
                        stopLoss,                  // stop loss
                        takeProfit,                 // take profit
                        NULL,                      // comment
                        createMagicNumber(DAPositionCreator_ID, BuyStopsGroup),           // magic number
                        expiry,                       // pending order expiration
                        clrNONE                    // color
   );
   
if( result == -1 ) {
   Print( "Order ", index, " creation failed for BuyStop at:", price);
   }
   else {
            if(OrderSelect(result, SELECT_BY_TICKET))
            Print("BuyStop ", index," created at ", price, " with ticket ", OrderTicket(), " Group ", getGroupName(OrderMagicNumber()));    
        }
return result;
}




int createSellStop( double startingPrice,
                    int index, 
                    int PIPsToStart,
                    int StopLossSells,
                    int TakeProfitSells,
                    Groups SellStopsGroup,
                    int distance,
                    double sellLots,
                    int slippage,
                    int tradesExpireAfterHours)
{
datetime now = TimeCurrent();
datetime expiry = tradesExpireAfterHours != 0 ? now + tradesExpireAfterHours * 3600 : 0;
double pip = MarketInfo(Symbol(), MODE_POINT);
double baseprice = startingPrice == 0.0 ? Bid : startingPrice;
double price =  baseprice - ( distance * index + PIPsToStart) * pip;
double stopLoss = StopLossSells !=0 ? price + StopLossSells * pip : 0;
double takeProfit = TakeProfitSells != 0 ? price - TakeProfitSells * pip : 0;


   bool spaceAvailable = false;
   
   if(CheckOnlySameGroupSpacing){
      spaceAvailable = checkSpaceForPosition(price,OP_SELLSTOP,SellStopsGroup);   
   } else {
      spaceAvailable = clearSpaceForPosition(price,OP_SELLSTOP,SellStopsGroup);
   }
   
   if( !spaceAvailable) {
      Print( "Space not available for SellStop at ", price, " with group ", getGroupName(createMagicNumber(DAPositionCreator_ID, SellStopsGroup)));
   return -1;
   }

int result = OrderSend(
                        Symbol(),                   // symbol
                        OP_SELLSTOP,                 // operation
                        sellLots,                    // volume   
                        price,                      // price
                        slippage,                   // slippage
                        stopLoss,                  // stop loss
                        takeProfit,                 // take profit
                        NULL,                      // comment
                        createMagicNumber(DAPositionCreator_ID, SellStopsGroup),           // magic number
                        expiry,                       // pending order expiration
                        clrNONE                    // color
   );
   
if( result == -1 ) {
   Print( "Order ", index, " creation failed for SellStop at:", price);
   }
   else {
            if(OrderSelect(result, SELECT_BY_TICKET))
            Print("SellStop ", index, " created at ", price, " with ticket ", OrderTicket(), " Group ", getGroupName(OrderMagicNumber()));    
        }
return result;
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
         
             if(getGroup(OrderMagicNumber()) == UserGroup ) { colour = UserGroupColour; }
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
 
 
 bool clearSpaceForPosition(double price, int operation, int group)
 {
   int positions[1000];
   
   if( VeryLongTermSpacing != 0  && group == VeryLongTerm)
   {
      int c = getPositionsInRange(Symbol(), operation, price, VeryLongTermSpacing, positions,SpaceExistingPositions, VeryLongTerm);
      if ( c > 0)  { return false; }
         
   }
   
   if( LongTermSpacing != 0 && group <= LongTerm )
   {
      int c = getPositionsInRange(Symbol(), operation, price, LongTermSpacing, positions,SpaceExistingPositions, LongTerm);
      for( int i =0; i< c; ++i)
      {  
       if(OrderSelect(positions[i], SELECT_BY_TICKET) ){
            if( OrderType()==OP_BUY || OrderType() == OP_SELL || group == LongTerm ){
               return false;
          }
          else {
             bool bResult = OrderDelete(positions[i]);
             if (!bResult) { Print ( "Could not delete order: ", positions[i]); } else { Print ( "deleted order: ", positions[i]); }
            }
         }
      }
   }
   
   if( MediumTermSpacing != 0 && group <= MediumTerm )
   {
      int c = getPositionsInRange(Symbol(), operation, price, MediumTermSpacing, positions,SpaceExistingPositions, MediumTerm);
      for( int i =0; i< c; ++i)
      {  
       if(OrderSelect(positions[i], SELECT_BY_TICKET) ){
            if( OrderType()==OP_BUY || OrderType() == OP_SELL || group == MediumTerm ){
               return false;
          }
          else {
             bool bResult = OrderDelete(positions[i]);
             if (!bResult) { Print ( "Could not delete order: ", positions[i]); }
            }
         }
      }
   }
   
   if( ShortTermSpacing != 0 && group <= ShortTerm )
   {
      int c = getPositionsInRange(Symbol(), operation, price, ShortTermSpacing, positions,SpaceExistingPositions, ShortTerm);
      for( int i =0; i< c; ++i)
      {  
       if(OrderSelect(positions[i], SELECT_BY_TICKET) ){
            if( OrderType()==OP_BUY || OrderType() == OP_SELL || group == ShortTerm ){
               return false;
          }
          else {
            bool bResult = OrderDelete(positions[i]);
             if (!bResult) { Print ( "Could not delete order: ", positions[i]); }
            }
         }
      }
   }
   
   if( UserGroupSpacing != 0 )
   {
      int c = getPositionsInRange(Symbol(), operation, price, UserGroupSpacing, positions,SpaceExistingPositions, UserGroup);
      for( int i =0; i< c; ++i)
      {  
       if(OrderSelect(positions[i], SELECT_BY_TICKET) ){
            if( OrderType()==OP_BUY || OrderType() == OP_SELL || group == UserGroup ){
               return false;
          }
          else {
             bool bResult = OrderDelete(positions[i]);
             if (!bResult) { Print ( "Could not delete order: ", positions[i]); }
            }
         }
      }
   }
        
   return true; 
 } 
 
 bool checkSpaceForPosition(double price, int operation, int group)
 {
   int positions[1000];
   
   if( VeryLongTermSpacing != 0  && group == VeryLongTerm)
   {
      int c = getPositionsInRangeSameGroup(Symbol(), operation, price, VeryLongTermSpacing, positions,SpaceExistingPositions, VeryLongTerm);
      if ( c > 0)  { return false; }
         
   }
   
   if( LongTermSpacing != 0  && group == LongTerm)
   {
      int c = getPositionsInRangeSameGroup(Symbol(), operation, price, LongTermSpacing, positions,SpaceExistingPositions, LongTerm);
      if ( c > 0)  { return false; }
         
   }
   
   if( MediumTermSpacing != 0 && group == MediumTerm )
   {
      int c = getPositionsInRangeSameGroup(Symbol(), operation, price, MediumTermSpacing, positions,SpaceExistingPositions, MediumTerm);
      if ( c > 0)  { return false; }
   }
   
   if( ShortTermSpacing != 0 && group == ShortTerm )
   {
      int c = getPositionsInRangeSameGroup(Symbol(), operation, price, ShortTermSpacing, positions,SpaceExistingPositions, ShortTerm);
       if ( c > 0)  { return false; }
   }
   
   if( UserGroupSpacing != 0  && group == UserGroup )
   {
      int c = getPositionsInRangeSameGroup(Symbol(), operation, price, UserGroupSpacing, positions,SpaceExistingPositions, UserGroup);
      if ( c > 0)  { return false; }
   }
        
   return true; 
 } 
 
int clearPositions( bool all=false, int slippage =35)
{

for(int i=0; i<OrdersTotal(); i++) {
     
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
        
           if ( OrderSymbol()==Symbol()) {
                               
               if (all || OrderType() == OP_BUYSTOP || OrderType() == OP_SELLSTOP) {
                     int result = false;
                     if(OrderType() == OP_BUY) {
                              result = OrderClose(OrderTicket(),OrderLots(),Bid,slippage);
                              } 
                     if(OrderType() == OP_SELL) {
                               result = OrderClose(OrderTicket(),OrderLots(),Ask,slippage);   
                               }
                     if(OrderType() == OP_SELLSTOP || OrderType() == OP_BUYSTOP) {          
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