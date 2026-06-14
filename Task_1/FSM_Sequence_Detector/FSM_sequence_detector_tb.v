module fsm_seq_det_tb;

    reg clk_tb;
    reg rst_tb;
    reg in_data_tb;
    wire detected_tb;

    fsm_seq_det uut (
        .clk(clk_tb),
        .rst(rst_tb),
        .in_data(in_data_tb),
        .detected(detected_tb)
    );

    reg [31:0] s;
    always #5 clk_tb = ~clk_tb;

    task apply_bit;
        input val;
        begin
            @(posedge clk_tb);
            in_data_tb = val;
        end
    endtask

    task run_seq;
        input integer len;
        input integer case_id;
        input [31:0] seq;
        begin
            $display("\nCASE %0d", case_id);

            for (integer i = len-1; i >= 0; i = i - 1)
                apply_bit(seq[i]);

            #10;
        end
    endtask

    initial begin
        $dumpfile("dump.vcd");$dumpvars; //EPWave *.vcd file (for simulation waveform viewing)

        clk_tb = 0;
        rst_tb = 1;
        in_data_tb = 0;

        #20;
        rst_tb = 0;

        run_seq(6, 1, 6'b111111);
        run_seq(6, 2, 6'b000000);
        run_seq(5, 3, 5'b10101);
        run_seq(5, 4, 5'b11101);
        run_seq(6, 5, 6'b111010);
        run_seq(6, 6, 6'b010111);
        run_seq(7, 7, 7'b1100111);

        $finish;
    end

    initial begin
        $monitor("time=%0t state=%0d in=%b detected=%b",
                 $time, uut.state, in_data_tb, detected_tb);
    end

endmodule
