#property copyright "Iman Dezfuly"
#property link      "http://www.Iman.ir"
#define version      "201612071"

#include "./desphilboy.mqh"

extern int OrderNumber = 0;
extern color LongTermColour = clrAqua;
extern color MediumTermColour = clrGreen;
extern color ShortTermColour = clrOrangeRed;
extern color UserGroupColour = clrBlue;

void init()
{
   Print("Desphilboy position marker ",version, " on ", Symbol());
   markPositions();
   paintPositions();
   ExpertRemove();
}



int markPositions()
{
  string symbol = Symbol();
   
  for(int i=0; i<OrdersTotal(); i++) {
                  
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderSymbol() == symbol) {
         OrderPrint(); 
         Print( "Order ", OrderTicket(), " has group ", getGroupName(OrderMagicNumber()));                                           
         }
      }
   }
      
   if( OrderNumber !=0 ){
         if(OrderSelect(OrderNumber, SELECT_BY_TICKET, MODE_TRADES)){
            OrderPrint(); 
            Print( "Order ", OrderTicket(), " has group ", getGroupName(OrderMagicNumber()));
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

   chartId = ChartID();
   symbol = Symbol();
        
  for(int i=0; i<OrdersTotal(); i++) {
          
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
         if(OrderSymbol() == symbol) {
         
             if(getGroup(OrderMagicNumber()) == UserGroup ) { colour = UserGroupColour; }
               else if(getGroup(OrderMagicNumber()) == ShortTerm ) { colour = ShortTermColour; }
                     else if(getGroup(OrderMagicNumber()) == MediumTerm ) { colour = MediumTermColour; }
                           else if(getGroup(OrderMagicNumber()) == LongTerm ) { colour = LongTermColour; }
                                 else {
                                    colour = clrNONE;
                                 }
            name = Symbol() + "-" + getGroupName(OrderMagicNumber()) + "-" + IntegerToString(i);
            ObjectDelete(name);
            bool bResult = ObjectCreate(
                              chartId
                              , name 
                              , OBJ_ARROW_BUY  
                              , 0  
                              , ChartTimeOnDropped()  
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
 