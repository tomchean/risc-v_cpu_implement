`define ADD 10
`define SUB 10
`define AND 10
`define OR 10
`define SLTU 10
`define XOR 10
`define SLL 10
`define SRL 10
`define SRA 10

module ALU(
    input   [4:0]   ALUSignal,
    input   [31:0]  AiA,
    input   [31:0]  AiB,
    output  [31:0]  Aout,
    input   ACin,           // ALU carry input
    output  ACout,          // ALU carry output  
    output  AZout,          // ALU Zero output    
);      

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
