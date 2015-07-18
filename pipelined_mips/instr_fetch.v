module instr_fetch(clock, reset,
				   pcSrcId, stalIf, stalId, 
				   jumpAddressId, pcBranchId,
				   ifbus, pcIf);

	input clock;
	input reset;
	
	input [1:0] pcSrcId; //ID output, ctrl IF jump
	input stalIf;  
	input stalId; 
	input [31:0] jumpAddressId; //jump address come from Intruction decode stage
	input [31:0] pcBranchId;      //branch address comes from ID stage
	
	output [31:0] pcIf;    //pc counter£¬thus address to instrMemory
	output [63:0] ifbus;   //ifbus to id
	
	wire [31:0] pcPlus4If;
	
	reg [31:0] pcWire;
	always @(pcSrcId, pcPlus4If, pcBranchId, jumpAddressId) begin 
		case(pcSrcId)
		2'b00:	
		begin
			pcWire = pcPlus4If;   //alu
		end
		2'b01:
		begin
			pcWire = pcBranchId;   //branch  here the branch and jump instr is implemented
		end
		2'b10:
		begin
			pcWire = jumpAddressId;  //jump
		end
		default:
			pcWire = 0;
		endcase
	end

	reg[31:0] pcReg;
	//assign the value of pcReg 0
	initial begin 
		pcReg = 0;
	end
	
	always @ (posedge clock) begin
	if(reset) 
		pcReg <= 0;
	else 
		if(!stalIf) 
			pcReg <= pcWire;
		
		if(pcReg == 100) $stop;	
	end
	
	
	assign pcIf = pcReg;
	
	assign pcPlus4If = pcIf +4; //pc + 4
	
	//read the instruction memory
	wire [31:0] rom_inst; // the instruction
	instr_rom instrMemory(.raddr(pcIf),.rout(rom_inst));
	
	//first pipeline - define the register for instruction stage
	reg [31:0] instr_reg;
	reg [31:0] pcPlus4If_reg;
	
	wire clrReg;
	assign clrReg = pcSrcId[1] || pcSrcId[0];  //if have jump or branch, clrReg = 1
	always @(posedge clock) begin
		if(reset) begin
			instr_reg <= 0;
			pcPlus4If_reg <= 0;		
		end
		else if(!stalId ) begin		  
			instr_reg <= rom_inst;
			pcPlus4If_reg <= pcPlus4If;
		end
		//if have jump or branch, clrReg = 1, then clear the if register and pc
		if(clrReg) begin
			instr_reg <= 0;
			pcPlus4If_reg <= 0;
		end
	end	
	
	//output pc and instr
	assign ifbus[31:0] = pcPlus4If_reg;
	assign ifbus[63:32] = instr_reg;
		
endmodule
