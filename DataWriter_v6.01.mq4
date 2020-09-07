//+------------------------------------------------------------------+
//|                                                   DataWriter.mq4 |
//|                                 Copyright 2018, Vladimir Zhbanko |
//+------------------------------------------------------------------+

#property copyright "Copyright 2020, Vladimir Zhbanko"
#property link      "https://vladdsm.github.io/myblog_attempt/"
#property version   "6.01"
#property strict
#define EANAME "DataWriter_v6.01"
/*
PURPOSE: Retrieve price and Indicator data for an asset 
USE: Data will be used for Decision Support System in R
HOW TO USE:

https://www.udemy.com/course/your-home-trading-environment/?referralCode=9EAD4CC112A476678658
https://www.udemy.com/course/your-trading-robot/?referralCode=529DCD0085D40BEC410C

*/


extern string           Header1 = "-----EA Main Settings-------";
extern int              UseBarsHistory        = 2300;
extern int              UseBarsCollect        = 2200;    
extern ENUM_TIMEFRAMES  chartPeriod           = 60;  // Choose the timeframe to retrive the data

extern bool             ShowScreenComments    = True;

enum ENUM_PAIR_SELECTION
  {
   Manual=0,   // Own Pair list
   Core7=1,    // Core 7
   Core14=2,   // Core 14
   Core28=3,   // All 28 pairs
   AUDPairs=6, // AUD pairs
   CADPairs=8, // CAD pairs
   EURPairs=5, // EUR pairs
   GBPPairs=7, // GBP pairs
   JPYPairs=4, // JPY pairs
   NZDPairs=9, // NZD pairs
   NoAUDPairs=10, // No AUD pairs
   NoCADPairs=11, // No CAD pairs
   NoEURPairs=12, // No EUR pairs
   NoGBPPairs=13, // No GBP pairs
   NoJPYPairs=14, // No JPY pairs
   NoNZDPairs=15, // No NZD pairs 
   ActiveChart=100 // Active Chart
  };
extern ENUM_PAIR_SELECTION   PairsTrading                = Core28; // Pair Selection ------------------------
extern string                OwnPairs                   = "";

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

string FileNameMix = "AI_RSIADX";

string commentText;

//+------------------------------------------------------------------+
//Internal variables declaration
//+------------------------------------------------------------------+
string Core7Pairs[] =  {"AUDUSD","EURUSD","GBPUSD","NZDUSD","USDCAD","USDCHF","USDJPY"};
string Core14Pairs[] = {"AUDJPY","AUDUSD","CHFJPY","EURCHF","EURGBP","EURJPY","EURUSD","GBPCHF","GBPJPY","GBPUSD","NZDJPY","NZDUSD","USDCHF","USDJPY"};
string Core28Pairs[] = {"AUDCAD","AUDCHF","AUDJPY","AUDNZD","AUDUSD","CADCHF","CADJPY","CHFJPY","EURAUD","EURCAD","EURCHF","EURGBP","EURJPY","EURNZD","EURUSD","GBPAUD","GBPCAD","GBPCHF","GBPJPY","GBPNZD","GBPUSD","NZDCAD","NZDCHF","NZDJPY","NZDUSD","USDCAD","USDCHF","USDJPY"};
string JPYPairs[] = {"AUDJPY","CADJPY","CHFJPY","EURJPY","GBPJPY","NZDJPY","USDJPY"};
string EURPairs[] = {"EURAUD","EURCAD","EURCHF","EURGBP","EURJPY","EURNZD","EURUSD"};
string AUDPairs[] = {"AUDCAD","AUDCHF","AUDJPY","AUDNZD","AUDUSD","EURAUD","GBPAUD"};
string GBPPairs[] = {"GBPAUD","GBPCAD","GBPCHF","GBPJPY","GBPNZD","GBPUSD","EURGBP"};
string CADPairs[] = {"CADCHF","CADJPY","AUDCAD","EURCAD","GBPCAD","NZDCAD","USDCAD"};
string NZDPairs[] = {"NZDCAD","NZDCHF","NZDJPY","NZDUSD","AUDNZD","EURNZD","GBPNZD"};
string NoJPYPairs[] = {"AUDCAD","AUDCHF","AUDNZD","AUDUSD","CADCHF","EURAUD","EURCAD","EURCHF","EURGBP","EURNZD","EURUSD","GBPAUD","GBPCAD","GBPCHF","GBPNZD","GBPUSD","NZDCAD","NZDCHF","NZDUSD","USDCAD","USDCHF"};
string NoEURPairs[] = {"AUDCAD","AUDCHF","AUDJPY","AUDNZD","AUDUSD","CADCHF","CADJPY","CHFJPY","GBPAUD","GBPCAD","GBPCHF","GBPJPY","GBPNZD","GBPUSD","NZDCAD","NZDCHF","NZDJPY","NZDUSD","USDCAD","USDCHF","USDJPY"};
string NoAUDPairs[] = {"CADCHF","CADJPY","CHFJPY","EURCAD","EURCHF","EURGBP","EURJPY","EURNZD","EURUSD","GBPCAD","GBPCHF","GBPJPY","GBPNZD","GBPUSD","NZDCAD","NZDCHF","NZDJPY","NZDUSD","USDCAD","USDCHF","USDJPY"};
string NoGBPPairs[] = {"AUDCAD","AUDCHF","AUDJPY","AUDNZD","AUDUSD","CADCHF","CADJPY","CHFJPY","EURAUD","EURCAD","EURCHF","EURJPY","EURNZD","EURUSD","NZDCAD","NZDCHF","NZDJPY","NZDUSD","USDCAD","USDCHF","USDJPY"};
string NoCADPairs[] = {"AUDCHF","AUDJPY","AUDNZD","AUDUSD","CHFJPY","EURAUD","EURCHF","EURGBP","EURJPY","EURNZD","EURUSD","GBPAUD","GBPCHF","GBPJPY","GBPNZD","GBPUSD","NZDCHF","NZDJPY","NZDUSD","USDCHF","USDJPY"};
string NoNZDPairs[] = {"AUDCAD","AUDCHF","AUDJPY","AUDUSD","CADCHF","CADJPY","CHFJPY","EURAUD","EURCAD","EURCHF","EURGBP","EURJPY","EURUSD","GBPAUD","GBPCAD","GBPCHF","GBPJPY","GBPUSD","USDCAD","USDCHF","USDJPY"};
string ActiveChart[] = {NULL};

string pairs[];



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
      
   if(PairsTrading == 0)StringSplit(OwnPairs,',',pairs);
   if(PairsTrading == 1)ArrayCopy(pairs,Core7Pairs);
   if(PairsTrading == 2)ArrayCopy(pairs,Core14Pairs);
   if(PairsTrading == 3)ArrayCopy(pairs,Core28Pairs);
   if(PairsTrading == 4)ArrayCopy(pairs,JPYPairs);
   if(PairsTrading == 5)ArrayCopy(pairs,EURPairs);
   if(PairsTrading == 6)ArrayCopy(pairs,AUDPairs);
   if(PairsTrading == 7)ArrayCopy(pairs,GBPPairs);
   if(PairsTrading == 8)ArrayCopy(pairs,CADPairs);
   if(PairsTrading == 9)ArrayCopy(pairs,NZDPairs);
   if(PairsTrading == 10)ArrayCopy(pairs,NoJPYPairs);
   if(PairsTrading == 11)ArrayCopy(pairs,NoEURPairs);
   if(PairsTrading == 12)ArrayCopy(pairs,NoAUDPairs);
   if(PairsTrading == 13)ArrayCopy(pairs,NoGBPPairs);
   if(PairsTrading == 14)ArrayCopy(pairs,NoCADPairs);
   if(PairsTrading == 15)ArrayCopy(pairs,NoNZDPairs);
   if(PairsTrading == 100)ArrayCopy(pairs,ActiveChart);
 
   if(ArraySize(pairs) <= 0){Print("No pairs to trade");return(INIT_FAILED);}
      
      
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
           //code that only executed in the beginning and once every bar
           //  record time to variable
            Time0 = Time[0];
            
            //comment
            commentText = StringConcatenate("\n",EANAME); 
            
            if (IsTesting()== true)
               {
               collectAndWrite(Symbol(), FileNameMix+Symbol()+IntegerToString(chartPeriod)+".csv", chartPeriod, UseBarsCollect);
               }
               
            if (IsTesting()== false) 
               {
               for(int c = 0; c < ArraySize(pairs); c++)
                     {collectAndWrite(pairs[c],FileNameMix+pairs[c]+IntegerToString(chartPeriod)+".csv", chartPeriod, UseBarsCollect);
                     if (ShowScreenComments) Comment(commentText); }
               }
            

      
      if(ShowScreenComments) Comment(commentText);

         
      }
      
      
  }
//+------------------------------------------------------------------+

void collectAndWrite(string symboll, string filename, int charPer1, int barsCollect)
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
                   TIME = iTime(symboll, charPer1, j);  //Time of the bar of the applied chart symbol
                   data = string(TIME); 
                    
                     string ind[18];
                     
                     ind[0]  = DoubleToStr(iClose(symboll,charPer1,j),5);
                     ind[1]  = DoubleToStr(iClose(symboll,charPer1,j+34),5);
                     ind[2]  = DoubleToStr(iRSI(symboll,charPer1, 8, PRICE_MEDIAN, j),3);
                     ind[3]  = DoubleToStr(iRSI(symboll,charPer1, 8, PRICE_MEDIAN, j+2),3);
                     ind[4]  = DoubleToStr(iRSI(symboll,charPer1, 8, PRICE_MEDIAN, j+3),3);
                     ind[5]  = DoubleToStr(iRSI(symboll,charPer1, 8, PRICE_MEDIAN, j+5),3);
                     ind[6]  = DoubleToStr(iRSI(symboll,charPer1, 8, PRICE_MEDIAN, j+8),3);
                     ind[7]  = DoubleToStr(iRSI(symboll,charPer1, 8, PRICE_MEDIAN, j+13),3);
                     ind[8]  = DoubleToStr(iRSI(symboll,charPer1, 8, PRICE_MEDIAN, j+21),3);
                     ind[9]  = DoubleToStr(iRSI(symboll,charPer1, 8, PRICE_MEDIAN, j+34),3);
                     ind[10] = DoubleToStr(iADX(symboll,charPer1, 8,PRICE_MEDIAN, MODE_MAIN,j),3);
                     ind[11] = DoubleToStr(iADX(symboll,charPer1, 8,PRICE_MEDIAN, MODE_MAIN,j+2),3);
                     ind[12] = DoubleToStr(iADX(symboll,charPer1, 8,PRICE_MEDIAN, MODE_MAIN,j+3),3);
                     ind[13] = DoubleToStr(iADX(symboll,charPer1, 8,PRICE_MEDIAN, MODE_MAIN,j+5),3);
                     ind[14] = DoubleToStr(iADX(symboll,charPer1, 8,PRICE_MEDIAN, MODE_MAIN,j+8),3);
                     ind[15] = DoubleToStr(iADX(symboll,charPer1, 8,PRICE_MEDIAN, MODE_MAIN,j+13),3);
                     ind[16] = DoubleToStr(iADX(symboll,charPer1, 8,PRICE_MEDIAN, MODE_MAIN,j+21),3);
                     ind[17] = DoubleToStr(iADX(symboll,charPer1, 8,PRICE_MEDIAN, MODE_MAIN,j+34),3);
                     
                     for(int i=0;i<ArraySize(ind);i++) data = data + ","+ind[i];   
                     
                     FileWrite(handle,data);   //write data to the file during each for loop iteration
                 }
               
               //             
                FileClose(handle);        //close file when data write is over
               //---------------------------------------------------------------------------------------------
         
  }
        

