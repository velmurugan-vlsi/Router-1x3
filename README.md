# Router 1×3 using Verilog HDL

<p align="center">

**RTL Design | Packet-Based Data Routing | Verilog HDL | ModelSim | Quartus Prime**

</p>

---

# Project Overview

The **Router 1×3** is a packet-based digital routing system implemented in **Verilog HDL**, designed to receive data packets from a single input channel and route them to one of three independent output ports based on the destination address encoded in the packet header. The design follows a modular RTL architecture, where each functional block performs a dedicated task in the packet transmission process.

The router accepts packets consisting of a **header**, **payload**, and **parity byte**. During packet reception, the destination address is extracted from the header and decoded to determine the appropriate output FIFO. A Finite State Machine (FSM) coordinates the complete routing process by controlling packet reception, FIFO write operations, parity processing, and flow control. The Register module manages packet storage and parity generation, while the Synchronizer module selects the destination FIFO and generates the necessary control signals. Three independent FIFOs buffer outgoing packets, allowing each output port to operate independently.

The design has been developed using a modular RTL approach, making each component independently testable and reusable. Individual module simulations, top-level integration simulations, and corner-case waveform analysis were performed using **ModelSim** to verify correct packet routing, FIFO operation, parity generation, error detection, and controller behavior. RTL synthesis was completed using **Intel Quartus Prime**, and the synthesized hierarchy was analyzed using the RTL Viewer.

This project demonstrates fundamental concepts of digital system design, including finite state machine implementation, packet-based communication, FIFO memory management, control and datapath separation, synchronous digital design, and modular hardware architecture. The Router 1×3 serves as a practical example of how packet routing mechanisms are implemented in hardware and provides a strong foundation for more advanced Network-on-Chip (NoC) and communication system designs.

---

# Features

- Routes incoming packets to one of three output ports based on the destination address.
- Supports packet-based communication using **Header – Payload – Parity** format.
- Modular RTL architecture consisting of independent functional blocks.
- Finite State Machine (FSM) based control for packet reception and routing.
- Three independent FIFOs for temporary packet buffering.
- Automatic destination address decoding.
- One-hot FIFO write enable generation.
- Packet buffering during FIFO full conditions.
- Load-after-full mechanism for uninterrupted packet transmission.
- Header, payload, and parity byte processing.
- Internal parity generation using XOR operation.
- Parity error detection and reporting.
- Soft reset generation for inactive FIFOs.
- Independent valid output generation for each output port.
- Active-low synchronous reset implementation.
- Parameterized FIFO memory with **16 × 9-bit** storage.
- Modular design enabling independent module simulation and verification.
- Simulation waveform analysis performed using **ModelSim**.
- RTL synthesis and hierarchy verification performed using **Intel Quartus Prime**.

---

# Design Specifications

| Parameter | Specification |
|-----------|---------------|
| Project Name | Router 1×3 |
| Design Language | Verilog HDL |
| Design Methodology | Register Transfer Level (RTL) |
| Router Type | 1 × 3 Packet Router |
| Number of Input Ports | 1 |
| Number of Output Ports | 3 |
| Data Width | 8 bits |
| FIFO Width | 9 bits |
| FIFO Depth | 16 Locations |
| Number of FIFOs | 3 |
| Packet Format | Header + Payload + Parity |
| Payload Length | 1–63 Bytes |
| Destination Address Width | 2 bits |
| Packet Routing | Destination Address Based |
| Parity Type | Bitwise XOR |
| Reset Type | Active-Low Synchronous Reset |
| Design Style | Modular RTL Design |
| Simulation Method | Waveform Analysis |
| Synthesis | RTL Synthesis |

---

# Tools Used

| Tool | Purpose |
|------|---------|
| **Visual Studio Code** | RTL development and source code editing |
| **ModelSim** | Simulation and waveform analysis of individual modules and the complete Router 1×3 design |
| **Intel Quartus Prime** | RTL synthesis, design compilation, and RTL Viewer generation |
| **RTL Viewer (Quartus Prime)** | Visualization and analysis of the synthesized RTL hierarchy and module interconnections |

---
