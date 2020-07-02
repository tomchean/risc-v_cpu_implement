module Mux2 (
    input [31:0] s1,
    input [31:0] s2,
    input control,
    output reg [31:0] o1
);

    always @(*) begin
        if (control == 0) o1 = s1;
        else o1 = s2;
    end

endmodule

module Mux4 (
    input [31:0] s1,
    input [31:0] s2,
    input [31:0] s3,
    input [31:0] s4,
    input [1:0] control,
    output reg [31:0] o1
);

    always @(*) begin
        case (control)
            2'b00 : o1 = s1;
            2'b01 : o1 = s2;
            2'b10 : o1 = s3;
            2'b11 : o1 = s4;
        endcase
    end

endmodule
