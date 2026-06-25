`timescale 1ns/1ps

module tb_synch_fifo();
  reg        rst_tb;
  reg        clk_tb;
  reg        write_en_tb;
  reg        read_en_tb;
  reg [7:0]  data_in_tb;
  wire [7:0] data_out_tb;
  
  synch_fifo uut (
    .rst(rst_tb),
	.clk(clk_tb),
	.write_en(write_en_tb),
	.read_en(read_en_tb),
	.data_in(data_in_tb),
	.data_out(data_out_tb)
  );

	initial clk_tb = 0;
	always #5 clk_tb = ~clk_tb;

	integer i;
	
	initial begin
		$dumpfile("dump.vcd"); $dumpvars;

		rst_tb      = 1;
		write_en_tb = 0;
		read_en_tb  = 0;
		data_in_tb  = 8'h00;

		#20;
		rst_tb = 0;

		write_en_tb = 1;
		read_en_tb  = 0;
		for (i = 0; i < 8; i = i + 1) begin
			@(posedge clk_tb);
			data_in_tb <= 8'hA0 + i;
			$display("[WRITE] data=0x%02h at t=%0t", 8'hA0 + i, $time);
		end

		@(posedge clk_tb);
		write_en_tb = 0;
		read_en_tb  = 1;
		for (i = 0; i < 8; i = i + 1) begin
			@(posedge clk_tb);
			$display("[READ]  data=0x%02h at t=%0t", data_out_tb, $time);
		end

		@(posedge clk_tb);
		read_en_tb = 0;

		#50;
		$finish;
	end
endmodule
