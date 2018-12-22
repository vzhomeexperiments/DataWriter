//+------------------------------------------------------------------+
//|                                                   DataWriter.mq4 |
//|                                 Copyright 2018, Vladimir Zhbanko |
//+------------------------------------------------------------------+
#include <06_NormalizeDouble.mqh>

#property copyright "Copyright 2018, Vladimir Zhbanko"
#property link      "https://vladdsm.github.io/myblog_attempt/"
#property version   "5.02"
#property strict

/*
PURPOSE: Retrieve price and Indicator data for an asset 
USE: Data will be used for Decision Support System in R - Version For Stock Assets
WANT TO LEARN HOW TO USE?

https://www.udemy.com/your-home-trading-environment/?couponCode=LAZYTRADE-GIT
https://www.udemy.com/your-trading-robot/?couponCode=LAZYTRADE-GIT

*/


extern string  Header1 = "-----EA Main Settings-------";
extern int     UseBarsHistory        = 400;
extern int     UseBarsCollect        = 333;    
extern int     chartPeriod           = 15; //min
extern bool    CollectClosePrice     = True;
extern string  DashboardComment      = "Record financial assets data to files"; // change this comment for descriptive purposes

string FileNamePrx1 = "AI_CP";


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
      
            //show dashboard
      ShowDashboard(DashboardComment, 0,
                    FileNamePrx1 + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv", 0,
                    "..", 0,
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
      
      //show dashboard
      ShowDashboard(DashboardComment, 0,
                    FileNamePrx1 + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv", 0,
                    "..", 0,
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


//---- stocks 
double tesla;
             
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
                     tesla = iClose("#TeslaMotor",chartPeriod,j);
                     
                     
                     data = string(TIME)+","+string(tesla);
                     
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
//+------------------------------------------------------------------+   