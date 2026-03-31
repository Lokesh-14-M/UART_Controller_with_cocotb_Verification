module uart_rx #(parameter clock_freq = 50000000 , parameter baud_rate = 9600 ) (
input wire clk ,
input wire rst ,
input wire rx ,

output reg [7:0]rx_data,
output reg rx_valid);

reg [15:0]clk_counter;
reg [2:0]bit_index;
reg [7:0]data_reg;



localparam integer divider = clock_freq / baud_rate;
localparam integer half_div = divider / 2;

localparam  idle = 2'b00;
localparam  start = 2'b01;
localparam  data = 2'b10;
localparam  stop = 2'b11;

reg [1:0] state; 

reg rx_sync1, rx_sync;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        rx_sync1 <= 1;
        rx_sync <= 1;
    end else begin
        rx_sync1 <= rx;
        rx_sync <= rx_sync1;
    end
end

always@(posedge clk or posedge rst)begin
	if(rst)begin
		clk_counter <= 0;
		bit_index <= 0;
		data_reg <= 0;
		state <= idle;
		rx_data <= 0;
		rx_valid <= 0;
	end
	else begin
		rx_valid <=0;
		case(state)
			idle: begin
				clk_counter <= 0;
				bit_index <= 0;
				if(rx_sync == 0)begin
					state <= start;
				end
			end
			
			start: begin
				if( clk_counter == half_div -1 )begin
					clk_counter <= 0;
					if(rx_sync == 0)begin
						state <= data;
				        end
				        else begin
				        	state <= idle;
				        end
				end
				else begin
					clk_counter <= clk_counter + 1;
				end
			end
			
			data: begin
				if(clk_counter == divider -1)begin
					clk_counter <= 0;
					data_reg[bit_index] <= rx_sync;
					if(bit_index == 7)begin
						bit_index <= 0;
						state <= stop;
					end
					else begin
						bit_index <= bit_index + 1 ;
					end
				end
				else begin
					clk_counter <= clk_counter + 1;
				end
			end
			
			stop: begin
				if( clk_counter == divider -1 )begin
					clk_counter <= 0;
					if (rx_sync == 1) begin     // valid stop bit
             					rx_data  <= data_reg;
            					rx_valid <= 1;
        				end
        				state <= idle;
				end
				else begin
					clk_counter <= clk_counter + 1;
				end
			end
		endcase
	end
end
endmodule			

