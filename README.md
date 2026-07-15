# Router 1×3 Verilog HDL Project

## 1. Introduction

The Router 1×3 is a packet-based digital communication module implemented in synthesizable Verilog HDL. It accepts packets from a single source and routes them to one of three output channels based on the destination address contained in the packet header. The design demonstrates finite state machine control, buffering with FIFOs, parity generation/checking, synchronization, and modular RTL design suitable for FPGA implementation and simulation.

## 2. Design Objectives

• Single input and three outputs
• Reliable packet routing
• Modular RTL
• FIFO buffering
• Error detection using parity
• Synthesizable design
• Verification using simulation

## 3. System Specification

Inputs: clock, resetn, pkt_valid, data_in[7:0], read_enb_0/1/2.
Outputs: data_out_0/1/2, vld_out_0/1/2, busy, err.
Destination decoding: 00→FIFO0, 01→FIFO1, 10→FIFO2.

## 4. Packet Format

Header contains destination address and payload length followed by payload bytes and a parity byte. The parity byte is generated from the header and payload and verified at the receiver.

## 5. Top-Level Architecture

The top module instantiates Register, FSM, Synchronizer, FIFO0, FIFO1 and FIFO2. The FSM generates control signals, the Register stores packet information, the Synchronizer selects the destination FIFO and the FIFOs buffer outgoing packets.

## 6. FSM Detailed Explanation

Detect Address: waits for pkt_valid and decodes destination.
Load First Data: captures first payload byte.
Load Data: receives remaining payload.
FIFO Full: pauses writes.
Load After Full: resumes after space is available.
Load Parity: receives parity byte.
Check Parity Error: compares computed and received parity then returns to idle.

## 7. Register Module

Stores header, payload, parity and intermediate values. Generates internal parity during packet reception and asserts err if the received parity mismatches the calculated parity.

## 8. Synchronizer Module

Routes write enable to only one FIFO, synchronizes FIFO status signals, generates valid outputs and soft resets, and prevents writing into a full FIFO.

## 9. FIFO Module

Each FIFO contains a memory array, write pointer, read pointer, empty flag, full flag and occupancy counter. Data is written sequentially and read independently by the destination receiver.

## 10. Data Flow

Incoming packet → Register → FSM Control → Synchronizer → Selected FIFO → data_out_x. Control signals ensure correct ordering of header, payload and parity.

## 11. Verification

Simulation covered:
- Normal packet routing
- Continuous packets
- Multiple destinations
- FIFO full
- FIFO empty
- Back-to-back packets
- Parity error
- Soft reset
The waveforms demonstrate correct FSM transitions, FIFO pointer movement, memory updates, parity generation and routed outputs.

## 12. RTL Viewer Discussion

The synthesized RTL hierarchy clearly shows the modular implementation. The top-level router connects the FSM, Register, Synchronizer and three FIFOs. This validates that the RTL is fully synthesizable and follows a clean hierarchical architecture.

## 13. FPGA Considerations

The design maps efficiently to FPGA resources. FIFOs infer memory/LUTRAM depending on synthesis settings. FSM maps to flip-flops and LUTs. Timing closure is simplified through synchronous design.

## 14. Future Improvements

Parameterizable FIFO depth, AXI4-Stream interface, SystemVerilog Assertions, UVM verification, functional coverage, FPGA hardware validation and performance optimization.

## 15. Conclusion

The Router 1×3 project demonstrates packet routing, FSM control, buffering, synchronization and error detection. It is an excellent RTL design project for FPGA and verification interviews because it integrates datapath, controller, storage and verification concepts into one complete design.
