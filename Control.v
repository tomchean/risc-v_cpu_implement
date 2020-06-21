module Control(
    input   [6:0]  Opcode,
    output  reg   Branch,
    output  reg   MemRead,
    output  reg   [1:0] MemtoReg,
    output  reg   [2:0] ALUOp,
    output  reg   MemWrite,
    output  reg   ALUSrc,
    output  reg   RegWrite
);

    parameter RTYPE  = 3'b000;
    parameter ITYPE  = 3'b001;
    parameter STYPE  = 3'b010;
    parameter BTYPE  = 3'b011;
    parameter UTYPE  = 3'b100;
    parameter JTYPE  = 3'b101;
    parameter LITYPE = 3'b110;
    parameter JITYPE = 3'b111;

    parameter ARITHMETIC = 7'b0110011;
    parameter ARI_IMM    = 7'b0010011;
    parameter BRANCH     = 7'b1100011;
    parameter MEMLOAD    = 7'b0000011;
    parameter MEMSAVE    = 7'b0100011;
    parameter AUIPC      = 7'b0010111;
    parameter JAL        = 7'b1101111;
    parameter JALR       = 7'b1100111;

    always @(*) begin
        case(Opcode)
            ARITHMETIC : begin
                Branch = 0;
                MemRead = 0;
                MemtoReg = 2'b00;
                ALUOp = RTYPE;
                MemWrite = 0;
                ALUSrc = 0;
                RegWrite = 1;
            end
            ARI_IMM : begin
                Branch = 0;
                MemRead = 0;
                MemtoReg = 2'b00;
                ALUOp = ITYPE;
                MemWrite = 0;
                ALUSrc = 1;
                RegWrite = 1;
            end
            BRANCH : begin
                Branch = 1;
                MemRead = 0;
                MemtoReg = 2'b00;
                ALUOp = BTYPE;
                MemWrite = 0;
                ALUSrc = 0;
                RegWrite = 1;
            end
            MEMLOAD : begin
                Branch = 0;
                MemRead = 1;
                MemtoReg = 2'b01;
                ALUOp = LITYPE;
                MemWrite = 0;
                ALUSrc = 1;
                RegWrite = 1;
            end
            MEMSAVE : begin
                Branch = 0;
                MemRead = 0;
                MemtoReg = 2'b00;
                ALUOp = STYPE;
                MemWrite = 1;
                ALUSrc = 1;
                RegWrite = 0;
            end
            AUIPC : begin
                Branch = 0;
                MemRead = 0;
                MemtoReg = 2'b10;
                ALUOp = UTYPE;
                MemWrite = 0;
                ALUSrc = 1;
                RegWrite = 1;
            end
            JAL : begin
                Branch = 0;
                MemRead = 0;
                MemtoReg = 2'b11;
                ALUOp = JTYPE;
                MemWrite = 0;
                ALUSrc = 1;
                RegWrite = 1;
            end
            JALR : begin
                Branch = 0;
                MemRead = 0;
                MemtoReg = 2'b11;
                ALUOp = JITYPE;
                MemWrite = 0;
                ALUSrc = 1;
                RegWrite = 1;
            end
            // Todo mul support
            /**
            MUL   : begin
                Branch = 1;
                MemRead = 0;
                MemtoReg = 0;
                ALUOp = 2'b01;
                MemWrite = 0;
                ALUSrc = 0;
                RegWrite = 1;
            end
            **/
        endcase
    end

endmodule
