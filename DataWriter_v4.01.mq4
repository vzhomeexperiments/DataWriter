//+------------------------------------------------------------------+
//|                                                   DataWriter.mq4 |
//|                                 Copyright 2018, Vladimir Zhbanko |
//+------------------------------------------------------------------+
#include <06_NormalizeDouble.mqh>

#property copyright "Copyright 2018, Vladimir Zhbanko"
#property link      "https://vladdsm.github.io/myblog_attempt/"
#property version   "4.01"
#property strict

/*
PURPOSE: Retrieve price and Indicator data for an asset 
USE: Data will be used for Decision Support System in R
WANT TO LEARN HOW TO USE?

https://www.udemy.com/your-home-trading-environment/?couponCode=LAZYTRADE-GIT
https://www.udemy.com/your-trading-robot/?couponCode=LAZYTRADE-GIT

*/


extern string  Header1 = "-----EA Main Settings-------";
extern int     UseBarsHistory        = 7300;
extern int     UseBarsCollect        = 7200;    
extern int     chartPeriod           = 15;


string FileNamePrx1 = "AI_CP";
string FileNamePrx2 = "AI_OP";
string FileNamePrx3 = "AI_LP";
string FileNamePrx4 = "AI_HP";
string FileNameRsi1 = "AI_RSI";
string FileNameBull = "AI_BullPow";
string FileNameBear = "AI_BearPow";
string FileNameAtr1 = "AI_Atr8";
string FileNameMacd = "AI_Macd";

/*
Content:
1. Function writeDataPow         collect Power Data         Line 106
2. Function writeDataCP          collect Close Price data   Line 189
3. Function writeDataOP          collect Open Price data
4. Function writeDataLP          collect Low Price data
5. Function writeDataHP          collect High Price data
6. Function writeDataRSI         collect Rsi data
7. Function writeDataBullPow     collect BullPower data
8. Function writeDataBearPow     collect BearPower data
9. Function writeDataAtr         collect Atr data
10.Function writeDataMacd        collect MACD data 
*/
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
      return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   
   // should generate unique time every minute https://www.mql5.com/en/forum/133366
   
      static datetime Time0;
   if(Time0 == Time[0])
     {
      
     }
     else
       {
      //  record time to variable
      Time0 = Time[0];
      //code that only executed once
       //record closed price data
      writeDataCP(FileNamePrx1 + string(chartPeriod) + ".csv", chartPeriod, UseBarsCollect);
      //record open price data
      //writeDataOP(FileNamePrx2 + string(chartPeriod) + ".csv", chartPeriod, UseBarsCollect);
      //record high price data
      //writeDataHP(FileNamePrx3 + string(chartPeriod) + ".csv", chartPeriod, UseBarsCollect);
      //record low price data
      //writeDataLP(FileNamePrx4 + string(chartPeriod) + ".csv", chartPeriod, UseBarsCollect);
      //record rsi indicator data
      //writeDataRSI(FileNameRsi1 + string(chartPeriod) + ".csv", chartPeriod, UseBarsCollect);
      //record bull power data
      //writeDataBullPow(FileNameBull + string(chartPeriod) + ".csv", chartPeriod, UseBarsCollect);
      //record bear power data
      //writeDataBearPow(FileNameBear + string(chartPeriod) + ".csv", chartPeriod, UseBarsCollect);
      //record atr data
      //writeDataAtr(FileNameAtr1 + string(chartPeriod) + ".csv", chartPeriod, UseBarsCollect);   
      //record macd data
      writeDataMacd(FileNameMacd + string(chartPeriod) + ".csv", chartPeriod, UseBarsCollect);   
      }
      
  }
//+------------------------------------------------------------------+


        
void writeDataCP(string filename, int charPer, int barsCollect)
// function to record 28 currencies pairs close price to the file (file to be used by all R scripts)
 {

/*
Pairs = c("EURUSD", "GBPUSD", "AUDUSD", "NZDUSD", "USDCAD", "USDCHF", "USDJPY",
                     "EURGBP", "EURJPY", "EURCHF", "EURNZD", "EURCAD", "EURAUD", "GBPAUD",
                     "GBPCAD", "GBPCHF", "GBPJPY", "GBPNZD", "AUDCAD", "AUDCHF", "AUDJPY",
                     "AUDNZD", "CADJPY", "CHFJPY", "NZDJPY", "NZDCAD", "NZDCHF", "CADCHF")   
*/

//---- 28 currencies
double eurusd, gbpusd, audusd, nzdusd, usdcad, usdchf;
double eurgbp, eurjpy, eurchf, eurnzd, eurcad, euraud;
double audchf, audjpy, audnzd, cadchf, cadjpy, chfjpy;
double gbpaud, gbpcad, gbpchf, gbpjpy, gbpnzd, nzdcad;
double nzdchf, audcad, usdjpy, nzdjpy;
             
string data;    //identifier that will be used to collect data string
datetime TIME;  //Time index
               // delete file if it's exist
               FileDelete(filename);
               // open file handle
               int handle = FileOpen(filename,FILE_CSV|FILE_READ|FILE_WRITE);
                FileSeek(handle,0,SEEK_SET);
               // generate data now using for loop
               //----Fill the arrays
         
               //loop j calculates surfaces and angles from beginning of the day
               for(int j = 0; j < barsCollect; j++)    //j scrolls through bars of the day
                 {
                     TIME = iTime(Symbol(), chartPeriod, j);  //Time of the bar of the applied chart symbol
                     //--- calculating close price for every currency
                     eurusd = iClose("EURUSD",chartPeriod,j);
                     gbpusd = iClose("GBPUSD",chartPeriod,j);
                     audusd = iClose("AUDUSD",chartPeriod,j);
                     nzdusd = iClose("NZDUSD",chartPeriod,j);
                     
                     usdcad = iClose("USDCAD",chartPeriod,j);
                     usdchf = iClose("USDCHF",chartPeriod,j);
                     usdjpy = iClose("USDJPY",chartPeriod,j);
                     eurgbp = iClose("EURGBP",chartPeriod,j);
                     
                     eurjpy = iClose("EURJPY",chartPeriod,j);
                     eurchf = iClose("EURCHF",chartPeriod,j);
                     eurnzd = iClose("EURNZD",chartPeriod,j);
                     eurcad = iClose("EURCAD",chartPeriod,j);
                     
                     euraud = iClose("EURAUD",chartPeriod,j);      
                     gbpaud = iClose("GBPAUD",chartPeriod,j);
                     gbpcad = iClose("GBPCAD",chartPeriod,j);
                     gbpchf = iClose("GBPCHF",chartPeriod,j);
                     
                     gbpjpy = iClose("GBPJPY",chartPeriod,j);
                     gbpnzd = iClose("GBPNZD",chartPeriod,j);
                     audcad = iClose("AUDCAD",chartPeriod,j);
                     audchf = iClose("AUDCHF",chartPeriod,j);
                     
                     audjpy = iClose("AUDJPY",chartPeriod,j);
                     audnzd = iClose("AUDNZD",chartPeriod,j);
                     cadjpy = iClose("CADJPY",chartPeriod,j);
                     chfjpy = iClose("CHFJPY",chartPeriod,j);
                     
                     nzdjpy = iClose("NZDJPY",chartPeriod,j);
                     nzdcad = iClose("NZDCAD",chartPeriod,j);
                     nzdchf = iClose("NZDCHF",chartPeriod,j);
                     cadchf = iClose("CADCHF",chartPeriod,j);
                     
                     
                     data = string(TIME)+","+string(eurusd)+"," + string(gbpusd) + "," +string(audusd)+ "," +string(nzdusd)+ ","
                                            +string(usdcad)+"," + string(usdchf) + "," +string(usdjpy)+ "," +string(eurgbp)+ ","
                                            +string(eurjpy)+"," + string(eurchf) + "," +string(eurnzd)+ "," +string(eurcad)+ ","
                                            +string(euraud)+"," + string(gbpaud) + "," +string(gbpcad)+ "," +string(gbpchf)+ ","
                                            +string(gbpjpy)+"," + string(gbpnzd) + "," +string(audcad)+ "," +string(audchf)+ ","
                                            +string(audjpy)+"," + string(audnzd) + "," +string(cadjpy)+ "," +string(chfjpy)+ ","
                                            +string(nzdjpy)+"," + string(nzdcad) + "," +string(nzdchf)+ "," +string(cadchf);
                  FileWrite(handle,data);   //write data to the file during each for loop iteration
                     
                 }
               
               //             
                FileClose(handle);        //close file when data write is over
               //---------------------------------------------------------------------------------------------
         
  }

void writeDataOP(string filename, int charPer, int barsCollect)
// function to record 28 currencies pairs open bar price to the file (file to be used by all R scripts)
 {

/*
Pairs = c("EURUSD", "GBPUSD", "AUDUSD", "NZDUSD", "USDCAD", "USDCHF", "USDJPY",
                     "EURGBP", "EURJPY", "EURCHF", "EURNZD", "EURCAD", "EURAUD", "GBPAUD",
                     "GBPCAD", "GBPCHF", "GBPJPY", "GBPNZD", "AUDCAD", "AUDCHF", "AUDJPY",
                     "AUDNZD", "CADJPY", "CHFJPY", "NZDJPY", "NZDCAD", "NZDCHF", "CADCHF")   
*/

//---- 28 currencies
double eurusd, gbpusd, audusd, nzdusd, usdcad, usdchf;
double eurgbp, eurjpy, eurchf, eurnzd, eurcad, euraud;
double audchf, audjpy, audnzd, cadchf, cadjpy, chfjpy;
double gbpaud, gbpcad, gbpchf, gbpjpy, gbpnzd, nzdcad;
double nzdchf, audcad, usdjpy, nzdjpy;
             
string data;    //identifier that will be used to collect data string
datetime TIME;  //Time index
               // delete file if it's exist
               FileDelete(filename);
               // open file handle
               int handle = FileOpen(filename,FILE_CSV|FILE_READ|FILE_WRITE);
                FileSeek(handle,0,SEEK_SET);
               // generate data now using for loop
               //----Fill the arrays
         
               //loop j calculates surfaces and angles from beginning of the day
               for(int j = 0; j < barsCollect; j++)    //j scrolls through bars of the day
                 {
                     TIME = iTime(Symbol(), chartPeriod, j);  //Time of the bar of the applied chart symbol
                     //--- calculating close price for every currency
                     eurusd = iOpen("EURUSD",chartPeriod,j);
                     gbpusd = iOpen("GBPUSD",chartPeriod,j);
                     audusd = iOpen("AUDUSD",chartPeriod,j);
                     nzdusd = iOpen("NZDUSD",chartPeriod,j);
                     
                     usdcad = iOpen("USDCAD",chartPeriod,j);
                     usdchf = iOpen("USDCHF",chartPeriod,j);
                     usdjpy = iOpen("USDJPY",chartPeriod,j);
                     eurgbp = iOpen("EURGBP",chartPeriod,j);
                     
                     eurjpy = iOpen("EURJPY",chartPeriod,j);
                     eurchf = iOpen("EURCHF",chartPeriod,j);
                     eurnzd = iOpen("EURNZD",chartPeriod,j);
                     eurcad = iOpen("EURCAD",chartPeriod,j);
                     
                     euraud = iOpen("EURAUD",chartPeriod,j);      
                     gbpaud = iOpen("GBPAUD",chartPeriod,j);
                     gbpcad = iOpen("GBPCAD",chartPeriod,j);
                     gbpchf = iOpen("GBPCHF",chartPeriod,j);
                     
                     gbpjpy = iOpen("GBPJPY",chartPeriod,j);
                     gbpnzd = iOpen("GBPNZD",chartPeriod,j);
                     audcad = iOpen("AUDCAD",chartPeriod,j);
                     audchf = iOpen("AUDCHF",chartPeriod,j);
                     
                     audjpy = iOpen("AUDJPY",chartPeriod,j);
                     audnzd = iOpen("AUDNZD",chartPeriod,j);
                     cadjpy = iOpen("CADJPY",chartPeriod,j);
                     chfjpy = iOpen("CHFJPY",chartPeriod,j);
                     
                     nzdjpy = iOpen("NZDJPY",chartPeriod,j);
                     nzdcad = iOpen("NZDCAD",chartPeriod,j);
                     nzdchf = iOpen("NZDCHF",chartPeriod,j);
                     cadchf = iOpen("CADCHF",chartPeriod,j);
                     
                     
                     data = string(TIME)+","+string(eurusd)+"," + string(gbpusd) + "," +string(audusd)+ "," +string(nzdusd)+ ","
                                            +string(usdcad)+"," + string(usdchf) + "," +string(usdjpy)+ "," +string(eurgbp)+ ","
                                            +string(eurjpy)+"," + string(eurchf) + "," +string(eurnzd)+ "," +string(eurcad)+ ","
                                            +string(euraud)+"," + string(gbpaud) + "," +string(gbpcad)+ "," +string(gbpchf)+ ","
                                            +string(gbpjpy)+"," + string(gbpnzd) + "," +string(audcad)+ "," +string(audchf)+ ","
                                            +string(audjpy)+"," + string(audnzd) + "," +string(cadjpy)+ "," +string(chfjpy)+ ","
                                            +string(nzdjpy)+"," + string(nzdcad) + "," +string(nzdchf)+ "," +string(cadchf);
                  FileWrite(handle,data);   //write data to the file during each for loop iteration
                     
                 }
               
               //             
                FileClose(handle);        //close file when data write is over
               //---------------------------------------------------------------------------------------------
         
  }

void writeDataHP(string filename, int charPer, int barsCollect)
// function to record 28 currencies pairs lowest bar price to the file (file to be used by all R scripts)
 {

/*
Pairs = c("EURUSD", "GBPUSD", "AUDUSD", "NZDUSD", "USDCAD", "USDCHF", "USDJPY",
                     "EURGBP", "EURJPY", "EURCHF", "EURNZD", "EURCAD", "EURAUD", "GBPAUD",
                     "GBPCAD", "GBPCHF", "GBPJPY", "GBPNZD", "AUDCAD", "AUDCHF", "AUDJPY",
                     "AUDNZD", "CADJPY", "CHFJPY", "NZDJPY", "NZDCAD", "NZDCHF", "CADCHF")   
*/

//---- 28 currencies
double eurusd, gbpusd, audusd, nzdusd, usdcad, usdchf;
double eurgbp, eurjpy, eurchf, eurnzd, eurcad, euraud;
double audchf, audjpy, audnzd, cadchf, cadjpy, chfjpy;
double gbpaud, gbpcad, gbpchf, gbpjpy, gbpnzd, nzdcad;
double nzdchf, audcad, usdjpy, nzdjpy;
             
string data;    //identifier that will be used to collect data string
datetime TIME;  //Time index
               // delete file if it's exist
               FileDelete(filename);
               // open file handle
               int handle = FileOpen(filename,FILE_CSV|FILE_READ|FILE_WRITE);
                FileSeek(handle,0,SEEK_SET);
               // generate data now using for loop
               //----Fill the arrays
         
               //loop j calculates surfaces and angles from beginning of the day
               for(int j = 0; j < barsCollect; j++)    //j scrolls through bars of the day
                 {
                     TIME = iTime(Symbol(), chartPeriod, j);  //Time of the bar of the applied chart symbol
                     //--- calculating close price for every currency
                     eurusd = iHigh("EURUSD",chartPeriod,j);
                     gbpusd = iHigh("GBPUSD",chartPeriod,j);
                     audusd = iHigh("AUDUSD",chartPeriod,j);
                     nzdusd = iHigh("NZDUSD",chartPeriod,j);
                     
                     usdcad = iHigh("USDCAD",chartPeriod,j);
                     usdchf = iHigh("USDCHF",chartPeriod,j);
                     usdjpy = iHigh("USDJPY",chartPeriod,j);
                     eurgbp = iHigh("EURGBP",chartPeriod,j);
                     
                     eurjpy = iHigh("EURJPY",chartPeriod,j);
                     eurchf = iHigh("EURCHF",chartPeriod,j);
                     eurnzd = iHigh("EURNZD",chartPeriod,j);
                     eurcad = iHigh("EURCAD",chartPeriod,j);
                     
                     euraud = iHigh("EURAUD",chartPeriod,j);      
                     gbpaud = iHigh("GBPAUD",chartPeriod,j);
                     gbpcad = iHigh("GBPCAD",chartPeriod,j);
                     gbpchf = iHigh("GBPCHF",chartPeriod,j);
                     
                     gbpjpy = iHigh("GBPJPY",chartPeriod,j);
                     gbpnzd = iHigh("GBPNZD",chartPeriod,j);
                     audcad = iHigh("AUDCAD",chartPeriod,j);
                     audchf = iHigh("AUDCHF",chartPeriod,j);
                     
                     audjpy = iHigh("AUDJPY",chartPeriod,j);
                     audnzd = iHigh("AUDNZD",chartPeriod,j);
                     cadjpy = iHigh("CADJPY",chartPeriod,j);
                     chfjpy = iHigh("CHFJPY",chartPeriod,j);
                     
                     nzdjpy = iHigh("NZDJPY",chartPeriod,j);
                     nzdcad = iHigh("NZDCAD",chartPeriod,j);
                     nzdchf = iHigh("NZDCHF",chartPeriod,j);
                     cadchf = iHigh("CADCHF",chartPeriod,j);
                     
                     
                     data = string(TIME)+","+string(eurusd)+"," + string(gbpusd) + "," +string(audusd)+ "," +string(nzdusd)+ ","
                                            +string(usdcad)+"," + string(usdchf) + "," +string(usdjpy)+ "," +string(eurgbp)+ ","
                                            +string(eurjpy)+"," + string(eurchf) + "," +string(eurnzd)+ "," +string(eurcad)+ ","
                                            +string(euraud)+"," + string(gbpaud) + "," +string(gbpcad)+ "," +string(gbpchf)+ ","
                                            +string(gbpjpy)+"," + string(gbpnzd) + "," +string(audcad)+ "," +string(audchf)+ ","
                                            +string(audjpy)+"," + string(audnzd) + "," +string(cadjpy)+ "," +string(chfjpy)+ ","
                                            +string(nzdjpy)+"," + string(nzdcad) + "," +string(nzdchf)+ "," +string(cadchf);
                  FileWrite(handle,data);   //write data to the file during each for loop iteration
                     
                 }
               
               //             
                FileClose(handle);        //close file when data write is over
               //---------------------------------------------------------------------------------------------
         
  }

void writeDataLP(string filename, int charPer, int barsCollect)
// function to record 28 currencies pairs lowest bar price to the file (file to be used by all R scripts)
 {

/*
Pairs = c("EURUSD", "GBPUSD", "AUDUSD", "NZDUSD", "USDCAD", "USDCHF", "USDJPY",
                     "EURGBP", "EURJPY", "EURCHF", "EURNZD", "EURCAD", "EURAUD", "GBPAUD",
                     "GBPCAD", "GBPCHF", "GBPJPY", "GBPNZD", "AUDCAD", "AUDCHF", "AUDJPY",
                     "AUDNZD", "CADJPY", "CHFJPY", "NZDJPY", "NZDCAD", "NZDCHF", "CADCHF")   
*/

//---- 28 currencies
double eurusd, gbpusd, audusd, nzdusd, usdcad, usdchf;
double eurgbp, eurjpy, eurchf, eurnzd, eurcad, euraud;
double audchf, audjpy, audnzd, cadchf, cadjpy, chfjpy;
double gbpaud, gbpcad, gbpchf, gbpjpy, gbpnzd, nzdcad;
double nzdchf, audcad, usdjpy, nzdjpy;
             
string data;    //identifier that will be used to collect data string
datetime TIME;  //Time index
               // delete file if it's exist
               FileDelete(filename);
               // open file handle
               int handle = FileOpen(filename,FILE_CSV|FILE_READ|FILE_WRITE);
                FileSeek(handle,0,SEEK_SET);
               // generate data now using for loop
               //----Fill the arrays
         
               //loop j calculates surfaces and angles from beginning of the day
               for(int j = 0; j < barsCollect; j++)    //j scrolls through bars of the day
                 {
                     TIME = iTime(Symbol(), chartPeriod, j);  //Time of the bar of the applied chart symbol
                     //--- calculating close price for every currency
                     eurusd = iLow("EURUSD",chartPeriod,j);
                     gbpusd = iLow("GBPUSD",chartPeriod,j);
                     audusd = iLow("AUDUSD",chartPeriod,j);
                     nzdusd = iLow("NZDUSD",chartPeriod,j);
                     
                     usdcad = iLow("USDCAD",chartPeriod,j);
                     usdchf = iLow("USDCHF",chartPeriod,j);
                     usdjpy = iLow("USDJPY",chartPeriod,j);
                     eurgbp = iLow("EURGBP",chartPeriod,j);
                     
                     eurjpy = iLow("EURJPY",chartPeriod,j);
                     eurchf = iLow("EURCHF",chartPeriod,j);
                     eurnzd = iLow("EURNZD",chartPeriod,j);
                     eurcad = iLow("EURCAD",chartPeriod,j);
                     
                     euraud = iLow("EURAUD",chartPeriod,j);      
                     gbpaud = iLow("GBPAUD",chartPeriod,j);
                     gbpcad = iLow("GBPCAD",chartPeriod,j);
                     gbpchf = iLow("GBPCHF",chartPeriod,j);
                     
                     gbpjpy = iLow("GBPJPY",chartPeriod,j);
                     gbpnzd = iLow("GBPNZD",chartPeriod,j);
                     audcad = iLow("AUDCAD",chartPeriod,j);
                     audchf = iLow("AUDCHF",chartPeriod,j);
                     
                     audjpy = iLow("AUDJPY",chartPeriod,j);
                     audnzd = iLow("AUDNZD",chartPeriod,j);
                     cadjpy = iLow("CADJPY",chartPeriod,j);
                     chfjpy = iLow("CHFJPY",chartPeriod,j);
                     
                     nzdjpy = iLow("NZDJPY",chartPeriod,j);
                     nzdcad = iLow("NZDCAD",chartPeriod,j);
                     nzdchf = iLow("NZDCHF",chartPeriod,j);
                     cadchf = iLow("CADCHF",chartPeriod,j);
                     
                     
                     data = string(TIME)+","+string(eurusd)+"," + string(gbpusd) + "," +string(audusd)+ "," +string(nzdusd)+ ","
                                            +string(usdcad)+"," + string(usdchf) + "," +string(usdjpy)+ "," +string(eurgbp)+ ","
                                            +string(eurjpy)+"," + string(eurchf) + "," +string(eurnzd)+ "," +string(eurcad)+ ","
                                            +string(euraud)+"," + string(gbpaud) + "," +string(gbpcad)+ "," +string(gbpchf)+ ","
                                            +string(gbpjpy)+"," + string(gbpnzd) + "," +string(audcad)+ "," +string(audchf)+ ","
                                            +string(audjpy)+"," + string(audnzd) + "," +string(cadjpy)+ "," +string(chfjpy)+ ","
                                            +string(nzdjpy)+"," + string(nzdcad) + "," +string(nzdchf)+ "," +string(cadchf);
                  FileWrite(handle,data);   //write data to the file during each for loop iteration
                     
                 }
               
               //             
                FileClose(handle);        //close file when data write is over
               //---------------------------------------------------------------------------------------------
         
  }

void writeDataRSI(string filename, int charPer, int barsCollect)
// function to record 28 currencies pairs close price to the file (file to be used by all R scripts)
 {

/*
Pairs = c("EURUSD", "GBPUSD", "AUDUSD", "NZDUSD", "USDCAD", "USDCHF", "USDJPY",
                     "EURGBP", "EURJPY", "EURCHF", "EURNZD", "EURCAD", "EURAUD", "GBPAUD",
                     "GBPCAD", "GBPCHF", "GBPJPY", "GBPNZD", "AUDCAD", "AUDCHF", "AUDJPY",
                     "AUDNZD", "CADJPY", "CHFJPY", "NZDJPY", "NZDCAD", "NZDCHF", "CADCHF")   
*/

//---- 28 currencies
double eurusd, gbpusd, audusd, nzdusd, usdcad, usdchf;
double eurgbp, eurjpy, eurchf, eurnzd, eurcad, euraud;
double audchf, audjpy, audnzd, cadchf, cadjpy, chfjpy;
double gbpaud, gbpcad, gbpchf, gbpjpy, gbpnzd, nzdcad;
double nzdchf, audcad, usdjpy, nzdjpy;
             
string data;    //identifier that will be used to collect data string
datetime TIME;  //Time index
               // delete file if it's exist
               FileDelete(filename);
               // open file handle
               int handle = FileOpen(filename,FILE_CSV|FILE_READ|FILE_WRITE);
                FileSeek(handle,0,SEEK_SET);
               // generate data now using for loop
               //----Fill the arrays
         
               //loop j calculates surfaces and angles from beginning of the day
               for(int j = 0; j < barsCollect; j++)    //j scrolls through bars of the day
                 {
                     TIME = iTime(Symbol(), chartPeriod, j);  //Time of the bar of the applied chart symbol
                     //--- calculating close price for every currency
                     eurusd = iRSI("EURUSD",chartPeriod, 8, PRICE_MEDIAN, j);
                     gbpusd = iRSI("GBPUSD",chartPeriod, 8, PRICE_MEDIAN, j);
                     audusd = iRSI("AUDUSD",chartPeriod, 8, PRICE_MEDIAN, j);
                     nzdusd = iRSI("NZDUSD",chartPeriod, 8, PRICE_MEDIAN, j);
                     
                     usdcad = iRSI("USDCAD",chartPeriod, 8, PRICE_MEDIAN, j);
                     usdchf = iRSI("USDCHF",chartPeriod, 8, PRICE_MEDIAN, j);
                     usdjpy = iRSI("USDJPY",chartPeriod, 8, PRICE_MEDIAN, j);
                     eurgbp = iRSI("EURGBP",chartPeriod, 8, PRICE_MEDIAN, j);
                     
                     eurjpy = iRSI("EURJPY",chartPeriod, 8, PRICE_MEDIAN, j);
                     eurchf = iRSI("EURCHF",chartPeriod, 8, PRICE_MEDIAN, j);
                     eurnzd = iRSI("EURNZD",chartPeriod, 8, PRICE_MEDIAN, j);
                     eurcad = iRSI("EURCAD",chartPeriod, 8, PRICE_MEDIAN, j);
                     
                     euraud = iRSI("EURAUD",chartPeriod, 8, PRICE_MEDIAN, j);      
                     gbpaud = iRSI("GBPAUD",chartPeriod, 8, PRICE_MEDIAN, j);
                     gbpcad = iRSI("GBPCAD",chartPeriod, 8, PRICE_MEDIAN, j);
                     gbpchf = iRSI("GBPCHF",chartPeriod, 8, PRICE_MEDIAN, j);
                     
                     gbpjpy = iRSI("GBPJPY",chartPeriod, 8, PRICE_MEDIAN, j);
                     gbpnzd = iRSI("GBPNZD",chartPeriod, 8, PRICE_MEDIAN, j);
                     audcad = iRSI("AUDCAD",chartPeriod, 8, PRICE_MEDIAN, j);
                     audchf = iRSI("AUDCHF",chartPeriod, 8, PRICE_MEDIAN, j);
                     
                     audjpy = iRSI("AUDJPY",chartPeriod, 8, PRICE_MEDIAN, j);
                     audnzd = iRSI("AUDNZD",chartPeriod, 8, PRICE_MEDIAN, j);
                     cadjpy = iRSI("CADJPY",chartPeriod, 8, PRICE_MEDIAN, j);
                     chfjpy = iRSI("CHFJPY",chartPeriod, 8, PRICE_MEDIAN, j);
                     
                     nzdjpy = iRSI("NZDJPY",chartPeriod, 8, PRICE_MEDIAN, j);
                     nzdcad = iRSI("NZDCAD",chartPeriod, 8, PRICE_MEDIAN, j);
                     nzdchf = iRSI("NZDCHF",chartPeriod, 8, PRICE_MEDIAN, j);
                     cadchf = iRSI("CADCHF",chartPeriod, 8, PRICE_MEDIAN, j);
                     
                     
                     data = string(TIME)+","+string(eurusd)+"," + string(gbpusd) + "," +string(audusd)+ "," +string(nzdusd)+ ","
                                            +string(usdcad)+"," + string(usdchf) + "," +string(usdjpy)+ "," +string(eurgbp)+ ","
                                            +string(eurjpy)+"," + string(eurchf) + "," +string(eurnzd)+ "," +string(eurcad)+ ","
                                            +string(euraud)+"," + string(gbpaud) + "," +string(gbpcad)+ "," +string(gbpchf)+ ","
                                            +string(gbpjpy)+"," + string(gbpnzd) + "," +string(audcad)+ "," +string(audchf)+ ","
                                            +string(audjpy)+"," + string(audnzd) + "," +string(cadjpy)+ "," +string(chfjpy)+ ","
                                            +string(nzdjpy)+"," + string(nzdcad) + "," +string(nzdchf)+ "," +string(cadchf);
                  FileWrite(handle,data);   //write data to the file during each for loop iteration
                     
                 }
               
               //             
                FileClose(handle);        //close file when data write is over
               //---------------------------------------------------------------------------------------------
         
  }
  
void writeDataBullPow(string filename, int charPer, int barsCollect)
// function to record 28 currencies pairs close price to the file (file to be used by all R scripts)
 {

/*
Pairs = c("EURUSD", "GBPUSD", "AUDUSD", "NZDUSD", "USDCAD", "USDCHF", "USDJPY",
                     "EURGBP", "EURJPY", "EURCHF", "EURNZD", "EURCAD", "EURAUD", "GBPAUD",
                     "GBPCAD", "GBPCHF", "GBPJPY", "GBPNZD", "AUDCAD", "AUDCHF", "AUDJPY",
                     "AUDNZD", "CADJPY", "CHFJPY", "NZDJPY", "NZDCAD", "NZDCHF", "CADCHF")   
*/

//---- 28 currencies
double eurusd, gbpusd, audusd, nzdusd, usdcad, usdchf;
double eurgbp, eurjpy, eurchf, eurnzd, eurcad, euraud;
double audchf, audjpy, audnzd, cadchf, cadjpy, chfjpy;
double gbpaud, gbpcad, gbpchf, gbpjpy, gbpnzd, nzdcad;
double nzdchf, audcad, usdjpy, nzdjpy;
             
string data;    //identifier that will be used to collect data string
datetime TIME;  //Time index
               // delete file if it's exist
               FileDelete(filename);
               // open file handle
               int handle = FileOpen(filename,FILE_CSV|FILE_READ|FILE_WRITE);
                FileSeek(handle,0,SEEK_SET);
               // generate data now using for loop
               //----Fill the arrays
         
               //loop j calculates surfaces and angles from beginning of the day
               for(int j = 0; j < barsCollect; j++)    //j scrolls through bars of the day
                 {
                     TIME = iTime(Symbol(), chartPeriod, j);  //Time of the bar of the applied chart symbol
                     //--- calculating close price for every currency
                     eurusd = iBullsPower("EURUSD",chartPeriod, 8, PRICE_MEDIAN, j);
                     gbpusd = iBullsPower("GBPUSD",chartPeriod, 8, PRICE_MEDIAN, j);
                     audusd = iBullsPower("AUDUSD",chartPeriod, 8, PRICE_MEDIAN, j);
                     nzdusd = iBullsPower("NZDUSD",chartPeriod, 8, PRICE_MEDIAN, j);
                     
                     usdcad = iBullsPower("USDCAD",chartPeriod, 8, PRICE_MEDIAN, j);
                     usdchf = iBullsPower("USDCHF",chartPeriod, 8, PRICE_MEDIAN, j);
                     usdjpy = iBullsPower("USDJPY",chartPeriod, 8, PRICE_MEDIAN, j);
                     eurgbp = iBullsPower("EURGBP",chartPeriod, 8, PRICE_MEDIAN, j);
                     
                     eurjpy = iBullsPower("EURJPY",chartPeriod, 8, PRICE_MEDIAN, j);
                     eurchf = iBullsPower("EURCHF",chartPeriod, 8, PRICE_MEDIAN, j);
                     eurnzd = iBullsPower("EURNZD",chartPeriod, 8, PRICE_MEDIAN, j);
                     eurcad = iBullsPower("EURCAD",chartPeriod, 8, PRICE_MEDIAN, j);
                     
                     euraud = iBullsPower("EURAUD",chartPeriod, 8, PRICE_MEDIAN, j);      
                     gbpaud = iBullsPower("GBPAUD",chartPeriod, 8, PRICE_MEDIAN, j);
                     gbpcad = iBullsPower("GBPCAD",chartPeriod, 8, PRICE_MEDIAN, j);
                     gbpchf = iBullsPower("GBPCHF",chartPeriod, 8, PRICE_MEDIAN, j);
                     
                     gbpjpy = iBullsPower("GBPJPY",chartPeriod, 8, PRICE_MEDIAN, j);
                     gbpnzd = iBullsPower("GBPNZD",chartPeriod, 8, PRICE_MEDIAN, j);
                     audcad = iBullsPower("AUDCAD",chartPeriod, 8, PRICE_MEDIAN, j);
                     audchf = iBullsPower("AUDCHF",chartPeriod, 8, PRICE_MEDIAN, j);
                     
                     audjpy = iBullsPower("AUDJPY",chartPeriod, 8, PRICE_MEDIAN, j);
                     audnzd = iBullsPower("AUDNZD",chartPeriod, 8, PRICE_MEDIAN, j);
                     cadjpy = iBullsPower("CADJPY",chartPeriod, 8, PRICE_MEDIAN, j);
                     chfjpy = iBullsPower("CHFJPY",chartPeriod, 8, PRICE_MEDIAN, j);
                     
                     nzdjpy = iBullsPower("NZDJPY",chartPeriod, 8, PRICE_MEDIAN, j);
                     nzdcad = iBullsPower("NZDCAD",chartPeriod, 8, PRICE_MEDIAN, j);
                     nzdchf = iBullsPower("NZDCHF",chartPeriod, 8, PRICE_MEDIAN, j);
                     cadchf = iBullsPower("CADCHF",chartPeriod, 8, PRICE_MEDIAN, j);
                     
                     
                     data = string(TIME)+","+string(eurusd)+"," + string(gbpusd) + "," +string(audusd)+ "," +string(nzdusd)+ ","
                                            +string(usdcad)+"," + string(usdchf) + "," +string(usdjpy)+ "," +string(eurgbp)+ ","
                                            +string(eurjpy)+"," + string(eurchf) + "," +string(eurnzd)+ "," +string(eurcad)+ ","
                                            +string(euraud)+"," + string(gbpaud) + "," +string(gbpcad)+ "," +string(gbpchf)+ ","
                                            +string(gbpjpy)+"," + string(gbpnzd) + "," +string(audcad)+ "," +string(audchf)+ ","
                                            +string(audjpy)+"," + string(audnzd) + "," +string(cadjpy)+ "," +string(chfjpy)+ ","
                                            +string(nzdjpy)+"," + string(nzdcad) + "," +string(nzdchf)+ "," +string(cadchf);
                  FileWrite(handle,data);   //write data to the file during each for loop iteration
                     
                 }
               
               //             
                FileClose(handle);        //close file when data write is over
               //---------------------------------------------------------------------------------------------
         
  }
  
void writeDataBearPow(string filename, int charPer, int barsCollect)
// function to record 28 currencies pairs close price to the file (file to be used by all R scripts)
 {

/*
Pairs = c("EURUSD", "GBPUSD", "AUDUSD", "NZDUSD", "USDCAD", "USDCHF", "USDJPY",
                     "EURGBP", "EURJPY", "EURCHF", "EURNZD", "EURCAD", "EURAUD", "GBPAUD",
                     "GBPCAD", "GBPCHF", "GBPJPY", "GBPNZD", "AUDCAD", "AUDCHF", "AUDJPY",
                     "AUDNZD", "CADJPY", "CHFJPY", "NZDJPY", "NZDCAD", "NZDCHF", "CADCHF")   
*/

//---- 28 currencies
double eurusd, gbpusd, audusd, nzdusd, usdcad, usdchf;
double eurgbp, eurjpy, eurchf, eurnzd, eurcad, euraud;
double audchf, audjpy, audnzd, cadchf, cadjpy, chfjpy;
double gbpaud, gbpcad, gbpchf, gbpjpy, gbpnzd, nzdcad;
double nzdchf, audcad, usdjpy, nzdjpy;
             
string data;    //identifier that will be used to collect data string
datetime TIME;  //Time index
               // delete file if it's exist
               FileDelete(filename);
               // open file handle
               int handle = FileOpen(filename,FILE_CSV|FILE_READ|FILE_WRITE);
                FileSeek(handle,0,SEEK_SET);
               // generate data now using for loop
               //----Fill the arrays
         
               //loop j calculates surfaces and angles from beginning of the day
               for(int j = 0; j < barsCollect; j++)    //j scrolls through bars of the day
                 {
                     TIME = iTime(Symbol(), chartPeriod, j);  //Time of the bar of the applied chart symbol
                     //--- calculating close price for every currency
                     eurusd = iBearsPower("EURUSD",chartPeriod, 8, PRICE_MEDIAN, j);
                     gbpusd = iBearsPower("GBPUSD",chartPeriod, 8, PRICE_MEDIAN, j);
                     audusd = iBearsPower("AUDUSD",chartPeriod, 8, PRICE_MEDIAN, j);
                     nzdusd = iBearsPower("NZDUSD",chartPeriod, 8, PRICE_MEDIAN, j);
                     
                     usdcad = iBearsPower("USDCAD",chartPeriod, 8, PRICE_MEDIAN, j);
                     usdchf = iBearsPower("USDCHF",chartPeriod, 8, PRICE_MEDIAN, j);
                     usdjpy = iBearsPower("USDJPY",chartPeriod, 8, PRICE_MEDIAN, j);
                     eurgbp = iBearsPower("EURGBP",chartPeriod, 8, PRICE_MEDIAN, j);
                     
                     eurjpy = iBearsPower("EURJPY",chartPeriod, 8, PRICE_MEDIAN, j);
                     eurchf = iBearsPower("EURCHF",chartPeriod, 8, PRICE_MEDIAN, j);
                     eurnzd = iBearsPower("EURNZD",chartPeriod, 8, PRICE_MEDIAN, j);
                     eurcad = iBearsPower("EURCAD",chartPeriod, 8, PRICE_MEDIAN, j);
                     
                     euraud = iBearsPower("EURAUD",chartPeriod, 8, PRICE_MEDIAN, j);      
                     gbpaud = iBearsPower("GBPAUD",chartPeriod, 8, PRICE_MEDIAN, j);
                     gbpcad = iBearsPower("GBPCAD",chartPeriod, 8, PRICE_MEDIAN, j);
                     gbpchf = iBearsPower("GBPCHF",chartPeriod, 8, PRICE_MEDIAN, j);
                     
                     gbpjpy = iBearsPower("GBPJPY",chartPeriod, 8, PRICE_MEDIAN, j);
                     gbpnzd = iBearsPower("GBPNZD",chartPeriod, 8, PRICE_MEDIAN, j);
                     audcad = iBearsPower("AUDCAD",chartPeriod, 8, PRICE_MEDIAN, j);
                     audchf = iBearsPower("AUDCHF",chartPeriod, 8, PRICE_MEDIAN, j);
                     
                     audjpy = iBearsPower("AUDJPY",chartPeriod, 8, PRICE_MEDIAN, j);
                     audnzd = iBearsPower("AUDNZD",chartPeriod, 8, PRICE_MEDIAN, j);
                     cadjpy = iBearsPower("CADJPY",chartPeriod, 8, PRICE_MEDIAN, j);
                     chfjpy = iBearsPower("CHFJPY",chartPeriod, 8, PRICE_MEDIAN, j);
                     
                     nzdjpy = iBearsPower("NZDJPY",chartPeriod, 8, PRICE_MEDIAN, j);
                     nzdcad = iBearsPower("NZDCAD",chartPeriod, 8, PRICE_MEDIAN, j);
                     nzdchf = iBearsPower("NZDCHF",chartPeriod, 8, PRICE_MEDIAN, j);
                     cadchf = iBearsPower("CADCHF",chartPeriod, 8, PRICE_MEDIAN, j);
                     
                     
                     data = string(TIME)+","+string(eurusd)+"," + string(gbpusd) + "," +string(audusd)+ "," +string(nzdusd)+ ","
                                            +string(usdcad)+"," + string(usdchf) + "," +string(usdjpy)+ "," +string(eurgbp)+ ","
                                            +string(eurjpy)+"," + string(eurchf) + "," +string(eurnzd)+ "," +string(eurcad)+ ","
                                            +string(euraud)+"," + string(gbpaud) + "," +string(gbpcad)+ "," +string(gbpchf)+ ","
                                            +string(gbpjpy)+"," + string(gbpnzd) + "," +string(audcad)+ "," +string(audchf)+ ","
                                            +string(audjpy)+"," + string(audnzd) + "," +string(cadjpy)+ "," +string(chfjpy)+ ","
                                            +string(nzdjpy)+"," + string(nzdcad) + "," +string(nzdchf)+ "," +string(cadchf);
                  FileWrite(handle,data);   //write data to the file during each for loop iteration
                     
                 }
               
               //             
                FileClose(handle);        //close file when data write is over
               //---------------------------------------------------------------------------------------------
         
  }              
  
void writeDataAtr(string filename, int charPer, int barsCollect)
// function to record 28 currencies pairs close price to the file (file to be used by all R scripts)
 {

/*
Pairs = c("EURUSD", "GBPUSD", "AUDUSD", "NZDUSD", "USDCAD", "USDCHF", "USDJPY",
                     "EURGBP", "EURJPY", "EURCHF", "EURNZD", "EURCAD", "EURAUD", "GBPAUD",
                     "GBPCAD", "GBPCHF", "GBPJPY", "GBPNZD", "AUDCAD", "AUDCHF", "AUDJPY",
                     "AUDNZD", "CADJPY", "CHFJPY", "NZDJPY", "NZDCAD", "NZDCHF", "CADCHF")   
*/

//---- 28 currencies
double eurusd, gbpusd, audusd, nzdusd, usdcad, usdchf;
double eurgbp, eurjpy, eurchf, eurnzd, eurcad, euraud;
double audchf, audjpy, audnzd, cadchf, cadjpy, chfjpy;
double gbpaud, gbpcad, gbpchf, gbpjpy, gbpnzd, nzdcad;
double nzdchf, audcad, usdjpy, nzdjpy;
             
string data;    //identifier that will be used to collect data string
datetime TIME;  //Time index
               // delete file if it's exist
               FileDelete(filename);
               // open file handle
               int handle = FileOpen(filename,FILE_CSV|FILE_READ|FILE_WRITE);
                FileSeek(handle,0,SEEK_SET);
               // generate data now using for loop
               //----Fill the arrays
         
               //loop j calculates surfaces and angles from beginning of the day
               for(int j = 0; j < barsCollect; j++)    //j scrolls through bars of the day
                 {
                     TIME = iTime(Symbol(), chartPeriod, j);  //Time of the bar of the applied chart symbol
                     //--- calculating close price for every currency
                     eurusd = iATR("EURUSD",chartPeriod, 8, j);
                     gbpusd = iATR("GBPUSD",chartPeriod, 8, j);
                     audusd = iATR("AUDUSD",chartPeriod, 8, j);
                     nzdusd = iATR("NZDUSD",chartPeriod, 8, j);
                     
                     usdcad = iATR("USDCAD",chartPeriod, 8, j);
                     usdchf = iATR("USDCHF",chartPeriod, 8, j);
                     usdjpy = iATR("USDJPY",chartPeriod, 8, j);
                     eurgbp = iATR("EURGBP",chartPeriod, 8, j);
                     
                     eurjpy = iATR("EURJPY",chartPeriod, 8, j);
                     eurchf = iATR("EURCHF",chartPeriod, 8, j);
                     eurnzd = iATR("EURNZD",chartPeriod, 8, j);
                     eurcad = iATR("EURCAD",chartPeriod, 8, j);
                     
                     euraud = iATR("EURAUD",chartPeriod, 8, j);      
                     gbpaud = iATR("GBPAUD",chartPeriod, 8, j);
                     gbpcad = iATR("GBPCAD",chartPeriod, 8, j);
                     gbpchf = iATR("GBPCHF",chartPeriod, 8, j);
                     
                     gbpjpy = iATR("GBPJPY",chartPeriod, 8, j);
                     gbpnzd = iATR("GBPNZD",chartPeriod, 8, j);
                     audcad = iATR("AUDCAD",chartPeriod, 8, j);
                     audchf = iATR("AUDCHF",chartPeriod, 8, j);
                     
                     audjpy = iATR("AUDJPY",chartPeriod, 8, j);
                     audnzd = iATR("AUDNZD",chartPeriod, 8, j);
                     cadjpy = iATR("CADJPY",chartPeriod, 8, j);
                     chfjpy = iATR("CHFJPY",chartPeriod, 8, j);
                     
                     nzdjpy = iATR("NZDJPY",chartPeriod, 8, j);
                     nzdcad = iATR("NZDCAD",chartPeriod, 8, j);
                     nzdchf = iATR("NZDCHF",chartPeriod, 8, j);
                     cadchf = iATR("CADCHF",chartPeriod, 8, j);
                     
                     
                     data = string(TIME)+","+string(eurusd)+"," + string(gbpusd) + "," +string(audusd)+ "," +string(nzdusd)+ ","
                                            +string(usdcad)+"," + string(usdchf) + "," +string(usdjpy)+ "," +string(eurgbp)+ ","
                                            +string(eurjpy)+"," + string(eurchf) + "," +string(eurnzd)+ "," +string(eurcad)+ ","
                                            +string(euraud)+"," + string(gbpaud) + "," +string(gbpcad)+ "," +string(gbpchf)+ ","
                                            +string(gbpjpy)+"," + string(gbpnzd) + "," +string(audcad)+ "," +string(audchf)+ ","
                                            +string(audjpy)+"," + string(audnzd) + "," +string(cadjpy)+ "," +string(chfjpy)+ ","
                                            +string(nzdjpy)+"," + string(nzdcad) + "," +string(nzdchf)+ "," +string(cadchf);
                  FileWrite(handle,data);   //write data to the file during each for loop iteration
                     
                 }
               
               //             
                FileClose(handle);        //close file when data write is over
               //---------------------------------------------------------------------------------------------
         
  }     
  
void writeDataMacd(string filename, int charPer, int barsCollect)
// function to record 28 currencies pairs MACD to the file (file to be used by all R scripts)
 {

/*
Pairs = c("EURUSD", "GBPUSD", "AUDUSD", "NZDUSD", "USDCAD", "USDCHF", "USDJPY",
                     "EURGBP", "EURJPY", "EURCHF", "EURNZD", "EURCAD", "EURAUD", "GBPAUD",
                     "GBPCAD", "GBPCHF", "GBPJPY", "GBPNZD", "AUDCAD", "AUDCHF", "AUDJPY",
                     "AUDNZD", "CADJPY", "CHFJPY", "NZDJPY", "NZDCAD", "NZDCHF", "CADCHF")   
*/

//---- 28 currencies
double eurusd, gbpusd, audusd, nzdusd, usdcad, usdchf;
double eurgbp, eurjpy, eurchf, eurnzd, eurcad, euraud;
double audchf, audjpy, audnzd, cadchf, cadjpy, chfjpy;
double gbpaud, gbpcad, gbpchf, gbpjpy, gbpnzd, nzdcad;
double nzdchf, audcad, usdjpy, nzdjpy;
             
string data;    //identifier that will be used to collect data string
datetime TIME;  //Time index
               // delete file if it's exist
               FileDelete(filename);
               // open file handle
               int handle = FileOpen(filename,FILE_CSV|FILE_READ|FILE_WRITE);
                FileSeek(handle,0,SEEK_SET);
               // generate data now using for loop
               //----Fill the arrays
         
               //loop j calculates surfaces and angles from beginning of the day
               for(int j = 0; j < barsCollect; j++)    //j scrolls through bars of the day
                 {
                     TIME = iTime(Symbol(), chartPeriod, j);  //Time of the bar of the applied chart symbol
                     //--- calculating close price for every currency
                     eurusd = iMACD("EURUSD",chartPeriod, 12, 26, 9, 0, 0, j);
                     gbpusd = iMACD("GBPUSD",chartPeriod, 12, 26, 9, 0, 0, j);
                     audusd = iMACD("AUDUSD",chartPeriod, 12, 26, 9, 0, 0, j);
                     nzdusd = iMACD("NZDUSD",chartPeriod, 12, 26, 9, 0, 0, j);
                     
                     usdcad = iMACD("USDCAD",chartPeriod, 12, 26, 9, 0, 0, j);
                     usdchf = iMACD("USDCHF",chartPeriod, 12, 26, 9, 0, 0, j);
                     usdjpy = iMACD("USDJPY",chartPeriod, 12, 26, 9, 0, 0, j);
                     eurgbp = iMACD("EURGBP",chartPeriod, 12, 26, 9, 0, 0, j);
                     
                     eurjpy = iMACD("EURJPY",chartPeriod, 12, 26, 9, 0, 0, j);
                     eurchf = iMACD("EURCHF",chartPeriod, 12, 26, 9, 0, 0, j);
                     eurnzd = iMACD("EURNZD",chartPeriod, 12, 26, 9, 0, 0, j);
                     eurcad = iMACD("EURCAD",chartPeriod, 12, 26, 9, 0, 0, j);
                     
                     euraud = iMACD("EURAUD",chartPeriod, 12, 26, 9, 0, 0, j);      
                     gbpaud = iMACD("GBPAUD",chartPeriod, 12, 26, 9, 0, 0, j);
                     gbpcad = iMACD("GBPCAD",chartPeriod, 12, 26, 9, 0, 0, j);
                     gbpchf = iMACD("GBPCHF",chartPeriod, 12, 26, 9, 0, 0, j);
                     
                     gbpjpy = iMACD("GBPJPY",chartPeriod, 12, 26, 9, 0, 0, j);
                     gbpnzd = iMACD("GBPNZD",chartPeriod, 12, 26, 9, 0, 0, j);
                     audcad = iMACD("AUDCAD",chartPeriod, 12, 26, 9, 0, 0, j);
                     audchf = iMACD("AUDCHF",chartPeriod, 12, 26, 9, 0, 0, j);
                     
                     audjpy = iMACD("AUDJPY",chartPeriod, 12, 26, 9, 0, 0, j);
                     audnzd = iMACD("AUDNZD",chartPeriod, 12, 26, 9, 0, 0, j);
                     cadjpy = iMACD("CADJPY",chartPeriod, 12, 26, 9, 0, 0, j);
                     chfjpy = iMACD("CHFJPY",chartPeriod, 12, 26, 9, 0, 0, j);
                     
                     nzdjpy = iMACD("NZDJPY",chartPeriod, 12, 26, 9, 0, 0, j);
                     nzdcad = iMACD("NZDCAD",chartPeriod, 12, 26, 9, 0, 0, j);
                     nzdchf = iMACD("NZDCHF",chartPeriod, 12, 26, 9, 0, 0, j);
                     cadchf = iMACD("CADCHF",chartPeriod, 12, 26, 9, 0, 0, j);
                     
                     
                     data = string(TIME)+","+string(eurusd)+"," + string(gbpusd) + "," +string(audusd)+ "," +string(nzdusd)+ ","
                                            +string(usdcad)+"," + string(usdchf) + "," +string(usdjpy)+ "," +string(eurgbp)+ ","
                                            +string(eurjpy)+"," + string(eurchf) + "," +string(eurnzd)+ "," +string(eurcad)+ ","
                                            +string(euraud)+"," + string(gbpaud) + "," +string(gbpcad)+ "," +string(gbpchf)+ ","
                                            +string(gbpjpy)+"," + string(gbpnzd) + "," +string(audcad)+ "," +string(audchf)+ ","
                                            +string(audjpy)+"," + string(audnzd) + "," +string(cadjpy)+ "," +string(chfjpy)+ ","
                                            +string(nzdjpy)+"," + string(nzdcad) + "," +string(nzdchf)+ "," +string(cadchf);
                  FileWrite(handle,data);   //write data to the file during each for loop iteration
                     
                 }
               
               //             
                FileClose(handle);        //close file when data write is over
               //---------------------------------------------------------------------------------------------
         
  }       