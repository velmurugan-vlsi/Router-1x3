
# Router 1×3 (Verilog HDL)

## Overview
This project implements a 1×3 packet router in Verilog HDL. It receives packets from a single input and routes them to one of three output FIFOs based on the destination address contained in the packet header.

## Features
- 1 Input → 3 Outputs
- FSM-based controller
- Register block
- Synchronizer
- Three FIFOs
- Parity generation and checking
- Busy signal
- FIFO full/empty handling
- Soft reset support

## Packet Format
| Field | Description |
|------|-------------|
| Header | Destination + Length |
| Payload | User Data |
| Parity | Error Detection |

Destination:
- 00 → FIFO0
- 01 → FIFO1
- 10 → FIFO2

## Architecture
```
Input
  │
Register
  │
 FSM
  │
Synchronizer
 ├── FIFO0
 ├── FIFO1
 └── FIFO2
```

## Modules
### FSM
Controls packet flow through Detect Address, Load First Data, Load Data, FIFO Full, Load After Full, Load Parity and Check Parity Error states.

### Register
Stores header, payload, parity and performs parity checking.

### Synchronizer
Selects the destination FIFO, generates write enables, valid outputs and soft resets.

### FIFO
Each FIFO contains memory, read pointer, write pointer, empty flag and full flag.

## Inputs
- clock
- resetn
- pkt_valid
- data_in[7:0]
- read_enb_0
- read_enb_1
- read_enb_2

## Outputs
- data_out_0
- data_out_1
- data_out_2
- vld_out_0
- vld_out_1
- vld_out_2
- busy
- err

## Verification
The design was verified using:
- Normal packet transfer
- Continuous packets
- Multiple packets
- FIFO full
- FIFO empty
- Soft reset
- Parity error
- Back-to-back packets

## Tools
- Verilog HDL
- ModelSim
- Quartus Prime RTL Viewer

## Folder Structure
```
Router-1x3/
├── RTL/
├── Testbench/
├── Simulation/
├── Waveforms/
├── RTL_Viewer/
└── README.md
```

## Future Work
- AXI interface
- UVM verification
- SystemVerilog Assertions
- Parameterized FIFO depth

## Conclusion
The Router 1×3 successfully routes packets to the selected output FIFO with parity protection, buffering, and FSM-controlled operation.
