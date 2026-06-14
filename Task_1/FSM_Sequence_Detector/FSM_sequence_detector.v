module fsm_seq_det (
    input  wire clk,
    input  wire rst,
	input  wire in_data,
    output reg  detected
);

  typedef enum reg[2:0] {S0, S1, S2, S3, S4, S5, S6} state_t;

  state_t state, next_state;

  
  always @(posedge clk or posedge rst) begin
        if (rst)
            state <= S0;
        else
            state <= next_state;
  end

  always @(*) begin
    case (state)
      S0: next_state = (in_data) ? S1 : S0;
      S1: next_state = (in_data) ? S2 : S0;
      S2: next_state = (in_data) ? S3 : S0;
      S3: next_state = (in_data) ? S3 : S4;
      S4: next_state = (in_data) ? S5 : S0;
      S5: next_state = (in_data) ? S1 : S6;
      S6: next_state = (in_data) ? S2 : S1;
	  default: next_state = S0;
    endcase
  end

  always @(*) begin
    detected = (state == S6);
  end

endmodule