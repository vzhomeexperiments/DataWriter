//+------------------------------------------------------------------+
//|                                                   DataWriter.mq4 |
//|                                 Copyright 2018, Vladimir Zhbanko |
//+------------------------------------------------------------------+

#property copyright "Copyright 2018, Vladimir Zhbanko"
#property link      "https://vladdsm.github.io/myblog_attempt/"
#property version   "4.02"
#property strict
#define EANAME "DataWriter_v4.02"
/*
PURPOSE: Retrieve price and Indicator data for an asset 
USE: Data will be used for Decision Support System in R
HOW TO USE:

https://www.udemy.com/course/your-home-trading-environment/?referralCode=9EAD4CC112A476678658
https://www.udemy.com/course/your-trading-robot/?referralCode=529DCD0085D40BEC410C

*/


extern string           Header1 = "-----EA Main Settings-------";
extern int              UseBarsHistory        = 14300;
extern int              UseBarsCollect        = 14200;    
extern ENUM_TIMEFRAMES  chartPeriod           = 15;  // Choose the timeframe to retrive the data
extern bool             CollectClosePrice     = True;
extern bool             CollectOpenPrice      = False;
extern bool             CollectLowerPrice     = False;
extern bool             CollectHigherPrice    = False;
extern bool             CollectRSI            = True;
extern bool             CollectBullPower      = False;
extern bool             CollectBearPower      = False;
extern bool             CollectATR8           = False;
extern bool             CollectMACD           = True;
extern bool             CollectStoch          = False;
extern bool             ShowScreenComments    = True;

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

string commentText;

string Pairs[] = {"EURUSD","GBPUSD","AUDUSD","NZDUSD","USDCAD","USDCHF","USDJPY","EURGBP",
                  "EURJPY","EURCHF","EURNZD","EURCAD","EURAUD","GBPAUD","GBPCAD","GBPCHF",
                  "GBPJPY","GBPNZD","AUDCAD","AUDCHF","AUDJPY","AUDNZD","CADJPY","CHFJPY",
                  "NZDJPY","NZDCAD","NZDCHF","CADCHF"};



/*
Content:

1. Function writeDataCP          collect Close Price data   
2. Function writeDataOP          collect Open Price data
3. Function writeDataLP          collect Low Price data
4. Function writeDataHP          collect High Price data
5. Function writeDataRSI         collect Rsi data
6. Function writeDataBullPow     collect BullPower data
7. Function writeDataBearPow     collect BearPower data
8. Function writeDataAtr         collect Atr data
9. Function writeDataMacd        collect MACD data 
10.Function writeDataStoch       collect Stoch data 
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
      
      if (ShowScreenComments) Comment("\n Initial files should be written, they will be updated on every new bar ...");
      
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
      //comment
      commentText = StringConcatenate("\n",EANAME); 
       
      //  record time to variable
      Time0 = Time[0];
      //code that only executed in the beginning and once every bar
      //record close price data
      if(CollectClosePrice)
         { 
          writeDataCP(FileNamePrx1 + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv", chartPeriod, UseBarsCollect);
          commentText = commentText + StringConcatenate("\n","Collecting...", FileNamePrx1 + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv"); 
         } 
      //record open price data
      if(CollectOpenPrice)
         {
          writeDataOP(FileNamePrx2 + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv", chartPeriod, UseBarsCollect);
          commentText = commentText + StringConcatenate("\n","Collecting...", FileNamePrx2 + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv");          
         } 
      //record low price data
      if(CollectLowerPrice)
         {
          writeDataHP(FileNamePrx3 + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv", chartPeriod, UseBarsCollect);
          commentText = commentText + StringConcatenate("\n","Collecting...", FileNamePrx3 + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv");          
         } 
      //record high price data
      if(CollectHigherPrice)
         {
          writeDataLP(FileNamePrx4 + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv", chartPeriod, UseBarsCollect);
          commentText = commentText + StringConcatenate("\n","Collecting...", FileNamePrx4 + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv");          
         } 
      //record rsi indicator data
      if(CollectRSI)
         {
          writeDataRSI(FileNameRsi1 + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv", chartPeriod, UseBarsCollect);
          commentText = commentText + StringConcatenate("\n","Collecting...", FileNameRsi1 + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv");          
         } 
      //record bull power data
      if(CollectBullPower)
         {
          writeDataBullPow(FileNameBull + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv", chartPeriod, UseBarsCollect);
          commentText = commentText + StringConcatenate("\n","Collecting...", FileNameBull + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv");          
         } 
      //record bear power data
      if(CollectBearPower)
         {
          writeDataBearPow(FileNameBear + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv", chartPeriod, UseBarsCollect);
          commentText = commentText + StringConcatenate("\n","Collecting...", FileNameBear + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv");          
         } 
      //record atr data
      if(CollectATR8)
         {
          writeDataAtr(FileNameAtr1 + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv", chartPeriod, UseBarsCollect);   
          commentText = commentText + StringConcatenate("\n","Collecting...", FileNameAtr1 + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv");          
         } 
      //record macd data
      if(CollectMACD)
         {
          writeDataMacd(FileNameMacd + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv", chartPeriod, UseBarsCollect);   
          commentText = commentText + StringConcatenate("\n","Collecting...", FileNameMacd + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv");          
         } 
      //record Stochastic data
      if(CollectStoch)
         {
          writeDataStoch(FileNameStoch + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv", chartPeriod, UseBarsCollect);
          commentText = commentText + StringConcatenate("\n","Collecting...", FileNameStoch + string(chartPeriod) + "-" + string(UseBarsCollect) + ".csv");          
         }

      
      
      if(ShowScreenComments) Comment(commentText);

         
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
                     string pairdata = DoubleToStr(iClose(Pairs[c],chartPeriod,j),5);
                     data = data + ","+pairdata;
                  
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
                     string pairdata = DoubleToStr(iOpen(Pairs[c],chartPeriod,j),5);
                     data = data + ","+pairdata;
                  
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
                     string pairdata = DoubleToStr(iHigh(Pairs[c],chartPeriod,j),5);
                     data = data + ","+pairdata;
                  
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
                     string pairdata = DoubleToStr(iLow(Pairs[c],chartPeriod,j),5);
                     data = data + ","+pairdata;
                  
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
                     string pairdata = DoubleToStr(iRSI(Pairs[c],chartPeriod, 8, PRICE_MEDIAN, j),3);
                     data = data + ","+pairdata;
                  
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
                     string pairdata = DoubleToStr(iBullsPower(Pairs[c],chartPeriod, 8, PRICE_MEDIAN, j),5);
                     data = data + ","+pairdata;
                  
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
                     string pairdata = DoubleToStr(iBearsPower(Pairs[c],chartPeriod, 8, PRICE_MEDIAN, j),5);
                     data = data + ","+ pairdata;
                  
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
                     string pairdata = DoubleToStr(iATR(Pairs[c],chartPeriod, 8, j),5);
                     data = data + ","+ pairdata;
                  
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
                     string pairdata = DoubleToStr(iMACD(Pairs[c],chartPeriod, 12, 26, 9, 0, 0, j),8);
                     data = data + ","+ pairdata;
                  
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
                     string pairdata = DoubleToStr(iStochastic(Pairs[c],chartPeriod,34, 13, 8, 0, 0, 0, j),8);
                     data = data + "," + pairdata;
                  
                     }
                     FileWrite(handle,data);   //write data to the file during each for loop iteration
                 }
               
               //             
                FileClose(handle);        //close file when data write is over
               //---------------------------------------------------------------------------------------------
         
  }       
  
