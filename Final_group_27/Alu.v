`include "Muldiv.v"

module Alu(
    input    clk,
    input   [4:0]   ALUSignal,
    input   [31:0]  AiA,
    input   [31:0]  AiB,
    output  reg [31:0]  Aout,
    output  reg  AZout,                // ALU Zero output    
    output  state_out
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

    reg state = 1'b0;
    reg mode = 1'b0;
    reg rst_n;
    reg valid;
    reg mulDiv_ready = 1'b0;
    wire [63:0] mulDivOut;
    wire ready;
    wire w_rst_n;
    wire w_mode;
    wire w_valid;

    assign state_out = state;
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

    always @(ready) begin
        case (state)
            MCYCLE : begin
                if (ready == 1'b1) begin
                    mulDiv_ready  = 1'b1;
                    state = SCYCLE;
                end
                else state = SCYCLE; 
            end
            SCYCLE : begin 
            end
            default : begin
                state = SCYCLE;
            end
        endcase
    end

    // ALU FSM
    always @(*) begin 
        case(ALUSignal)
            ADD: begin
                Aout = AiA + AiB;       // Addition
                state = SCYCLE;
                valid = 1'b0;
                mulDiv_ready  = 1'b0;
                /** Todo
                * Hard code here
                * remove it after fix
                **/
            end
            SUB: begin
                Aout = AiA - AiB;       // Substration
                state = SCYCLE;
                valid = 1'b0;
                mulDiv_ready  = 1'b0;
            end
            SLL: begin
                Aout = AiA << AiB;      // Shift AiB bits left
                state = SCYCLE;
                valid = 1'b0;
                mulDiv_ready  = 1'b0;
            end
            SLT: begin
                state = SCYCLE;
                valid = 1'b0;
                mulDiv_ready  = 1'b0;
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
                if (AiA < AiB)
                    Aout = 1'b1;
                else
                    Aout = 1'b0;
                state = SCYCLE;
                valid = 1'b0;
                mulDiv_ready  = 1'b0;
            end
            XOR: begin
                Aout = AiA ^ AiB;       // XOR
                state = SCYCLE;
                valid = 1'b0;
                mulDiv_ready  = 1'b0;
            end
            SRL: begin
                Aout = AiA >>> AiB;     // Arithmetic shift AiB bits right
                state = SCYCLE;
                valid = 1'b0;
                mulDiv_ready  = 1'b0;
            end
            SRA: begin
                Aout = AiA >> AiB;      // Shift AiB bits right
                state = SCYCLE;
                valid = 1'b0;
                mulDiv_ready  = 1'b0;
            end
            OR: begin
                Aout = AiA | AiB;       // Bitwise OR
                state = SCYCLE;
                valid = 1'b0;
                mulDiv_ready  = 1'b0;
            end
            AND: begin
                Aout = AiA & AiB;       // Bitwise AND
                state = SCYCLE;
                valid = 1'b0;
                mulDiv_ready  = 1'b0;
            end
            MUL : begin
                Aout = mulDivOut[31:0];
                case (state)
                    SCYCLE : begin
                        if (mulDiv_ready == 0) begin
                            rst_n = 1'b1;
                            valid = 1'b1;
                            state = MCYCLE;
                        end
                        else begin
                            rst_n = 1'b0;
                            valid = 1'b0;
                            state = SCYCLE;
                        end
                    end
                    MCYCLE : begin
                    end
                endcase
            end
            default : begin
                Aout = 32'b0;
            end
        endcase
    end

    always @(*) begin
        if (Aout == 0) AZout = 1;
        else AZout = 0;
    end

endmodule
