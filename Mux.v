module Mux2 (
    input s1,
    input s2,
    input control,
    output o1
)

    always @(*) begin
        if (control == 0) o1 = s1;
        else o1 = s2;
    end

endmodule

module Mux4 (
    input s1,
    input s2,
    input s3,
    input s4,
    input [1:0] control,
    output o1
)

    always @(*) begin
        case (control):
            2'b00 : o1 = s1;
            2'b01 : o1 = s2;
            2'b10 : o1 = s3;
            2'b11 : o1 = s4;
        endcase
    end

endmodule
