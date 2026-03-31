module uart_top (
    input wire clk,
    input wire rst,
    input wire [7:0] tx_data,
    input wire tx_start,

    output wire [7:0] rx_data,
    output wire rx_valid,
    output wire tx_wire  
);

    // 🔥 VCD dump
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, uart_top);
    end

    // TX
    uart_tx tx_inst (
        .clk(clk),
        .rst(rst),
        .tx_data(tx_data),
        .tx_start(tx_start),
        .tx(tx_wire),
        .tx_busy()
    );

    // RX (LOOPBACK)
    uart_rx rx_inst (
        .clk(clk),
        .rst(rst),
        .rx(tx_wire),   
        .rx_data(rx_data),
        .rx_valid(rx_valid)
    );

endmodule
