// Copyright (C) 1991-2010 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, Altera MegaCore Function License 
// Agreement, or other applicable license agreement, including, 
// without limitation, that your use is for the sole purpose of 
// programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the 
// applicable agreement for further details.

// PROGRAM		"Quartus II"
// VERSION		"Version 9.1 Build 350 03/24/2010 Service Pack 2 SJ Web Edition"
// CREATED		"Sat Sep 26 12:26:46 2015"

module adc2dac(
	CLOCK_27,
	CLOCK_50,
	AUD_ADCDAT,
	AUD_outL,
	AUD_outR,
	I2C_SCLK,
	AUD_XCK,
	AUD_DACDAT,
	AUD_ADCLRCK,
	AUD_DACLRCK,
	I2C_SDAT,
	AUD_BCLK,
	AUD_inL,
	AUD_inR
);


input	CLOCK_27;
input	CLOCK_50;
input	AUD_ADCDAT;
input	[15:0] AUD_outL;
input	[15:0] AUD_outR;
output	I2C_SCLK;
output	AUD_XCK;
output	AUD_DACDAT;
output	AUD_ADCLRCK;
output	AUD_DACLRCK;
inout	I2C_SDAT;
inout	AUD_BCLK;
output	[15:0] AUD_inL;
output	[15:0] AUD_inR;

wire	SYNTHESIZED_WIRE_9;
wire	SYNTHESIZED_WIRE_10;
wire	SYNTHESIZED_WIRE_4;
wire	SYNTHESIZED_WIRE_5;

assign	AUD_XCK = SYNTHESIZED_WIRE_5;
assign	AUD_ADCLRCK = SYNTHESIZED_WIRE_10;
assign	AUD_DACLRCK = SYNTHESIZED_WIRE_10;




I2C_AV_Config	b2v_inst(
	.iCLK(CLOCK_50),
	.iRST_N(SYNTHESIZED_WIRE_9),
	.I2C_SDAT(I2C_SDAT),
	.I2C_SCLK(I2C_SCLK)
	);
	defparam	b2v_inst.A_PATH_CTRL = 5;
	defparam	b2v_inst.CLK_Freq = 50000000;
	defparam	b2v_inst.D_PATH_CTRL = 6;
	defparam	b2v_inst.Dummy_DATA = 0;
	defparam	b2v_inst.I2C_Freq = 20000;
	defparam	b2v_inst.LUT_SIZE = 51;
	defparam	b2v_inst.POWER_ON = 7;
	defparam	b2v_inst.SAMPLE_CTRL = 9;
	defparam	b2v_inst.SET_ACTIVE = 10;
	defparam	b2v_inst.SET_FORMAT = 8;
	defparam	b2v_inst.SET_HEAD_L = 3;
	defparam	b2v_inst.SET_HEAD_R = 4;
	defparam	b2v_inst.SET_LIN_L = 1;
	defparam	b2v_inst.SET_LIN_R = 2;
	defparam	b2v_inst.SET_VIDEO = 11;


audio_converter	b2v_inst3(
	.AUD_BCK(AUD_BCLK),
	.AUD_DACLRCK(SYNTHESIZED_WIRE_10),
	.AUD_ADCDAT(AUD_ADCDAT),
	.AUD_ADCLRCK(SYNTHESIZED_WIRE_10),
	.iRST_N(SYNTHESIZED_WIRE_9),
	.AUD_outL(AUD_outL),
	.AUD_outR(AUD_outR),
	.AUD_DACDAT(AUD_DACDAT),
	.AUD_inL(AUD_inL),
	.AUD_inR(AUD_inR));


VGA_Audio_PLL	b2v_inst5(
	.areset(SYNTHESIZED_WIRE_4),
	.inclk0(CLOCK_27),
	
	.c1(SYNTHESIZED_WIRE_5)
	);


audio_clock	b2v_inst6(
	.iCLK_18_4(SYNTHESIZED_WIRE_5),
	.iRST_N(SYNTHESIZED_WIRE_9),
	.oAUD_BCK(AUD_BCLK),
	.oAUD_LRCK(SYNTHESIZED_WIRE_10));
	defparam	b2v_inst6.CHANNEL_NUM = 2;
	defparam	b2v_inst6.DATA_WIDTH = 16;
	defparam	b2v_inst6.REF_CLK = 18432000;
	defparam	b2v_inst6.SAMPLE_RATE = 48000;


Reset_Delay	b2v_inst7(
	.iCLK(CLOCK_50),
	.oRESET(SYNTHESIZED_WIRE_9));

assign	SYNTHESIZED_WIRE_4 =  ~SYNTHESIZED_WIRE_9;


endmodule
