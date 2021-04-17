# 4bitPC

A 4-bit computer can work with 4 data-bits for its various operations including addition, subtraction and so on. It consists of several parts to achieve this including program counter, accumulator, instruction registers, general purpose registers, stack registers, etc. The instructions fed into the computer are 8-bit long; with the upper 4-bits i.e. upper nibble represents the operation code, which is basically the program counter for case-based operations. The implemented algorithm is to some extent similar to the Simple As Possible (SAP)-1 architecture, with reduced complexity but enhanced calculative capability.

# Operations
Here, I have performed the following 16 operations:

1.	ADD  A,B
2.	SUB  A,B
3.	XCHG  B,A
4.	MOV A, [ADDRESS]
5.	RCR  B
6.	IN  A
7.	OUT  A
8.	AND  A,B
9.	TEST  B, BYTE
10.	OR  B, BYTE
11.	XOR  A, [ADDRESS]
12.	PUSH  B
13.	POP  B
14.	CALL  ADDRESS
15.	RET
16.	HLT
 
To achieve this goal, the implemented algorithm has been the following:
*	Registers A and B (in the code, regs[0] and regs[1], in order) shall contain the values to be worked with
*	All the instructions shall be kept in a 16x8 program registers
*	Each instructions will be 8-bit long, with the upper nibble being the opcode
*	All the data shall be kept in another 16x8 data registers
*	16 case-based operations shall be performed depending on the opcode
*	Zero, sign and carry flags shall contain the updated flag values

# How it works
The progReg holds all the instructions, dataStore holds all the input values, stackReg holds the pushed values where the stackPoint is at 14 (b’1110). For the case-based operations, casez is utilized as the lower 4-bit of the instructions are don’t care values. The regs[0] and regs[1] are declared as reg, each 4-bit long, as this is a 4-bit PC. They are declared in this way so that more registers can be easily accessed.

*	ADD: regs[0] and regs[1] values are added, and if regs[0] becomes 0 after addition, then z_flag (zero flag) will be 1, otherwise 0.
*	SUB: regs[1] is subtracted from regs[0], and if regs[0] becomes 0 after addition, then z_flag (zero flag) will be 1, otherwise 0. If regs[0] is less than regs[1], then s_flag (sign flag) will be 1.
*	XCHG: Using a temporary register, regs[0] and regs[1] interchanges their values. If regs[0] becomes zero, then z_flag=1.
*	MOV A, [ADDRESS]: According to the lower nibble (4-bits) of the instruction, data is fetched from the dataStore and put in A.
*	RCR B: The carry flag is stored and later put in the MSB of B, whereas the rest of the values are shifter to the right.
*	IN A: Input is put in A
*	OUT A: A is put in myoutput.
*	AND A,B: And operation is performed, which is by default bitwise and.
*	TEST  B, [ADDRESS]: Here and operation is performed without altering B. To do that, temp stores the value of B primarily, and later it is put in B again. The lower nibble of the instruction is important, to fetch the desired value from dataStore.
*	OR  B, [ADDRESS]: Or operation is performed after fetching the value from dataStore.
*	XOR  A, [ADDRESS]: XOR operation is after fetching the value from dataStore.
*	PUSH  B: The value of B is pushed into the stack. The stackPoint was at 14, since it works in LIFO (Last-in-First-out) method, the stackPoint becomes 13 and there the value of B is stored.
*	POP  B: The value of B is returned from the stack. stackReg[stackPoint] holds the desired value, whose size is also 4-bit.
*	CALL  ADDRESS: Performing the call operation, this particular value of progCount shall be stored, as it needs to perform the later operations from this point. This is similar to PUSH, but I couldn’t implement it.
*	RET: The program starts with the stored progCount value to bring that stored value. I couldn’t implement it.
*	HLT: Hlt  variable becomes 1, stopping the whole program, i.e., the case-based operations.
