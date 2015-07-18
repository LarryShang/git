module instr_writeBack (membus, regWriteWb,
						writeRegWb, resultWb);
	

	input [70:0] membus;
	
	output regWriteWb;
	output [4:0] writeRegWb;
	output [31:0 ]resultWb;

	wire memtoRegWb;
	wire [31:0] aluOutWb;
	wire [31:0] readDataWb;
	reg [31:0] resultWb;
	
	//decode the membus
	assign writeRegWb = membus[4:0];
	assign aluOutWb = membus[36:5];
 	assign readDataWb = membus[68:37];
	assign memtoRegWb = membus[69];
	assign regWriteWb = membus[70];
	
	//fifth pipeline - write back to the register file
	always @ (memtoRegWb, readDataWb, aluOutWb) 
	begin
		if(memtoRegWb == 1'b1)
			resultWb = readDataWb;
		else
			resultWb = aluOutWb;
	end
	
endmodule
