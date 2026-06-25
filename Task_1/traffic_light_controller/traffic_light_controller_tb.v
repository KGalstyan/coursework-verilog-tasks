module tb_traffic_light_controller;

    reg clk_tb;
    reg rst_tb;

    wire red_tb;
    wire yellow_tb;
    wire green_tb;

	traffic_light_controller #(
      .RED_TIME(8),
      .YELLOW_TIME(2),
      .GREEN_TIME(10),
      .TIMER_SIZE(4)
	) uut (
      .clk(clk_tb),
      .rst(rst_tb),
      .red(red_tb),
      .yellow(yellow_tb),
      .green(green_tb)
	);

    always #5 clk_tb = ~clk_tb;

    initial begin
      	$dumpfile("dump.vcd"); $dumpvars; //EPWave *.vcd file (for simulation waveform viewing)
        clk_tb = 0;
        rst_tb = 1;

        #20 rst_tb = 0;

        #500 $finish;
    end
endmodule
