//+------------------------------------------------------------------+
//|                                                   DataWriter.mq4 |
//|                                 Copyright 2017, Vladimir Zhbanko |
//|                                       vladimir.zhbanko@gmail.com |
//+------------------------------------------------------------------+
#include <06_NormalizeDouble.mqh>

#property copyright "Copyright 2017, Vladimir Zhbanko"
#property link      "vladimir.zhbanko@gmail.com"
#property version   "3.04"
#property strict

/*
PURPOSE: 
USE:
*/

/* 
DataWriter v3.01 Release Notes: 
- EA that suppose to write information from EA power indicator to the file
- Several working modes are possible
-- write x bars and stop
-- write x bars on every new bar and continue
DataWriter v3.02 Release Notes: 
- EA prepared to record data for instance base learning k-NN
- Same structure of file but different basic parameters
-- collecting two past days to predict next day (96*2 bars)
DataWriter v3.03 Release Notes:
- EA that record currencies closed prices to the file
- information update take place on every bar
DataWriter v3.04 Release Notes:
- also collect: RSI, BullPower, BearPower data

*/
extern string  Header1 = "-----EA Main Settings-------";
extern int     UseBarsHistory        = 200;
extern int     UseBarsCollect        = 195;    
extern int     chartPeriod           = 1440;
extern bool    modeSinglePair        = false;      //when single pair is false all currencies are outputted to the screen, true only those works that are on chart
extern bool    modeStartHour         = false;

string FileNamePow1 = "AllPowersOnce";
string FileNamePow2 = "AllPowers";
string FileNamePrx1 = "AllPricesOnce";
string FileNamePrx2 = "AllPrices";
string FileNameRsi1 = "AllRSI";
string FileNameBull = "AllBullPow";
string FileNameBear = "AllBearPow";


/*
Content:
1. Function writeData            collect Power Data         Line 106
2. Function writeDataPrices      collect Price Data         Line 189
3. Function writeDataRSI         collect Rsi data           Line 275
4. Function writeDataBullPow     collect BullPower data     Line 361
5. Function writeDataBearPow     collect BearPower data     Line 447
*/
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   FileNamePow1 = FileNamePow1 + string(chartPeriod) + ".csv";
   FileNamePrx1 = FileNamePrx1 + string(chartPeriod) + ".csv";
   writeData(FileNamePow1, UseBarsHistory, chartPeriod, modeSinglePair, modeStartHour, UseBarsHistory);
   writeDataPrices(FileNamePrx1, chartPeriod, UseBarsCollect);
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
      //record power indicator data     
      writeData(FileNamePow2 + string(chartPeriod) + ".csv", UseBarsHistory, chartPeriod, modeSinglePair, modeStartHour, UseBarsCollect);
      //record closed price data
      writeDataPrices(FileNamePrx2 + string(chartPeriod) + ".csv", chartPeriod, UseBarsCollect);
      //record rsi indicator data
      writeDataRSI(FileNameRsi1 + string(chartPeriod) + ".csv", chartPeriod, UseBarsCollect);
      //record bull power data
      writeDataBullPow(FileNameBull + string(chartPeriod) + ".csv", chartPeriod, UseBarsCollect);
      //record bear power data
      writeDataBearPow(FileNameBear + string(chartPeriod) + ".csv", chartPeriod, UseBarsCollect);   
      }
      
  }
//+------------------------------------------------------------------+

void writeData(string filename, int HistBars, int charPer, bool singlePair, bool dayStartReset, int barsCollect)
// dedicated if/else pair to handle data recording once a day (see v4.00)
 {

/*extern bool    WriteOnce             = true;
extern int     UseBarsHistory        = 600;       
extern int     chartPeriod           = 15;
extern bool    modeSinglePair        = false;      //when single pair is false all currencies are outputted to the screen, true only those works that are on chart
extern bool    modeStartHour         = false;*/
               //---------------------------------------------------------------------------------------------
               //Code to write the csv file with the information from the indicator All_Power.mq4
               /*
Arrays position:
USD - Pos 0
EUR - Pos 1
GBP - Pos 2
AUD - Pos 3
JPY - Pos 4
NZD - Pos 5
CHF - Pos 6
CAD - Pos 7
*/

//Variables for Currency Power Calculation
double Power[][8];         //contains powers for periods for all currencies
double PowerR0[][8];       //contains powers for last NumberBarsAngles for all currencies
double PowerR1[][8];       //contains powers for last NumberBarsAngles for all currencies shifted
double Surface[][8];       //contains integral of powers for periods for all currencies
//double SurfaceR0[][8];     //contains integral of power for periods for all currencies previous bar
//double SurfaceR1[][8];     //contains difference between Surface and SurfacePrev
//double SurfaceD[][8];      //contains surfaces differences
//double Area[8];            //contains area formed by surface for 8 currencies
//double Angles[8];          //contains sum of angles 
               ArrayInitialize(Power,0);
               ArrayInitialize(Surface, 0);
               ArrayResize(Power,barsCollect,0); //resize 1st dim of array to match it with number of bars from beginning of day
               ArrayResize(Surface,barsCollect, 0);
               
               string data;    //identifier that will be used to collect data string
               // delete file if it's exist
               FileDelete(filename);
               // open file handle
               int handle = FileOpen(filename,FILE_CSV|FILE_READ|FILE_WRITE);
                FileSeek(handle,0,SEEK_SET);
               // generate data now using for loop
               //----Fill the arrays
         for(int i = 0; i <= 7; i++) //i scrolls through all currencies involved
           {
               //loop j calculates surfaces and angles from beginning of the day
               for(int j = 0; j < barsCollect; j++)    //j scrolls through bars of the day
                 {
                     //calculate power indicator from the beginning of the day
                     Power[j][i] = iCustom(NULL,0, "ALL_Power", singlePair, dayStartReset, charPer, HistBars, i, j);
                     //calculate the surface created by each currency
                     Surface[j][i] = charPer*(Power[j][i] - 1);        //surface of last closed bar; value > 0 indicate stronger currency
                     //summarize total area of the indicator "bars" 
                     //Area[i] = Area[i] + Surface[j][i];    //area is derived by summing the array in 2nd dimension
                 }
               
               
           }
               
               //write data to file:
               for(int k=0;k<barsCollect;k++)
               {
                  datetime TIME = iTime(Symbol(), charPer, k);                                   //Time of the bar

                  data = string(TIME)+","+string(Power[k][0])+"," + string(Power[k][1]) + "," +string(Power[k][2])+ "," +string(Power[k][3])+ ","
                                        +string(Power[k][4])+"," + string(Power[k][5]) + "," +string(Power[k][6])+ "," +string(Power[k][7])+
                                        ","+string(Surface[k][0])+"," + string(Surface[k][1]) + "," +string(Surface[k][2])+ "," +string(Surface[k][3])+ ","
                                        +string(Surface[k][4])+"," + string(Surface[k][5]) + "," +string(Surface[k][6])+ "," +string(Surface[k][7]);
                  FileWrite(handle,data);   //write data to the file during each for loop iteration
               }       
               //             
                FileClose(handle);        //close file when data write is over
               //---------------------------------------------------------------------------------------------
               

   
         
  }
      
        
void writeDataPrices(string filename, int charPer, int barsCollect)
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
                                            +string(nzdjpy)+"," + string(nzdcad) + "," +string(nzdchf)+ "," +string(cadchf)+ ",";
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
                                            +string(nzdjpy)+"," + string(nzdcad) + "," +string(nzdchf)+ "," +string(cadchf)+ ",";
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
                                            +string(nzdjpy)+"," + string(nzdcad) + "," +string(nzdchf)+ "," +string(cadchf)+ ",";
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
                                            +string(nzdjpy)+"," + string(nzdcad) + "," +string(nzdchf)+ "," +string(cadchf)+ ",";
                  FileWrite(handle,data);   //write data to the file during each for loop iteration
                     
                 }
               
               //             
                FileClose(handle);        //close file when data write is over
               //---------------------------------------------------------------------------------------------
         
  }                  