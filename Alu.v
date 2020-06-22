`include "Muldiv.v"

module Alu(
    input    clk,
    input   [4:0]   ALUSignal,
    input   [31:0]  AiA,
    input   [31:0]  AiB,
    output  reg [31:0]  Aout,
    output  reg AZout,                // ALU Zero output    
    output  reg state
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
    parameter MUL  = 4'b1010;
    parameter DIV  = 4'b1011;

    parameter SCYCLE = 1'b0;
    parameter MCYCLE = 1'b1;

    reg mode;
    reg rst_n;
    reg valid;
    wire [63:0] mulDivOut;
    wire ready;
    wire w_rst_n;
    wire w_mode;
    wire w_valid;

    assign w_rst_n = rst_n; 
    assign w_mode = mode; 
    assign w_valid = valid; 

    Muldiv muldiv(
        .clk(clk),
        .rst_n(rst_n),
        .valid(valid),
        .mode(mode),
        .in_A(AiA),
        .in_B(AiB),
        .ready(ready),
        .out(mulDivOut)
    );

    always @(*) begin
        case (state)
            MCYCLE : begin
                if (ready == 1'b1) begin
                    rst_n = 1'b1;
                    state = SCYCLE;
                    Aout = mulDivOut[31:0];
                end
            end
        endcase
    end

    // ALU FSM
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
                    if (AiA[31] == 1'b1)
                        Aout = 1'b1;
                    else begin
                        if (AiA < AiB)
                            Aout = 1'b1;
                        else
                            Aout = 1'b0;
                    end
                end
                else begin
                    if (AiA[31] == 1'b0)
                        Aout = 1'b0;
                    else begin
                        if (AiA[30:0] < AiB[30:0])
                            Aout = 1'b0;
                        else
                            Aout = 1'b1;
                    end
                end
            end
            SLTU: begin                 //Unsigned SLT
                if (AiA < AiB)
                    Aout = 1'b1;
                else
                    Aout = 1'b0;
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
            MUL : begin
                if (state != MCYCLE) begin
                    mode = 1'b0;
                    rst_n = 1'b0;
                    valid = 1'b1;
                end
            end
        endcase
    end

    always @(Aout) begin
        if (Aout == 0) AZout = 1;
        else AZout = 0;
    end

endmodule
