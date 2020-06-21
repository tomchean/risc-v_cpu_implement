module Alu(
    input   [4:0]   ALUSignal,
    input   [31:0]  AiA,
    input   [31:0]  AiB,
    output  [31:0]  Aout,
    input   ACin,           // ALU carry input
    output  ACout,          // ALU carry output  
    output  AZout,          // ALU Zero output    
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
            `ADD: begin
                {ACout, Aout} = AiA + AiB + ACin; // Addition
            end
            `SUB: begin
                Aout = AiA - AiB;       // Substration
            end
            `AND: begin
                Aout = AiA & AiB;       // Bitwise AND
            end
            `OR: begin
                Aout = AiA | AiB;       // Bitwise OR
            end
            `SLTU: begin                //?? SLTU or SLTI?
                if (AiA < AiB)
                    Aout = 32'b1;
                else
                    Aout = 32'b0;
            end            
            `XOR: begin
                Aout = AiA ^ AiB;       // XOR
            end
            `SLL: begin
                Aout = AiA << AiB;      // Shift AiB bits left
            end
            `SRL: begin
                Aout = AiA >>> AiB;     // Arithmetic shift AiB bits right
            end
            `SRA: begin
                Aout = AiA >> AiB;      // Shift AiB bits right
            end
        endcase
    end
    always @(Aout) begin
        if(Aout==0)
            AZout = 1;
    end
endmodule