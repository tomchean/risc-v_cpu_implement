module ALU_Control(
    input   [2:0]   Funct3,
    input   [6:0]   Funct7,
    input   [1:0]   ALUOp,
    output  [4:0]   ALUSignal
)

    always @(*) begin 
        case (ALUOp):
            2'b00 : ALUSignal = `ADD;
            2'b01 : ALUSignal = `SUB;
            2'b10 : begin
                case (Funct3):
                    3'b000: begin
                        if (Funct7 == 7'b0000000) ALUSignal = `ADD;
                        else ALUSignal = `SUB;
                    end
                    3'b001: ALUSignal = `SLL;
                    3'b010: ALUSignal = `SLTU;      //?? SLTU or SLTI?
                    3'b011: ALUSignal = `XOR;
                    3'b100: ALUSignal = `SRL;
                    3'b101: ALUSignal = `SRA;
                    3'b110: ALUSignal = `OR;
                    3'b111: ALUSignal = `AND;
                endcase
            end
        endcase
    end
endmodule
