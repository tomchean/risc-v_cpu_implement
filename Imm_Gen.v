module Imm_Gen (
    input   [24:0] Instruction,
    input   [2:0]  Type,
    output  [31:0] Imm
)

    parameter RTYPE  = 3'b000;
    parameter ITYPE  = 3'b001;
    parameter STYPE  = 3'b010;
    parameter BTYPE  = 3'b011;
    parameter UTYPE  = 3'b100;
    parameter JTYPE  = 3'b101;
    parameter LITYPE = 3'b110;
    parameter LJTYPE = 3'b111;

    always @(*) begin
        case (Type):
            default : Imm = 32'h0;
        endcase
    end

endmodule
