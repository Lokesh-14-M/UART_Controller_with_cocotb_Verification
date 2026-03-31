# UART Controller with cocotb Verification
A fully synthesizable UART (Universal Asynchronous Receiver-Transmitter) core designed for FPGA implementation.
Tested on Altera MAX 10 FPGA, this project demonstrates a modern digital design workflow using Verilog RTL and Python-based verification.

📁 Project Structure

     rtl/          # Verilog design files
     schematic/    # Generated architecture diagrams
     test/         # Cocotb testbench and Makefile
     waveform/     # Simulation waveforms (VCD + PDF)

🔹 Details

    rtl/
        uart_tx.v → Transmitter module
        uart_rx.v → Receiver module
        uart_top.v → Top module (loopback design)
        Baud rate generator
    
    schematic/
        Quartus Prime diagrams (industry standard)
        Yosys diagrams (open-source flow)
    
    test/
        test_uart.py → Cocotb testbench
        Makefile → Run simulation easily
    
    waveform/
      .vcd → Raw waveform data
      .pdf → Clean timing diagrams

🛠️ Toolchain

    HDL Design	Verilog
    Simulation	Icarus Verilog
    Verification	Cocotb (Python)
    Synthesis	Yosys & Quartus Prime
    Waveform View	GTKWave

🏗️ Architecture & Features

⚙️ Key Features

    Baud Rate: 9600 bps (from 50 MHz clock)
    Robust Receiver Design
    Uses mid-bit sampling (half-divider clock) for accuracy
    Loopback Architecture
    TX → RX internally connected
    Enables full-path validation without external hardware 
    
🧪 Verification

    The design is verified using cocotb, ensuring realistic hardware behavior.

✅ Test Cases

        0x55
        0xA5
        0x3C
        0xFF

🔍 Key Observation

    The receiver correctly captures 0x55
    Even while the transmitter prepares the next byte (0x45)


📊 Example Waveform

![Waveform Results](waveform/logic_viewer.png)

🚀 How to Run

1️⃣ Install Dependencies

    Make sure you have:
    
        Python 3
        Icarus Verilog
        Cocotb
        GTKWave

2️⃣ Run Simulation

    cd test/
    make

3️⃣ View Waveform

    gtkwave waveform/your_file.vcd

📜 License

This project is licensed under the MIT License.
