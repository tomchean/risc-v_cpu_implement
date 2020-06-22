module Alu(
    input   [4:0]   ALUSignal,
    input   [31:0]  AiA,
    input   [31:0]  AiB,
    output  reg [31:0]  Aout,
    output  reg AZout                   // ALU Zero output    
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
        endcase
    end

    always @(Aout) begin
        if (Aout == 0)
            AZout = 1;
    end

endmodule
