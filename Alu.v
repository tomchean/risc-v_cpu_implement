module Alu(
    input   [4:0]   ALUSignal,
    input   [31:0]  AiA,
    input   [31:0]  AiB,
    output  reg [31:0]  Aout,
    output  reg AZout                   // ALU Zero output    
);      

    `include "Alu_Control.v"

    ALU_Control alu_control0(
        .ALUSignal(ALUSignal)
        .valid(valid)
        .mode(mode)
    );

    parameter ADD  = 4'b0000;
    parameter SUB  = 4'b0001;
    parameter SLL  = 4'b0010;
    parameter SLT  = 4'b0011;
    parameter SLTU = 4'b0100;
    parameter XOR  = 4'b0101;
    parameter SRL  = 4'b0110;
    parameter SRA  = 4'b0111;
    parameter OR   = 4'b1000;
    parameter AND  = 4'b1001;
    parameter MUL  = 99;
    parameter DIV  = 98;

    // ALU FSM
    always @(ALUSignal) begin
        case(state)
            IDLE: begin
                if (valid) begin
                    if (mode) state_nxt = DIV;
                    else state_nxt = MULT;
                end
                else begin
                    if (mode) state_nxt = SCC;
                end
                else state_nxt = IDLE;
            end
            SCC: begin
                if (counter == 1) state_nxt = OUT;
            end
            MULT: begin
                if (counter == 31) state_nxt = OUT;
                else state_nxt = MULT;
            end
            DIV : begin
                if (counter == 31) state_nxt = OUT;
                else state_nxt = DIV;
            end
            OUT : state_nxt = IDLE;
        default: state_nxt = OUT;
        endcase
    end

    always @(*) begin 
        case(ALUSignal)
            ADD: begin
                Aout = AiA + AiB;       // Addition
            end
            SUB: begin
                Aout = AiA - AiB;       // Substration
            end
            SLL: begin
                Aout = AiA << AiB;      // Shift AiB bits left
            end
            SLT: begin
                if (AiB[31] == 1'b0) begin
                    if (AiA[31] == 1'b1) Aout = 1'b1;
                    else begin
                        if (AiA < AiB) Aout = 1'b1;
                        else Aout = 1'b0;
                    end
                end
                else begin
                    if (AiA[31] == 1'b0) Aout = 1'b0;
                    else begin
                        if (AiA[30:0] < AiB[30:0]) Aout = 1'b0;
                        else Aout = 1'b1;
                    end
                end
            end
            SLTU: begin                 //Unsigned SLT
                if (AiA < AiB) Aout = 1'b1;
                else Aout = 1'b0;
            end
            XOR: begin
                Aout = AiA ^ AiB;       // XOR
            end
            SRL: begin
                Aout = AiA >>> AiB;     // Arithmetic shift AiB bits right
            end
            SRA: begin
                Aout = AiA >> AiB;      // Shift AiB bits right
            end
            OR: begin
                Aout = AiA | AiB;       // Bitwise OR
            end
            AND: begin
                Aout = AiA & AiB;       // Bitwise AND
            end
            MUL: begin
                Aout = AiA * AiB;       // Multiplication
            end
            DIV: begin
                Aout = AiA / AiB;       // Division
            end
        endcase
    end

    always @(Aout) begin
        if (Aout == 0)
            AZout = 1;
    end

endmodule
