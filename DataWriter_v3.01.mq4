//+------------------------------------------------------------------+
//|                                                   DataWriter.mq4 |
//|                                 Copyright 2018, Vladimir Zhbanko |
//+------------------------------------------------------------------+
#include <06_NormalizeDouble.mqh>

#property copyright "Copyright 2018, Vladimir Zhbanko"
#property link      "https://vladdsm.github.io/myblog_attempt/"
#property version   "3.01"
#property strict

/*
PURPOSE: Write result of All Powers Custom Indicator
USE:
*/

/* 
DataWriter v3.01 Release Notes: 
- EA that suppose to write information from EA power indicator to the file
- Several working modes are possible
-- write x bars and stop
-- write x bars on every new bar and continue
*/
extern string  Header1 = "-----EA Main Settings-------";
extern int     UseBarsHistory        = 9000;
extern int     UseBarsCollect        = 1;    
extern int     chartPeriod           = 15;
extern bool    modeSinglePair        = false;      //when single pair is false all currencies are outputted to the screen, true only those works that are on chart
extern bool    modeStartHour         = false;



//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   writeData("AllPowersOnce.csv", UseBarsHistory, chartPeriod, modeSinglePair, modeStartHour, UseBarsHistory);
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
      writeData("AllPowers.csv", UseBarsHistory, chartPeriod, modeSinglePair, modeStartHour, UseBarsCollect);
      
         
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
double SurfaceR0[][8];     //contains integral of power for periods for all currencies previous bar
double SurfaceR1[][8];     //contains difference between Surface and SurfacePrev
double SurfaceD[][8];      //contains surfaces differences
double Area[8];            //contains area formed by surface for 8 currencies
double Angles[8];          //contains sum of angles 
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
                     Area[i] = Area[i] + Surface[j][i];    //area is derived by summing the array in 2nd dimension
                     
                     
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
      
        