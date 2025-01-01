`default_nettype none
`include "pwm_rgb.v"

module top(output [2:0] RGB, input clk, enable, data);
    wire pwm_en_bit;
    wire internal_clk;
    reg [15:0] data_in;
    reg [3:0] index;
    reg [7:0] pwm_val_r;
    reg [7:0] pwm_val_g;
    reg [7:0] pwm_val_b;

    reg [2:0] leds;
    reg led;

    assign RGB[0]  = ~leds[0];
    assign RGB[1]  = ~leds[1];
    assign RGB[2]  = ~leds[2];

    SB_HFOSC SB_HFOSC_inst(
    .CLKHFEN(1),
    .CLKHFPU(1),
    .CLKHF(internal_clk)
    );

    pwm pwm_init_r(.clk(internal_clk),
                 .en(pwm_en_bit),
                 .value_input(pwm_val_r),
                 .out(leds[0]));
    pwm pwm_init_g(.clk(internal_clk),
                 .en(pwm_en_bit),
                 .value_input(pwm_val_g),
                 .out(leds[1]));
    pwm pwm_init_b(.clk(internal_clk),
                 .en(pwm_en_bit),
                 .value_input(pwm_val_b),
                 .out(leds[2]));
    initial begin
        index = 3'd0;
        data_in = 255;
        pwm_val_r = 255;
        pwm_val_g = 255;
        pwm_val_b = 255;
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
            case (data_in[15:8])
            1: begin pwm_val_r <= data_in[7:0]; end
            2: begin pwm_val_g <= data_in[7:0]; end
            3: begin pwm_val_b <= data_in[7:0]; end
            endcase
            index <= 0;
        end
    end


endmodule