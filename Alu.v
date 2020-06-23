`define CLCYE_TIME 10.0

module Alu(
    input   [4:0]   ALUSignal,
    input   [31:0]  AiA,
    input   [31:0]  AiB,
    input           ready,
    output  reg [31:0]  Aout,
    output  reg     AZout,              // ALU Zero output
    output  reg     valid,
    output  reg     mode
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
    parameter MUL  = 4'b1100;
    parameter DIV  = 4'b1101;
    parameter SCS  = 1'b0;
    parameter MCS  = 1'b1;

    //reg     [1:0]   ALUstate, ALUstate_nxt;
    reg     clk, ALUstate, ALUstate_nxt;
    integer   i;

    assign ALUSignal = SRL;             // For test: Set value to ALUSignal
    assign AiA = 32'hFFFF_FFFF;         // For test: Set value to ALUinA
    assign AiB = 32'h0000_0005;         // For test: Set value to ALUinB

    // Clock waveform definition            // For test
    always begin
        for (i=1; i<=100; i=i+1) begin
            #(`CLCYE_TIME*0.5) clk = ~clk;   // For test
        end
    end

    // FSM ALUstate
    always @(ALUSignal) begin
        case(ALUstate)
            SCS: begin                  // Single cycle state
                if ((ALUSignal == MUL) || (ALUSignal == DIV)) ALUstate_nxt = MCS;
                else ALUstate_nxt = SCS;
            end
            MCS: begin                  // Multi cycle state
                if (ready) ALUstate_nxt = SCS;
            end
        default: ALUstate_nxt = SCS;
        endcase
    end

    always @(*) begin
        case(ALUstate)
            SCS: begin
                valid = 0;
            end
            MCS: begin
                valid = 1;
                #(`CLCYE_TIME)
                valid = 0;
            end
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
            SLT: begin                  // Signed SLT
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
            SLTU: begin                 // Unsigned SLT
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
                mode = 0;
                Aout = AiA * AiB;       // Multiplication
            end
            DIV: begin
                mode = 1;
                #(`CLCYE_TIME)
                mode = 0;
                Aout = AiA / AiB;       // Division
            end
        endcase
    end

    always @(Aout) begin
        if (Aout == 0)
            AZout = 1;
    end

endmodule
