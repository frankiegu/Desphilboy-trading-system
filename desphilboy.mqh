//version  20180311
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

//ARV constants
#define LONGARVAVERAGECANDLES  17
#define SHORTARVAVERAGECANDLES  4

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
    OneMinute = 1,
    TwoMinutes = 2,
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
    TenHours = 600,
    TwelveHours = 720,
    SixteenHours = 960,
    TwentyHours = 1200,
    OneDay = 1440,
    ThirtyHours = 1800,
    ThirtyTwoHours = 1920,
    OneAndHalfDay = 2160,
    FourtyHours = 2400,
    TwoDays = 2880,
    TwoDaysAnd8Hours = 3360,
    SixtyFourHours = 3840,
    ThreeDays = 4320,
    FourDays = 5760,
    FiveDays = 7200,
    SevenDays = 10080,
    TenDays = 14400,
    TwelveDays = 17280,
    FortNight = 20160,
    FifteenDays = 21600
    
};




// fibonacci
enum FiboRetrace {
    NoRetrace = 0,
    PaniclyRetrace = 1,
    MinRetrace = 2,
    LowRetrace = 3,
    HalfRetrace = 4,
    MaxRetrace = 5,
    Retrace65=6,
    Retrace70=7,
    Retrace75=8,
    Retrace80=9,
    Retrace85=10,
    Retrace90=11,
    Retrace95=12,
    WholeRetrace=13,
    Retrace105=14,
    Retrace110=15,
    Retrace115=16
};

double Fibo[] = {
    0.000,
    0.1,
    0.236,
    0.382,
    0.500,
    0.618,
    0.65,
    0.70,//whole
    0.75,
    0.80,
    0.85,
    0.90,
    0.95,
    1.0,
    1.05,
    1.1,
    1.15
};

struct pairInfo {
    string pairName;
    double netPosition;
    double unsafeNetPosition;
    double unsafeBuys;
    double unsafeSells;
    double buyLots;
    double sellLots;
    int numberOfLoosingBuys;
    int numberOfLoosingSells;
    int reservedOpositeSells[1000];
    int reservedOpositeBuys[1000];
    int reservedBuysCount;
    int reservedSellsCount;
};

static int TrailingInfo[gid_Panic + 1][LifePeriod + 1];
static bool beVerbose = false;
static pairInfo pairInfoCache [100];
static int pairsCount = 0;


int updatePairInfoCache(string pairNamesCommaSeparated) {
    string pairNames[100];
    int numPairs = StringSplit(pairNamesCommaSeparated, ',', pairNames);

    for (int i = 0; i < numPairs; ++i) {
        pairInfoCache[i].pairName = pairNames[i];
       
        pairInfoCache[i].buyLots = getVolBallance(pairInfoCache[i].pairName, OP_BUY);
        pairInfoCache[i].sellLots = getVolBallance(pairInfoCache[i].pairName, OP_SELL);
        pairInfoCache[i].netPosition =  pairInfoCache[i].buyLots  - pairInfoCache[i].sellLots;
        pairInfoCache[i].unsafeNetPosition = getUnsafeNetPosition(pairInfoCache[i].pairName);
        pairInfoCache[i].unsafeBuys = getUnsafeBuys(pairInfoCache[i].pairName);
        pairInfoCache[i].unsafeSells = getUnsafeSells(pairInfoCache[i].pairName);
        pairInfoCache[i].numberOfLoosingBuys = getNumberOfLoosingBuys(pairInfoCache[i].pairName);
        pairInfoCache[i].numberOfLoosingSells = getNumberOfLoosingSells(pairInfoCache[i].pairName);
        matchLoosingTrades(pairInfoCache[i]);
    }

    if (beVerbose) {
        Print("*******     Pairs information *******");
        for (int i = 0; i < numPairs; ++i) {
            Print(i, ":", pairInfoCache[i].pairName, " information: ");
            Print("netPosition:", pairInfoCache[i].netPosition, " Buys:", pairInfoCache[i].buyLots, " Sells:", pairInfoCache[i].sellLots);
            Print("unsafeNetPosition:", pairInfoCache[i].unsafeNetPosition, " unsafeBuys:", pairInfoCache[i].unsafeBuys, " unsafeSells:", pairInfoCache[i].unsafeSells);
            Print("numberOfLoosingBuys:", pairInfoCache[i].numberOfLoosingBuys);
            for (int j = 0; j < pairInfoCache[i].reservedSellsCount; ++j)
                Print("reservedSells[", j, "]=", pairInfoCache[i].reservedOpositeSells[j]);
            Print("numberOfLoosingSells:", pairInfoCache[i].numberOfLoosingSells);
            for (int j = 0; j < pairInfoCache[i].reservedBuysCount; ++j)
                Print("reservedBuys[", j, "]=", pairInfoCache[i].reservedOpositeBuys[j]);
        }
    }

    return numPairs;
}

int getNumberOfLoosingBuys(string symbol) {
    int loosingBuysCounter = 0;
    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol && OrderType() == OP_BUY && OrderProfit() < 0) {
                loosingBuysCounter++;
            }
        }
    }
    return loosingBuysCounter;
}


int getNumberOfLoosingSells(string symbol) {
    int loosingSellsCounter = 0;
    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol && OrderType() == OP_SELL && OrderProfit() < 0) {
                loosingSellsCounter++;
            }
        }
    }
    return loosingSellsCounter;
}


ENUM_TIMEFRAMES findStandardTimeFrameOf(int minutes) {
    if (minutes > PERIOD_MN1) return PERIOD_MN1;
    if (minutes > PERIOD_W1) return PERIOD_W1;
    if (minutes > PERIOD_D1) return PERIOD_D1;
    if (minutes > PERIOD_H4) return PERIOD_H4;
    if (minutes > PERIOD_H1) return PERIOD_H1;
    if (minutes > PERIOD_M30) return PERIOD_M30;
    if (minutes > PERIOD_M15) return PERIOD_M15;
    if (minutes > PERIOD_M5) return PERIOD_M5;
    return PERIOD_MN1;
}

// My indicator calculating Average Relational Volatility
double arvIndicator(string symbol, int timeframe, int longCandlesCount, int shortCandlesCount) {
    ENUM_TIMEFRAMES timeFrame = findStandardTimeFrameOf(timeframe);
    int longHighestIndex = iHighest(symbol, timeFrame, MODE_HIGH, longCandlesCount, 0);
    int longLowestIndex = iLowest(symbol, timeFrame, MODE_LOW, longCandlesCount, 0);

    int shortHighestIndex = iHighest(symbol, timeFrame, MODE_HIGH, shortCandlesCount, 0);
    int shortLowestIndex = iLowest(symbol, timeFrame, MODE_LOW, shortCandlesCount, 0);

    if (longHighestIndex == -1 || longLowestIndex == -1 || shortLowestIndex == -1 || shortHighestIndex == -1) {
        Print("arvIndicator: could not get ranges, returning error value -1.");
        return -1;
    }

    double longRange = iHigh(symbol, timeFrame, longHighestIndex) - iLow(symbol, timeFrame, longLowestIndex);
    double shortRange = iHigh(symbol, timeFrame, shortHighestIndex) - iLow(symbol, timeFrame, shortLowestIndex);
   
    if(longRange == 0) {
    //avoid divide by zero
      return 0.49;
    }
    return (shortRange / longRange);
}

//Average relative volatility
double getARVHuristic(string tradeSymbol, int positionLifeTime) {
    double avrIndicatorValue = arvIndicator(tradeSymbol, positionLifeTime, LONGARVAVERAGECANDLES, SHORTARVAVERAGECANDLES);

    if (avrIndicatorValue < 0) {
        return 1; // returning safe value because of error
    }

    if (avrIndicatorValue < 0.3) { // is very steady
        return 0.7;
    }

    if (avrIndicatorValue < 0.5) { // is normal
        return 1;
    }

    return 1.33; // is very volatile
}


int findLowestBuy(string symbol, double floorPrice = 0.0) {
    int preserveTicket = OrderTicket();
    double lowestprice = 999999999;
    int lowestTicket = -1;

    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol && OrderType() == OP_BUY) {
                if (OrderOpenPrice() < lowestprice && OrderOpenPrice() > floorPrice) {
                    lowestTicket = OrderTicket();
                    lowestprice = OrderOpenPrice();
                }
            }
        }
    }

    bool bResult = OrderSelect(preserveTicket, SELECT_BY_TICKET, MODE_TRADES);
    return lowestTicket;
}


int findHighestSell(string symbol, double ceilingPrice = 99999999) {
    int preserveTicket = OrderTicket();
    double highestprice = 0;
    int highestTicket = -1;

    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol && OrderType() == OP_SELL) {
                if (OrderOpenPrice() > highestprice && OrderOpenPrice() < ceilingPrice) {
                    highestTicket = OrderTicket();
                    highestprice = OrderOpenPrice();
                }
            }
        }
    }

    bool bResult = OrderSelect(preserveTicket, SELECT_BY_TICKET, MODE_TRADES);
    return highestTicket;
}

void matchLoosingTrades(pairInfo & pairinfo) {
    int ticketFound = 0;
    pairinfo.reservedSellsCount = 0;
    double priceOfFoundTrade = 999999999;
    for (int i = 0; i < pairinfo.numberOfLoosingBuys && ticketFound != -1; ++i) {
        ticketFound = findHighestSell(pairinfo.pairName, priceOfFoundTrade);
        if (ticketFound != -1) {
            pairinfo.reservedOpositeSells[i] = ticketFound;
            pairinfo.reservedSellsCount++;
            if (OrderSelect(ticketFound, SELECT_BY_TICKET, MODE_TRADES)) {
                priceOfFoundTrade = OrderOpenPrice();
            } else {
                Print("matchLoosingTrades:could not select ticket:", ticketFound, " breaking the search.");
                break;
            }
        }
    }

    ticketFound = 0;
    priceOfFoundTrade = 0;
    pairinfo.reservedBuysCount = 0;
    for (int i = 0; i < pairinfo.numberOfLoosingSells && ticketFound != -1; ++i) {
        ticketFound = findLowestBuy(pairinfo.pairName, priceOfFoundTrade);
        if (ticketFound != -1) {
            pairinfo.reservedOpositeBuys[i] = ticketFound;
            pairinfo.reservedBuysCount++;
            if (OrderSelect(ticketFound, SELECT_BY_TICKET, MODE_TRADES)) {
                priceOfFoundTrade = OrderOpenPrice();
            }else {
                Print("matchLoosingTrades:could not select ticket:", ticketFound, " breaking the search.");
                break;
            }
        }
    }
    return;
}

int getPairInfoIndex(string pairName) {
    for (int i = 0; i < pairsCount; ++i)
        if (pairInfoCache[i].pairName == pairName) return i;

    return -1;
}


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
    if (isUltraLongTerm(magicNumber)) {
        return gid_UltraLongTerm;
    } else if (isVeryLongTerm(magicNumber)) {
        return gid_VeryLongTerm;
    } else if (isLongTerm(magicNumber)) {
        return gid_LongTerm;
    } else if (isMediumTerm(magicNumber)) {
        return gid_MediumTerm;
    } else if (isShortTerm(magicNumber)) {
        return gid_ShortTerm;
    } else if (isVeryShort(magicNumber)) {
        return gid_VeryShortTerm;
    } else if (isUltraShort(magicNumber)) {
        return gid_UltraShortTerm;
    } else if (isInstant(magicNumber)) {
        return gid_InstantTerm;
    } else return gid_NoGroup;
}


int getPositionsInterval(string symbol, int operation, double rangeLow, double rangeHi, int & results[]) {
    int resultCounter = 0;

    int openPosType = (operation == OP_SELLSTOP || operation == OP_SELLLIMIT) ? OP_SELL : OP_BUY;

    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol &&
                (OrderType() == operation || (OrderType() == openPosType)) &&
                OrderOpenPrice() > rangeLow &&
                OrderOpenPrice() < rangeHi) {
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

int getCurrentTrailingStop(int tradeTicket, GroupIds orderGroup, bool lifePeriodEffectiveAlways, bool panic = false, double heuristicsValue = 1, string symbol="", double tradeStopLoss=0) {

     if (panic && !isReservedTrade(tradeTicket, symbol)) {
        if (beVerbose) Print(tradeTicket, ": Returning a panic trailing stop: ", TrailingInfo[gid_Panic][TrailingStop] );
        return TrailingInfo[gid_Panic][TrailingStop];
    }

    if (panic && isReservedTrade(tradeTicket, symbol)) {
        if (beVerbose) Print(tradeTicket, ": Returning half a nprmal trailing stop for panic reserved ticket: ", TrailingInfo[gid_UltraLongTerm][TrailingStop] * 0.5 * heuristicsValue);
        return (int) (TrailingInfo[gid_UltraLongTerm][TrailingStop] * 0.5 * heuristicsValue);
    }
    
    if (TrailingInfo[orderGroup][LifePeriod] == PERIOD_CURRENT) {
        return TrailingInfo[orderGroup][TrailingStop];
    }

    if (tradeStopLoss != 0 && !lifePeriodEffectiveAlways) {
        if (beVerbose) Print(tradeTicket, ": Active calculation not effective after first stop loss, returning constant trailing stop");
        return TrailingInfo[orderGroup][TrailingStop];
    }

    int orderTrailingStop = (int)(TrailingInfo[orderGroup][TrailingStop] * heuristicsValue);
    if (beVerbose) Print(tradeTicket, ": Factor is:", heuristicsValue, " ,Order Trailing Stop  is: ", orderTrailingStop);
    return orderTrailingStop;
}

double getCurrentRetrace(int tradeTicket, GroupIds orderGroup, bool lifePeriodEffectiveAlways, bool panic = false, double heuristicsValue = 1, string symbol="", double tradeStopLoss=0) {

    if (panic && !isReservedTrade(tradeTicket, symbol)) {
        if (beVerbose) Print(tradeTicket, ": Returning a panic trailing stop. ");
        return Fibo[TrailingInfo[gid_Panic][Retrace]];
    }

    if (panic && isReservedTrade(tradeTicket,symbol)) {
          if (beVerbose) Print(tradeTicket, ": Returning half a nprmal retrace for panic reserved ticket.");
        double reservingCoefficient =1;
        int reservedIndex = inReservedTrades(tradeTicket,symbol);
        if( reservedIndex > -1) reservingCoefficient = 0.9 /(1 + reservedIndex);  
        return Fibo[TrailingInfo[gid_UltraLongTerm][Retrace]] * 0.5 * heuristicsValue * reservingCoefficient ;
    }

    if (TrailingInfo[orderGroup][LifePeriod] == PERIOD_CURRENT) {

        return Fibo[TrailingInfo[orderGroup][Retrace]];
    }

    if (tradeStopLoss != 0 && !lifePeriodEffectiveAlways) {

        return Fibo[TrailingInfo[orderGroup][Retrace]];
    }

    double orderRetrace = (Fibo[TrailingInfo[orderGroup][Retrace]] * heuristicsValue);
    if (beVerbose) Print(tradeTicket,": Factor is:", heuristicsValue, " , Retrace is: ", orderRetrace);
    return orderRetrace;
}


double lifeTimeHeuristic(datetime orderOpenTime, GroupIds orderGroupId) {
    double minutesElapsed = getMinutesOld(orderOpenTime);
    double lifeTimeInMinutes = TrailingInfo[orderGroupId][LifePeriod];
    
   if (lifeTimeInMinutes == 0) {
        lifeTimeInMinutes = 30;
    } // prevent divide by zero
    double timesLifeTimeElapsed = (minutesElapsed / lifeTimeInMinutes);
    return 1 / (1 + 0.5 * timesLifeTimeElapsed * timesLifeTimeElapsed);
}

int getPipsProfit(double orderOpenPrice, string symbol) {
 
 double price  = (MarketInfo(symbol, MODE_BID) + MarketInfo(symbol, MODE_ASK)) /2;
 double pointValue = MarketInfo(symbol, MODE_POINT);
 double diff = MathAbs(orderOpenPrice - price);
 return (int) (diff/pointValue);
 
 }


double priceTimeHeuristic(int tradeTicket, datetime orderOpenTime, GroupIds orderGroupId, double orderOpenPrice, string symbol) {
    double minutesElapsed = getMinutesOld(orderOpenTime);
    double lifeTimeInMinutes = TrailingInfo[orderGroupId][LifePeriod];
    
     if (lifeTimeInMinutes == 0)  return 1;   // no need to proceed
    
    double timesLifeTimeElapsed = minutesElapsed / lifeTimeInMinutes;
    
    if( timesLifeTimeElapsed < 3 ) return 1;  // the Heuristic is to prolong longer lasting trades, not intended to act on new trades
    
    int pipsProfit = getPipsProfit(orderOpenPrice, symbol);
    double timesTrailingStop = pipsProfit / TrailingInfo[orderGroupId][TrailingStop];
    double priceTimeRatio= (timesTrailingStop / timesLifeTimeElapsed);
    
    if(priceTimeRatio < 0.2 ) {  
    if( isReservedTrade(tradeTicket, symbol)) return 1.0;
    return 0.7; }
    if(priceTimeRatio > 0.5)  return 1.25;
   
   return 1;
}



double unsafeBalanceHeuristic(int ticketNumber, string symbol, int orderType, bool tradeReservationEnabled) {
    int pairIndex = getPairInfoIndex(symbol);
    if (pairIndex == -1) { // reurn a safe value because there is no pair info
        return 1;
    }

    if ((orderType == OP_BUY && pairInfoCache[pairIndex].unsafeNetPosition < 0) || (orderType == OP_SELL && pairInfoCache[pairIndex].unsafeNetPosition > 0)) {
        return 1.33;
    }

   if(tradeReservationEnabled && isReservedTrade(ticketNumber, symbol)) {
      return 1;
   }
   
   if ((orderType == OP_BUY && pairInfoCache[pairIndex].netPosition > 0.008) || (orderType == OP_SELL && pairInfoCache[pairIndex].netPosition < -0.008)) {
        return 0.8;
    }

    return 1;
}

double balanceHeuristic(int ticketNumber, string symbol, int orderType, bool tradeReservationEnabled) {
    int pairIndex = getPairInfoIndex(symbol);
    if (pairIndex == -1) { // reurn a safe value because there is no pair info
        return 1;
    }

    if ((orderType == OP_BUY && pairInfoCache[pairIndex].netPosition < 0) || (orderType == OP_SELL && pairInfoCache[pairIndex].netPosition > 0)) {
        return 1.5;
    }

   if(tradeReservationEnabled && isReservedTrade(ticketNumber, symbol)) {
      return 1;
   }
   
   if ((orderType == OP_BUY && pairInfoCache[pairIndex].netPosition > 0.008) || (orderType == OP_SELL && pairInfoCache[pairIndex].netPosition < -0.008)) {
        return 0.75;
    }

    return 1;
}

double averageCandleMaxMinLength(string symbol, ENUM_TIMEFRAMES timeFrame, int count) {
   if( count ==0) return 0;
   
   double sum = 0;
   for(int i=0; i<count; ++i) {
      sum = iHigh(symbol, timeFrame, i) -  iLow(symbol, timeFrame, i) + sum;
   }
   
   return (sum/count);
}

double hammerness(string symbol, ENUM_TIMEFRAMES timeFrame, int shift) {

   double candleMovement = MathAbs(iClose(symbol, timeFrame, shift) - iOpen(symbol, timeFrame, shift));
   if(candleMovement == 0) candleMovement = 0.0001;   // put a minimum to avoid divide by zero
   
   double lowertail = MathMin(iOpen(symbol, timeFrame, shift), iClose(symbol,timeFrame,shift)) - iLow(symbol, timeFrame, shift) ;
   double uppertail =  iHigh(symbol, timeFrame, shift) - MathMax(iOpen(symbol, timeFrame, shift), iClose(symbol,timeFrame,shift)) ;
     
    //  Print("lowerTail:", lowertail, " UpperTail:", uppertail);
    double bullishness = (lowertail - uppertail) / candleMovement;
   
   double bullishnessFactor = bullishness > 5 ? 1: (bullishness < -5 ? -1 : 0); 
    
    return bullishnessFactor * dodginess(symbol,timeFrame, shift); 
  
}

double dodginess(string symbol, ENUM_TIMEFRAMES timeFrame, int shift) {
    double average100 = averageCandleMaxMinLength(symbol, timeFrame, 100);
   // Print("average100=",average100);
   if(average100 == 0) return 0;  //avoid divide by 0
   
   double relationalStrength = (iHigh(symbol,timeFrame,shift) - iLow(symbol,timeFrame,shift))/average100;
   // Print("relationalStrength:", relationalStrength);
   if(relationalStrength == 0) return 0;  //candle is very weak, or error,avoid divide by 0
   
   double averageVol =(double) (iVolume(symbol, timeFrame, shift +1) + iVolume( symbol, timeFrame, shift + 2) + iVolume( symbol, timeFrame, shift + 3) + iVolume( symbol, timeFrame, shift + 4))/4;
   // Print("averageVol:", averageVol);
    if(averageVol == 0) return 0;  //avoid divide by 0
    
    double relationalVolume =  iVolume( symbol, timeFrame, shift)/averageVol;
    // Print("Relational volume:", relationalVolume);
    
    double candleMovement = MathAbs(iClose(symbol, timeFrame, shift) - iOpen(symbol, timeFrame, shift));
    if(candleMovement == 0) candleMovement = 0.001;   // put a minimum to avoid divide by zero
    // Print("Candle movement:", candleMovement);
    double concentration = MathMin(5, MathAbs((relationalStrength * average100)/candleMovement));
    // Print("Concentration:", concentration);
    
    return concentration * MathPow(relationalVolume, 2) * MathPow(relationalStrength,2); 
}


double hammerHeuristic(int ticketNumber, string symbol, int orderType, bool tradeReservationEnabled, GroupIds tradeGroup) {

// Print(ticketNumber, "start hammer:");
   
    ENUM_TIMEFRAMES timeFrame = findStandardTimeFrameOf(TrailingInfo[tradeGroup][LifePeriod]);
   double effectiveHammerness = hammerness(symbol, timeFrame, 1);
   // Print("effectiveHammerness:", effectiveHammerness);
  
   if(effectiveHammerness > 6 ) {
      if(orderType == OP_SELL ) return 0.75;
      } 
   if(effectiveHammerness > -6 ) {
     return 1;
      } 
      
  if(orderType == OP_BUY) return 0.75;

   return 1; 
}

double dodgyHeuristic(int ticketNumber, string symbol, int orderType, bool tradeReservationEnabled, GroupIds tradeGroup) {

// Print("Start dodgy:");
   ENUM_TIMEFRAMES timeFrame = findStandardTimeFrameOf(TrailingInfo[tradeGroup][LifePeriod]);
   double effectiveDodginess = dodginess(symbol, timeFrame, 1) * candleSign(symbol,timeFrame, 2);
   // Print(" effective dodginess:", effectiveDodginess);

   if(effectiveDodginess > 6 && orderType == OP_SELL ) return 0.75;
   
   if(effectiveDodginess < -6 && orderType == OP_BUY ) return 0.75;
      
 return 1;
}


int candleSign(string symbol, ENUM_TIMEFRAMES timeFrame, int shift) {
return  iOpen(symbol, timeFrame, shift) - iClose(symbol, timeFrame, shift) > 0 ? 1 : -1;
}

int getMinutesOld(datetime creationTime) {
    int diff = (int)(TimeCurrent() - creationTime);
    return (int) diff / 60;
}


double getNetPosition(string symbol) {
    int preserveTicket = OrderTicket();
    double balance = 0;

    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol) {
                if (OrderType() == OP_BUY) balance = balance + OrderLots();
                if (OrderType() == OP_SELL) balance = balance - OrderLots();
            }
        }
    }

    bool bResult = OrderSelect(preserveTicket, SELECT_BY_TICKET, MODE_TRADES);
    return balance;
}


double getPriceOfHighest(int operation, string symbol) {
    int preserveTicket = OrderTicket();
    double price = 0;

    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol) {
                if (OrderType() == operation) price = MathMax(price, OrderOpenPrice());

            }
        }
    }

    bool bResult = OrderSelect(preserveTicket, SELECT_BY_TICKET, MODE_TRADES);
    return price;
}


double getPriceOfLowest(int operation, string symbol) {
    double price = 99990;
    int preserveTicket = OrderTicket();
    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol) {
                if (OrderType() == operation) price = MathMin(price, OrderOpenPrice());

            }
        }
    }

    bool bResult = OrderSelect(preserveTicket, SELECT_BY_TICKET, MODE_TRADES);
    return price;
}


bool isPanic(string symbol, ENUM_TIMEFRAMES timeframe, int panicPIPS) {
    double minPrice = MathMin(iLow(symbol, timeframe, 0), iLow(symbol, timeframe, 1));
    double maxPrice = MathMax(iHigh(symbol, timeframe, 0), iHigh(symbol, timeframe, 1));

    double span = maxPrice - minPrice;

    double symbolPoint = MarketInfo(symbol, MODE_POINT);
    if (symbolPoint <= 0) {
        Print("Cannot find point value for ", symbol);
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

int appendTradesIfAppropriate(string pairname, int pointsDistance, int spacing, int spikePIPs, double spikeTradeLots, double maxLots, double absMaxLots, int stopLoss, Groups group) {
    if (CreateBuysCondition(pairname, spikePIPs, maxLots, absMaxLots)) {
        Print("Creating spike buy-stops on ", pairname);
        appendBuyStops(pairname, pointsDistance, spacing, spikeTradeLots, stopLoss, group);
    }

    if (CreateSellsCondition(pairname, spikePIPs, maxLots, absMaxLots)) {
        Print("Creating spike sell-stops on ", pairname);
        appendSellStops(pairname, pointsDistance, spacing, spikeTradeLots, stopLoss, group);
    }

    return 0;
}


bool CreateBuysCondition(string pairname, int spikePIPs, double maxLots, double absMaxLots) {

    double pp = MarketInfo(pairname, MODE_POINT);
    double symbolAsk = MarketInfo(pairname, MODE_ASK);
    int pairIndex = getPairInfoIndex(pairname);

    if(pairIndex == -1) {
        Print("CreateBuysCondition: could not find index for ", pairname);
        return false;
    }

    if (pairInfoCache[pairIndex].unsafeNetPosition < maxLots && pairInfoCache[pairIndex].buyLots < absMaxLots) {
        if (getPriceOfLowest(OP_BUYSTOP, pairname) > (symbolAsk + spikePIPs * pp)) {
            return true;
        }
    }
    return false;
}


bool CreateSellsCondition(string pairname, int spikePIPs, double maxLots, double absMaxLots) {

    double pp = MarketInfo(pairname, MODE_POINT);
    double symbolBid = MarketInfo(pairname, MODE_BID);
    int pairIndex = getPairInfoIndex(pairname);

    if(pairIndex == -1) {
        Print("CreateBuysCondition: could not find index for ", pairname);
        return false;
    }

    if (pairInfoCache[pairIndex].unsafeNetPosition > (-1 * maxLots) && pairInfoCache[pairIndex].sellLots < absMaxLots) {
        if (getPriceOfHighest(OP_SELLSTOP, pairname) < (symbolBid - spikePIPs * pp)) {
            return true;
        }
    }

    return false;
}


double getUnsafeNetPosition(string symbol) {
    return getUnsafeBuys(symbol) - getUnsafeSells(symbol);
}

// returns sum  of lots of all buys which have no stop-loss yet

double getUnsafeBuys(string symbol) {
    double balance = 0;
    int preserveTicket = OrderTicket();
    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol) {
                if (OrderType() == OP_BUY && (OrderStopLoss() < OrderOpenPrice())) {
                    balance = balance + OrderLots();
                }
            }

        }
    }

    bool bResult = OrderSelect(preserveTicket, SELECT_BY_TICKET, MODE_TRADES);
    return balance;
}

double getUnsafeSells(string symbol) {
    double balance = 0;
    int preserveTicket = OrderTicket();
    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol) {
                if (OrderType() == OP_SELL && (OrderStopLoss() > OrderOpenPrice() || OrderStopLoss() == 0)) {
                    balance = balance + OrderLots();
                }
            }
        }
    }

    bool bResult = OrderSelect(preserveTicket, SELECT_BY_TICKET, MODE_TRADES);
    return balance;
}

double getVolBallance(string symbol, int orderType = OP_SELL) {
    double balance = 0;
    int preserveTicket = OrderTicket();
    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol) {
                if (OrderType() == orderType) balance = balance + OrderLots();
            }
        }
    }

    bool bResult = OrderSelect(preserveTicket, SELECT_BY_TICKET, MODE_TRADES);
    return balance;
}


int appendBuyStops(string pairName, int distance, int spacing, double lots, int stoploss, Groups grp) {
    double symbolAsk = MarketInfo(pairName, MODE_ASK);
    Groups g = UltraLongTerm;

    for (int i = 0; i < 8; i++, g += UltraLongTerm) {
        createBuyStop(pairName, symbolAsk, i, 2 * distance, stoploss, 0, MathMax(g, grp), distance, lots, 100, 0, spacing);
        createBuyStop(pairName, symbolAsk, i + 8, 2 * distance, stoploss, 0, MathMax(g, grp), distance, lots, 100, 0, spacing);
    }

    return 0;
}



int appendSellStops(string pairName, int distance, int spacing, double lots, int stoploss, Groups grp) {
    double symbolBid = MarketInfo(pairName, MODE_BID);
    Groups g = UltraLongTerm;

    for (int i = 0; i < 8; i++, g += UltraLongTerm) {
        createSellStop(pairName, symbolBid, i, 2 * distance, stoploss, 0, MathMax(g, grp), distance, lots, 100, 0, spacing);
        createSellStop(pairName, symbolBid, i+ 8, 2 * distance, stoploss, 0, MathMax(g, grp), distance, lots, 100, 0, spacing);
    }

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
    double symbolAsk = MarketInfo(symbol, MODE_ASK);
    double baseprice = startingPrice == 0.0 ? symbolAsk : startingPrice;
    double pip = MarketInfo(symbol, MODE_POINT);
    double price = baseprice + (distance * index + PIPsToStart) * pip;
    double stopLoss = StopLossBuys != 0 ? price - StopLossBuys * pip : 0;
    double takeProfit = TakeProfitBuys != 0 ? price + TakeProfitBuys * pip : 0;


    bool spaceAvailable = false;
    spaceAvailable = clearSpaceForPosition(price, OP_BUYSTOP, spacing, symbol);


    if (!spaceAvailable) {
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
        Print("Order ", index, " creation failed for BuyStop at:", price, "on ", symbol);
    } else {
        if (OrderSelect(result, SELECT_BY_TICKET))
            Print("BuyStop ", index, " created at ", price, " with ticket ", OrderTicket(), " Group ", getGroupName(OrderMagicNumber()), " on ", symbol);
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
    double symbolBid = MarketInfo(symbol, MODE_BID);
    double pip = MarketInfo(symbol, MODE_POINT);
    double baseprice = startingPrice == 0.0 ? symbolBid : startingPrice;
    double price = baseprice - (distance * index + PIPsToStart) * pip;
    double stopLoss = StopLossSells != 0 ? price + StopLossSells * pip : 0;
    double takeProfit = TakeProfitSells != 0 ? price - TakeProfitSells * pip : 0;


    bool spaceAvailable = false;

    spaceAvailable = clearSpaceForPosition(price, OP_SELLSTOP, spacing, symbol);


    if (!spaceAvailable) {
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
        Print("Order ", index, " creation failed for SellStop at:", price, " on ", symbol);
    } else {
        if (OrderSelect(result, SELECT_BY_TICKET))
            Print("SellStop ", index, " created at ", price, " with ticket ", OrderTicket(), " Group ", getGroupName(OrderMagicNumber()), " on ", symbol);
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

double calcHuristics(int ticketNumber
                              , string symbol
                              , int ordertype
                              , int magicNumber
                              , datetime openTime
                              , double openPrice
                              , bool arvHeuristic
                              , bool unsafeNetPositionsHeuristic
                              , bool netPositionsHeuristic
                              , bool hammerHeuriticEnabled
                              , bool dodgyHeuristicEnabled
                              , bool priceOverTimeHeuristic                            
                              , bool opositeLoosingTrades
                              , bool panic) {
    double arvHeuVal = 1.0;
    double unsafeNetPosHeuVal = 1.0;
    double netPosHeuVal = 1.0;
    double timeHeuVal = 1.0;
    double hammerHeuVal = 1.0;
    double dodgyHeuVal = 1.0;
    double priceTimeHeuVal = 1.0;

    GroupIds grpId = calculateGroupId(ticketNumber, magicNumber, opositeLoosingTrades, symbol);

    int lifetime = TrailingInfo[grpId][LifePeriod];

    if (arvHeuristic) arvHeuVal = getARVHuristic(symbol, lifetime);
    if (unsafeNetPositionsHeuristic) unsafeNetPosHeuVal = unsafeBalanceHeuristic(ticketNumber,symbol, ordertype, opositeLoosingTrades);
    if (netPositionsHeuristic) netPosHeuVal = balanceHeuristic(ticketNumber,symbol, ordertype, opositeLoosingTrades);
    if (hammerHeuriticEnabled) hammerHeuVal = hammerHeuristic(ticketNumber,symbol, ordertype, opositeLoosingTrades, grpId);
    if (dodgyHeuristicEnabled) dodgyHeuVal = dodgyHeuristic(ticketNumber,symbol, ordertype, opositeLoosingTrades, grpId);
    if(priceOverTimeHeuristic && !panic) priceTimeHeuVal = priceTimeHeuristic(ticketNumber, openTime,grpId,openPrice,symbol);
    timeHeuVal = lifeTimeHeuristic(openTime, grpId);
    if(beVerbose) {
    Print(ticketNumber, ": timeHeu:", timeHeuVal, " unsafeNetPosHeuVal:", unsafeNetPosHeuVal, " netPoseHeuVal:", netPosHeuVal);
    Print(ticketNumber, ": ARVHeu:", arvHeuVal, " HammerVal:", hammerHeuVal, " DodgyVal:", dodgyHeuVal, " PriceOverTimeHeu:", priceTimeHeuVal);
    }
    return timeHeuVal * arvHeuVal * unsafeNetPosHeuVal * netPosHeuVal * priceTimeHeuVal * hammerHeuVal * dodgyHeuVal;
}


bool isReservedTrade(int tradeTicket, string symbol) {
    int index = getPairInfoIndex(symbol);
    if(index== -1) return false;

    bool result = (isInArray(tradeTicket, pairInfoCache[index].reservedOpositeBuys, pairInfoCache[index].reservedBuysCount) 
    || isInArray(tradeTicket, pairInfoCache[index].reservedOpositeSells, pairInfoCache[index].reservedSellsCount));

    return result;
}


int inReservedTrades(int tradeTicket, string symbol) {
    int index = getPairInfoIndex(symbol);
    if(index== -1) return false;

   int buyIndex = inArray(tradeTicket, pairInfoCache[index].reservedOpositeBuys, pairInfoCache[index].reservedBuysCount);
   if(buyIndex != -1) return buyIndex;
   
   return inArray(tradeTicket, pairInfoCache[index].reservedOpositeSells, pairInfoCache[index].reservedSellsCount);
}

bool isInArray(int ticketTofind, int & ticketArray[], int arrayCount) {
    for (int i = 0; i < arrayCount; ++i)
        if (ticketArray[i] == ticketTofind) return true;
    return false;
}

int inArray(int ticketTofind, int & ticketArray[], int arrayCount) {
    for (int i = 0; i < arrayCount; ++i)
        if (ticketArray[i] == ticketTofind) return i;
    return -1;
}

GroupIds calculateGroupId(int tradeTicket, int magicNumber, bool opositeReserveEnabled = true, string symbol="") {
   GroupIds realGroup=getGroupId(magicNumber);

    if (opositeReserveEnabled && isReservedTrade(tradeTicket, symbol) && realGroup >= gid_UltraLongTerm) {
    if(beVerbose) Print(tradeTicket, " is reserved, real group is ",realGroup," calculated group is UltraLongTerm");
    
    return gid_UltraLongTerm;
    }
    
    return realGroup;
}
//+------------------------------------------------------------------+
//|This function trails the position which is selected.                        |
//+------------------------------------------------------------------+
void trailPosition(int orderTicket,
    bool continueLifeTimeAfterFirstSL,
    ENUM_TIMEFRAMES panicTimeFrame,
    int panicPIPS,
    bool arvHeuristic,
    bool unsafeNetPositionsHeuristic,
    bool netPositionsHeuristic,
    bool hammerCandleHeuristic,
    bool dodgycandleHeuristic,
    bool priceOverTimeHeuristic,
    bool opositeLoosingTrades) {
    double pBid, pAsk, pp, pDiff, pRef, pStep, pRetraceTrail, pDirectTrail;

    if (!OrderSelect(orderTicket, SELECT_BY_TICKET, MODE_TRADES)) {
        Print("could not access order ", orderTicket, " in trailPosition function");
        return;
    }

    GroupIds tradeGroupId = calculateGroupId(orderTicket, OrderMagicNumber(), opositeLoosingTrades, OrderSymbol());

    bool panic = isPanic(OrderSymbol(), panicTimeFrame, panicPIPS);

    double heuristics = calcHuristics(orderTicket
                                                      , OrderSymbol()
                                                      , OrderType()
                                                      , OrderMagicNumber()
                                                      ,OrderOpenTime()
                                                      ,OrderOpenPrice()
                                                      , arvHeuristic
                                                      , unsafeNetPositionsHeuristic
                                                      , netPositionsHeuristic
                                                      , hammerCandleHeuristic
                                                      , dodgycandleHeuristic
                                                      , priceOverTimeHeuristic
                                                      , opositeLoosingTrades
                                                      ,panic);

    double RetraceValue = getCurrentRetrace(orderTicket, tradeGroupId, continueLifeTimeAfterFirstSL, panic, heuristics, OrderSymbol(), OrderStopLoss());
    int TrailingStop = getCurrentTrailingStop(orderTicket, tradeGroupId, continueLifeTimeAfterFirstSL, panic, heuristics,OrderSymbol(), OrderStopLoss());
      if(beVerbose) Print("trailPosition:", orderTicket,": retrace:",RetraceValue, " trailing: ",TrailingStop);
   
    pp = MarketInfo(OrderSymbol(), MODE_POINT);
    pDirectTrail = TrailingStop * pp;
    pStep = TrailingInfo[tradeGroupId][Step] * pp;

    if (OrderType() == OP_BUY) {
        pBid = MarketInfo(OrderSymbol(), MODE_BID);
        pDiff = pBid - OrderOpenPrice();
        pRetraceTrail = pDiff > pDirectTrail ? (pDiff - pDirectTrail) * RetraceValue : 0;
        if (beVerbose) Print(OrderTicket(), " RetraceTrail value is: ", pRetraceTrail);
        pRef = pBid - pDirectTrail - pRetraceTrail;
        if (beVerbose) Print(OrderTicket(), " Ref value is: ", pRef);

        if (pRef - OrderOpenPrice() > 0) { // order is in profit.
            if ((OrderStopLoss() != 0.0 && pRef - OrderStopLoss() > pStep && pRef - OrderOpenPrice() > pStep) || (OrderStopLoss() == 0.0 && pRef - OrderOpenPrice() > pStep)) {
                ModifyStopLoss(pRef);
                return;
            }
        }
    }

    if (OrderType() == OP_SELL) {
        pAsk = MarketInfo(OrderSymbol(), MODE_ASK);
        pDiff = OrderOpenPrice() - pAsk;
        pRetraceTrail = pDiff > pDirectTrail ? (pDiff - pDirectTrail) * RetraceValue : 0;
        pRef = pAsk + pDirectTrail + pRetraceTrail;

        if (OrderOpenPrice() - pRef > 0) { // order is in profit.
            if ((OrderStopLoss() != 0.0 && OrderStopLoss() - pRef > pStep && OrderOpenPrice() - pRef > pStep) || (OrderStopLoss() == 0.0 && OrderOpenPrice() - pRef > pStep)) {
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
void ModifyStopLoss(double ldStopLoss) {
    bool bResult;
    bResult = OrderModify(OrderTicket(), OrderOpenPrice(), ldStopLoss, OrderTakeProfit(), 0, CLR_NONE);

    if (bResult) {
        Print("Order ", OrderTicket(), " modified to Stoploss=", ldStopLoss, " group:", getGroupName(OrderMagicNumber()));
    } else {
        Print("could not modify order:", OrderTicket(), " group:", getGroupName(OrderMagicNumber()));
    }
}
//+------------------------------------------------------------------+
