//+------------------------------------------------------------------+
//|                                                   DataWriter.mq4 |
//|                                 Copyright 2016, Vladimir Zhbanko |
//+------------------------------------------------------------------+
#include <06_NormalizeDouble.mqh>

#property copyright "Copyright 2018, Vladimir Zhbanko"
#property link      "https://vladdsm.github.io/myblog_attempt/"
#property version   "2.00"
#property strict

int handle;
string fileName, header, data;

/*
PURPOSE: This will write current prices Ask/Bid and Volume of ticks to the chart every 1Minute
USE: Attach to the chart Period M1
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
   
   // should generate unique time every minute
   
      static datetime Time0;
   if(Time0 == Time[0])
     {
      fileName = (string)Symbol()+"_"+(string)Time0+".csv";
     }
     else
       {
      
      // this should create a unique file at every minute!
      Time0 = Time[0];
      
      // open file handle
      handle = FileOpen(fileName,FILE_CSV|FILE_READ|FILE_WRITE);
      FileSeek(handle,0,SEEK_END);
      
                     // generate data 
                     datetime CLOCK = Time[0]; 
                     double   ASK  = ND(Ask);
                     double   BID  = ND(Bid);
                     long     VOL   = Volume[0]; //iVolume(NULL,PERIOD_M1, 0);
                     
                     // Summarizing the data into one string separated by commas
                     data = (string)CLOCK+","+(string)ASK+","+(string)BID+","+(string)VOL;
      FileWrite(handle,data);   
      //close file when data write is over
      FileClose(handle);      
      }
      
  }
//+------------------------------------------------------------------+