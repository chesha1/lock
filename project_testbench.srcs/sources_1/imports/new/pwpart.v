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
    input clk,          //ʱ��
    input del,          //�˸��
    input [9:0]sw,      //0~9 9λ����
    input sw10,         //1Ϊ��������״̬��0Ϊ�ȴ�״̬
    input sw11,         //1Ϊ�޸�����״̬��0Ϊ�ȴ�״̬
    input back,         //���¸ü����صȴ�ģʽ
    input enter,        //ȷ�ϼ�
    input ok,           //ȷ����������
    input alarmcancel,  //ȡ������
    output reg [19:0] data,     //�Ĵ���������
    output reg [2:0]  state,    //000�ȴ�״̬��001��������״̬,010�޸�����״̬(����Աģʽ),011�����趨���״̬��101����״̬,110�������״̬,111����״̬�����������ʱ����count3��ѡ��״̬��
    output reg [19:0] password, //���ڼĴ��趨����
    output reg [4:0] count3           //���ڼ�¼��������������
    );
    
    reg[3:0] count1=0;   //���������������
    reg[3:0] count2=0;  //���������������   
    reg[32:0] s10=0;     //����10s����
    reg[32:0] s20=0;     //����20s����
    reg[5:0]  pd=5'b0;    //������������ʱ����
    reg[19:0] pw=20'b0;   //����������ʱ����
    reg swchange=0 ;
     
    
        initial
        begin
          data <= 20'b00000_00000_00000_00000;
          password <= 20'b00000_00000_00000_00000;//����Ԥ��Ϊ0
          state<=3'b000; //��ʼΪ�ȴ�״̬
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
        
        //���в���s10��s20��Ϊ0  
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
        
        //��ȷ�������û�������Ϻ󣬰���"back"��ϵͳ�ص��ȴ�״̬��
        
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
        
        
        //ϵͳ���������У�ֻҪ������û�д򿪣����10��û�ж�ϵͳ������ϵͳ�ص��ȴ�״̬��
        
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
        
        //ϵͳ���������У�����������Ѿ��򿪣����20��û�ж�ϵͳ������ϵͳ�Զ��������ص��ȴ�״̬��
        
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
         
          
          //����Ա����ͨ�����ã�ר�ð������������롣                
          if(sw11==1 && sw10==0)
          begin 
          if(enter==1 && state==3'b000) begin state<=3'b010; pw=password; data<=20'b01111_01111_01111_01111;end//����admin���������Աģʽ���޸�����״̬��
//            else if(state==3'b010) begin password=pw;state<=3'b000;data<=20'b00000_00000_00000_00000;ad=0;end  //�ٴΰ���admin���˳�����Աģʽ
          if(state==3'b010)
            begin
            if(ok==1 && count1!=4)  //��λ�������룬����9λ���أ�����ok�����趨�������֣�����������ȷ����ȷ��ֵ��data�����������ʾ�����������ִ����򽫴���λ�ø�ֵ4'b1110
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
                if(pd==5'b01010) //�ҵ��뷨��Ҫ������������� �����������ʾһ�ᡣ
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
                if(count1==4) //����������Ϻ��ٰ���enter�����������趨���״̬
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
            //����Ա�趨����ʱ���ڰ���ȷ����֮ǰ������ͨ�����˸��������ÿ��һ���˸������һλ���롣        
          if(del==1 && sw11==1 && sw10==0)
            begin
            if(count1==1) begin password[19:15]=5'b01111;data[19:15]=5'b01111;count1=count1-1;end 
            else if(count1==2) begin password[14:10]=5'b01111;data[14:10]=5'b01111;count1=count1-1;end
            else if(count1==3) begin password[9:5]=5'b01111;data[9:5]=5'b01111;count1=count1-1;end
            else if(count1==4) begin password[4:0]=5'b01111;data[4:0]=5'b01111;count1=count1-1;end
            end 
          end
          
          //�û������Ҫ������������Ӧ�Ŀ��ؽ�����������״̬������4λ���룬����ȷ��������������ȷ�����򿪣���������󣬽���ʾ�������Ҫ���������룬�������붼���󣬽����������źš�
          if(sw10==1&& sw11==0)//����SW[10]Ϊ1��ϵͳ���ڵȴ�״̬ʱ��������������״̬
          begin
          if(enter==1 && state==3'b000) begin state=3'b001;data=20'b01111_01111_01111_01111;end
          if(state==3'b001)  //��λ�������룬����9λ���أ�����ok�����������֣�����������ȷ����ȷ��ֵ��data�����������ʾ�ͺ�����������ȷ�������жϣ����������ִ����򽫴���λ�ø�ֵ4'b1110
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
            if(pd==5'b01010) //�ҵ��뷨��Ҫ������������� �����������ʾһ�ᡣ
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
                        if(data==password) begin state=3'b111;end//������ȷ��������״̬
                        if(data!=password) //������������򷵻���������״̬����count3���ڼ�¼������������count3Ϊ3ʱ���뱨��״̬
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
                    
               //�û���������ʱ���ڰ���ȷ����֮ǰ������ͨ�����˸��������ÿ��һ���˸������һλ���롣  
                if(del==1 && sw10==1 && sw11==0)
                begin
                if(count2==1) begin data[19:15]=5'b01111;count2=count2-1;end
                else if(count2==2) begin data[14:10]=5'b01111;count2=count2-1;end
                else if(count2==3) begin data[9:5]=5'b01111;count2=count2-1;end
                else if(count2==4) begin data[4:0]=5'b01111;count2=count2-1;end                              
                end
            end
          end
          
          
          //������ֻ�й���Ա����Ӧ�Ĵ���ר�ð���������ֹͣ�������ٰ�һ��back���صȴ�״̬��
         
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
         
         
          
          //sw10��sw11Ϊ0ʱ��Ϊ�ȴ�״̬                  
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
           
        
        //�����趨��Ϻ󣬰���back�����صȴ�״̬
          
        if(state==3'b011)
            begin
            if(back==1) begin state<=3'b000;data=20'b00000_00000_00000_00000;end
            end
     
        end
              
        
                                        
endmodule
