`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/20 11:18:52
// Design Name: 
// Module Name: debounce
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

//`define UD #1
//module debounce(
//    input clk,
//    input key_in,
//    output key_out
//);

//// inner signal
//reg [1:0] key_in_r;
//wire pp;
//reg [19:0] cnt_base;
//reg key_value_r;

////内部信号
//always @(posedge clkin)
//key_in_r<= `UD {key_in_r[0],key_in};

//// 检测有输入有没有变化
//assign pp = key_in_r[0]^key_in_r[1];

////延迟计数器
//always @(posedge clkin)
//if(pp==1'b1)
//       cnt_base <= `UD 20'd0;
//    else
//       cnt_base <= `UD cnt_base + 1;

////输出
//always @(posedge clkin)
//if(cnt_base==20'd20_000)
//   key_value_r <= `UD key_in_r[0];

//assign key_value = key_value_r;
//endmodule

//module debounce(
//    input wire clk,
//    input wire key_in,
//    output reg key_out
//    );

////    localparam TIME_20MS = 1_000_000;
//    localparam TIME_20MS = 20_000;       // just for test

//    reg key_cnt;
//    reg [20:0] cnt;
    
//      initial
//      begin
//      key_out<=0;
//      key_cnt<=0;
//      cnt<=0;
//      end
      
//    always @(posedge clk) begin 
//        if(key_in==0)begin
//        key_out<=0;
//        key_cnt<=0;
//        cnt<=0; 
//        end          
//        if(key_cnt == 0 && key_out != key_in)
//            key_cnt <= 1;
//        else if(cnt == TIME_20MS - 1)
//            key_cnt <= 0;
                
//        if(key_cnt)
//            cnt <= cnt + 1'b1;
//        else
//            cnt <= 0;
              
//        if(key_cnt == 0 && key_out != key_in)
//            key_out <= key_in;
//    end
//endmodule

module debounce(
    input clk,
    input key_in,
    output reg key_out
    );
    
    reg [16:0] cnt;
    reg ol;
    
    initial
    begin
        key_out = 0;
        cnt = 0;
        ol = 0;
    end
    
    always @(posedge clk)
    begin
        
        if (key_out == 1)
            key_out = 0;
        
        if (cnt == 20000)
        begin
            if (key_in == 1)
            key_out = 1;
            ol = key_in;
            cnt = 0;
        end
        
        if (key_in == ol)
            cnt = 0;
        
        else
            cnt = cnt + 1;
    
    end

endmodule