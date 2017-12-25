//+------------------------------------------------------------------+
//|                                                   DataWriter.mq4 |
//|                                 Copyright 2016, Vladimir Zhbanko |
//|                                       vladimir.zhbanko@gmail.com |
//+------------------------------------------------------------------+
#include <06_NormalizeDouble.mqh>

#property copyright "Copyright 2016, Vladimir Zhbanko"
#property link      "vladimir.zhbanko@gmail.com"
#property version   "1.00"
#property strict

int handle;
string fileName, header, data;

/*
PURPOSE: 
USE:
*/

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
/*---
   fileName = (string)Symbol()+".csv";//create the name of the file specific for each symbol used...
      // open file handle
      handle = FileOpen(fileName,FILE_CSV|FILE_READ|FILE_WRITE);
      FileSeek(handle,0,SEEK_END);
      header =  "Time"+","+"Open"+","+"High"+","+"Low"+","+"Close"+","+"Volume";
      FileWrite(handle, header);
      //close file when data write is over
      FileClose(handle);        
*/
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
    //recording only once in a minute and only values of the last minute
   static datetime Time0;
   if(Time0 == Time[0])
     {
      
     }
     else
       {
        Time0 = Time[0];
        
            // write a filename
      fileName = (string)Symbol()+".csv";//create the name of the file specific for each symbol used...
      // open file handle
      handle = FileOpen(fileName,FILE_CSV|FILE_READ|FILE_WRITE);
      FileSeek(handle,0,SEEK_END);
      
                     // generate data 
                     datetime CLOCK = iTime(NULL, PERIOD_M1, 1); 
                     double   OPEN  = ND(iOpen(NULL, PERIOD_M1, 1));
                     double   HIGH  = ND(iHigh(NULL, PERIOD_M1, 1));
                     double   LOW   = ND(iLow(NULL, PERIOD_M1, 1));
                     double   CLOSE = ND(iClose(NULL, PERIOD_M1, 1));
                     long     VOL   = iVolume(NULL,PERIOD_M1, 1);
                     
                     // Summarizing the data into one string separated by commas
                     data = (string)CLOCK+","+(string)OPEN+","+(string)HIGH+","+(string)LOW+","+(string)CLOSE+","+(string)VOL;
                     
      FileWrite(handle,data);   
                   
      //close file when data write is over
      FileClose(handle);      
        
       }
  
  }
//+------------------------------------------------------------------+

