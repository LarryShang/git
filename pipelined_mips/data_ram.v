
module data_ram(clock,raddr,rout,wen,waddr,win);
    input clock; 
    input wen; 
    input [31:0] win;
    input [31:0] raddr;
    input [31:0] waddr;
    output [31:0] rout;
    reg [31:0] ram[63:0];    
	
	integer k;
	 initial begin
		for(k=0;k<63;k=k+1)begin
		ram[k] = 32'b0; 
		end
	 end
	 

    assign rout = ram[raddr];
    
    always @(posedge clock) begin
        if (wen) begin
            ram[waddr] = win;
        end
    end
endmodule
