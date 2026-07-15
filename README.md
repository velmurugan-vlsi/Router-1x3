# Router-1x3

::: {align="center"}
# Router-1x3

### Verilog RTL Design • RTL Verification • RTL Synthesis • Waveform Validation

![Verilog](https://img.shields.io/badge/HDL-Verilog-blue)
![Simulation](https://img.shields.io/badge/Simulation-ModelSim-success)
![Synthesis](https://img.shields.io/badge/Synthesis-Quartus_Prime-orange)
![Status](https://img.shields.io/badge/RTL-Verified-brightgreen)
:::

------------------------------------------------------------------------

# Overview

**Router-1x3** is a Verilog RTL implementation of a packet router that
accepts packets from a single source interface and forwards them to one
of three destination FIFOs. The destination is selected using the two
least significant bits of the packet header.

The project includes RTL design, module-level verification, top-level
verification, RTL synthesis using Intel Quartus Prime, and validation
through ModelSim waveform analysis.

------------------------------------------------------------------------

# Router Architecture

> Replace this placeholder with the final architecture diagram.

![Architecture](images/architecture.png)

------------------------------------------------------------------------

# Packet Format

Each packet consists of three parts:

  Field         Description
  ------------- ------------------------------------------------------
  **Header**    Contains the payload length and destination address.
  **Payload**   User data transferred through the selected FIFO.
  **Parity**    Used to detect transmission errors.

### Header Format

      Bits      Field
  ------------- ---------------------
   **\[7:2\]**  Payload Length
   **\[1:0\]**  Destination Address

### Destination Address Mapping

   Address  Selected FIFO
  --------- ---------------
   `2'b00`  FIFO0
   `2'b01`  FIFO1
   `2'b10`  FIFO2

------------------------------------------------------------------------

# RTL Modules

  -----------------------------------------------------------------------
  Module                          Function
  ------------------------------- ---------------------------------------
  **FSM**                         Controls packet flow and generates all
                                  control signals.

  **Register**                    Stores header information, generates
                                  parity, compares received parity and
                                  reports errors.

  **Synchronizer**                Decodes destination address, selects
                                  the output FIFO, generates write enable
                                  signals and soft resets.

  **FIFO (3x)**                   Buffers packets independently for each
                                  output port.

  **Top Module**                  Integrates all RTL modules into the
                                  complete Router-1x3 design.
  -----------------------------------------------------------------------

------------------------------------------------------------------------

# Verification

## Module-Level Verification

Dedicated testbenches were developed for:

-   FIFO
-   FSM
-   Register
-   Synchronizer

Each module was verified independently before top-level integration.

### Top-Level Verification

Two independent testbenches were used.

**Functional Testbench**

-   Packet routing
-   FIFO selection
-   Payload transfer
-   Correct parity handling
-   Packet read operation

**Corner-Case Testbench**

-   FIFO Full
-   WAIT_TILL_EMPTY
-   LOAD_AFTER_FULL
-   Reset during packet processing
-   Reset during FIFO full
-   Soft reset timeout
-   FIFO wrap-around
-   Simultaneous read/write
-   Read while write
-   Back-to-back packets
-   Protocol robustness (`pkt_valid`)

------------------------------------------------------------------------

# Verification Summary

  Test Case                  Status
  ------------------------- --------
  FIFO0 Routing                ✅
  FIFO1 Routing                ✅
  FIFO2 Routing                ✅
  Correct Parity               ✅
  Parity Error Detection       ✅
  FIFO Full                    ✅
  WAIT_TILL_EMPTY              ✅
  LOAD_AFTER_FULL              ✅
  Reset During Packet          ✅
  Reset During FIFO Full       ✅
  Soft Reset Timeout           ✅
  Simultaneous Read/Write      ✅
  FIFO Wrap-Around             ✅
  Read While Write             ✅
  Protocol Robustness          ✅

------------------------------------------------------------------------

# RTL Synthesis

The RTL design was synthesized using **Intel Quartus Prime**.

Synthesis was used to:

-   Verify synthesizability of the RTL
-   Generate RTL Netlist
-   Generate Technology Netlist
-   Validate hardware connectivity after synthesis

> FPGA implementation and on-board hardware validation were not
> performed.

------------------------------------------------------------------------

# Waveform Validation

RTL behavior was validated using ModelSim waveforms for:

-   Normal Packet Transfer
-   FIFO Full
-   WAIT_TILL_EMPTY
-   LOAD_AFTER_FULL
-   Parity Error
-   Reset Scenarios
-   Soft Reset Timeout
-   FIFO Wrap-Around
-   Simultaneous Read/Write

------------------------------------------------------------------------

# Tools

  Tool                  Purpose
  --------------------- ------------------------------------
  Verilog HDL           RTL Design
  Visual Studio Code    Code Development
  ModelSim              RTL Simulation & Waveform Analysis
  Intel Quartus Prime   RTL Synthesis & Netlist Generation

------------------------------------------------------------------------

# Author

**VELMURUGAN R**

Electronics and Communication Engineering Student

Aspiring Design Verification Engineer
