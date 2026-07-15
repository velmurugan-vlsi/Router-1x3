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
# Packet Format

The Router 1×3 operates on a packet-based communication protocol, where each packet is transmitted sequentially through a single input interface. Every packet consists of three major components: a **Header**, **Payload**, and **Parity Byte**. The router interprets the header to determine the destination output port and the size of the incoming payload before forwarding the packet to the appropriate FIFO.

The packet format implemented in this design is illustrated below.

```
                    Packet Structure

    +----------+--------------------------+----------+
    |  Header  |       Payload Data       |  Parity  |
    +----------+--------------------------+----------+
      8 Bits         1 – 63 Bytes           8 Bits
```

## Header Format

The header occupies one byte (8 bits) and contains two fields:

```
                    Header Byte (8 Bits)

      +--------------------------------+-----------+
Bits  |             [7 : 2]            |   [1 : 0] |
      +--------------------------------+-----------+
Field |        Payload Length          | Destination|
      |                                |  Address   |
      +--------------------------------+-----------+
```

### Destination Address (DA)

The least significant two bits of the header represent the destination address. These bits determine which output FIFO stores the incoming packet.

| Destination Address | Selected Output |
|---------------------|-----------------|
| `2'b00` | FIFO0 (Output Port 0) |
| `2'b01` | FIFO1 (Output Port 1) |
| `2'b10` | FIFO2 (Output Port 2) |
| `2'b11` | Invalid Destination Address |

Only one FIFO is selected for each packet, ensuring that data is routed to the correct output port.

---

### Payload Length

Bits **[7:2]** of the header specify the payload length.

The payload length field determines the number of payload bytes that follow the header.

| Header Bits | Description |
|-------------|-------------|
| `[7:2]` | Number of payload bytes |
| Range | 1 to 63 Bytes |

The Router FSM uses this field to determine when payload reception is complete and when the parity byte should be expected.

---

## Payload

The payload contains the actual information being transmitted through the router.

Characteristics:

- Variable length
- Minimum payload size: **1 Byte**
- Maximum payload size: **63 Bytes**
- Stored in the selected FIFO
- Routed without modification

Each payload byte is written sequentially into the destination FIFO while the FSM remains in the **LOAD_DATA** state.

---

## Parity Byte

The final byte of every packet is the parity byte.

Its purpose is to detect transmission errors by comparing the transmitted parity with the internally generated parity.

The parity byte is calculated by performing a bitwise XOR operation on the header and every payload byte.

```
Packet Parity

Parity = Header
       ⊕ Payload Byte 1
       ⊕ Payload Byte 2
       ⊕ ...
       ⊕ Payload Byte N
```

where **N** is the payload length specified in the header.

During packet reception, the Register module continuously generates an internal parity value. After receiving the transmitted parity byte, both values are compared. If a mismatch is detected, the **err** signal is asserted, indicating a parity error.

---

## Example Packet

The following example illustrates the packet organization.

```
Header  = 8'b00010101

Length  = Header[7:2]
        = 000101
        = 5 Bytes

DA      = Header[1:0]
        = 01

Destination FIFO = FIFO1
```

Packet sequence:

```
Header
Payload Byte 1
Payload Byte 2
Payload Byte 3
Payload Byte 4
Payload Byte 5
Parity Byte
```

The Synchronizer decodes the destination address (`01`) and enables **FIFO1**. The FSM controls packet reception, while the Register module generates the parity during payload reception.

---

## Packet Reception Sequence

Each packet is processed in the following order:

```
               Incoming Packet

                     │
                     ▼

              Receive Header Byte

                     │
                     ▼

         Decode Destination Address

                     │
                     ▼

          Read Payload Length Field

                     │
                     ▼

        Select Destination FIFO

                     │
                     ▼

         Receive Payload Bytes

                     │
                     ▼

        Generate Internal Parity

                     │
                     ▼

         Receive Parity Byte

                     │
                     ▼

          Compare Parity Values

                     │
          ┌──────────┴──────────┐
          │                     │
          ▼                     ▼
      Match                 Mismatch
          │                     │
          ▼                     ▼
 Packet Accepted          Assert err Signal
```

---

# Router Architecture

<p align="center">

**📌 Insert the Router 1×3 Architecture Block Diagram Here**

</p>

The Router 1×3 follows a modular Register Transfer Level (RTL) architecture, where the overall functionality is divided into independent hardware blocks. Each module performs a specific task within the packet routing process, resulting in a design that is easy to understand, verify, and maintain.

The architecture consists of four primary modules:

- Router FSM
- Register
- Synchronizer
- Three Output FIFOs

These modules operate together to receive an incoming packet, decode its destination, buffer the data, perform parity verification, and deliver the packet to the selected output port.

The overall architecture can be divided into two major sections:

- **Control Path**
- **Data Path**

The control path manages the routing decisions and timing of operations, while the data path transfers packet bytes from the input interface to the selected FIFO.

---

## Major Functional Blocks

### FSM (Finite State Machine)

The FSM acts as the controller of the complete router.

It coordinates every stage of packet reception by generating the control signals required for:

- Header detection
- Payload loading
- FIFO write control
- FIFO full handling
- Parity processing
- Error checking

Every module in the router operates under the supervision of the FSM.

---

### Register

The Register module forms the primary data path of the router.

Its responsibilities include:

- Receiving incoming packet bytes
- Storing the header
- Buffering payload data
- Generating internal parity
- Storing the received parity byte
- Detecting parity errors
- Forwarding data toward the FIFO

---

### Synchronizer

The Synchronizer acts as the interface between the controller and the output FIFOs.

Its responsibilities include:

- Decoding the destination address
- Selecting the appropriate FIFO
- Generating one-hot write enable signals
- Monitoring FIFO status
- Generating valid output signals
- Issuing soft reset signals

Only one FIFO is enabled for writing during a packet transaction.

---

### FIFO

Three identical FIFOs are used to buffer packets independently for each destination port.

Each FIFO provides:

- Temporary packet storage
- Independent read and write operations
- Empty detection
- Full detection
- Soft reset support

Using independent FIFOs allows packets destined for different outputs to be buffered simultaneously without interfering with each other.

---

# Data Flow

The data path represents the movement of packet data through the router, from the input interface to the selected output FIFO.

```
               Incoming Packet

                     │

                     ▼

              Register Module

                     │

                     ▼

             Synchronizer Module

                     │

         Destination Address Decode

                     │

      ┌────────┬────────┬────────┐
      ▼        ▼        ▼
    FIFO0    FIFO1    FIFO2

      │        │        │

      ▼        ▼        ▼

 Output0   Output1   Output2
```

### Data Flow Description

1. The incoming packet is received through the `data_in` interface.
2. The Register module captures the header and payload bytes.
3. The destination address is extracted from the header.
4. The Synchronizer decodes the destination address.
5. The corresponding FIFO write enable signal is generated.
6. Payload bytes are written into the selected FIFO.
7. The packet remains buffered until the corresponding read enable is asserted.
8. The FIFO transfers the stored packet to the selected output port.

Throughout this process, packet ordering is preserved, ensuring First-In First-Out (FIFO) behavior.

---

# Control Flow

While the data path transfers packet bytes, the control path determines **when** each operation should occur.

```
                   pkt_valid

                       │

                       ▼

                FSM Controller

                       │

        ┌──────────────┼──────────────┐

        ▼              ▼              ▼

    Register      Synchronizer      FIFO

        │              │              │

        └──────────────┼──────────────┘

                       ▼

                  Status Signals

                (busy, full, empty,
                 parity_done, err)
```

The FSM continuously monitors status signals generated by the Register and Synchronizer modules. Based on these signals, it decides whether to receive a new packet, continue payload transmission, wait for FIFO availability, process the parity byte, or complete packet reception.

This separation between the control path and data path improves modularity and simplifies the overall hardware implementation.

---

# Top Module

The Top Module serves as the highest level of the Router 1×3 design and integrates all functional blocks into a single hardware system. It provides the external interface of the router and manages communication between the internal modules.

Rather than implementing routing functionality directly, the Top Module is responsible for instantiating each submodule and establishing the required signal connections between them.

The integrated modules include:

- Router FSM
- Register
- Synchronizer
- FIFO0
- FIFO1
- FIFO2

Together, these modules implement the complete packet routing process.

---

## Responsibilities

The Top Module performs the following functions:

- Receives packet data from the external interface.
- Distributes control signals to all internal modules.
- Connects the FSM with the Register and Synchronizer.
- Connects the Register output to the selected FIFO.
- Routes FIFO outputs to the corresponding output ports.
- Provides status outputs such as `busy`, `err`, and valid output signals.
- Integrates the complete Router 1×3 design into a single synthesizable module.

---

## External Interface

### Inputs

| Signal | Description |
|---------|-------------|
| `clock` | System clock |
| `resetn` | Active-low synchronous reset |
| `pkt_valid` | Indicates a valid incoming packet |
| `data_in[7:0]` | Input packet data |
| `read_enb_0` | Read enable for FIFO0 |
| `read_enb_1` | Read enable for FIFO1 |
| `read_enb_2` | Read enable for FIFO2 |

### Outputs

| Signal | Description |
|---------|-------------|
| `data_out_0[7:0]` | Data output from FIFO0 |
| `data_out_1[7:0]` | Data output from FIFO1 |
| `data_out_2[7:0]` | Data output from FIFO2 |
| `vld_out_0` | Valid output indication for FIFO0 |
| `vld_out_1` | Valid output indication for FIFO1 |
| `vld_out_2` | Valid output indication for FIFO2 |
| `busy` | Indicates that the router is processing a packet |
| `err` | Indicates parity error detection |

---

## Module Interconnection

The Top Module connects the controller and datapath to form a complete packet routing system.

- The FSM controls the Register and Synchronizer through control signals.
- The Register forwards packet data to the selected FIFO.
- The Synchronizer generates FIFO write enable signals and monitors FIFO status.
- Each FIFO independently stores packets for its corresponding output port.
- Read enable signals retrieve packets from the selected FIFO and present them on the output interface.

This hierarchical organization improves readability, modularity, and simplifies simulation and RTL synthesis while allowing each functional block to be developed and verified independently.
