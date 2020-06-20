module Control(
    input   [5:0]  Opcode,
    output   reg   Branch,
    output   reg   MemRead,
    output   reg   MemtoReg,
    output   reg   [1:0] ALUOp,
    output   reg   MemWrite,
    output   reg   ALUSrc,
    output   reg   RegWrite
)

    parameter ARITHMETIC = 7'b0110011;
    parameter ARI_IMM    = 7'b0010011;
    parameter BRANCH     = 7'b1100011;
    parameter MEMLOAD    = 7'b0000011;
    parameter MEMSAVE    = 7'b0100011;
    parameter AUIPC      = 7'b0010111;

    always @(*) begin
        case(Opcode):
            `ARITHMETIC : begin
                Branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                ALUOp = 2'b10;
                MemWrite = 0;
                ALUSrc = 0;
                RegWrite = 1;
            end
            `ARI_IMM : begin
                Branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                ALUOp = 2'b10;
                MemWrite = 0;
                ALUSrc = 1;
                RegWrite = 1;
            end
            `BRANCH : begin
                Branch = 1;
                MemRead = 0;
                MemtoReg = 0;
                ALUOp = 2'b01;
                MemWrite = 0;
                ALUSrc = 0;
                RegWrite = 1;
            end
            `MEMLOAD : begin
                Branch = 0;
                MemRead = 1;
                MemtoReg = 1;
                ALUOp = 2'b00;
                MemWrite = 0;
                ALUSrc = 1;
                RegWrite = 1;
            end
            `MEMSAVE : begin
                Branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                ALUOp = 2'b00;
                MemWrite = 1;
                ALUSrc = 1;
                RegWrite = 0;
            end
            // Todo auipc and mul support
            /**
            `AUIPC : begin
                Branch = 1;
                MemRead = 0;
                MemtoReg = 0;
                ALUOp = 2'b01;
                MemWrite = 0;
                ALUSrc = 0;
                RegWrite = 1;
            end
            `MUL   : begin
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
