`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/21 17:36:15
// Design Name: 
// Module Name: pwpart
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


module pwpart(
    input clk,          //时钟
    input del,          //退格键
    input [9:0]sw,      //0~9 9位密码
    input sw10,         //1为输入密码状态，0为等待状态
    input sw11,         //1为修改密码状态，0为等待状态
    input back,         //按下该键返回等待模式
    input enter,        //确认键
    input ok,           //确认数字输入
    input alarmcancel,  //取消报警
    output reg [19:0] data,     //寄存输入密码
    output reg [2:0]  state,    //000等待状态，001输入密码状态,010修改密码状态(管理员模式),011密码设定完毕状态，101报警状态,110报警解除状态,111解锁状态。（密码错误时根据count3来选择状态）
    output reg [19:0] password, //用于寄存设定密码
    output reg [4:0] count3           //用于记录密码输入错误次数
    );
    
    reg[3:0] count1=0;   //用于设置密码计数
    reg[3:0] count2=0;  //用于输入密码计数   
    reg[32:0] s10=0;     //用于10s计数
    reg[32:0] s20=0;     //用于20s计数
    reg[5:0]  pd=5'b0;    //单个密码数临时保存
    reg[19:0] pw=20'b0;   //密码数据临时保存
    reg swchange=0 ;
     
    
        initial
        begin
          data <= 20'b00000_00000_00000_00000;
          password <= 20'b00000_00000_00000_00000;//密码预设为0
          state<=3'b000; //初始为等待状态
          count3<=0;
          swchange<=0;
          count1<=0;
          count2<=0;
          s10<=0;
          s20<=0;
          pd<=0;
          pw<=20'b0;
        end
       
             
        always@(posedge clk)
        begin
        
        //若有操作s10，s20设为0  
        if(ok==1)begin s10=0;s20=0;end
        if(enter==1)begin s10=0;s20=0;end
        if(del==1)begin s10=0;s20=0;end
        if(back==1)begin s10=0;s20=0;end
        if(alarmcancel==1)begin s10=0;s20=0;end
        
//        /*
//        always@(posedge sw[0]) begin swchange=1;swchange=0;end
//        always@(posedge sw[1]) begin swchange=1;swchange=0;end
//        always@(posedge sw[2]) begin swchange=1;swchange=0;end
//        always@(posedge sw[3]) begin swchange=1;swchange=0;end
//        always@(posedge sw[4]) begin swchange=1;swchange=0;end
//        always@(posedge sw[5]) begin swchange=1;swchange=0;end
//        always@(posedge sw[6]) begin swchange=1;swchange=0;end
//        always@(posedge sw[7]) begin swchange=1;swchange=0;end
//        always@(posedge sw[8]) begin swchange=1;swchange=0;end
//        always@(posedge sw[9]) begin swchange=1;swchange=0;end
//        always@(posedge sw10)  begin swchange=1;swchange=0;end
//        always@(negedge sw[0]) begin swchange=1;swchange=0;end
//        always@(negedge sw[1]) begin swchange=1;swchange=0;end
//        always@(negedge sw[2]) begin swchange=1;swchange=0;end
//        always@(negedge sw[3]) begin swchange=1;swchange=0;end
//        always@(negedge sw[4]) begin swchange=1;swchange=0;end
//        always@(negedge sw[5]) begin swchange=1;swchange=0;end
//        always@(negedge sw[6]) begin swchange=1;swchange=0;end
//        always@(negedge sw[7]) begin swchange=1;swchange=0;end
//        always@(negedge sw[8]) begin swchange=1;swchange=0;end
//        always@(negedge sw[9]) begin swchange=1;swchange=0;end
//        always@(negedge sw10)  begin swchange=1;swchange=0;end
//        */
        
        //正确开锁后，用户处理完毕后，按下"back"，系统回到等待状态。
        
        if(state==3'b111)
            begin                                       
                if(back==1)
                begin
                state=3'b000;
                data=20'b00000_00000_00000_00000;
                count1=0;
                count2=0;
                count3=0;
                s10=0;
                s20=0;
                pd=0;
////                pw=0;
                end
            end                
        
        
        //系统操作过程中，只要密码锁没有打开，如果10秒没有对系统操作，系统回到等待状态。
        
        if(state!=3'b111)
            begin
            s10=s10+1;
            if(s10==1000000000)  
                begin
                state=3'b000;
                data=20'b00000_00000_00000_00000;
                count1=0;
                count2=0;
                count3<=0;
                s10=0;
                s20=0;
                pd=0;
//                pw=0;
                end                   
            end
        
        //系统操作过程中，如果密码锁已经打开，如果20秒没有对系统操作，系统自动上锁，回到等待状态。
        
        if(state==3'b111)
            begin
            s20<=s20+1;
            if(s20==2000000000) 
                begin
                state<=3'b000;
                data<=20'b00000_00000_00000_00000;
                count1=0;
                count2=0;
                count3<=0;
                s10=0;
                s20=0;
                pd=0;
//                pw=0;
                end                 
            end
         
          
          //管理员可以通过设置（专用按键）更改密码。                
          if(sw11==1 && sw10==0)
          begin 
          if(enter==1 && state==3'b000) begin state<=3'b010; pw=password; data<=20'b01111_01111_01111_01111;end//按下admin键进入管理员模式（修改密码状态）
//            else if(state==3'b010) begin password=pw;state<=3'b000;data<=20'b00000_00000_00000_00000;ad=0;end  //再次按下admin键退出管理员模式
          if(state==3'b010)
            begin
            if(ok==1 && count1!=4)  //按位设置密码，拨动9位开关，按下ok输入设定密码数字，输入数字正确则正确赋值（data用于数码管显示），输入数字错误则将错误位置赋值4'b1110
                begin
                case(sw)
                10'b1000000000:pd=5'b00000;
                10'b0100000000:pd=5'b00001;
                10'b0010000000:pd=5'b00010;
                10'b0001000000:pd=5'b00011;
                10'b0000100000:pd=5'b00100;
                10'b0000010000:pd=5'b00101;
                10'b0000001000:pd=5'b00110;
                10'b0000000100:pd=5'b00111;
                10'b0000000010:pd=5'b01000;
                10'b0000000001:pd=5'b01001;
                default:pd=5'b01010;
                endcase
                count1=count1+1;
                if(pd==5'b01010) //我的想法是要是数字输入错误 在数码管上显示一横。
                    begin 
                    if(count1==4) begin password[19:15]=pd;data[4:0]=pd;end 
                    if(count1==3) begin password[14:10]=pd;data[9:5]=pd;end
                    if(count1==2) begin password[9:5]=pd;data[14:10]=pd;end
                    if(count1==1) begin password[4:0]=pd;data[19:15]=pd;end
                    end
                    else if(count1==1&&pd!=5'b01010) begin password[19:15]=pd;data[19:15]=pd;end      
                    else if(count1==2&&pd!=5'b01010) begin password[14:10]=pd;data[14:10]=pd;end 
                    else if(count1==3&&pd!=5'b01010) begin password[9:5]=pd;data[9:5]=pd;end 
                    else if(count1==4&&pd!=5'b01010) begin password[4:0]=pd;data[4:0]=pd;end
                    end
                if(count1==4) //密码设置完毕后，再按下enter键进入密码设定完毕状态
                    begin
                    if(enter==1&&data[19:15]!=5'b01010&&data[14:10]!=5'b01010&&data[9:5]!=5'b01010&&data[4:0]!=5'b01010)    
                    begin
                    pw=password;
//                    data<=20'b00000_00000_00000_00000;
                    count1=0;
                    count2=0;
                    count3=0;
                    pd=0;
                    state<=3'b011; 
                    end
                    end
            end 
            //管理员设定密码时，在按下确定键之前，可以通过按退格键修正，每按一次退格键消除一位密码。        
          if(del==1 && sw11==1 && sw10==0)
            begin
            if(count1==1) begin password[19:15]=5'b01111;data[19:15]=5'b01111;count1=count1-1;end 
            else if(count1==2) begin password[14:10]=5'b01111;data[14:10]=5'b01111;count1=count1-1;end
            else if(count1==3) begin password[9:5]=5'b01111;data[9:5]=5'b01111;count1=count1-1;end
            else if(count1==4) begin password[4:0]=5'b01111;data[4:0]=5'b01111;count1=count1-1;end
            end 
          end
          
          //用户如果需要开锁，拨动相应的开关进入输入密码状态，输入4位密码，按下确定键后，若密码正确，锁打开，若密码错误，将提示密码错误，要求重新输入，三次输入都错误，将发出报警信号。
          if(sw10==1&& sw11==0)//开关SW[10]为1且系统处于等待状态时，进入输入密码状态
          begin
          if(enter==1 && state==3'b000) begin state=3'b001;data=20'b01111_01111_01111_01111;end
          if(state==3'b001)  //按位输入密码，拨动9位开关，按下ok输入密码数字，输入数字正确则正确赋值（data用于数码管显示和后续对密码正确与否进行判断），输入数字错误则将错误位置赋值4'b1110
            begin
            if(ok==1 && count2!=4 )
                begin
                case(sw) 
                10'b1000000000:pd=5'b00000;
                10'b0100000000:pd=5'b00001;
                10'b0010000000:pd=5'b00010;
                10'b0001000000:pd=5'b00011;
                10'b0000100000:pd=5'b00100;
                10'b0000010000:pd=5'b00101;
                10'b0000001000:pd=5'b00110;
                10'b0000000100:pd=5'b00111;
                10'b0000000010:pd=5'b01000;
                10'b0000000001:pd=5'b01001;
                default:pd=5'b01010;
                endcase
                count2=count2+1;
            if(pd==5'b01010) //我的想法是要是数字输入错误 在数码管上显示一横。
                begin 
                if(count2==4) data[4:0]=pd;
                if(count2==3) data[9:5]=pd;
                if(count2==2) data[14:10]=pd;
                if(count2==1) data[19:15]=pd;
                end
            else if(count2==4&&pd!=5'b01010) data[4:0]=pd;
            else if(count2==3&&pd!=5'b01010) data[9:5]=pd; 
            else if(count2==2&&pd!=5'b01010) data[14:10]=pd; 
            else if(count2==1&&pd!=5'b01010) data[19:15]=pd; 
            end
            if(count2==4)
                    begin
                    if(enter==1)
                        begin
                        if(data==password) begin state=3'b111;end//密码正确则进入解锁状态
                        if(data!=password) //密码输入错误则返回输入密码状态，且count3用于记录密码输错次数，count3为3时进入报警状态
                            begin
                            count3=count3+1;
                            if(count3!=3)
                                begin
                                state=3'b001;
                                data=20'b01111_01111_01111_01111;
                                count2=0;
                                end
                                else if(count3==3) state=3'b101;
                            end
                        end
                    end
                    
               //用户输入密码时，在按下确定键之前，可以通过按退格键修正，每按一次退格键消除一位密码。  
                if(del==1 && sw10==1 && sw11==0)
                begin
                if(count2==1) begin data[19:15]=5'b01111;count2=count2-1;end
                else if(count2==2) begin data[14:10]=5'b01111;count2=count2-1;end
                else if(count2==3) begin data[9:5]=5'b01111;count2=count2-1;end
                else if(count2==4) begin data[4:0]=5'b01111;count2=count2-1;end                              
                end
            end
          end
          
          
          //报警后，只有管理员作相应的处理（专用按键）才能停止报警。再按一次back返回等待状态。
         
          if(state==3'b101)
            begin
            if(alarmcancel==1) state=3'b110;
            end
            if(state==3'b110)
              begin
              if(back==1) 
                begin
                state<=3'b000;
                data<=20'b00000_00000_00000_00000;
                count1=0;
                count2=0;
                count3<=0;
                s10=0;
                s20=0;
                pd=0;
//                pw=0;
                end
              end
         
         
          
          //sw10和sw11为0时，为等待状态                  
          if(sw10==0 && sw11==0)
          begin
            state=3'b000;
            data=20'b00000_00000_00000_00000;
            password=pw;
            count1=0;
            count2=0;
            count3=0;
            s10=0;
            s20=0;
            pd=0;
//            pw=0;
          end
           
        
        //密码设定完毕后，按下back键返回等待状态
          
        if(state==3'b011)
            begin
            if(back==1) begin state<=3'b000;data=20'b00000_00000_00000_00000;end
            end
     
        end
              
        
                                        
endmodule
