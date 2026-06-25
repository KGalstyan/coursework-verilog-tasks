`timescale 1ns/1ps

module tb_asynch_fifo();
  reg        rst_tb;
  reg        write_clk_tb;
  reg        write_en_tb;
  reg        read_clk_tb;
  reg        read_en_tb;
  reg [7:0]  data_in_tb;
  wire [7:0] data_out_tb;
  
  asynch_fifo uut (
    .rst(rst_tb),
	.write_clk(write_clk_tb),
	.write_en(write_en_tb),
	.read_clk(read_clk_tb),
	.read_en(read_en_tb),
	.data_in(data_in_tb),
	.data_out(data_out_tb)
  );

	initial write_clk_tb = 0;
	always #5 write_clk_tb = ~write_clk_tb;

	initial read_clk_tb = 0;
	always #7 read_clk_tb = ~read_clk_tb;

	integer i;

	task write_data_to_fifo;
		input [7:0] data;
		begin
			@(posedge write_clk_tb);
			data_in_tb  <= data;
			write_en_tb <= 1;
			@(posedge write_clk_tb);
			write_en_tb <= 0;
			$display("[WRITE] data=0x%02h at t=%0t", data, $time);
		end
    endtask

	task read_data_from_fifo;
		begin
			@(posedge read_clk_tb);
			read_en_tb <= 1;
			@(posedge read_clk_tb);
			read_en_tb <= 0;
			@(posedge read_clk_tb);
			$display("[READ]  data=0x%02h at t=%0t", data_out_tb, $time);
		end
    endtask
	
	initial begin
      $dumpfile("dump.vcd"); $dumpvars;  //EPWave *.vcd file (for simulation waveform viewing)

		rst_tb      = 1;
		write_en_tb = 0;
		read_en_tb  = 0;
		data_in_tb  = 8'h00;

		#20;
		rst_tb = 0;

		for (i = 0; i < 8; i = i + 1)
			write_data_to_fifo(8'hA0 + i);

		for (i = 0; i < 8; i = i + 1)
			read_data_from_fifo;

			fork begin
				write_data_to_fifo(8'hBE);
				write_data_to_fifo(8'hEF);
			end begin
				#25;
				read_data_from_fifo;
				read_data_from_fifo;
			end
		join
		#50;
		$finish;
	end
endmodule