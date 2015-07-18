
module instr_decode(clock, reset, 
					ifbus, idbus, 
					aluOutMem, writeRegMem, regWriteMem,
					resultWb, writeRegWb,regWriteWb,
					pcSrcId, pcBranchId,
					jumpAddress, instrID,
					rsIdOut, rtIdOut);
	input clock;
	input reset;
	
	input [63:0] ifbus;
	input [31:0] resultWb;
	input [4:0] writeRegWb;
	input regWriteWb;
	input [31:0] aluOutMem;
	input [4:0] writeRegMem;
	input regWriteMem;
	
	output [31:0] instrID;
	output [1:0] pcSrcId;
	output [118:0] idbus;
	output [31:0] pcBranchId;
	output [4:0] rsIdOut, rtIdOut;
	
	/**
	*the input of the instr_fetch, being selected by pcSrcId, to form the pc.
	*/
	output [31:0] jumpAddress;
	
	wire [31:0] ifbus_pcPlus4Id;
	wire [31:0] ifbus_instruction;
	
	//input from if
	assign ifbus_pcPlus4Id = ifbus[31:0];
	assign ifbus_instruction = ifbus[63:32];
	assign instrID = ifbus[63:32];

	wire [5:0] op;
	wire [5:0] funct;
	wire [4:0] radd1;
	wire [4:0] radd2;
	wire [4:0] wadd;
	wire [31:0] wdata; //the data to be written into the register file
	wire [4:0] rsId;
	wire [4:0] rtId;
	wire [4:0] rdId;
	wire [15:0] address;
	
	assign op = ifbus_instruction[31:26];
	assign funct = ifbus_instruction[5:0];
	assign radd1 = ifbus_instruction[25:21];
	assign radd2 = ifbus_instruction[20:16];
	assign wadd = writeRegWb;		//come from the wb stage 
	assign wdata = resultWb; 			//come from the wb stage
	assign rsId = ifbus_instruction[25:21];
	assign rtId = ifbus_instruction[20:16];
	assign rdId = ifbus_instruction[15:11];
	assign address = ifbus_instruction[15:0];
	
	//assign the output  wire rsIdOut, rtIdOut
	assign rsIdOut = ifbus_instruction[25:21];
	assign rtIdOut = ifbus_instruction[20:16];
	
	//to form the target address of the jump instruction
	// assign jumpAddress = {ifbus_pcPlus4Id[31:28], ifbus_instruction[25:0], 1'b0,1'b0};
		//the output of the register file
	wire [31:0] rdata1;
	wire [31:0] rdata2;
	assign jumpAddress = rdata1;
	
	//the result of the address wire,
	wire [31:0] signExtend;
	assign signExtend = {{17{address[15]}},address[14:0]};
	
	//assign the pcBranchId
	assign pcBranchId = (signExtend << 2) + ifbus_pcPlus4Id;
	

	
	//read or write the register file
	regfile registers(.clock(clock), .reset(reset), .raddr1(radd1),.rout1(rdata1),.raddr2(radd2),
                .rout2(rdata2),.wen(regWriteWb),.waddr(wadd),.win(wdata));


	wire cal_flag, add, sub, andd, orr, lw, sw, addi, subi,beqz, jr;
	assign cal_flag = !op[5] && !op[4] && !op[3] 
					&& !op[2] && !op[1] && !op[0];
	assign add = cal_flag && funct[5] && !funct[4] 
					&& !funct[3] && !funct[2] && !funct[1] && !funct[0];
	assign sub = cal_flag && funct[5] && !funct[4] 
					&& !funct[3] && !funct[2] && funct[1] && !funct[0];
	assign andd = cal_flag && funct[5] && !funct[4] 
					&& !funct[3] && funct[2] && !funct[1] && !funct[0];
	assign orr = cal_flag && funct[5] && !funct[4] 
					&& !funct[3] && funct[2] && !funct[1] && funct[0];
	assign jr = cal_flag && !funct[5] && !funct[4] 
					&& funct[3] && !funct[2] && !funct[1] && !funct[0];				
	assign lw =  op[5] && !op[4] && !op[3] 
					&& !op[2] && op[1] && op[0];
	assign sw =  op[5] && !op[4] && op[3] 
					&& !op[2] && op[1] && op[0];
	assign addi =  !op[5] && !op[4] && op[3] 
					&& !op[2] && !op[1] && !op[0];
	assign 	subi =  !op[5] && !op[4] && op[3] 
					&& op[2] && !op[1] && !op[0];
	assign beqz =  !op[5] && !op[4] && !op[3] 
					&& op[2] && !op[1] && !op[0];


	wire regWriteId,memtoRegId, memWriteId, aluSrcId, regDstId, jumpId, branchId;
	wire [2:0] aluControlId;
	
	assign regWriteId = add || sub || andd || orr || lw || addi || subi;
	assign memtoRegId = lw;
	assign memWriteId = sw;
	assign aluControlId[2] = andd || orr ;
	assign aluControlId[1] = sub || orr ||  beqz || subi;
	assign aluControlId[0] = add|| andd || lw || sw || addi;
	assign aluSrcId = addi || lw || sw || subi ;
	assign regDstId = add || sub|| andd ||orr ; 
	assign jumpId = jr;
	assign branchId = beqz;  
   
   /**
   *The control signal to select the source of value1Id,
   * the value of value1Id may come from Mem stage
   * to solve the Data hazards
   */
	reg forwardAId;  
	reg forwardBId;
	always @(rsId, rtId, writeRegMem, regWriteMem) 
	begin
		//if the result of the former instrution is in Mem stage, 
		//and the source register(rsId, rtId) is the same with 
		//the register that will be written(writeRegMem),
		//execute the forward

		if ((rsId != 5'b0) && (rsId == writeRegMem) && regWriteMem) 
			forwardAId = 1'b1;
		else 
			forwardAId = 1'b0;
			
		if ((rtId != 5'b0) && (rtId == writeRegMem) && regWriteMem) 
			forwardBId = 1'b1;
		else 
			forwardBId = 1'b0;
	
	end

	wire [31:0] value1Id; //The result that selected by forwardA
	wire [31:0] value2Id;	//The result that selected by forwardB 
	assign value1Id = (forwardAId == 0) ? rdata1 : aluOutMem;
	assign value2Id = (forwardBId == 0) ? rdata2 : aluOutMem;
	
	wire equalId;
	assign equalId = (value1Id == 0) ? 1'b1 : 1'b0;
	
	reg temp;
	//assign temp = branchId && equalId;
	always @(branchId, equalId) begin
	    temp = branchId & equalId;
	end
	assign pcSrcId[0] = temp;
	assign pcSrcId[1] = jumpId;
	
	//second pipeline -define the register of the Instruction Decode stage
	reg [31:0] signImmId_reg;
	reg [4:0] rdId_reg;
	reg [4:0] rtId_reg;
	reg [4:0] rsId_reg;
	reg [31:0] value1Id_reg;
	reg [31:0] value2Id_reg;
	reg regdstId_reg;
	reg aluSrcId_reg;
	reg [2:0] aluContolId_reg;
	reg memWriteId_reg;
	reg memtoRegId_reg;
	reg regWriteId_reg;
	
	always @ (posedge clock) 
	begin
		if(reset) begin 
			signImmId_reg   <= 0;
			rdId_reg        <= 0;
			rtId_reg        <= 0;
			rsId_reg        <= 0;
			value1Id_reg    <= 0;
			value2Id_reg    <= 0;
			regdstId_reg    <= 0;
			aluSrcId_reg    <= 0;
			aluContolId_reg <= 0; 
			memWriteId_reg  <= 0;
			memtoRegId_reg  <= 0;
			regWriteId_reg  <= 0;
		end
		else begin
				signImmId_reg <= signExtend;
				rdId_reg      <= rdId;
				rtId_reg      <= rtId;
				rsId_reg      <= rsId;
				value1Id_reg  <= value1Id;
				value2Id_reg  <= value2Id;
				regdstId_reg     <= regDstId;
				aluSrcId_reg     <= aluSrcId;
				aluContolId_reg  <= aluControlId; 
				memWriteId_reg   <= memWriteId;
				memtoRegId_reg   <= memtoRegId;
				regWriteId_reg   <= regWriteId;
		end
	end	
	
	//assign the idbus for convenience
	assign idbus[31:0] = signImmId_reg;
	assign idbus[36:32] = rdId_reg;
	assign idbus[41:37] = rtId_reg;
	assign idbus[46:42] = rsId_reg;
	assign idbus[78:47] = value2Id_reg;
	assign idbus[110:79] = value1Id_reg;
	assign idbus[111] = regdstId_reg;
	assign idbus[112] = aluSrcId_reg;
	assign idbus[115:113] = aluContolId_reg;
	assign idbus[116] = memWriteId_reg;
	assign idbus[117] = memtoRegId_reg;
	assign idbus[118] = regWriteId_reg;

endmodule