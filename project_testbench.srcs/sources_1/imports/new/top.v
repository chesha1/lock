`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southeast University School of Information
// Engineer: S.C Ym.X
// 
// Create Date: 2020/09/21 18:14:56
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
//    input clk,          //时钟
//    input wire BTND,          //退格键
//    input wire [9:0]SW,      //SW[9:0] 9位密码
//    input wire SW10,          //SW10 1为输入密码状态，0为等待状态
//    input wire SW11,         //SW11 1为修改密码状态，0为等待状态
//    input wire BTNU,        //按下该键返回等待模式
//    input wire BTNC,        //确认键
//    input wire BTNR,        //确认数字输入
//    input wire BTNL,        //取消报警
//    output wire[6:0] a_to_g,
//    output wire [7:0] AN,
//    output wire [15:0] LED
);

    reg clk;         //时钟
    reg BTND;          //退格键
    reg [9:0]SW;      //SW[9:0] 9位密码
    reg SW10;          //SW10 1为输入密码状态，0为等待状态
    reg SW11;         //SW11 1为修改密码状态，0为等待状态
    reg BTNU;        //按下该键返回等待模式
    reg BTNC;        //确认键
    reg BTNR;        //确认数字输入
    reg BTNL;        //取消报警
    wire[6:0] a_to_g;
    wire [7:0] AN;
    wire [15:0] LED;
    wire [4:0]  Count3;
    reg [2:0] temp1=3'b101;
    wire [2:0]  State;      //000等待状态，001输入密码状态,010修改密码状态(管理员模式),011密码设定完毕状态,101报警状态,110报警解除状态,111解锁状态


    initial
    begin
    SW=0;
    clk=0;
    forever
    #10 clk=~clk;
    end
    
    initial
    begin
    BTND=0;
    SW10=1;
    SW11=0;
    BTNC=0;
    #10000 BTNC=1;
    #2000000 BTNC=0;
    SW[6]=1;
    #1000 BTNR=0;
    #2000000 BTNR=1;
    #2000000 BTNR=0;
    #2000000 BTNR=1;
    #2000000 BTNR=0;
    #2000000 BTNR=1;
    #2000000 BTNR=0;
    #2000000 BTNR=1;
    #2000000 BTNC=0;
    #2000000 BTNC=1;
    #2000000 BTNC=0;
    
        #1000 BTNR=0;
    #2000000 BTNR=1;
    #2000000 BTNR=0;
    #2000000 BTNR=1;
    #2000000 BTNR=0;
    #2000000 BTNR=1;
    #2000000 BTNR=0;
    #2000000 BTNR=1;
    #2000000 BTNC=0;
    #2000000 BTNC=1;
    #2000000 BTNC=0;
    
        #1000 BTNR=0;
    #2000000 BTNR=1;
    #2000000 BTNR=0;
    #2000000 BTNR=1;
    #2000000 BTNR=0;
    #2000000 BTNR=1;
    #2000000 BTNR=0;
    #2000000 BTNR=1;
    #2000000 BTNC=0;
    #2000000 BTNC=1;
    #2000000 BTNC=0;
    
        #2000000 BTNC=0;
    #2000000 BTNC=1;
    #2000000 BTNC=0;
    
            #2000000 BTNL=0;
#2000000 BTNL=1;
#2000000 BTNL=0;

            #2000000 BTNU=0;
#2000000 BTNU=1;
#200000 BTNU=0;

    

    end





wire [19:0] Data;                 //寄存输入密码
wire [19:0] Password;//用于寄存设定密码

   
wire BTND1;         //退格键
wire BTNU1;         //按下该键返回等待模式
wire BTNC1;         //确认键
wire BTNR1;         //确认数字输入
wire BTNL1;         //取消报警



debounce debounce1(.clk(clk),.key_in(BTNC),.key_out(BTNC1));
debounce debounce2(.clk(clk),.key_in(BTNU),.key_out(BTNU1));
debounce debounce3(.clk(clk),.key_in(BTNL),.key_out(BTNL1));
debounce debounce4(.clk(clk),.key_in(BTNR),.key_out(BTNR1));
debounce debounce5(.clk(clk),.key_in(BTND),.key_out(BTND1));

pwpart M1(   .sw(SW),
             .clk(clk),
             .del(BTND1),
             .sw10(SW10),
             .sw11(SW11),
             .back(BTNU1),
             .enter(BTNC1),
             .ok(BTNR1),
             .alarmcancel(BTNL1),
             .data(Data),
             .state(State),
             .password(Password),
             .count3(Count3)
            );          
                
show M2(    .x(Data),
            .clk(clk),
            .State(State),
            .count(Count3),
            .a_to_g(a_to_g),
            .AN(AN),
            .LED(LED)
            );                
endmodule