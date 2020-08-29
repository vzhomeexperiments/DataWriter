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
               collectAndWrite(Symbol(), FileNameMix+Symbol()+".csv", chartPeriod, UseBarsCollect);
               }
               
            if (IsTesting()== false) 
               {
               for(int c = 0; c < ArraySize(pairs); c++)
                     {collectAndWrite(pairs[c],FileNameMix+pairs[c]+".csv", chartPeriod, UseBarsCollect);
                     if (ShowScreenComments) Comment(commentText); }
               }
            

      
      if(ShowScreenComments) Comment(commentText);

         
      }
      
      
  }
//+------------------------------------------------------------------+

void collectAndWrite(string symboll, string filename, int charPer1, int barsCollect)
// function to record 28 currencies pairs close price to the file (file to be used by all R scripts)
 {
 
int digits = MarketInfo(symboll, MODE_DIGITS); 
 
 
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
                    
                     string ind[16];
                     
                     ind[0]  = DoubleToStr(iClose(symboll,charPer1,j),digits);
                     ind[1]  = DoubleToStr(iClose(symboll,charPer1,j+34),digits);
                     //AC
                     ind[2]  = DoubleToStr(iAC(symboll,charPer1, j),3);
                     ind[3]  = DoubleToStr(iAC(symboll,charPer1, j+2),3);
                     ind[4]  = DoubleToStr(iAC(symboll,charPer1, j+3),3);
                     ind[5]  = DoubleToStr(iAC(symboll,charPer1, j+5),3);
                     ind[6]  = DoubleToStr(iAC(symboll,charPer1, j+8),3);
                     ind[7]  = DoubleToStr(iAC(symboll,charPer1, j+13),3);
                     ind[8]  = DoubleToStr(iAC(symboll,charPer1, j+21),3);
                     ind[9]  = DoubleToStr(iAC(symboll,charPer1, j+34),3);
                     //AD
                     ind[10]  = DoubleToStr(iAC(symboll,charPer1, j),3);
                     ind[11]  = DoubleToStr(iAC(symboll,charPer1, j+2),3);
                     ind[12]  = DoubleToStr(iAC(symboll,charPer1, j+3),3);
                     ind[13]  = DoubleToStr(iAC(symboll,charPer1, j+5),3);
                     ind[14]  = DoubleToStr(iAC(symboll,charPer1, j+8),3);
                     ind[15]  = DoubleToStr(iAC(symboll,charPer1, j+13),3);
                     ind[16]  = DoubleToStr(iAC(symboll,charPer1, j+21),3);
                     ind[17]  = DoubleToStr(iAC(symboll,charPer1, j+34),3); 
                     //ADX
                     ind[18]  = DoubleToStr(iADX(symboll,charPer1, 8,PRICE_MEDIAN, MODE_MAIN,j),3);
                     ind[19] = DoubleToStr(iADX(symboll,charPer1, 8,PRICE_MEDIAN, MODE_MAIN,j+2),3);
                     ind[20] = DoubleToStr(iADX(symboll,charPer1, 8,PRICE_MEDIAN, MODE_MAIN,j+3),3);
                     ind[21] = DoubleToStr(iADX(symboll,charPer1, 8,PRICE_MEDIAN, MODE_MAIN,j+5),3);
                     ind[22] = DoubleToStr(iADX(symboll,charPer1, 8,PRICE_MEDIAN, MODE_MAIN,j+8),3);
                     ind[23] = DoubleToStr(iADX(symboll,charPer1, 8,PRICE_MEDIAN, MODE_MAIN,j+13),3);
                     ind[24] = DoubleToStr(iADX(symboll,charPer1, 8,PRICE_MEDIAN, MODE_MAIN,j+21),3);
                     ind[25] = DoubleToStr(iADX(symboll,charPer1, 8,PRICE_MEDIAN, MODE_MAIN,j+34),3);
                     //ATR
                     ind[26] = DoubleToStr(iATR(symboll,charPer1, 8,j),digits);
                     ind[27] = DoubleToStr(iATR(symboll,charPer1, 8,j+2),digits);
                     ind[28] = DoubleToStr(iATR(symboll,charPer1, 8,j+3),digits);
                     ind[29] = DoubleToStr(iATR(symboll,charPer1, 8,j+5),digits);
                     ind[30] = DoubleToStr(iATR(symboll,charPer1, 8,j+8),digits);
                     ind[31] = DoubleToStr(iATR(symboll,charPer1, 8,j+13),digits);
                     ind[32] = DoubleToStr(iATR(symboll,charPer1, 8,j+21),digits);
                     ind[33] = DoubleToStr(iATR(symboll,charPer1, 8,j+34),digits);
                     
                     
                     //BearsPower
                     ind[34] = DoubleToStr(iBearsPower(symboll,charPer1, 8, PRICE_MEDIAN, j),digits);
                     ind[35] = DoubleToStr(iBearsPower(symboll,charPer1, 8, PRICE_MEDIAN, j+2),digits);
                     ind[36] = DoubleToStr(iBearsPower(symboll,charPer1, 8, PRICE_MEDIAN, j+3),digits);
                     ind[37] = DoubleToStr(iBearsPower(symboll,charPer1, 8, PRICE_MEDIAN, j+5),digits);
                     ind[38] = DoubleToStr(iBearsPower(symboll,charPer1, 8, PRICE_MEDIAN, j+8),digits);
                     ind[39] = DoubleToStr(iBearsPower(symboll,charPer1, 8, PRICE_MEDIAN, j+13),digits);
                     ind[40] = DoubleToStr(iBearsPower(symboll,charPer1, 8, PRICE_MEDIAN, j+21),digits);
                     ind[41] = DoubleToStr(iBearsPower(symboll,charPer1, 8, PRICE_MEDIAN, j+34),digits);
                     //BullsPower
                     ind[42] = DoubleToStr(iBullsPower(symboll,charPer1, 8, PRICE_MEDIAN, j),digits);
                     ind[43] = DoubleToStr(iBullsPower(symboll,charPer1, 8, PRICE_MEDIAN, j+2),digits);
                     ind[44] = DoubleToStr(iBullsPower(symboll,charPer1, 8, PRICE_MEDIAN, j+3),digits);
                     ind[45] = DoubleToStr(iBullsPower(symboll,charPer1, 8, PRICE_MEDIAN, j+5),digits);
                     ind[46] = DoubleToStr(iBullsPower(symboll,charPer1, 8, PRICE_MEDIAN, j+8),digits);
                     ind[47] = DoubleToStr(iBullsPower(symboll,charPer1, 8, PRICE_MEDIAN, j+13),digits);
                     ind[48] = DoubleToStr(iBullsPower(symboll,charPer1, 8, PRICE_MEDIAN, j+21),digits);
                     ind[49] = DoubleToStr(iBullsPower(symboll,charPer1, 8, PRICE_MEDIAN, j+34),digits);
                     
                     
                     //CCI
                     ind[50] = DoubleToStr(iCCI(symboll,charPer1, 8, PRICE_MEDIAN, j),3);
                     ind[51] = DoubleToStr(iCCI(symboll,charPer1, 8, PRICE_MEDIAN, j+2),3);
                     ind[52] = DoubleToStr(iCCI(symboll,charPer1, 8, PRICE_MEDIAN, j+3),3);
                     ind[53] = DoubleToStr(iCCI(symboll,charPer1, 8, PRICE_MEDIAN, j+5),3);
                     ind[54] = DoubleToStr(iCCI(symboll,charPer1, 8, PRICE_MEDIAN, j+8),3);
                     ind[55] = DoubleToStr(iCCI(symboll,charPer1, 8, PRICE_MEDIAN, j+13),3);
                     ind[56] = DoubleToStr(iCCI(symboll,charPer1, 8, PRICE_MEDIAN, j+21),3);
                     ind[57] = DoubleToStr(iCCI(symboll,charPer1, 8, PRICE_MEDIAN, j+34),3);
                     

                     //Momentum             
                     ind[58] = DoubleToStr(iMomentum(symboll,charPer1, 8, PRICE_MEDIAN, j),3);
                     ind[59] = DoubleToStr(iMomentum(symboll,charPer1, 8, PRICE_MEDIAN, j+2),3);
                     ind[60] = DoubleToStr(iMomentum(symboll,charPer1, 8, PRICE_MEDIAN, j+3),3);
                     ind[61] = DoubleToStr(iMomentum(symboll,charPer1, 8, PRICE_MEDIAN, j+5),3);
                     ind[62] = DoubleToStr(iMomentum(symboll,charPer1, 8, PRICE_MEDIAN, j+8),3);
                     ind[63] = DoubleToStr(iMomentum(symboll,charPer1, 8, PRICE_MEDIAN, j+13),3);
                     ind[64] = DoubleToStr(iMomentum(symboll,charPer1, 8, PRICE_MEDIAN, j+21),3);
                     ind[65] = DoubleToStr(iMomentum(symboll,charPer1, 8, PRICE_MEDIAN, j+34),3);
                     
                                          
                     //MACD
                     ind[66] = DoubleToStr(iMACD( symboll,charPer1, 12, 26, 9, 0, 0, j),digits);
                     ind[67] = DoubleToStr(iMACD(symboll,charPer1, 12, 26, 9, 0, 0, j+2),digits);
                     ind[68] = DoubleToStr(iMACD(symboll,charPer1, 12, 26, 9, 0, 0, j+3),digits);
                     ind[69] = DoubleToStr(iMACD(symboll,charPer1, 12, 26, 9, 0, 0, j+5),digits);
                     ind[70] = DoubleToStr(iMACD(symboll,charPer1, 12, 26, 9, 0, 0, j+8),digits);
                     ind[71] = DoubleToStr(iMACD(symboll,charPer1, 12, 26, 9, 0, 0, j+13),digits);
                     ind[72] = DoubleToStr(iMACD(symboll,charPer1, 12, 26, 9, 0, 0, j+21),digits);
                     ind[73] = DoubleToStr(iMACD(symboll,charPer1, 12, 26, 9, 0, 0, j+34),digits);
                     

                     //RSI
                     ind[74]  = DoubleToStr(iRSI(symboll,charPer1, 8, PRICE_MEDIAN, j),3);
                     ind[75]  = DoubleToStr(iRSI(symboll,charPer1, 8, PRICE_MEDIAN, j+2),3);
                     ind[76]  = DoubleToStr(iRSI(symboll,charPer1, 8, PRICE_MEDIAN, j+3),3);
                     ind[77]  = DoubleToStr(iRSI(symboll,charPer1, 8, PRICE_MEDIAN, j+5),3);
                     ind[78]  = DoubleToStr(iRSI(symboll,charPer1, 8, PRICE_MEDIAN, j+8),3);
                     ind[79]  = DoubleToStr(iRSI(symboll,charPer1, 8, PRICE_MEDIAN, j+13),3);
                     ind[80]  = DoubleToStr(iRSI(symboll,charPer1, 8, PRICE_MEDIAN, j+21),3);
                     ind[81]  = DoubleToStr(iRSI(symboll,charPer1, 8, PRICE_MEDIAN, j+34),3);
                     
                     
                     //MFI
                     ind[82]  = DoubleToStr(iMFI(symboll,charPer1, 8, j),3);
                     ind[83]  = DoubleToStr(iMFI(symboll,charPer1, 8, j+2),3);
                     ind[84]  = DoubleToStr(iMFI(symboll,charPer1, 8, j+3),3);
                     ind[85]  = DoubleToStr(iMFI(symboll,charPer1, 8, j+5),3);
                     ind[86]  = DoubleToStr(iMFI(symboll,charPer1, 8, j+8),3);
                     ind[87]  = DoubleToStr(iMFI(symboll,charPer1, 8, j+13),3);
                     ind[88]  = DoubleToStr(iMFI(symboll,charPer1, 8, j+21),3);
                     ind[89]  = DoubleToStr(iMFI(symboll,charPer1, 8, j+34),3);
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                    
           
                     
                     
                     //Bands Upper Short Term 
                     ind[90] = DoubleToStr(iBands(symboll,charPer1, 50, 0, 0, PRICE_CLOSE, MODE_UPPER, j),digits);
                     ind[91] = DoubleToStr(iBands(symboll,charPer1, 50, 0, 0, PRICE_CLOSE, MODE_UPPER, j+2),digits);
                     ind[92] = DoubleToStr(iBands(symboll,charPer1, 50, 0, 0, PRICE_CLOSE, MODE_UPPER, j+3),digits);
                     ind[93] = DoubleToStr(iBands(symboll,charPer1, 50, 0, 0, PRICE_CLOSE, MODE_UPPER, j+5),digits);
                     ind[94] = DoubleToStr(iBands(symboll,charPer1, 50, 0, 0, PRICE_CLOSE, MODE_UPPER, j+8),digits);
                     ind[95] = DoubleToStr(iBands(symboll,charPer1, 50, 0, 0, PRICE_CLOSE, MODE_UPPER, j+13),digits);
                     ind[96] = DoubleToStr(iBands(symboll,charPer1, 50, 0, 0, PRICE_CLOSE, MODE_UPPER, j+21),digits);
                     ind[97] = DoubleToStr(iBands(symboll,charPer1, 50, 0, 0, PRICE_CLOSE, MODE_UPPER, j+34),digits);
                    
                     //Bands Lower Short Term 
                     ind[98] = DoubleToStr(iBands(symboll,charPer1, 50, 0, 0, PRICE_CLOSE, MODE_LOWER, j),digits);
                     ind[99] = DoubleToStr(iBands(symboll,charPer1, 50, 0, 0, PRICE_CLOSE, MODE_LOWER, j+2),digits);
                     ind[100] = DoubleToStr(iBands(symboll,charPer1, 50, 0, 0, PRICE_CLOSE, MODE_LOWER, j+3),digits);
                     ind[101] = DoubleToStr(iBands(symboll,charPer1, 50, 0, 0, PRICE_CLOSE, MODE_LOWER, j+5),digits);
                     ind[102] = DoubleToStr(iBands(symboll,charPer1, 50, 0, 0, PRICE_CLOSE, MODE_LOWER, j+8),digits);
                     ind[103] = DoubleToStr(iBands(symboll,charPer1, 50, 0, 0, PRICE_CLOSE, MODE_LOWER, j+13),digits);
                     ind[104] = DoubleToStr(iBands(symboll,charPer1, 50, 0, 0, PRICE_CLOSE, MODE_LOWER, j+21),digits);
                     ind[105] = DoubleToStr(iBands(symboll,charPer1, 50, 0, 0, PRICE_CLOSE, MODE_LOWER, j+34),digits);
                     
                     
                     //MA Short Term 
                     ind[106] = DoubleToStr(iMA(symboll,charPer1,  50, 0, MODE_EMA, PRICE_CLOSE, j),digits);
                     ind[107] = DoubleToStr(iMA(symboll,charPer1,  50, 0, MODE_EMA, PRICE_CLOSE, j+2),digits);
                     ind[108] = DoubleToStr(iMA(symboll,charPer1,  50, 0, MODE_EMA, PRICE_CLOSE, j+3),digits);
                     ind[109] = DoubleToStr(iMA(symboll,charPer1,  50, 0, MODE_EMA, PRICE_CLOSE, j+5),digits);
                     ind[110] = DoubleToStr(iMA(symboll,charPer1,  50, 0, MODE_EMA, PRICE_CLOSE, j+8),digits);
                     ind[111] = DoubleToStr(iMA(symboll,charPer1,  50, 0, MODE_EMA, PRICE_CLOSE, j+13),digits);
                     ind[112] = DoubleToStr(iMA(symboll,charPer1,  50, 0, MODE_EMA, PRICE_CLOSE, j+21),digits);
                     ind[113] = DoubleToStr(iMA(symboll,charPer1,  50, 0, MODE_EMA, PRICE_CLOSE, j+34),digits);
                     
                     
                     
                     
                     
                     //Bands Upper Mid Term 
                     ind[114] = DoubleToStr(iBands(symboll,charPer1, 100, 0, 0, PRICE_CLOSE, MODE_UPPER, j),digits);
                     ind[115] = DoubleToStr(iBands(symboll,charPer1, 100, 0, 0, PRICE_CLOSE, MODE_UPPER, j+2),digits);
                     ind[116] = DoubleToStr(iBands(symboll,charPer1, 100, 0, 0, PRICE_CLOSE, MODE_UPPER, j+3),digits);
                     ind[117] = DoubleToStr(iBands(symboll,charPer1, 100, 0, 0, PRICE_CLOSE, MODE_UPPER, j+5),digits);
                     ind[118] = DoubleToStr(iBands(symboll,charPer1, 100, 0, 0, PRICE_CLOSE, MODE_UPPER, j+8),digits);
                     ind[119] = DoubleToStr(iBands(symboll,charPer1, 100, 0, 0, PRICE_CLOSE, MODE_UPPER, j+13),digits);
                     ind[120] = DoubleToStr(iBands(symboll,charPer1, 100, 0, 0, PRICE_CLOSE, MODE_UPPER, j+21),digits);
                     ind[121] = DoubleToStr(iBands(symboll,charPer1, 100, 0, 0, PRICE_CLOSE, MODE_UPPER, j+34),digits);
                     
                     //Bands Lower Mid Term 
                     ind[122] = DoubleToStr(iBands(symboll,charPer1, 100, 0, 0, PRICE_CLOSE, MODE_LOWER, j),digits);
                     ind[123] = DoubleToStr(iBands(symboll,charPer1, 100, 0, 0, PRICE_CLOSE, MODE_LOWER, j+2),digits);
                     ind[124] = DoubleToStr(iBands(symboll,charPer1, 100, 0, 0, PRICE_CLOSE, MODE_LOWER, j+3),digits);
                     ind[125] = DoubleToStr(iBands(symboll,charPer1, 100, 0, 0, PRICE_CLOSE, MODE_LOWER, j+5),digits);
                     ind[126] = DoubleToStr(iBands(symboll,charPer1, 100, 0, 0, PRICE_CLOSE, MODE_LOWER, j+8),digits);
                     ind[127] = DoubleToStr(iBands(symboll,charPer1, 100, 0, 0, PRICE_CLOSE, MODE_LOWER, j+13),digits);
                     ind[128] = DoubleToStr(iBands(symboll,charPer1, 100, 0, 0, PRICE_CLOSE, MODE_LOWER, j+21),digits);
                     ind[129] = DoubleToStr(iBands(symboll,charPer1, 100, 0, 0, PRICE_CLOSE, MODE_LOWER, j+34),digits);
                     
                     
                     //MA Mid Term 
                     ind[130] = DoubleToStr(iMA(symboll,charPer1,  100, 0, MODE_EMA, PRICE_CLOSE, j),digits);
                     ind[131] = DoubleToStr(iMA(symboll,charPer1,  100, 0, MODE_EMA, PRICE_CLOSE, j+2),digits);
                     ind[132] = DoubleToStr(iMA(symboll,charPer1,  100, 0, MODE_EMA, PRICE_CLOSE, j+3),digits);
                     ind[133] = DoubleToStr(iMA(symboll,charPer1,  100, 0, MODE_EMA, PRICE_CLOSE, j+5),digits);
                     ind[134] = DoubleToStr(iMA(symboll,charPer1,  100, 0, MODE_EMA, PRICE_CLOSE, j+8),digits);
                     ind[135] = DoubleToStr(iMA(symboll,charPer1,  100, 0, MODE_EMA, PRICE_CLOSE, j+13),digits);
                     ind[136] = DoubleToStr(iMA(symboll,charPer1,  100, 0, MODE_EMA, PRICE_CLOSE, j+21),digits);
                     ind[137] = DoubleToStr(iMA(symboll,charPer1,  100, 0, MODE_EMA, PRICE_CLOSE, j+34),digits);
                     
                     
                     
                     
                     
                     //Bands Upper Long Term 
                     ind[138] = DoubleToStr(iBands(symboll,charPer1, 200, 0, 0, PRICE_CLOSE, MODE_UPPER, j),digits);
                     ind[139] = DoubleToStr(iBands(symboll,charPer1, 200, 0, 0, PRICE_CLOSE, MODE_UPPER, j+2),digits);
                     ind[140] = DoubleToStr(iBands(symboll,charPer1, 200, 0, 0, PRICE_CLOSE, MODE_UPPER, j+3),digits);
                     ind[141] = DoubleToStr(iBands(symboll,charPer1, 200, 0, 0, PRICE_CLOSE, MODE_UPPER, j+5),digits);
                     ind[142] = DoubleToStr(iBands(symboll,charPer1, 200, 0, 0, PRICE_CLOSE, MODE_UPPER, j+8),digits);
                     ind[143] = DoubleToStr(iBands(symboll,charPer1, 200, 0, 0, PRICE_CLOSE, MODE_UPPER, j+13),digits);
                     ind[144] = DoubleToStr(iBands(symboll,charPer1, 200, 0, 0, PRICE_CLOSE, MODE_UPPER, j+21),digits);
                     ind[145] = DoubleToStr(iBands(symboll,charPer1, 200, 0, 0, PRICE_CLOSE, MODE_UPPER, j+34),digits);
                     
                     //Bands Lower Long Term 
                     ind[146] = DoubleToStr(iBands(symboll,charPer1, 200, 0, 0, PRICE_CLOSE, MODE_LOWER, j),digits);
                     ind[147] = DoubleToStr(iBands(symboll,charPer1, 200, 0, 0, PRICE_CLOSE, MODE_LOWER, j+2),digits);
                     ind[148] = DoubleToStr(iBands(symboll,charPer1, 200, 0, 0, PRICE_CLOSE, MODE_LOWER, j+3),digits);
                     ind[149] = DoubleToStr(iBands(symboll,charPer1, 200, 0, 0, PRICE_CLOSE, MODE_LOWER, j+5),digits);
                     ind[150] = DoubleToStr(iBands(symboll,charPer1, 200, 0, 0, PRICE_CLOSE, MODE_LOWER, j+8),digits);
                     ind[151] = DoubleToStr(iBands(symboll,charPer1, 200, 0, 0, PRICE_CLOSE, MODE_LOWER, j+13),digits);
                     ind[152] = DoubleToStr(iBands(symboll,charPer1, 200, 0, 0, PRICE_CLOSE, MODE_LOWER, j+21),digits);
                     ind[153] = DoubleToStr(iBands(symboll,charPer1, 200, 0, 0, PRICE_CLOSE, MODE_LOWER, j+34),digits);
                     
                     
                     //MA Long Term 
                     ind[154] = DoubleToStr(iMA(symboll,charPer1,  200, 0, MODE_EMA, PRICE_CLOSE, j),digits);
                     ind[155] = DoubleToStr(iMA(symboll,charPer1,  200, 0, MODE_EMA, PRICE_CLOSE, j+2),digits);
                     ind[156] = DoubleToStr(iMA(symboll,charPer1,  200, 0, MODE_EMA, PRICE_CLOSE, j+3),digits);
                     ind[157] = DoubleToStr(iMA(symboll,charPer1,  200, 0, MODE_EMA, PRICE_CLOSE, j+5),digits);
                     ind[158] = DoubleToStr(iMA(symboll,charPer1,  200, 0, MODE_EMA, PRICE_CLOSE, j+8),digits);
                     ind[159] = DoubleToStr(iMA(symboll,charPer1,  200, 0, MODE_EMA, PRICE_CLOSE, j+13),digits);
                     ind[160] = DoubleToStr(iMA(symboll,charPer1,  200, 0, MODE_EMA, PRICE_CLOSE, j+21),digits);
                     ind[161] = DoubleToStr(iMA(symboll,charPer1,  200, 0, MODE_EMA, PRICE_CLOSE, j+34),digits);
                     
                    
                     
                     
                     
                     for(int i=0;i<ArraySize(ind);i++) data = data + ","+ind[i];   
                     
                     FileWrite(handle,data);   //write data to the file during each for loop iteration
                 }
               
               //             
                FileClose(handle);        //close file when data write is over
               //---------------------------------------------------------------------------------------------
         
  }
        

