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
//    input clk,          //ʱ��
//    input wire BTND,          //�˸��
//    input wire [9:0]SW,      //SW[9:0] 9λ����
//    input wire SW10,          //SW10 1Ϊ��������״̬��0Ϊ�ȴ�״̬
//    input wire SW11,         //SW11 1Ϊ�޸�����״̬��0Ϊ�ȴ�״̬
//    input wire BTNU,        //���¸ü����صȴ�ģʽ
//    input wire BTNC,        //ȷ�ϼ�
//    input wire BTNR,        //ȷ����������
//    input wire BTNL,        //ȡ������
//    output wire[6:0] a_to_g,
//    output wire [7:0] AN,
//    output wire [15:0] LED
);

    reg clk;         //ʱ��
    reg BTND;          //�˸��
    reg [9:0]SW;      //SW[9:0] 9λ����
    reg SW10;          //SW10 1Ϊ��������״̬��0Ϊ�ȴ�״̬
    reg SW11;         //SW11 1Ϊ�޸�����״̬��0Ϊ�ȴ�״̬
    reg BTNU;        //���¸ü����صȴ�ģʽ
    reg BTNC;        //ȷ�ϼ�
    reg BTNR;        //ȷ����������
    reg BTNL;        //ȡ������
    wire[6:0] a_to_g;
    wire [7:0] AN;
    wire [15:0] LED;
    wire [4:0]  Count3;
    reg [2:0] temp1=3'b101;
    wire [2:0]  State;      //000�ȴ�״̬��001��������״̬,010�޸�����״̬(����Աģʽ),011�����趨���״̬,101����״̬,110�������״̬,111����״̬


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





wire [19:0] Data;                 //�Ĵ���������
wire [19:0] Password;//���ڼĴ��趨����

   
wire BTND1;         //�˸��
wire BTNU1;         //���¸ü����صȴ�ģʽ
wire BTNC1;         //ȷ�ϼ�
wire BTNR1;         //ȷ����������
wire BTNL1;         //ȡ������



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