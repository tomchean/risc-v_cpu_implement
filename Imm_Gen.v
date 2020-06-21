module Imm_Gen (
    input   [24:0] Instruction,
    input   [2:0]  Type,
    output reg [31:0] Imm
);

    parameter RTYPE  = 3'b000;
    parameter ITYPE  = 3'b001;
    parameter STYPE  = 3'b010;
    parameter BTYPE  = 3'b011;
    parameter UTYPE  = 3'b100;
    parameter JTYPE  = 3'b101;
    parameter LITYPE = 3'b110;
    parameter JITYPE = 3'b111;

    always @(*) begin
        case (Type)
            RTYPE : Imm = 32'h0;
            ITYPE : Imm = {{20{Instruction[24]}}, Instruction[24:13];
            STYPE : Imm = {{20{Instruction[24]}}, Instruction[24:18], Instruction[4:0]};
            BTYPE : Imm = {{20{Instruction[24]}}, Instruction[24], Instruction[0], Instruction[23:18], Instruction[4:1], Instruction[0]};
            UTYPE : Imm = Instruction[24:5];
            JTYPE : Imm ={{12{Instruction[24]}}, Instruction[24], Instruction[12:5], Instruction[13], Instruction[23:14]}; 
            LITYPE : Imm = {{20{Instruction[24]}}, Instruction[24:13];
            JITYPE : Imm = {{20{Instruction[24]}}, Instruction[24:13];
            default : Imm = 32'h0;
        endcase
    end

endmodule
