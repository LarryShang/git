module regfile(clock, reset, raddr1,rout1,raddr2,rout2,wen,waddr,win);
    
	input clock;    
	input reset;
	
    input wen; 
    input [31:0] win;
    input [4:0] raddr1,raddr2;
    input [4:0] waddr;
	
    output [31:0] rout1,rout2;
    wire  [31:0] t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, s0, s1, s2, s3, s4, s5, s6, s7;
    
    reg [31:0] ram[31:0];
    assign rout1 = ram[raddr1];
    assign rout2 = ram[raddr2];
    
	 integer k;
	 initial begin
		for(k=0;k<32;k=k+1)begin
		ram[k] = 32'b0; 
		end
	 end
	
    always @(negedge clock) 
    begin
        if (wen) 
        begin
            if(waddr!=0) ram[waddr]= win;
           $display("win = %d ram[%d],\t%d\n",win, ram[waddr], waddr);
           // $stop;
        end
    end
	
	 assign t0 = ram[8];
	 assign t1 = ram[9];
	 assign t2 = ram[10];
	 assign t3 = ram[11];
	 assign t4 = ram[12];
	 assign t5 = ram[13];
	 assign t6 = ram[14];
	 assign t7 = ram[15];
	 assign t8 = ram[24];
	 assign t9 = ram[25];
	 assign s0 = ram[16];
	 assign s1 = ram[17];
	 assign s2 = ram[18];
	 assign s3 = ram[19];
	 assign s4 = ram[20];
	 assign s5 = ram[21];
	 assign s6 = ram[22];
	 assign s7 = ram[23];	

	
endmodule