module uart_tx #(parameter clock_freq = 50000000, parameter baud_rate = 9600) (
    input wire clk,
    input wire rst,
    input wire [7:0] tx_data,
    input wire tx_start,
    output reg tx,
    output reg tx_busy
);

    wire baud_tick;
    reg [2:0] bit_index;
    reg [7:0] data_reg;
    
    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;
    reg [1:0] state;

    // Instantiate your baud rate generator
    baudtick #(.clock_freq(clock_freq), .baud_rate(baud_rate)) generator (
        .clk(clk),
        .rst(rst),
        .tick(baud_tick)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            tx <= 1'b1;
            tx_busy <= 1'b0;
            bit_index <= 3'b0;
            data_reg <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    tx <= 1'b1;
                    tx_busy <= 1'b0;
                    if (tx_start) begin
                        data_reg <= tx_data;
                        tx_busy <= 1'b1;
                        state <= START;
                    end
                end

                START: begin
                    tx <= 1'b0; // Start bit is low
                    if (baud_tick) begin
                        state <= DATA;
                        bit_index <= 0;
                    end
                end

                DATA: begin
                    tx <= data_reg[bit_index];
                    if (baud_tick) begin
                        if (bit_index == 7) begin
                            state <= STOP;
                        end else begin
                            bit_index <= bit_index + 1;
                        end
                    end
                end

                STOP: begin
                    tx <= 1'b1; // Stop bit is high
                    if (baud_tick) begin
                        state <= IDLE;
                        tx_busy <= 1'b0;
                    end
                end
            endcase
        end
    end
endmodule
