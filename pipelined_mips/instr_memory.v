module instr_memory(clock, reset, 
					exebus, membus,
					aluOutMem_wire, writeRegMem_wire,
					regWriteMem_wire);

	input clock;
	input reset;
	
	input  [71:0] exebus;
	output [70:0] membus;
	output [31:0] aluOutMem_wire;
	output [4:0]  writeRegMem_wire;
	output regWriteMem_wire;
	
	//define the wires
	wire[4:0] writeRegMem_wire;
	wire[31:0] exebus_writeDataMem;
	wire[31:0] aluOutMem_wire;
	wire regWriteMem_wire;
	wire exebus_memWriteMem;
	wire exebus_memtoRegMem;
	wire exebus_regWriteMem;

	assign writeRegMem_wire = exebus[4:0];
	assign exebus_writeDataMem = exebus[36:5];
	assign aluOutMem_wire = exebus[68:37];
	assign exebus_memWriteMem = exebus[69];
	assign exebus_memtoRegMem = exebus[70];
	assign exebus_regWriteMem = exebus[71];
	
	assign regWriteMem_wire = exebus[71];
	//define the output of the data ram
	wire [31:0] readDataMemWire;
	
	//define the date ram. And input or output the data.
	data_ram dataMemory(.clock(clock),.raddr(aluOutMem_wire),.rout(readDataMemWire),
	      .wen(exebus_memWriteMem),.waddr(aluOutMem_wire),.win(exebus_writeDataMem));

	//fourth pipeline - define the register of the Mem stage
	reg regWriteMem;
	reg memtoRegMem;
	reg [31:0] readDataMem;
	reg [31:0] aluOutMem;
	reg [4:0] writeRegMem;
	
	always @(posedge clock) begin
		if(reset) begin
			regWriteMem <= 0;
			memtoRegMem <= 0;
			readDataMem <= 0;
			aluOutMem   <= 0;
			writeRegMem <= 0;
		end
		else begin
			regWriteMem <= exebus_regWriteMem;
			memtoRegMem <= exebus_memtoRegMem;
			readDataMem <= readDataMemWire;
			aluOutMem   <= aluOutMem_wire;
			writeRegMem <= writeRegMem_wire;
		end
	end
	
	assign membus[4:0] = writeRegMem;
	assign membus[36:5] = aluOutMem;
	assign membus[68:37] = readDataMem;
	assign membus[69] = memtoRegMem;
	assign membus[70] = regWriteMem;
	
endmodule
