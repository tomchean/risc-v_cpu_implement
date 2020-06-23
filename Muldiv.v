module Muldiv(
    input               clk,
    input               rst_n,
    input               valid,
    input               mode,       // mode: 0: multu, 1: divu
    input       [31:0]  in_A,
    input       [31:0]  in_B,
    output reg          ready,
    output reg  [63:0]  out
);

    // Definition of states
    parameter IDLE = 2'b00;
    parameter MULT = 2'b01;
    parameter DIV  = 2'b10;
    parameter OUT  = 2'b11;

    reg  [ 1:0] state, state_nxt;
    reg  [ 4:0] counter, counter_nxt;
    reg  [63:0] shreg, shreg_nxt;
    reg  [31:0] alu_in, alu_in_nxt;
    reg  [32:0] alu_out;

    assign out = shreg;
    assign ready = (state == 2'b11);
    
    // Combinational always block
    always @(*) begin
        case(state)
            IDLE: begin
                if (valid) begin
                    if (mode) state_nxt = DIV;
                    else state_nxt = MULT;
                end
                else state_nxt = IDLE;
            end
            MULT: begin
                if (counter == 31) state_nxt = OUT;
                else state_nxt = MULT;
            end
            DIV : begin
                if (counter == 31) state_nxt = OUT;
                else state_nxt = DIV;
            end
            OUT : state_nxt = IDLE;
        default: state_nxt = OUT;
        endcase
    end

    always @(*) begin
        case(state)
            MULT: counter_nxt = counter + 1;
            DIV : counter_nxt = counter + 1;
            IDLE: counter_nxt = 0;
            OUT : counter_nxt = 0;
        endcase
    end
    
    // ALU input
    always @(*) begin
        case(state)
            IDLE: begin
                if (valid) alu_in_nxt = in_B;
                else       alu_in_nxt = 0;
            end
            OUT : alu_in_nxt = 0;
            default: alu_in_nxt = alu_in;
        endcase
    end

    always @(*) begin
        case(state)
            MULT: begin
                if (shreg[0] == 1'b1) begin
                    alu_out = alu_in; 
                end
                else alu_out = 0; 
            end
            DIV: begin
                    alu_out = alu_in; 
            end
            IDLE: begin
                if(valid) alu_out = in_A;
                else alu_out = 0;
            end
            default: alu_out = 0;
        endcase
    end
    
    always @(*) begin
        case(state)
            MULT: begin
                shreg_nxt = shreg >> 1;
                shreg_nxt[63:31] = shreg_nxt[63:31] + alu_out;
            end
            DIV: begin
                if (alu_out <= shreg[63:31]) begin
                    shreg_nxt[63:31] = shreg_nxt[63:31] - alu_out;
                    shreg_nxt = shreg_nxt<< 1;
                    shreg_nxt[0] = 1'b1;
                end
                else begin
                    shreg_nxt = shreg << 1;
                end
            end
            default: shreg_nxt = alu_out;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end
        else begin
            state <= state_nxt;
            counter <= counter_nxt;
            shreg <= shreg_nxt;
            alu_in <= alu_in_nxt;
        end
    end

endmodule
