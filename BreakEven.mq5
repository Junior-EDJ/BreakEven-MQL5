//+------------------------------------------------------------------+
//|                                                    BreakEven.mq5 |
//|                                   Copyright 2019,Junior Domingos |
//|                                      juniordomingos738@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019,Junior Domingos"
#property link      "juniordomingos738@gmail.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Trade/Trade.mqh>
CTrade trade;

//Number Magic
input int numero_magico = 123;


input string									campo2;//>               BreakEven
input bool										break_even = false;//Break Even?
input double									distancia_break = 100;//Distance to trigger BreakEven
int OnInit()
  {
//---
   	trade.SetExpertMagicNumber(numero_magico);
//---
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
   
  }
//+------------------------------------------------------------------+
//Make Break Even
void BreakEven()
{
	for(int i=0;i<PositionsTotal();i++)
	{
		PositionSelectByTicket(PositionGetTicket(i));
		//magic number and symbol
		if(PositionGetInteger(POSITION_MAGIC)==numero_magico && PositionGetString(POSITION_SYMBOL)==_Symbol)
		{
			//type buy
			if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
			{
				if(UltimoTick() > PositionGetDouble(POSITION_PRICE_OPEN)+NormalizePrice(distancia_break) 
				&& PositionGetDouble(POSITION_SL) < PositionGetDouble(POSITION_PRICE_OPEN))
				{
					if(trade.PositionModify(PositionGetTicket(i),PositionGetDouble(POSITION_PRICE_OPEN),PositionGetDouble(POSITION_TP)))
					{
					
					}
					else
						Print("Error triggering breakEven ",GetLastError());
				}
			}
			//type sell
			else if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
			{
				if(UltimoTick() < PositionGetDouble(POSITION_PRICE_OPEN)-NormalizePrice(distancia_break) 
				&& PositionGetDouble(POSITION_SL) > PositionGetDouble(POSITION_PRICE_OPEN))
				{
					if(trade.PositionModify(PositionGetTicket(i),PositionGetDouble(POSITION_PRICE_OPEN),PositionGetDouble(POSITION_TP)))
					{

					}
					else
						Print("Error triggering breakEven ",GetLastError());
				}
			}
		}
	}
}
//---
double NormalizePrice(double price, string symbol=NULL, double tick=0)
{
   static const double _tick = tick ? tick : SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_SIZE);
   return round(price / _tick) * _tick;
}
//---
double UltimoTick()
{
	return SymbolInfoDouble(_Symbol,SYMBOL_LAST);
}
