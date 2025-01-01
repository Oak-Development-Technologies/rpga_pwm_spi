module pwm(input clk, input en, input [7:0] value_input, output out);
   reg [7:0] counter;
   reg [7:0] value; //max 255

   assign out = (counter < value);

   initial begin
      counter = 0;
      value[0] = 255;
      value[1] = 255;
      value[2] = 255;
   end

   always @(posedge clk)
   begin
      counter <= counter + 1;
      
      if(en == 1'b1) begin
        value <= value_input;
      end;
   end
endmodule