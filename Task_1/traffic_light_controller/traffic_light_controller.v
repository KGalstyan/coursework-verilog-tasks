module traffic_light_controller #(
	parameter RED_TIME=8,
	parameter YELLOW_TIME=2,
	parameter GREEN_TIME=10,
	parameter TIMER_SIZE=4)
(
    input  wire clk,
    input  wire rst,
    output reg red,
    output reg yellow,
    output reg green
);

  typedef enum reg[1:0] {RED_STATE, GREEN_STATE, YELLOW_STATE} state_t;

  state_t state;
  reg [TIMER_SIZE-1:0] timer;
  
  always @(posedge clk or posedge rst) begin
    if (rst) begin
		state <= RED_STATE;
		timer <= 0;
      end 
	else begin
	  timer <= timer + 1;
      case (state)
        RED_STATE:
				if(timer == RED_TIME-1) begin
					state <= GREEN_STATE;
					timer <= 0;
        		end
        GREEN_STATE:
				if(timer == GREEN_TIME-1) begin
					state <= YELLOW_STATE;
					timer <= 0;
        		end
        YELLOW_STATE:
				if(timer == YELLOW_TIME-1) begin
					state <= RED_STATE;
					timer <= 0;
        		end
	  endcase
    end
  end

  always @(*) begin
	red    = 0;
	yellow = 0;
	green  = 0;

      case(state)
		RED_STATE:    red    = 1;
		GREEN_STATE:  green  = 1;
		YELLOW_STATE: yellow = 1;
      endcase
  end

endmodule
