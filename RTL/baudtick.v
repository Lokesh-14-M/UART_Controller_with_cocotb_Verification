module baudtick #(parameter clock_freq = 50000000 , parameter baud_rate = 9600) (
input wire clk ,
input wire rst , 
output reg tick);

reg [15:0]counter;

localparam integer divider = clock_freq / baud_rate ;

always@(posedge clk or posedge rst)begin
	if(rst) begin
		counter <= 14'b0;
		tick <= 1'b0;
	end
	else if(counter == divider - 1)begin
		counter <= 14'b0;
		tick <= 1'b1;
	end
	else begin
		counter <= counter + 1 ;
		tick <= 1'b0;
	end
end
endmodule 
		
