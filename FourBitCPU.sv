module FourBitCPU(clk_load, reset, clk, myprogram, myinput, progReg, dataStore, stackReg, myoutput, HLT, s_flag, z_flag, c_flag);
	parameter n=4;
	input clk_load, reset, clk; // program, data shall be loaded with clk_load and the computer shall
								// with clk
	
	input [7:0] myprogram;			// Instructions and memory addresses that
										// are clk_loaded before a computer run
	input [n-1:0] myinput;					// Data that are clk_loaded before a computer run
	

	reg [n-1:0] regs[1:0]; // registers, where regs[0]=A and regs[1]=B; In this way it can be easily extended.
	output reg [7:0] progReg[0:15]; // instructions shall be loaded here.
	output reg [n-1:0] dataStore[0:15]; // data shall be loaded here.
										// responsible for address-based operations
	output reg [n-1:0] stackReg[0:15]; // stack registers shall contain the push operations
	
	output reg [n-1:0] myoutput; // output shall be shown here under OUT operation
	output reg HLT, s_flag, z_flag, c_flag;	// status flags: sign, zero and carry 

	reg [n-1:0] stackPoint, addPoint, temp;	// temporary storage, opcode, address and stack pointers
	
	integer progCount = 0; // Program counter, counting from 0 to 15
	integer i = 0;
	
	// initializing
	initial								
	begin
		{s_flag, c_flag, z_flag, HLT} = 0;
		stackPoint = 4'b1110;
		regs[0] = 4'b0111;        
		regs[1] = 4'b0011;        
	end
	
	// instructions, memory addresses are being loaded -- before the computer starts
	always @(posedge clk_load)
	begin
		if(i < 16)
		begin
			progReg[i] = myprogram;
			dataStore[i] = myinput;
			i = i + 1;
		end
	end
	
	// Computer shall operate at this portion, after all the instructions are loaded.
	always @(posedge clk)
	begin
		if(progCount < 16 && !HLT) // for 16 operations, counter shall count up to 16 or until HLT is given
		
			addPoint = progReg[progCount][3:0];	// lower nibble represents the address
			
			begin
				casez(progReg[progCount]) //casez is considered since the lower nibble are don't care here.

					//ADD regs[0],regs[1]
					8'b0000????:
					begin
										 
						{c_flag, regs[0]} = regs[0] + regs[1];
						z_flag = (regs[0] == 0)? 1:0;
						
					end
					
					//SUB regs[0],regs[1]
					8'b0001????:
					begin					
						if (regs[0] < regs[1]) s_flag = 1;
						else s_flag = 0;
						regs[0] = regs[0]+(~regs[1]+1);
						z_flag = (regs[0] == 0)? 1:0;
						
					end
					
					//XCHG regs[1],regs[0]
					8'b0010????:
					begin					
						temp = regs[0];
						regs[0] = regs[1];
						regs[1] = temp;
					end
					
					//MOV regs[0],[ADDRESS]
					8'b0011????:
					begin					
						regs[0] = dataStore[addPoint]; // lower nibble is in addPoint, which will indicate the value from dataStore.
						z_flag = (regs[0] == 0)? 1:0;
					end
					
					//RCR regs[1]
					8'b0100????:
					begin					
						temp[3] = c_flag;
						{regs[1], c_flag} = {regs[1], c_flag} >> 1;
						regs[1][3] = temp[3]; //z_flag is not considered since accumulator is not changing
						
					end
					
					
					
					//IN regs[0]
					8'b0101????: regs[0] = myinput;
					
					//OUT regs[0]
					8'b0110????: myoutput = regs[0];
					
					
					//AND regs[0],regs[1]
					8'b0111????:
					begin
					 regs[0] = regs[0]&regs[1]; //AND operation
					 if (regs[0] == 0) z_flag = 1;
					 end
					
					//TEST
					8'b1000????:
					begin				
						c_flag = 0; // TEST operation
						 temp = regs[0];
						 regs[0] = (regs[0]&regs[1]);
						 s_flag = regs[0][3];
						 regs[0] = temp;
					end
					
					//OR B, ADDRESS
					8'b1001????:
					
					begin					
						regs[1] = regs[1] | dataStore[addPoint]; //flags will not update as its not accumulator
					end
					
					//XOR regs[0], ADDRESS
					8'b1010????:
					
					begin					
						regs[0] = regs[0] ^ dataStore[addPoint];
						if (regs[0] == 0) z_flag = 1;
						else z_flag = 0;
					end
					
					
					//PUSH
					8'b1011????:
					
					begin				
						stackPoint = stackPoint - 1;
						stackReg[stackPoint] = regs[1];
					end
					
					
					
					//POP
					8'b1100????:
					
					begin				
						regs[1] = stackReg[stackPoint];
						stackPoint = stackPoint + 1;
					end
					
								
					
					//HLT
					8'b1111????:
					begin	
						HLT = 1;
					end						
				endcase
			progCount = progCount + 1;
			end
	end
	
endmodule 