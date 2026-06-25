module asynch_fifo (
    input  wire        rst,
    input  wire        write_clk,
    input  wire        write_en,
    input  wire        read_clk,
    input  wire        read_en,
    input  wire [7:0]  data_in,
    output reg  [7:0]  data_out
);
    reg [7:0] memory_arr [0:7];
    reg [2:0] write_pointer;
    reg [2:0] read_pointer;

    // write
    always @(posedge write_clk or posedge rst) begin
        if (rst) begin
            write_pointer <= 3'b0;
        end else begin
            if (write_en) begin
                memory_arr[write_pointer] <= data_in;
                write_pointer <= write_pointer + 1'b1;
            end
        end
    end

    // read
    always @(posedge read_clk or posedge rst) begin
        if (rst) begin
            read_pointer <= 3'b0;
        end else begin
            if (read_en) begin
                data_out <= memory_arr[read_pointer];
                read_pointer <= read_pointer + 1'b1;
            end
        end
    end
endmodule