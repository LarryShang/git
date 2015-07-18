module instr_execute(clock, reset, 
					idbus, exebus,
					regWriteMem, regWriteWb,
					writeRegMem, writeRegWb,
					resultWb, aluOutMem,
					memtoRegExeWire, rtExeOut);
	
	input clock;
	input reset;

	input [118:0] idbus;
	input regWriteMem; //from mem stage
	input regWriteWb;  //from writeBack stage
	input [4:0] writeRegMem; 
	input [4:0] writeRegWb;
	input [31:0] resultWb;
	input [31:0] aluOutMem;
	
	output [4:0] rtExeOut;
	output memtoRegExeWire;
	output [71:0] exebus;
	
	parameter 	ADD  = 3'b001,
						    SUB  = 3'b010,
						   AND  = 3'b101,
						   OR   = 3'b110;
						 
	
	//define the wires
	wire [31:0] idbus_signImmExe;
	wire [4:0] idbus_rdExe;
	wire [4:0] idbus_rtExe;
	wire [4:0] idbus_rsExe;
	wire[31:0] idbus_value1Exe;
	wire[31:0] idbus_value2Exe;
	wire idbus_regdstExe;
	wire idbus_aluSrcExe;
	wire [2:0] idbus_aluContolExe;
	wire idbus_memWriteExe;
	wire idbus_memtoRegExe;
	wire idbus_regWriteExe;
	
	//parse the idbus
	assign idbus_signImmExe = idbus[31:0];
	assign idbus_rdExe = idbus[36:32];
	assign idbus_rtExe = idbus[41:37];
	assign idbus_rsExe = idbus[46:42];
	assign idbus_value2Exe = idbus[78:47];
	assign idbus_value1Exe = idbus[110:79];
	assign idbus_regdstExe = idbus[111];
	assign idbus_aluSrcExe = idbus[112];
	assign idbus_aluContolExe = idbus[115:113];
	assign idbus_memWriteExe = idbus[116];
	assign idbus_memtoRegExe = idbus[117];
	assign idbus_regWriteExe = idbus[118];
	
	//assign the output wire---rtExeOut,  memtoRegExe_wire
	//be used in the cpu.v, to solve the hazard
	assign rtExeOut = idbus[41:37];
	assign memtoRegExeWire = idbus[117];
	
	
	//define the contol signal for bypass
	reg [1:0] forwardAExe;
	reg [1:0] forwardBExe;
	
	//detect the EXE hazard, MEM hazard, and the signal to solve the hazard
	always @(idbus_rsExe, idbus_rtExe, 
			writeRegMem, regWriteMem,
			writeRegWb, regWriteWb) 

	begin
		if ((idbus_rsExe != 5'b0) && (idbus_rsExe == writeRegMem) && regWriteMem) 
			forwardAExe = 2'b10;
		else if ((idbus_rsExe != 0) && (idbus_rsExe == writeRegWb) && regWriteWb) 
			forwardAExe = 2'b01;
		else 
			forwardAExe = 2'b00;
			
		if ((idbus_rtExe != 5'b0) && (idbus_rtExe == writeRegMem) && regWriteMem) 
			forwardBExe = 2'b10;
		else if ((idbus_rtExe != 5'b0) && (idbus_rtExe == writeRegWb) && regWriteWb) 
			forwardBExe = 2'b01;
		else 
			forwardBExe = 2'b00;
	
	end
	
	reg [31:0] srcAExe;
	reg [31:0] tempExe;
	reg [31:0] srcBExe;
	//choose the srcAeXE, tempeXE for ALU
	always @ (forwardAExe, forwardBExe, 
			  idbus_value1Exe, idbus_value2Exe,
			  resultWb, aluOutMem)

	begin
		if(forwardAExe == 2'b00)
			srcAExe = idbus_value1Exe;
		else if(forwardAExe == 2'b01)
			srcAExe = resultWb;
		else
			srcAExe = aluOutMem;

		if(forwardBExe == 2'b00)
			tempExe = idbus_value2Exe;
		else if(forwardBExe == 2'b01)
			tempExe = resultWb;
		else
			tempExe = aluOutMem;

	end
	
	//choose the srcBExe for ALU
	always @(idbus_aluSrcExe, tempExe, idbus_signImmExe) begin
		if(idbus_aluSrcExe ==0)   // come from the RB
			srcBExe = tempExe;
		else
			srcBExe = idbus_signImmExe;  //come from the Imm

	end
	
	//third pipeline - define the register of the EXE stage
	reg regWriteExe;
	reg memtoRegExe;
	reg memWriteExe;
	reg [31:0] aluOutExe;
	reg [31:0] writeDataExe;
	reg [4:0] writeRegExe;

	always @(posedge clock) 

	begin
		if(reset) begin
			regWriteExe <= 0;
			memtoRegExe <= 0;
			memWriteExe <= 0;
			writeDataExe <= 0;
			writeRegExe <= 0;
		end
		else begin

			regWriteExe <= idbus_regWriteExe;
			memtoRegExe <= idbus_memtoRegExe;
			memWriteExe <= idbus_memWriteExe;
			writeDataExe <= tempExe;
			writeRegExe <= (idbus_regdstExe == 0) ? idbus_rtExe : idbus_rdExe;

		    //evaluate the aluOutExe according to the control signal
		    
			case(idbus_aluContolExe)
				ADD:
					begin
						aluOutExe <= srcAExe + srcBExe;
					end
				
				SUB:
					begin
						aluOutExe <= srcAExe - srcBExe;
					end
				AND:
					begin 
						aluOutExe <= srcAExe & srcBExe;
					end
				OR:
					begin
						aluOutExe <= srcAExe | srcBExe;
					end

				default: 
				   begin

				   end
      endcase




		end	
	end   

	assign exebus[4:0] = writeRegExe;
	assign exebus[36:5] = writeDataExe;
	assign exebus[68:37] = aluOutExe;
	assign exebus[69] = memWriteExe;
	assign exebus[70] = memtoRegExe;
	assign exebus[71] = regWriteExe;
	
endmodule