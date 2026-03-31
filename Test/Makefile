TOPLEVEL_LANG = verilog
VERILOG_SOURCES = uart_top.v uart_tx.v uart_rx.v baudtick.v

TOPLEVEL = uart_top
MODULE = test_uart

SIM = icarus

WAVES=1

include $(shell cocotb-config --makefiles)/Makefile.sim
