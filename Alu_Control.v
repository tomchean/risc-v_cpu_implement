module ALU_Control(
    input   [2:0]   Funct3,
    input   [6:0]   Funct7,
    input   [2:0]   ALUOp,
    output  reg [4:0]   ALUSignal
);


    parameter RTYPE  = 3'b000;
    parameter ITYPE  = 3'b001;
    parameter STYPE  = 3'b010;
    parameter BTYPE  = 3'b011;
    parameter UTYPE  = 3'b100;
    parameter JTYPE  = 3'b101;
    parameter LITYPE = 3'b110;
    parameter JITYPE = 3'b111;

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
        case (ALUOp)
            RTYPE : begin
                case (Funct3)
                    3'b000: begin
                        if (Funct7 == 7'b0000000) ALUSignal = ADD;
                        else ALUSignal = SUB;
                    end
                    3'b001: ALUSignal = SLL;
                    3'b010: ALUSignal = SLT;
                    3'b011: ALUSignal = SLTU;
                    3'b100: ALUSignal = XOR;
                    3'b101: begin
                        if (Funct7 == 7'b0000000) ALUSignal = SRL;
                        else ALUSignal = SRA;
                    end
                    3'b110: ALUSignal = OR;
                    3'b111: ALUSignal = AND;
                endcase
            end
            ITYPE : begin
                case (Funct3)
                    3'b000: ALUSignal = ADD;
                    3'b001: ALUSignal = SLL;
                    3'b010: ALUSignal = SLT;
                    3'b011: ALUSignal = SLTU;
                    3'b100: ALUSignal = XOR;
                    3'b101: begin
                        if (Funct7 == 7'b0000000) ALUSignal = SRL;
                        else ALUSignal = SRA;
                    end
                    3'b110: ALUSignal = OR;
                    3'b111: ALUSignal = AND;
                endcase
            end
            STYPE :  ALUSignal = ADD;
            BTYPE :  ALUSignal = SUB; // only BEQ
            UTYPE :  ALUSignal = ADD; // only AUIPC
            JTYPE :  ALUSignal = ADD; // only JAL
            JITYPE : ALUSignal = ADD; // only JALR
            LITYPE : ALUSignal = ADD; // only lw
        endcase
    end
endmodule
