
module cpu(clock, reset, writeRegWb, resultWb,pcIf, pcSrcId, instrID);
	
	input clock;
	input reset;

	output [31:0] pcIf;
	output [1:0] pcSrcId;
	output [31:0] instrID;
	output [4:0]  writeRegWb;
	output [31:0] resultWb;
   
	wire [63:0]  ifbus;
	wire [118:0] idbus;
	wire [71:0]  exebus;
	wire [70:0]  membus;
	
	wire [31:0] pcBranchId;
	wire [31:0] jumpAddress;
	
	/**
	* handle the lw-data hazard
	*/
	//the control singal
	wire stalIf;
	wire stalId;
	wire flushExe;
	
	wire [4:0] rsId, rtId;
	wire [4:0] rtExe;
	wire memtoRegExe;

	assign stalIf = ( (rsId == rtExe) || (rtId == rtExe) )&& memtoRegExe;
	assign stalId = ( (rsId == rtExe) || (rtId == rtExe) )&& memtoRegExe;
	assign flushExe = ( (rsId == rtExe) || (rtId == rtExe) )&& memtoRegExe;
	/**
	* end for handle the lw-data hazard
	*/
	
	wire regWriteMem;
	wire [4:0] writeRegMem;
	wire [31:0] aluOutMem;
	
	wire regWriteWb;
	wire [4:0] writeRegWb;
	wire [31:0 ] resultWb;
	

instr_fetch fetch_module(.clock(clock), .reset(reset),
				   .pcSrcId(pcSrcId), .stalIf(stalIf), .stalId(stalId), 
				   .jumpAddressId(jumpAddress), .pcBranchId(pcBranchId),
				   .ifbus(ifbus), .pcIf(pcIf));
				   
instr_decode decode_module(.clock(clock), .reset(flushExe), 
					.ifbus(ifbus), .idbus(idbus), 
					.aluOutMem(aluOutMem), .writeRegMem(writeRegMem), .regWriteMem(regWriteMem),
					.resultWb(resultWb), .writeRegWb(writeRegWb),.regWriteWb(regWriteWb),
					.pcSrcId(pcSrcId), .pcBranchId(pcBranchId),
					.jumpAddress(jumpAddress), .instrID(instrID),
					.rsIdOut(rsId), .rtIdOut(rtId));
					
instr_execute execute_module(.clock(clock), .reset(reset), 
					.idbus(idbus), .exebus(exebus),
					.regWriteMem(regWriteMem), .regWriteWb(regWriteWb),
					.writeRegMem(writeRegMem), .writeRegWb(writeRegWb),
					.resultWb(resultWb), .aluOutMem(aluOutMem),
					.memtoRegExeWire(memtoRegExe), .rtExeOut(rtExe));
					
instr_memory memory_module(.clock(clock), .reset(reset), 
					.exebus(exebus), .membus(membus),
					.aluOutMem_wire(aluOutMem), .writeRegMem_wire(writeRegMem),
					.regWriteMem_wire(regWriteMem));	
instr_writeBack writeBack_module(.membus(membus), .regWriteWb(regWriteWb),
						.writeRegWb(writeRegWb), .resultWb(resultWb));
							

endmodule
