module ALU(
    input   [4:0]   ALUSignal,
    input   [31:0]  ALUinA,
    input   [31:0]  ALUinB,
    output  [31:0]  ALUout,
    output  [1:0]   Flags
)

    always @(*) begin 
        case (ALUSignal):
            ADD: begin
                ALUout = ALUinA + ALUinB;       // Addition
            end
            SUB: begin
                ALUout = ALUinA - ALUinB;       // Substration
            end
            AND: begin
                ALUout = ALUinA & ALUinB;       // Bitwise AND
            end
            OR: begin
                ALUout = ALUinA | ALUinB;       // Bitwise OR
            end
            SLTU: begin                         //?? SLTU or SLTI?
                if (ALUinA < ALUinB)
                    ALUout = 32'b1;
                else
                    ALUout = 32'b0;
            end            
            XOR: begin
                ALUout = ALUinA ^ ALUinB;       
            end
            SLL: begin
                ALUout = ALUinA << ALUinB;      // Shift ALUinB bits left
            end
            SRL: begin
                ALUout = ALUinA >>> ALUinB;     // Arithmetic shift ALUinB bits right
            end
            SRA: begin
                ALUout = ALUinA >> ALUinB;      // Shift ALUinB bits right
            end
        endcase
    end
endmodule
