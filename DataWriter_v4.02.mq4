//+------------------------------------------------------------------+
//|                                                   DataWriter.mq4 |
//|                                 Copyright 2018, Vladimir Zhbanko |
//+------------------------------------------------------------------+
#include <06_NormalizeDouble.mqh>

#property copyright "Copyright 2018, Vladimir Zhbanko"
#property link      "https://vladdsm.github.io/myblog_attempt/"
#property version   "4.02"
#property strict

/*
PURPOSE: Retrieve price and Indicator data for an asset 
USE: Data will be used for Decision Support System in R
WANT TO LEARN HOW TO USE?

https://www.udemy.com/your-home-trading-environment/?couponCode=LAZYTRADE-GIT
https://www.udemy.com/your-trading-robot/?couponCode=LAZYTRADE-GIT

*/


extern string  Header1 = "-----EA Main Settings-------";
extern int     UseBarsHistory        = 14300;
extern int     UseBarsCollect        = 14200;    
extern ENUM_TIMEFRAMES  chartPeriod           = 15;  // Choose the timeframe to retrive the data
extern bool    CollectClosePrice     = False;
extern bool    CollectOpenPrice      = True;
extern bool    CollectLowerPrice     = False;
extern bool    CollectHigherPrice    = False;
extern bool    CollectRSI            = False;
extern bool    CollectBullPower      = False;
extern bool    CollectBearPower      = False;
extern bool    CollectATR8           = False;
extern bool    CollectMACD           = False;
extern bool    CollectStoch          = False;
extern string  DashboardComment      = "Record financial assets data to files"; // change this comment for descriptive purposes

string FileNamePrx1 = "AI_CP";
string FileNamePrx2 = "AI_OP";
string FileNamePrx3 = "AI_LP";
string FileNamePrx4 = "AI_HP";
string FileNameRsi1 = "AI_RSI";
string FileNameBull = "AI_BullPow";
string FileNameBear = "AI_BearPow";
string FileNameAtr1 = "AI_Atr8";
string FileNameMacd = "AI_Macd";
string FileNameStoch = "AI_Stoch";

string Pairs[] = {"EURUSD","GBPUSD","AUDUSD","NZDUSD","USDCAD","USDCHF","USDJPY","EURGBP",
                  "EURJPY","EURCHF","EURNZD","EURCAD","EURAUD","GBPAUD","GBPCAD","GBPCHF",
                  "GBPJPY","GBPNZD","AUDCAD","AUDCHF","AUDJPY","AUDNZD","CADJPY","CHFJPY",
                  "NZDJPY","NZDCAD","NZDCHF","CADCHF"};



/*
Content:

2. Function writeDataCP          collect Close Price data   
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
      //useful to generate files when market is closed
      if(CollectClosePrice)writeDataCP(FileNamePrx1 + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv", chartPeriod, UseBarsCollect);
      //record open price data
      if(CollectOpenPrice)writeDataOP(FileNamePrx2 + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv", chartPeriod, UseBarsCollect);
      //record low price data
      if(CollectLowerPrice)writeDataHP(FileNamePrx3 + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv", chartPeriod, UseBarsCollect);
      //record high price data
      if(CollectHigherPrice)writeDataLP(FileNamePrx4 + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv", chartPeriod, UseBarsCollect);
      //record rsi indicator data
      if(CollectRSI)writeDataRSI(FileNameRsi1 + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv", chartPeriod, UseBarsCollect);
      //record bull power data
      if(CollectBullPower)writeDataBullPow(FileNameBull + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv", chartPeriod, UseBarsCollect);
      //record bear power data
      if(CollectBearPower)writeDataBearPow(FileNameBear + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv", chartPeriod, UseBarsCollect);
      //record atr data
      if(CollectATR8)writeDataAtr(FileNameAtr1 + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv", chartPeriod, UseBarsCollect);   
      //record macd data
      if(CollectMACD)writeDataMacd(FileNameMacd + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv", chartPeriod, UseBarsCollect);   
      //record Stochastic data
      if(CollectStoch)writeDataStoch(FileNameStoch + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv", chartPeriod, UseBarsCollect);   
            //show dashboard
      ShowDashboard(DashboardComment, 0,
                    FileNamePrx1 + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv", 0,
                    FileNameMacd + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv", 0,
                    "..", 0,
                    "..", 0,
                    "..", 0,
                    "..", 0); 
      
      
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
      //code that only executed in the beginning and once every bar
      if(CollectClosePrice)writeDataCP(FileNamePrx1 + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv", chartPeriod, UseBarsCollect);
      //record open price data
      if(CollectOpenPrice)writeDataOP(FileNamePrx2 + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv", chartPeriod, UseBarsCollect);
      //record low price data
      if(CollectLowerPrice)writeDataHP(FileNamePrx3 + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv", chartPeriod, UseBarsCollect);
      //record high price data
      if(CollectHigherPrice)writeDataLP(FileNamePrx4 + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv", chartPeriod, UseBarsCollect);
      //record rsi indicator data
      if(CollectRSI)writeDataRSI(FileNameRsi1 + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv", chartPeriod, UseBarsCollect);
      //record bull power data
      if(CollectBullPower)writeDataBullPow(FileNameBull + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv", chartPeriod, UseBarsCollect);
      //record bear power data
      if(CollectBearPower)writeDataBearPow(FileNameBear + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv", chartPeriod, UseBarsCollect);
      //record atr data
      if(CollectATR8)writeDataAtr(FileNameAtr1 + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv", chartPeriod, UseBarsCollect);   
      //record macd data
      if(CollectMACD)writeDataMacd(FileNameMacd + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv", chartPeriod, UseBarsCollect);   
      //record Stochastic data
      if(CollectStoch)writeDataStoch(FileNameStoch + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv", chartPeriod, UseBarsCollect);
      //show dashboard
      ShowDashboard(DashboardComment, 0,
                    FileNamePrx1 + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv", 0,
                    FileNameMacd + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv", 0,
                    "..", 0,
                    "..", 0,
                    "..", 0,
                    "..", 0); 
         
      }
      
      
  }
//+------------------------------------------------------------------+


        
void writeDataCP(string filename, int charPer, int barsCollect)
// function to record 28 currencies pairs close price to the file (file to be used by all R scripts)
 {
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
                   data = string(TIME); 
                    
                   for(int c = 0; c < ArraySize(Pairs); c++)
                    {
                     int digits = MarketInfo(Pairs[c], MODE_DIGITS); 
                     double pairdata = DoubleToString(iClose(Pairs[c],chartPeriod,j), digits);
                     data = data + ","+string(pairdata);
                  
                     }
                     FileWrite(handle,data);   //write data to the file during each for loop iteration
                 }
               
               //             
                FileClose(handle);        //close file when data write is over
               //---------------------------------------------------------------------------------------------
         
  }

void writeDataOP(string filename, int charPer, int barsCollect)
// function to record 28 currencies pairs open bar price to the file (file to be used by all R scripts)
       { 
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
                   data = string(TIME); 
                    
                   for(int c = 0; c < ArraySize(Pairs); c++)
                    {
                     int digits = MarketInfo(Pairs[c], MODE_DIGITS); 
                     double pairdata = DoubleToString(iOpen(Pairs[c],chartPeriod,j), digits);
                     data = data + ","+string(pairdata);
                  
                     }
                     FileWrite(handle,data);   //write data to the file during each for loop iteration
                 }
               
               //             
                FileClose(handle);        //close file when data write is over
               //---------------------------------------------------------------------------------------------
         
  }

void writeDataHP(string filename, int charPer, int barsCollect)
// function to record 28 currencies pairs lowest bar price to the file (file to be used by all R scripts)
 {
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
                   data = string(TIME); 
                    
                   for(int c = 0; c < ArraySize(Pairs); c++)
                    {
                     int digits = MarketInfo(Pairs[c], MODE_DIGITS); 
                     double pairdata = DoubleToString(iHigh(Pairs[c],chartPeriod,j), digits);
                     data = data + ","+string(pairdata);
                  
                     }
                     FileWrite(handle,data);   //write data to the file during each for loop iteration
                 }
               
               //             
                FileClose(handle);        //close file when data write is over
               //---------------------------------------------------------------------------------------------
}

void writeDataLP(string filename, int charPer, int barsCollect)
// function to record 28 currencies pairs lowest bar price to the file (file to be used by all R scripts)
 {
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
                   data = string(TIME); 
                    
                   for(int c = 0; c < ArraySize(Pairs); c++)
                    {
                     int digits = MarketInfo(Pairs[c], MODE_DIGITS); 
                     double pairdata = DoubleToString(iLow(Pairs[c],chartPeriod,j), digits);
                     data = data + ","+string(pairdata);
                  
                     }
                     FileWrite(handle,data);   //write data to the file during each for loop iteration
                 }
               
               //             
                FileClose(handle);        //close file when data write is over
               //---------------------------------------------------------------------------------------------
  }
  
  

void writeDataRSI(string filename, int charPer, int barsCollect)
// function to record 28 currencies pairs close price to the file (file to be used by all R scripts)
 {
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
                   data = string(TIME); 
                    
                   for(int c = 0; c < ArraySize(Pairs); c++)
                    {
                     double pairdata = DoubleToString(iRSI(Pairs[c],chartPeriod, 8, PRICE_MEDIAN, j), 2);
                     data = data + ","+string(pairdata);
                  
                     }
                     FileWrite(handle,data);   //write data to the file during each for loop iteration
                 }
               
               //             
                FileClose(handle);        //close file when data write is over
               //---------------------------------------------------------------------------------------------
  }
  
  
void writeDataBullPow(string filename, int charPer, int barsCollect)
// function to record 28 currencies pairs close price to the file (file to be used by all R scripts)
 {
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
                   data = string(TIME); 
                    
                   for(int c = 0; c < ArraySize(Pairs); c++)
                    {
                     double pairdata = DoubleToString(iBullsPower(Pairs[c],chartPeriod, 8, PRICE_MEDIAN, j), 2);
                     data = data + ","+string(pairdata);
                  
                     }
                     FileWrite(handle,data);   //write data to the file during each for loop iteration
                 }
               
               //             
                FileClose(handle);        //close file when data write is over
               //---------------------------------------------------------------------------------------------
         
  }
  
void writeDataBearPow(string filename, int charPer, int barsCollect)
// function to record 28 currencies pairs close price to the file (file to be used by all R scripts)
 {
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
                   data = string(TIME); 
                    
                   for(int c = 0; c < ArraySize(Pairs); c++)
                    {
                     double pairdata = DoubleToString(iBearsPower(Pairs[c],chartPeriod, 8, PRICE_MEDIAN, j), 2);
                     data = data + ","+string(pairdata);
                  
                     }
                     FileWrite(handle,data);   //write data to the file during each for loop iteration
                 }
               
               //             
                FileClose(handle);        //close file when data write is over
               //---------------------------------------------------------------------------------------------
         
  }              
  
void writeDataAtr(string filename, int charPer, int barsCollect)
// function to record 28 currencies pairs close price to the file (file to be used by all R scripts)
 {
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
                   data = string(TIME); 
                    
                   for(int c = 0; c < ArraySize(Pairs); c++)
                    {
                     int digits = MarketInfo(Pairs[c], MODE_DIGITS); 
                     double pairdata = DoubleToString(iATR(Pairs[c],chartPeriod, 8, j), digits);
                     data = data + ","+string(pairdata);
                  
                     }
                     FileWrite(handle,data);   //write data to the file during each for loop iteration
                 }
               
               //             
                FileClose(handle);        //close file when data write is over
               //---------------------------------------------------------------------------------------------
         
  }     
  
void writeDataMacd(string filename, int charPer, int barsCollect)
// function to record 28 currencies pairs MACD to the file (file to be used by all R scripts)
 {
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
                   data = string(TIME); 
                    
                   for(int c = 0; c < ArraySize(Pairs); c++)
                    {
                     double pairdata = iMACD(Pairs[c],chartPeriod, 12, 26, 9, 0, 0, j);
                     data = data + ","+string(pairdata);
                  
                     }
                     FileWrite(handle,data);   //write data to the file during each for loop iteration
                 }
               
               //             
                FileClose(handle);        //close file when data write is over
               //---------------------------------------------------------------------------------------------
         
  }       
  
void writeDataStoch(string filename, int charPer, int barsCollect)
// function to record 28 currencies pairs Stochastic indicator to the file (file to be used by all R scripts)
 {
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
                   data = string(TIME); 
                    
                   for(int c = 0; c < ArraySize(Pairs); c++)
                    {
                     double pairdata = iStochastic(Pairs[c],chartPeriod,34, 13, 8, 0, 0, 0, j);
                     data = data + ","+string(pairdata);
                  
                     }
                     FileWrite(handle,data);   //write data to the file during each for loop iteration
                 }
               
               //             
                FileClose(handle);        //close file when data write is over
               //---------------------------------------------------------------------------------------------
         
  }       
  
 //+------------------------------------------------------------------+
//| Dashboard - Comment Version                                    
//+------------------------------------------------------------------+
void ShowDashboard(string Descr0, int magic,
                   string Descr1, int Param1,
                   string Descr2, double Param2,
                   string Descr3, int Param3,
                   string Descr4, double Param4,
                   string Descr5, int Param5,
                   string Descr6, double Param6
                     ) 
  {
// Purpose: This function creates a dashboard showing information on your EA using comments function
// Type: Customisable 
// Modify this function to suit your trading robot
//----

string new_line = "\n"; // "\n" or "\n\n" will move the comment to new line
string space = ": ";    // generate space
string underscore = "________________________________";

Comment(
        new_line 
      + Descr0 + space + IntegerToString(magic)
      + new_line
      + underscore  
      + new_line 
      + new_line
      + Descr1 + space + IntegerToString(Param1)
      + new_line
      + Descr2 + space + DoubleToString(Param2, 1)
      + new_line        
      + underscore  
      + new_line 
      + new_line
      + Descr3 + space + IntegerToString(Param3)
      + new_line
      + Descr4 + space + DoubleToString(Param4, 1)
      + new_line        
      + underscore  
      + new_line 
      + new_line
      + Descr5 + space + IntegerToString(Param5)
      + new_line
      + Descr6 + space + DoubleToString(Param6, 1)
      + new_line        
      + underscore  
      + "");
      
      
  }

//+------------------------------------------------------------------+
//| End of Dashboard - Comment Version                                     
//+-------------------------------------------------------