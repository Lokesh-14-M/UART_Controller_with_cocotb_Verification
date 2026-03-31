import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

@cocotb.test()
async def uart_loopback_test(dut):

  
 
cocotb.start_soon(Clock(dut.clk, 20, units="ns").start())

    #  Reset
    dut.rst.value = 1
    dut.tx_start.value = 0
    dut.tx_data.value = 0

    for _ in range(10):
        await RisingEdge(dut.clk)

    dut.rst.value = 0

    #  Test data 
    test_vectors = [0x55, 0xA5, 0x3C, 0xFF]

    for data in test_vectors:

        # Send data
        dut.tx_data.value = data
        dut.tx_start.value = 1
        await RisingEdge(dut.clk)
        dut.tx_start.value = 0

        # Wait for RX valid
        while dut.rx_valid.value == 0:
            await RisingEdge(dut.clk)

        received = int(dut.rx_data.value)

        cocotb.log.info(f"Sent: {data:#04x}, Received: {received:#04x}")

        #  Assertion
        assert received == data, f"Mismatch: sent {data:#04x}, got {received:#04x}"

        # small delay between packets
        for _ in range(20):
            await RisingEdge(dut.clk)

    cocotb.log.info(" UART Loopback Test PASSED")
