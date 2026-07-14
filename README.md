# Router-1x3

<p align="center">

![Verilog](https://img.shields.io/badge/HDL-Verilog-blue)
![Simulation](https://img.shields.io/badge/Simulation-ModelSim-success)
![Editor](https://img.shields.io/badge/Editor-VS%20Code-007ACC)
![Status](https://img.shields.io/badge/Project-Completed-brightgreen)

</p>

---

## Project Overview

**Router-1x3** is a Verilog RTL implementation of a **1×3 packet router** capable of routing incoming packets to one of three output FIFOs based on the destination address embedded in the packet header.

The design follows a modular architecture consisting of an FSM Controller, Register Block, Synchronizer, and three independent FIFOs. The complete RTL functionality has been verified through **directed functional testbenches**, **corner-case verification**, and **waveform analysis** using ModelSim.

This project focuses exclusively on **RTL Design and Functional Verification**.

---

## Features

- 1 Input → 3 Output Router
- Packet-based communication
- Header decoding
- Three independent output FIFOs
- FIFO Full handling
- WAIT_TILL_EMPTY handling
- LOAD_AFTER_FULL recovery
- Internal parity generation
- Packet parity verification
- Parity error detection
- Soft Reset support
- Timeout handling
- Fully modular RTL architecture

---

# Architecture

> *(Insert Architecture Diagram Here)*

```text
images/router_architecture.png
```

---

# Packet Format

| Bits | Description |
|------|-------------|
| [7:2] | Payload Length |
| [1:0] | Destination Address |

Packet Structure

```
+---------+-------------+---------+
| Header  | Payload      | Parity  |
+---------+-------------+---------+
```

Destination Address

| Address | FIFO |
|---------|------|
| 00 | FIFO0 |
| 01 | FIFO1 |
| 10 | FIFO2 |

---

# Router Operation

The router receives packets sequentially from the source.

1. Header is received.
2. Destination address is decoded.
3. Synchronizer selects the appropriate FIFO.
4. Payload bytes are written into the selected FIFO.
5. Internal parity is generated while receiving data.
6. Received parity is compared with calculated parity.
7. Valid packets are delivered to the destination FIFO.
8. Destination reads packets using the corresponding `read_enb` signal.

---

# Module Description

## FSM (Finite State Machine)

Responsible for controlling the complete packet flow.

Main responsibilities:

- Address decoding
- Packet loading
- FIFO full handling
- Parity processing
- WAIT_TILL_EMPTY handling
- LOAD_AFTER_FULL handling

States

- DECODE_ADDRESS
- LOAD_FIRST_DATA
- LOAD_DATA
- FIFO_FULL_STATE
- LOAD_AFTER_FULL
- LOAD_PARITY
- CHECK_PARITY_ERROR
- WAIT_TILL_EMPTY

---

## Register Block

Responsible for packet processing.

Functions

- Header storage
- Internal parity generation
- Packet parity storage
- Error generation
- low_pkt_valid generation
- parity_done generation
- Temporary storage during FIFO full

---

## Synchronizer

Acts as the traffic manager between the FSM and FIFOs.

Functions

- FIFO selection
- FIFO full detection
- Valid output generation
- Soft reset generation
- Write enable generation

---

## FIFO

Three independent FIFOs are used.

Each FIFO

- Depth : **16**
- Width : **9 bits**
  - 8-bit Data
  - 1-bit Header Flag (LFD)

Functions

- Packet buffering
- Read/Write operations
- Full detection
- Empty detection
- Simultaneous read/write support

---

## Top Module

Integrates

- FSM
- Register
- Synchronizer
- FIFO0
- FIFO1
- FIFO2

into a complete Router-1x3 architecture.

---

# Project Structure

```
Router-1x3
│
├── rtl
│   ├── fifo.v
│   ├── fsm.v
│   ├── register.v
│   ├── syncronizer.v
│   └── top.v
│
├── testbench
│   ├── router_tb.v
│   └── router_corner_tb.v
│
├── images
│   ├── architecture.png
│   ├── packet_format.png
│   └── ...
│
├── waveforms
│   ├── normal_packet.png
│   ├── fifo_full.png
│   ├── parity_error.png
│   ├── timeout.png
│   └── ...
│
└── README.md
```

---

# Verification Strategy

The RTL was verified using **directed testbenches** and **waveform analysis**.

### Functional Testbench

Verifies standard router functionality.

- Packet routing
- FIFO selection
- Packet read/write
- Correct parity
- Output validation

### Corner Case Testbench

Verifies boundary and exceptional scenarios.

- FIFO Full
- WAIT_TILL_EMPTY
- LOAD_AFTER_FULL
- Reset during packet processing
- Reset during FIFO full
- Timeout (Soft Reset)
- Back-to-back packets
- Simultaneous read/write
- FIFO wrap-around
- Illegal `pkt_valid` robustness
- Read while writing to the same FIFO

---

# Verification Summary

| Test Case | Status |
|-----------|:------:|
| Normal Packet Routing | ✅ |
| FIFO0 Routing | ✅ |
| FIFO1 Routing | ✅ |
| FIFO2 Routing | ✅ |
| Correct Parity | ✅ |
| Parity Error | ✅ |
| FIFO Full | ✅ |
| WAIT_TILL_EMPTY | ✅ |
| LOAD_AFTER_FULL | ✅ |
| Reset During Packet | ✅ |
| Reset During FIFO Full | ✅ |
| Soft Reset Timeout | ✅ |
| Back-to-Back Packets | ✅ |
| Simultaneous Read/Write | ✅ |
| FIFO Wrap-Around | ✅ |
| Read While Writing | ✅ |
| Protocol Robustness (`pkt_valid`) | ✅ |

---

# Waveform Results

### Normal Packet

> *(Insert Screenshot)*

---

### FIFO Full

> *(Insert Screenshot)*

---

### WAIT_TILL_EMPTY

> *(Insert Screenshot)*

---

### LOAD_AFTER_FULL

> *(Insert Screenshot)*

---

### Parity Error

> *(Insert Screenshot)*

---

### Simultaneous Read / Write

> *(Insert Screenshot)*

---

### FIFO Wrap Around

> *(Insert Screenshot)*

---

### Timeout (Soft Reset)

> *(Insert Screenshot)*

---

# Tools Used

| Tool | Purpose |
|------|---------|
| Verilog HDL | RTL Design |
| ModelSim | Simulation & Waveform Analysis |
| Visual Studio Code | RTL Development |

---

# How to Simulate

Compile all RTL files.

```
vlog fifo.v
vlog register.v
vlog syncronizer.v
vlog fsm.v
vlog top.v
```

Compile the testbench.

```
vlog router_tb.v
```

Run simulation.

```
vsim router1x3_tb
run -all
```

---

# Learning Outcomes

This project strengthened practical understanding of:

- RTL Design using Verilog
- FSM Design
- FIFO Architecture
- Packet Routing
- Synchronization Logic
- Directed Functional Verification
- Corner Case Verification
- Waveform Debugging
- Modular Hardware Design

---

# Author

**VELMURUGAN R**

Aspiring Design Verification Engineer

---
