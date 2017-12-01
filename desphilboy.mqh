//version  20171101
// heaer file for desphilboy
//+------------------------------------------------------------------+
//|                                                   desphilboy.mqh |
//|                                                       Desphilboy |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Desphilboy"
#property link "https://www.mql5.com"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// desphilboy system unique Identifier is Mahmaraza Rahvareh My best friend who died in Motorcycle accident
#define MAHMARAZA_RAHVARA_ID 1921 // He loved this number, was his magic number
#define GROUP_SHIFT_CONSTANT 10000

// 4 default groups IDs verylong, long term, medium term and short term positions plus one custom group for user
#define ULTRALONGTERMGROUP 10000
#define VERYLONGTERMGROUP 20000
#define LONGTERMGROUP 30000
#define MEDTERMGROUP 40000
#define SHORTTERMGROUP 50000
#define VERYSHORTTERMGROUP 60000
#define ULTRASHORTTERMGROUP 70000
#define INSTANTTERMGROUP 80000

// EA signature on the position
#define ImanTrailing_ID 100000
#define GroupedImanTrailing_ID 200000
#define DesphilboyPositionCreator_ID 300000
#define DAPositionCreator_ID 400000

enum Groups {
    NoGroup = 0,
    UltraLongTerm=ULTRALONGTERMGROUP,
    VeryLongTerm = VERYLONGTERMGROUP,
    LongTerm = LONGTERMGROUP,
    MediumTerm = MEDTERMGROUP,
    ShortTerm = SHORTTERMGROUP,
    VeryShortTerm = VERYSHORTTERMGROUP,
    UltraShortTerm = ULTRASHORTTERMGROUP,
    InstantTerm = INSTANTTERMGROUP
};

enum BuyTypes {
    Buy,
    BuyLimit,
    BuyStop
};

enum SellTypes {
    Sell,
    SellLimit,
    SellStop
};

enum TradeActs {
    Initialize,
    Repair,
    Append,
    Terminate,
    NoAction
};

enum GroupIds {
    gid_NoGroup = 0,
    gid_UltraLongTerm = 1,
    gid_VeryLongTerm = 2,
    gid_LongTerm = 3,
    gid_MediumTerm = 4,
    gid_ShortTerm = 5,
    gid_VeryShortTerm = 6,
    gid_UltraShortTerm = 7,
    gid_InstantTerm = 8,
    gid_Panic = 9
};

enum TrailingFields {
    TrailingStop = 0, Step = 1, Retrace = 2, LifePeriod = 3
};

enum LifeTimes {
    NoLifeTime = 0,
    FiveMinutes = 5,
    TenMinutes = 10,
    Quarter = 15,
    HalfHour = 30,
    Min45 = 45,
    OneHour = 60,
    Footbal = 90,
    TwoHours = 120,
    ThreeHours = 180,
    FourHours = 240,
    SixHours = 360,
    EightHours = 480,
    TwelveHours = 720,
    SixteenHours = 960,
    OneDay = 1440,
    TwoDays = 2880,
    SixtyFourHours = 3840,
    ThreeDays = 4320,
    FiveDays = 7200
};




// fibonacci
enum FiboRetrace {
    NoRetrace = 0,
    PaniclyRetrace = 1,
    MinRetrace = 2,
    LowRetrace = 3,
    HalfRetrace = 4,
    MaxRetrace = 5,
    AlmostWholeRetrace=6,
    WholeRetrace=7
};

double Fibo[] = {
    0.000,
    0.1,
    0.236,
    0.382,
    0.500,
    0.618,
    0.9,
    0.95
};

static int TrailingInfo[gid_Panic + 1][LifePeriod + 1];

// common functions to work with Magic Numbers
int createMagicNumber(int eaId, int groupId) {
    return eaId + groupId + MAHMARAZA_RAHVARA_ID;
}

bool isDesphilboy(int magicNumber) {
    return (magicNumber % 10000) == MAHMARAZA_RAHVARA_ID;
}

bool isUltraLongTerm(int magicNumber) {
    if (isDesphilboy(magicNumber)) {
        return ((magicNumber % 100000) - MAHMARAZA_RAHVARA_ID) == ULTRALONGTERMGROUP;
    }
    return false;
}

bool isVeryLongTerm(int magicNumber) {
    if (isDesphilboy(magicNumber)) {
        return ((magicNumber % 100000) - MAHMARAZA_RAHVARA_ID) == VERYLONGTERMGROUP;
    }
    return false;
}


bool isLongTerm(int magicNumber) {
    if (isDesphilboy(magicNumber)) {
        return ((magicNumber % 100000) - MAHMARAZA_RAHVARA_ID) == LONGTERMGROUP;
    }
    return false;
}

bool isShortTerm(int magicNumber) {
    if (isDesphilboy(magicNumber)) {
        return ((magicNumber % 100000) - MAHMARAZA_RAHVARA_ID) == SHORTTERMGROUP;
    }
    return false;
}


bool isMediumTerm(int magicNumber) {
    if (isDesphilboy(magicNumber)) {
        return ((magicNumber % 100000) - MAHMARAZA_RAHVARA_ID) == MEDTERMGROUP;
    }
    return false;
}


bool isVeryShort(int magicNumber) {
    if (isDesphilboy(magicNumber)) {
        return ((magicNumber % 100000) - MAHMARAZA_RAHVARA_ID) == VERYSHORTTERMGROUP;
    }
    return false;
}

bool isUltraShort(int magicNumber) {
    if (isDesphilboy(magicNumber)) {
        return ((magicNumber % 100000) - MAHMARAZA_RAHVARA_ID) == ULTRASHORTTERMGROUP;
    }
    return false;
}

bool isInstant(int magicNumber) {
    if (isDesphilboy(magicNumber)) {
        return ((magicNumber % 100000) - MAHMARAZA_RAHVARA_ID) == INSTANTTERMGROUP;
    }
    return false;
}

bool isManual(int magicNumber) {
    return magicNumber == 0;
}


string getGroupName(int magicNumber) {

    if (isUltraLongTerm(magicNumber)) {
        return "UltraLongTerm";
    } else if (isVeryLongTerm(magicNumber)) {
        return "VeryLongTerm";
    } else if (isLongTerm(magicNumber)) {
        return "LongTerm";
    } else if (isMediumTerm(magicNumber)) {
        return "MediumTerm";
    } else if (isShortTerm(magicNumber)) {
        return "ShortTerm";
    } else if (isVeryShort(magicNumber)) {
        return "VeryShortTerm";
    } else if (isUltraShort(magicNumber)) {
        return "UltraShort";
    } else if (isInstant(magicNumber)) {
        return "Instant";
    } else if (isManual(magicNumber)) {
        return "Manual";
    } else return "Unknown";

}


Groups getGroup(int magicNumber) {
    if (isUltraLongTerm(magicNumber)) {
        return UltraLongTerm;
    } else if (isVeryLongTerm(magicNumber)) {
        return VeryLongTerm;
    } else if (isLongTerm(magicNumber)) {
        return LongTerm;
    } else if (isMediumTerm(magicNumber)) {
        return MediumTerm;
    } else if (isShortTerm(magicNumber)) {
        return ShortTerm;
    } else if (isVeryShort(magicNumber)) {
        return VeryShortTerm;
    } else if (isUltraShort(magicNumber)) {
        return UltraShortTerm;
    } else if (isInstant(magicNumber)) {
        return InstantTerm;
    } else return NoGroup;
}

GroupIds getGroupId(int magicNumber) {
    if (isVeryLongTerm(magicNumber)) {
        return gid_VeryLongTerm;
    } else if (isLongTerm(magicNumber)) {
        return gid_LongTerm;
    } else if (isMediumTerm(magicNumber)) {
        return gid_MediumTerm;
    } else if (isShortTerm(magicNumber)) {
        return gid_ShortTerm;
    } else if (isVeryShort(magicNumber)) {
        return gid_VeryShortTerm;
    }
    return gid_NoGroup;
}


int getPositionsInterval(string symbol, int operation, double rangeLow, double rangeHi, int & results[]) {
    int resultCounter = 0;

    int openPosType = (operation == OP_SELLSTOP || operation == OP_SELLLIMIT) ? OP_SELL : OP_BUY;

    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol &&
                (OrderType() == operation || (OrderType() == openPosType)) &&
                OrderOpenPrice() > rangeLow &&
                OrderOpenPrice() < rangeHi ) {
                results[resultCounter] = OrderTicket();
                resultCounter++;
            }
        }
    }

    return resultCounter;
}


int getPositionsInRange(string symbol, int operation, double center, int PIPsMargin, int & results[]) {
    double pip = MarketInfo(symbol, MODE_POINT);
    double l = center - PIPsMargin * pip;
    double h = center + PIPsMargin * pip;
    return getPositionsInterval(symbol, operation, l, h, results);
}


int getCurrentTrailingStop(int tradeTicket, int & trailingInfo[][], bool lifePeriodEffectiveAlways, bool panic = false) {

    if (panic) {
        return trailingInfo[gid_Panic][TrailingStop];
    }

    if (!OrderSelect(tradeTicket, SELECT_BY_TICKET, MODE_TRADES)) {
        return trailingInfo[gid_Panic][TrailingStop];
    }

    GroupIds orderGroup = getGroupId(OrderMagicNumber());

    if (trailingInfo[orderGroup][LifePeriod] == PERIOD_CURRENT) {

        return trailingInfo[orderGroup][TrailingStop];
    }

    if (OrderStopLoss() != 0 && !lifePeriodEffectiveAlways) {

        return trailingInfo[orderGroup][TrailingStop];
    }

    double minutesElapsed = getMinutesOld(OrderOpenTime());
    double lifeTimeInMinutes = trailingInfo[orderGroup][LifePeriod];
    if (lifeTimeInMinutes == 0) {
        lifeTimeInMinutes = 30;
    } // prevent divide by zero
    double timesLifeTimeElapsed = (minutesElapsed / lifeTimeInMinutes);
    
    if( timesLifeTimeElapsed < 0 ) { timesLifeTimeElapsed = 0;} // avoid -1 and divide by zero
    
    int orderTrailingStop = (int)(trailingInfo[orderGroup][TrailingStop] / (1 + timesLifeTimeElapsed));
    // Print("Factor is:", 1+ timesLifeTimeElapsed, ",Order Trailing Stop for ", tradeTicket, " is ", orderTrailingStop);
    return orderTrailingStop;
}

double getCurrentRetrace(int tradeTicket, int & trailingInfo[][], bool lifePeriodEffectiveAlways, bool panic = false) {

    if (panic) {
        return Fibo[trailingInfo[gid_Panic][Retrace]];
    }

    if (!OrderSelect(tradeTicket, SELECT_BY_TICKET, MODE_TRADES)) {
        return Fibo[trailingInfo[gid_Panic][Retrace]];
    }

    GroupIds orderGroup = getGroupId(OrderMagicNumber());

    if (trailingInfo[orderGroup][LifePeriod] == PERIOD_CURRENT) {

        return Fibo[trailingInfo[orderGroup][Retrace]];
    }

    if (OrderStopLoss() != 0 && !lifePeriodEffectiveAlways) {

        return Fibo[trailingInfo[orderGroup][Retrace]];
    }

    double minutesElapsed = getMinutesOld(OrderOpenTime());
    double lifeTimeInMinutes = trailingInfo[orderGroup][LifePeriod];
    if (lifeTimeInMinutes == 0) {
        lifeTimeInMinutes = 30;
    } // prevent divide by zero
    double timesLifeTimeElapsed = (minutesElapsed / lifeTimeInMinutes);
    
    if( timesLifeTimeElapsed < 0 ) { timesLifeTimeElapsed = 0;} // avoid -1 and divide by zero
    
    double orderRetrace = (Fibo[trailingInfo[orderGroup][Retrace]] / (1 + timesLifeTimeElapsed));
    // Print("Factor is:", 1+ timesLifeTimeElapsed, ", Order retrace for ", tradeTicket, " is ", orderRetrace);
    return orderRetrace;
}



int getMinutesOld(datetime creationTime) {

    int diff = (int)(TimeCurrent() - creationTime);

    return (int) diff / 60;
}


double getNetPosition(string symbol) {

    double balance = 0;

    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol) {
                if (OrderType() == OP_BUY) balance = balance + OrderLots();
                if (OrderType() == OP_SELL) balance = balance - OrderLots();
            }
        }
    }
    return balance;
}


double getPriceOfHighest(int operation, string symbol) {
    double price = 0;

    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol) {
                if (OrderType() == operation) price = MathMax(price, OrderOpenPrice());

            }
        }
    }
    return price;
}


double getPriceOfLowest(int operation, string symbol) {
    double price = 99990;

    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol) {
                if (OrderType() == operation) price = MathMin(price, OrderOpenPrice());

            }
        }
    }
    return price;
}


bool isPanic(string symbol, ENUM_TIMEFRAMES timeframe, int panicPIPS) {

    double minPrice = MathMin(iLow(symbol, timeframe, 0), iLow(symbol, timeframe, 1));
    double maxPrice = MathMax(iHigh(symbol, timeframe, 0), iHigh(symbol, timeframe, 1));

    double span = maxPrice - minPrice;

    double symbolPoint = MarketInfo(symbol, MODE_POINT);
    if(symbolPoint <= 0) {
      Print("Cannot find point value for ",symbol);
      return false; 
    }

    int spanPips = (int)(span / symbolPoint);

    return (spanPips >= panicPIPS);
}


int filterOutTradesNotIn(string allowedPairs) {
    int result = 0;
    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (StringFind(allowedPairs, OrderSymbol(), 0) == -1) {
                if (OrderType() != OP_SELL && OrderType() != OP_BUY) {
                    Print("Order ", OrderTicket(), " being deleted because ", OrderSymbol(), " not found in ", allowedPairs);
                    result = OrderDelete(OrderTicket());
                }

            }
        }
    }
    return result;
}

int appendTradesIfAppropriate(string pairname, int pointsMargin, int spacing, int spikePIPs, double spikeTradeLots, double maxLots, double absMaxLots) {

    double netLotsAllowed = maxLots;
    double pp = MarketInfo(pairname, MODE_POINT);

    if (getUnsafeNetPosition(pairname) < netLotsAllowed && getUnsafeBuys(pairname) < absMaxLots) {
        if (getPriceOfLowest(OP_BUYSTOP, pairname) > (Ask + spikePIPs * pp)) {
            Print("Creating Buy Stops on ", pairname);
            appendBuyStops(pairname, pointsMargin, spacing, spikeTradeLots);
        }
    }

    if (getUnsafeNetPosition(pairname) > (-1 * netLotsAllowed) && getUnsafeSells(pairname) < absMaxLots) {
        if (getPriceOfHighest(OP_SELLSTOP, pairname) < (Bid - spikePIPs * pp)) {
            Print("Creating Sell Stops on ", pairname);
            appendSellStops(pairname, pointsMargin, spacing, spikeTradeLots);
        }
    }

    return 0;

}

double getUnsafeNetPosition(string symbol) {

    double balance = 0;

    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol) {
                if (OrderType() == OP_BUY && OrderStopLoss() < OrderOpenPrice()) balance = balance + OrderLots();
                if (OrderType() == OP_SELL && OrderStopLoss() > OrderOpenPrice()) balance = balance - OrderLots();
            }
        }
    }
    return balance;
}

// returns sum  of lots of all buys which have no stop-loss yet 

double getUnsafeBuys(string symbol) {
    double balance = 0;

    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol) {
                if (OrderType() == OP_BUY && OrderStopLoss() < OrderOpenPrice()) balance = balance + OrderLots();
            }
        }
    }
    return balance;
}

double getUnsafeSells(string symbol) {
    double balance = 0;

    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol) {
                if (OrderType() == OP_SELL && OrderStopLoss() > OrderOpenPrice()) balance = balance + OrderLots();
            }
        }
    }
    return balance;
}

double getAppropriateLotSize() {
    return AccountEquity() / 10000.0;
}



int appendBuyStops(string pairName, int margin, int spacing, double lots) {
    double point = MarketInfo(pairName, MODE_POINT);

    createBuyStop(pairName, Ask, 0, (int)(margin * 1.5), 0, 0, VeryShortTerm, margin, lots, 100, 0, spacing);
    createBuyStop(pairName, Ask, 1, (int)(margin * 1.5), 0, 0, ShortTerm, margin, lots, 100, 0, spacing);
    createBuyStop(pairName, Ask, 2, (int)(margin * 1.5), 0, 0, MediumTerm, margin, lots, 100, 0, spacing);
    createBuyStop(pairName, Ask, 3, (int)(margin * 1.5), 0, 0, ShortTerm, margin, lots, 100, 0, spacing);
    createBuyStop(pairName, Ask, 4, (int)(margin * 1.5), 0, 0, VeryShortTerm, margin, lots, 100, 0, spacing);
    return 0;
}



int appendSellStops(string pairName, int margin, int spacing, double lots) {
    double point = MarketInfo(pairName, MODE_POINT);


    createSellStop(pairName, Bid, 0, (int)(margin * 1.5), 0, 0, VeryShortTerm, margin, lots, 100, 0, spacing);
    createSellStop(pairName, Bid, 1, (int)(margin * 1.5), 0, 0, ShortTerm, margin, lots, 100, 0, spacing);
    createSellStop(pairName, Bid, 2, (int)(margin * 1.5), 0, 0, MediumTerm, margin, lots, 100, 0, spacing);
    createSellStop(pairName, Bid, 3, (int)(margin * 1.5), 0, 0, ShortTerm, margin, lots, 100, 0, spacing);
    createSellStop(pairName, Bid, 4, (int)(margin * 1.5), 0, 0, VeryShortTerm, margin, lots, 100, 0, spacing);
    return 0;
}


int createBuyStop(
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
    int spacing) {
    datetime now = TimeCurrent();
    datetime expiry = tradesExpireAfterHours != 0 ? now + tradesExpireAfterHours * 3600 : 0;
    double baseprice = startingPrice == 0.0 ? Ask : startingPrice;
    double pip = MarketInfo(symbol, MODE_POINT);
    double price = baseprice + (distance * index + PIPsToStart) * pip;
    double stopLoss = StopLossBuys != 0 ? price - StopLossBuys * pip : 0;
    double takeProfit = TakeProfitBuys != 0 ? price + TakeProfitBuys * pip : 0;


    bool spaceAvailable = false;
    spaceAvailable = clearSpaceForPosition(price, OP_BUYSTOP, spacing, Symbol());


    if (!spaceAvailable) {
        Print("Space not available for SellStop at ", price, " with group ", getGroupName(createMagicNumber(DAPositionCreator_ID, BuyStopsGroup)));
        return -1;
    }


    int result = OrderSend(
        symbol, // symbol
        OP_BUYSTOP, // operation
        buyLots, // volume
        price, // price
        slippage, // slippage
        stopLoss, // stop loss
        takeProfit, // take profit
        NULL, // comment
        createMagicNumber(DAPositionCreator_ID, BuyStopsGroup), // magic number
        expiry, // pending order expiration
        clrNONE // color
    );

    if (result == -1) {
        Print("Order ", index, " creation failed for BuyStop at:", price);
    } else {
        if (OrderSelect(result, SELECT_BY_TICKET))
            Print("BuyStop ", index, " created at ", price, " with ticket ", OrderTicket(), " Group ", getGroupName(OrderMagicNumber()));
    }
    return result;
}




int createSellStop(
    string symbol,
    double startingPrice,
    int index,
    int PIPsToStart,
    int StopLossSells,
    int TakeProfitSells,
    Groups SellStopsGroup,
    int distance,
    double sellLots,
    int slippage,
    int tradesExpireAfterHours,
    int spacing) {
    datetime now = TimeCurrent();
    datetime expiry = tradesExpireAfterHours != 0 ? now + tradesExpireAfterHours * 3600 : 0;
    double pip = MarketInfo(symbol, MODE_POINT);
    double baseprice = startingPrice == 0.0 ? Bid : startingPrice;
    double price = baseprice - (distance * index + PIPsToStart) * pip;
    double stopLoss = StopLossSells != 0 ? price + StopLossSells * pip : 0;
    double takeProfit = TakeProfitSells != 0 ? price - TakeProfitSells * pip : 0;


    bool spaceAvailable = false;

    spaceAvailable = clearSpaceForPosition(price, OP_SELLSTOP, spacing, Symbol());


    if (!spaceAvailable) {
        Print("Space not available for SellStop at ", price, " with group ", getGroupName(createMagicNumber(DAPositionCreator_ID, SellStopsGroup)));
        return -1;
    }

    int result = OrderSend(
        symbol, // symbol
        OP_SELLSTOP, // operation
        sellLots, // volume
        price, // price
        slippage, // slippage
        stopLoss, // stop loss
        takeProfit, // take profit
        NULL, // comment
        createMagicNumber(DAPositionCreator_ID, SellStopsGroup), // magic number
        expiry, // pending order expiration
        clrNONE // color
    );

    if (result == -1) {
        Print("Order ", index, " creation failed for SellStop at:", price);
    } else {
        if (OrderSelect(result, SELECT_BY_TICKET))
            Print("SellStop ", index, " created at ", price, " with ticket ", OrderTicket(), " Group ", getGroupName(OrderMagicNumber()));
    }
    return result;
}

bool clearSpaceForPosition(double price, int operation, int Spacing, string symbol) {
    int positions[1000];
  

    if (Spacing != 0) {
        int c = getPositionsInRange(symbol, operation, price, Spacing, positions);
        if (c > 0) {
            return false;
        }
    }

return true; 
}