// Your code
`define OPCODE mem_rdata_I[6:0]
`define RD mem_rdata_I[11:7]
`define RS1 mem_rdata_I[19:15]
`define RS2 mem_rdata_I[24:20]
`define FUNCT3 mem_rdata_I[14:12]
`define FUNCT7 mem_rdata_I[31:25]
`define IMM mem_rdata_I[31:7]

`include "Alu.v"
`include "Alu_Control.v"
`include "Mux.v"
`include "Imm_Gen.v"
`include "Control.v"
`include "Muldiv.v"

module CHIP(clk,
            rst_n,
            // For mem_D
            mem_wen_D,
            mem_addr_D,
            mem_wdata_D,
            mem_rdata_D,
            // For mem_I
            mem_addr_I,
            mem_rdata_I);

    input         clk, rst_n ;
    // For mem_D
    output        mem_wen_D  ;
    output [31:0] mem_addr_D ;
    output [31:0] mem_wdata_D;
    input  [31:0] mem_rdata_D;
    // For mem_I
    output [31:0] mem_addr_I ;
    input  [31:0] mem_rdata_I;
    
    //---------------------------------------//
    // Do not modify this part!!!            //
    // Exception: You may change wire to reg //
    reg    [31:0] PC          ;              //
    reg    [31:0] PC_nxt      ;              //
    wire          regWrite    ;              //
    wire   [ 4:0] rs1, rs2, rd;              //
    wire   [31:0] rs1_data    ;              //
    wire   [31:0] rs2_data    ;              //
    wire   [31:0] rd_data     ;              //
    //---------------------------------------//

    // Todo: other wire/reg
    assign mem_addr_I = PC;

    // alu signal
    wire [4:0]  ALUSignal;
    wire [31:0] ALUInput2;
    wire ALUZout;
    wire [31:0] ALUResult;
    wire [31:0] ImmOut;
    wire [31:0] Addr;
    wire [31:0] PCPlus4;
    wire [1:0] PCControl;

    // controller signal
    wire MemRead;
    wire [1:0] MemtoReg;
    wire [2:0] ALUOp;
    wire MemWrite;
    wire ALUSrc;
    wire RegWrite;

    assign regWrite = RegWrite;
    assign rs1 = `RS1;
    assign rs2 = `RS2;
    assign rd = `RD;
    assign Addr = ImmOut + PC;
    assign PCPlus4 = PC + 4;

    //---------------------------------------//
    // Do not modify this part!!!            //
    reg_file reg0(                           //
        .clk(clk),                           //
        .rst_n(rst_n),                       //
        .wen(regWrite),                      //
        .a1(rs1),                            //
        .a2(rs2),                            //
        .aw(rd),                             //
        .d(rd_data),                         //
        .q1(rs1_data),                       //
        .q2(rs2_data));                      //
    //---------------------------------------//
    
    // Todo: any combinational/sequential circuit
    

    ALU_Control alu_control0(
        .Funct3(`FUNCT3),
        .Funct7(`FUNCT7),
        .ALUOp(ALUOp),
        .ALUSignal(ALUSignal)
    );

    Control control0(
        .Opcode(`OPCODE),
        .PCControl(PCControl),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .ALUOp(ALUOp),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite)
    );

    Imm_Gen imm_gen0(
        .Instruction(`IMM),
        .Type(ALUOp),
        .Imm(ImmOut)
    );

    Alu alu0(
        .ALUSignal(ALUSignal),
        .AiA(rs1_data),
        .AiB(ALUInput2),
        .Aout(ALUResult),
        .AZout(ALUZout)
    );

    Mux2 aluInput2(
        .s1(rs2_data),
        .s2(ImmOut),
        .control(ALUSrc),
        .o1(ALUInput2)
    );

    Muldiv muldiv(
        .clk(clk),
        .rst_n(rst_n),
        .valid(Muldiv_valid),
        .mode(Muldiv_mode),
        .in_A(rs1_data),
        .in_B(ALUInput2),
        .ready(Muldiv_ready),
        .out(Muldiv_out)
    );

    Mux4 regWriteData(
        .s1(ALUResult),
        .s2(mem_rdata_D),
        .s3(Addr),
        .s4(PCPlus4), // 
        .control(MemtoReg),
        .o1(rd_data)
    );

    assign  mem_wen_D = MemWrite;
    assign  mem_wdata_D = MemWrite ? rs2_data: 0;
    assign  mem_addr_D = ALUResult;

    always @(*) begin
        case (PCControl)
            2'b00 : PC_nxt = PC + 4;
            2'b01 : begin
                if (ALUZout == 1'b0) PC_nxt = PC + ImmOut << 1; // branch
                else PC_nxt = PC + 4;
            end
            2'b10 : PC_nxt = PC + (ImmOut << 1);   //jal 
            2'b11 : PC_nxt = ALUResult;          //jalr 
            default : PC_nxt = PC + 4; 
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            PC <= 32'h00010000; // Do not modify this value!!!
        end
        else begin
            PC <= PC_nxt;
        end
    end
endmodule

module reg_file(clk, rst_n, wen, a1, a2, aw, d, q1, q2);
   
    parameter BITS = 32;
    parameter word_depth = 32;
    parameter addr_width = 5; // 2^addr_width >= word_depth
    
    input clk, rst_n, wen; // wen: 0:read | 1:write
    input [BITS-1:0] d;
    input [addr_width-1:0] a1, a2, aw;

    output [BITS-1:0] q1, q2;

    reg [BITS-1:0] mem [0:word_depth-1];
    reg [BITS-1:0] mem_nxt [0:word_depth-1];

    integer i;

    assign q1 = mem[a1];
    assign q2 = mem[a2];

    always @(*) begin
        for (i=0; i<word_depth; i=i+1)
            mem_nxt[i] = (wen && (aw == i)) ? d : mem[i];
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mem[0] <= 0;
            for (i=1; i<word_depth; i=i+1) begin
                case(i)
                    32'd2: mem[i] <= 32'hbffffff0;
                    32'd3: mem[i] <= 32'h10008000;
                    default: mem[i] <= 32'h0;
                endcase
            end
        end
        else begin
            mem[0] <= 0;
            for (i=1; i<word_depth; i=i+1)
                mem[i] <= mem_nxt[i];
        end       
    end
endmodule
