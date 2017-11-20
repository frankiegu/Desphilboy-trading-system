
Desphilic trading system (method) is a defensive trading system to protect you from loss. It is intended to be used on an MetaTrader4/5 (MT4) or MT5 terminal. The Desphilic system is comprised of 2 main expert advisors (EA)s which are following the Desphilic trading strategy:

#A- EAs and Strategies

1- 	grouped-Iman-Trailing.mq4 is a trade protecting EA implementins a special kind of trailing stop. it creates/moves stoploss line for a trade once it goes into certain amount of profit.

2-  A Position creator (can be any of included position creators in this repo) that creates buystops and sellstops for you and marks them as belonging to Desphilic-trading-system and assigns them to one of the five defined groups .

3-  the trading strategy which is compliant with defensive trading (Desphilic strategy) and is based on market  movement. Desphilic stratege does not predict or decide the market but it waits for the market move and goes along it.



#A- System components and their usage:
System main 3 parts should be used as follows:

##1- A trailing stop (protecting) Expert Advisor (EA)
This EA should be running in a MetaTrader4/5 terminal on a computer which is always up and running with a very low latency (short ping time) to the trade server. Usually this computer is a VPS (Virtual Private Server ) or it can be a dedicated server. To have a shorter communication delay the machine should be located geographically close to your broker's trade servers. A lot of brokers have their servers hosted in New York and some of them have servers close to London, still some of them have servers elsewhere. No matter where your brokers system resides, the best place for your EA-server maching is the closest you can get to your broker's server with a reasonable price. The EA source code can be retrieved from the system git repository at address:

https://github.com/desphilboy/Desphilboy-trading-system

the	grouped-Iman-Trailing.mq4 is the source code for this expert advisor which is a customized trailling stop acting on your trades (in case trade is in profit) and creates stop-loss for positions or moves existing stop losses so that the trade will close before it goes back into loss. When a trade is in profit, this EA will move the stop-loss for your trade and maximizes the benefit according to the settings you have provided when starting it and based on position belonging to one of the five groups (VeryLong, LongTerm, MediumTerm, ShortTerm, VeryShort).
this EA must be up and running all the times 24/7 to protect your trades. Please note that this EA will not act on trades which do not belong to any of 5 groups. To create a position belonging to one of those four groups, you need to create it with Position Creator experts in this system ( any of EAs with the name of Position creator like AdHocPositionCreator or PositionCreator).


##2- A Position Creator (Buy-stop and Sell-stop creator EA)
This EA runs on MetaTrader4/5 on you own laptop or computer. you can run this on a normal computer and it does not need to be permanently on and it can be safely exited after you are done with trade creation. This EA is the "DAPositionCreator.mq4" or "PositionCreator.mq4" or "AdHoc..." in repository of the system. These EAs can mass-create trades for you with predefined stop-loss and take-profit and LOT volume, in your predefined price range and belongin to the groups you specify. These EAs will communicate all these info to the server, using the trade-magic-number (Magic number is a trade attribute in Mt4 systems) and your server will know and recognize the trades and will know their designated groups and acts on them as desired and configured for each group. Some of these PositionCreator EAs can also paint your trades with colours so that you know which one belongs to which group when you look at your terminal.


##3- Desphilic strategy
The trading strategy itself is a main part of this system which is giving sense to EAs. In Desphilic trading system, no stop-loss or take-profit is expected for a trade (but still you can have them if you like). In addition there always are pending orders buy-stops and sell stops on the chart which are positioned according to trader's decision. The trader can use any number of buy-stops or sell-stops anywhere on the chart according to his prediction about price movement. Buy stops normally start form about 20 PIPS above the current price and sell stops start from about 20 PIPS below the current price in the chart.
The Theory behind this is: if price moves up, it will hit your buy stops one after other and you will profit. if it moves down, it will hit your sell stops 1 after another and again you will profit. This obviously this does not mean that you will always win with this strategy, as told before, the whole system is a defensive protective system to prevent big looses. maximizing the profit is still on trader's shoulders and depends on how you position your Buystops/Sellstops and how good you predict the market moves.
see section D for more info.


#B- System mechanism of work:

## Formula of stop,step and retrace
Heart of this system is a coeficiented trailing stop. this algorithm uses 3 parameters to define its behaviour on a trade:

1- the coeficient (C):

C is normally one of fibonacci retrace ratios(i. e. maxRetrace = 0.618, halfRetrace = 0.5, lowRetrace = 0.382 and minRetrace = 23.6, noRetrace = 0).

2-Step (S):

S is the number of PIPs you must be in benefit before system considers to do any action. differences less than S will be ignored as they are regarded being by accident or to low to consider.

3-constant Trailing (T):

T is the number of PIPs you want your stop-loss to be behind the price when system acts on a trade.

the algorithm calculates price ref using this formula:

priceDifference = current price - positionOpenPrice

Ref = priceDifference - T - (priceDifference - T) * C

and if Ref - S > currentStopLoss then changes the stop loss to be equal to Ref.

in addition, you can specify 4 values for S,T,C and assign each set of (S,T,C) to one of the 4 groups (LongTerm, MedTerm, ShortTerm, VeryShort) and then create a trade in one of those groups. the system will apply your defined group values to the trades belonging to that group.

example: (PIPs are small pip in this system which is 0.1 of a real PIP)

you can set  short term S=50, T=200, C= 0.382  and Long term S=70, T=500, C= 0.618 then you can create 2 trades and put one of them in short term and the other one in long term group. then the trade which is in long term will be applied a trailing stop with 50 PIPS trailing and 7 PIPs step and 0.618 retrace factor while the trade you have created as short term will be applied a trailing stop of 20,5, 0.382 .

##- time based calculations
If enable time-based trailing, once your trade is open, the system will monitor the trade and will lower the parameters (stop, step, retrace) by the amount of time elapsed from order-opening-moment. There is a lifetime defined for each of 5 groups and the parameters will be divided by number-of-life-times-elapsed. If a trade position is a short-term-group trade and life-time for short-term-group (let's say) is 2 hours, then the trailing stop value applied to that trade will be:

effective-trailing-stop = initial-trailing-stop * life-time / time-elapsed;

as per this example in first 2 hours the effective trailing stop will become half, and in second 2 hours it gets one-third of the original value.
if time feature is disabled, parameters will always be used as configured without change.

##- panic conditions
Panic condition happens if there is a very sharp move in the price (for example more than 150 PIPs in 2 minutes). in this case, if PanicProtection is enabled, panic values will apply to trades until the panic conditions are dissmissed. Panic parameters are normally small stop, step and retrace values. If Panic protection is disabled, trades will be treated as usual

## Active trading and spike trading

A spike is a very quick price move in a very short time( the same as a panic condition). If spike trading is enabled, EA will attempt creating new positions ( buys and sell stops). If spike trading is enable, new positions will be crated in case of spikes happening. If active trading is enabled new positions will be created automatically even in normal conditions ( as per definde by use)


#C- How to run this system:

##1- you need to hire a VPS or dedicated server.

I do not recommend any VPS provider here because do not want to  bias toward any business. you can find hundreds of VPS and dedicated server providers by simply searching (googling) it. (if you still need recommended provider private message me using "Desphilboy@yahoo.com").
A good VPS will have a small ping time ( probably less than 10 milli seconds ) to your trading server and will have a good stability and enough CPU, Memory and Hard-Disk space to run your MetaTrader4 without problem. Personally I recommend Linux OS + wine, but how you run your server is totaly up to you. You will need to remotely access the server using VNC or RemoteDesktop and for this, you need a good internet connection as well ( recommend speed at least 2Mbits/S) but you will not need to connect to server frequently. After you run yor server once and execute grouped-Iman-trailing EA on your account on server, you will not need to connect to server anymore unless you want to change your server setup or your trade group S,C or T values.


##2- Tasks to do on your VPS

after you get access to your VPS, install a MT4 on it (one terminal per trading account) and login to your trade account and run "grouped-Iman-Trailing.mq4" on one of the charts. this will manage all your trades and you do not need to repeat this on every chart. To run the EA you will need to copy the source file in the experts directory and  compile it. for How to do that there is a good help page form metaqoutes but briefly you need to copy that file into the expert directory which is normally "C:\\Program files (x86)\\MetaTrader4\\MQL4\Experts" on windows or "~/.wine/drive_c/Program files (x86)/MetaTrader4/MQL4/Experts" on Linux.
for successfuly compiling EAs you will need "desphilboy.mqh" file in the same directory.
then you will need to run MQL4 editor and press compile which is available from Mt4 menue. After successful compilation you will see the EA available in the navigator (do a refresh if not) and then drag-drop it on your chart and it will attach itself to the trading chart and will bring up the parameters window which you can use it to change the EA parameters like S,C and T for different groups. you can now disconnect from the VPS and we are done with it unless you want to change gruop parameters.

NOTE 1: do not shutdown or suspend or logout the VPS, just close your own client window. VPS and the terminal with EA must keep running.

NOTE 2: your auto-trading must be enabled both in main switch and in EA parameters dialog.
("AutoTrading main switch" is a button on Mt4 tool pane which is initially red dot and changes to green triangle when enabled and for our purpose it must be always green. meanwhile there is a tick box in EA properties dialog for enabling auto trading and it must be ticked)

NOTE3: do not run it straight away on your real money account. instead try it first on a demo account and get familiar with the system at no expense.

NOTE4: A PIP value in all EAs in this system is a point value which is 0.1 PIP also called a small PIP. (this means you must put 10 for 1 PIP and 50 in our numbers means 5 real PIPs)


##3- On your own computer
now open your normal trading Mt4 terminal on your own computer. repeat the steps for compilation of EA for PositionCreator on you own computer. Open a chart and add "PositionCreator" EA to  your chart and create some trades.
to do so,  again your auto trading must be enabled and also there is a switch in EA parameters named "creat positions" which must be true.
If your setup is all correct, you will see system acting on your trades when price goes up and down. there will be a stop-loss created for your trades when they go into profit more than the T+S value specified  for their group. this trailing stop will protect your trades from going back into loss.

NOTE: you must always have either stop loss for a trade or must have oposit pending trades (have buyStops to protect Sells and Sellstop and have  Sellstop to protect buys or buyStops) to manage the risk.

NOTE: this system does not replace money management rules or technical analysis or trader's knowledge, they are still valuable and necessary for a successful trade.

NOTE: System will not react on trades created manually or using any other trading system. it acts *only* on its own creatd trades.

DISCLAIMER: this is not a sold or for profit system,I will not and nobody have the right to ask you any amount of money for using this system. Also the system comes as it is and there will be no compensation on the money you loose on or interpreted to be lost because of this system. If you use this system, it is at your own risk and be aware that Trading Forex involves massive risk on your investment and you must understand exactly what you are doing. this system does not help novice traders or traders lacking knowledge about trading forex and/or other markets.


#D- Desphiic (Desphilboy) Method:

The theory behind Desphilic trading system is assumption of market dominant players who try to move market according to their own benefit and at the expense of others loosing. As a romantic story:

A 60 years old Iranian merchant Haji Bazari named "Haji Bazrafshan" is the Forex market dominant player. Haji Bazrafshan is a very rich man, theoretically with no financial limits. He always overloads market with massive demand pressure (buy pressure) or massive supply pressure (sell pressure) to make fake market waves and move the price in such a way that makes small participants loose their money. This is why 90% of traders are loosing all the time. We never judge Haji Bazrafshan and we do not really know why/when/How he will do these moves. Sometimes it is possible to anticipate Haji's next move from his previouse behaviour and from market info and sometimes it is not. Because of this, you need to protect yourself against so called "market opposite movements" or the evilish movements of Haji. Opposite movement is the move which is almost always exactly in reverse direction of all news and sentiments,fundamental and technical analysis and rules. These moves normally continue until you either get a margin call or convinced that whatever you were thinking was incorrect or you do not understand anything correctly about the forex market and the truth is exactly opposite of your current understanding and therefore you close your positions in loss. Then suddenly, Haji changes market direction to whatever you were thinking before and was actually correct.
This movement is actually an existing reality and is caused by major participants pushing price in reverse direction until they hit a large number of stop-losses which is the sign of other traders loosing their money. They change market direction after that to the correct direction which is what you had thought and analytics had anticipated and news were confirming.

Desphilic method starts by putting number of buy stops and sell stops with some distance from the price, lets say we put 5 sell stops starting 10 pips below the current price and leave 20 pips between each or them and have 5 buy stop starting 10 pips above the current price and 20 pips between them.
( for example if current price of AUDUSD is 0.7, then sellstops at { 0.699, 0.697,0.695,0.693,0.691 } and buyStops at {0.701,0.703,0.705,0.7070,0.709})

Because we are going to protect ourselves against opposite movements, we will always keep stops ( BuyStop or SellStop ) in reverse direction. actually we will always have both buy stops and sell stops. our buy stops always start some pips above the current price and sell stops some pips below the price.
If price goes up, it will hit our buy stops and converts them into long (buy) positions and we gain profit, if price goes down, it will hit our sellStops into short (Sell) positions and we will profit again. actually our buy/sell stops act as stop-loss for each-other.
if price reverses at a sell, that sell goes into loss, we put another sell stop a few pips below it and leave it. price cannot make other loosing sell for us unless passing and  giving profit to the one which is reversed at.
if price reverses at a buy, that buy goes into loss, we put another buy stop a few pips above it an leave it. market cannot make another loosing buy for us, unless giving benefit to the one which is currently in loss.

if we have 2 or more winning buys or sells, we will then put a stop-loss in benefit area  for all of them but the last one. this means if the price suddenly reverses the movement, it will close all trades in benefit except the last one.

you can be bullish or bearish by changing the distance between your positions or putting different stop-loss/take-profits for them. or closing your positions when you think they are in maximum benefit.

the only recomendation is this: "Always keep some buy stops and some sell stops"

with desphilic method it is still possible to loose money but the only way to loose big money is when the market crashes or there is a very fast movement so that slippage goes high and becomes more and more and  your broker cannot buy or sell for you, or you are away and nobody is taking care of your trading account.

to minimize these possibilities we have written or system of expert advisors and we use a VPS to monitor our trades 24/7/365 and also have a better delay.

the big-loose risk can go down to 0% by using a proper money-management rule and general risk management as before. actually you can still use all methods which are recommended by professionals or experienced traders and still a good trader can perform much different from a bad trader. this method does not replace trading knowledge and will not help a dizzy or lazy man to win. you will still need everything which you need as a normal trader. the only benefit of this method is to lower the risk and protect you against valotile market and big looses due to spikes and sudden market collapses ONLY WHEN IT IS POSSIBLE.

A set of forex trading instructions and Expert Advisors for MT4

1- Our trading infra structure:

A- Machine No.1 the "trading machine"

We use a Linux server ( fedora 23 is recommended ) as our trading machine which is supposed to be located on a data center close to the market or broker servers. There are lots of companies and businesses around who provide you with a proper service of this type and you can get various types and levels of these services with diferent fees. you can find these services by simply googling the keywords "VPS in new york city", "hire cloud servers", "servers suitable for trade" or similar keywords. When hiring these services have in mind that the most important factors of a server for trading purposes are its network-delay to your brokers server and its stability (it must have less than 10ms delay and must be 24/7 always online and connected to network). You should be able to hire a server with less than 10ms ping-time delay to your brokers server by something less than 50$ per month. If price or ping time differ very much from this, you are probably on a wrong track.

B- Machines No.2 and 3,4 ... so on

These machines are normal clients probably laptops, Desktops, Mobile phones or any other kind of device capable of running a MT4 client. we recommend Fedora on a laptop for the client( FAQ: will I be able to use fedora for normal daily computing usage? YES! You can). this machine might run any OS , but we recommend linux and we put instructions for linux. If you are using windows that is ok, but your commands and settings may differ a little bit.

