`default_nettype none
`include "pwm.v"

module top(output LED_R, input clk, enable, data);
    wire pwm_en_bit;
    wire internal_clk;
    reg [7:0] data_in;
    reg [2:0] index;
    reg [7:0] pwm_val;

    reg led;

    assign LED_R  = ~led;

    SB_HFOSC SB_HFOSC_inst(
    .CLKHFEN(1),
    .CLKHFPU(1),
    .CLKHF(internal_clk)
    );

    pwm pwm_init(.clk(internal_clk),
                 .en(pwm_en_bit),
                 .value_input(pwm_val),
                 .out(led));

    initial begin
        index = 3'd0;
        data_in = 255;
        pwm_val = 255;
        pwm_en_bit = 0;
    end

    always @(posedge clk) begin
        if (enable) begin
            pwm_en_bit <= 0;
            data_in[index] <= data;
            index <= index + 1;
        end
        else begin
            pwm_en_bit <= 1;
            pwm_val <= data_in;
            index <= 0;
        end
    end


endmodule