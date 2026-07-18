# Router 1×3 using Verilog HDL

<p align="center">

**RTL Design • Packet-Based Routing • Verilog HDL • ModelSim • Intel Quartus Prime**

</p>

---

# Project Overview

The **Router 1×3** is a packet-based digital routing system developed using **Verilog HDL** at the Register Transfer Level (RTL). It receives packets from a single input interface and routes them to one of three output ports according to the destination address encoded in the packet header.

The design follows a modular architecture consisting of four major functional blocks: **FSM**, **Register**, **Synchronizer**, and **three independent FIFOs**. The FSM controls the routing sequence, the Register processes packet data and parity, the Synchronizer selects the destination FIFO and generates control signals, while the FIFOs buffer packets before transmission to the corresponding output ports.

The router supports packet buffering, destination address decoding, parity generation and checking, FIFO flow control, and soft reset functionality. Individual modules and the complete integrated design were simulated using **ModelSim**, where functionality was verified through waveform analysis. RTL synthesis was performed using **Intel Quartus Prime**, and the synthesized architecture was examined using the RTL Viewer.

This project demonstrates key digital design concepts including finite state machine implementation, packet-based communication, FIFO memory architecture, parity-based error detection, and modular RTL design.

---

# Features

- Single input and three independent output ports
- Packet-based routing using destination address decoding
- Modular RTL architecture
- FSM-based packet control
- Three independent FIFOs for packet buffering
- Header, payload, and parity processing
- Internal parity generation and parity error detection
- FIFO full handling with Load-After-Full mechanism
- One-hot FIFO write enable generation
- Independent valid output signals for each FIFO
- Soft reset support for inactive FIFOs
- Active-low synchronous reset
- Waveform-based simulation using ModelSim
- RTL synthesis using Intel Quartus Prime

---

# Design Specifications

| Parameter | Specification |
|-----------|---------------|
| **Project Name** | Router 1×3 |
| **Design Language** | Verilog HDL |
| **Design Methodology** | Register Transfer Level (RTL) |
| **Router Type** | 1 × 3 Packet Router |
| **Input Ports** | 1 |
| **Output Ports** | 3 |
| **Data Width** | 8 Bits |
| **FIFO Width** | 9 Bits |
| **FIFO Depth** | 16 × 9 |
| **Number of FIFOs** | 3 |
| **Packet Format** | Header + Payload + Parity |
| **Payload Length** | 1–63 Bytes |
| **Destination Address Width** | 2 Bits |
| **Parity Method** | Bitwise XOR |
| **Reset Type** | Active-Low Synchronous Reset |
| **Simulation Method** | Waveform Analysis |
| **Synthesis Tool** | Intel Quartus Prime |

---

# Tools Used

| Tool | Purpose |
|------|---------|
| **Visual Studio Code** | RTL development and source code editing |
| **ModelSim** | Simulation and waveform analysis |
| **Intel Quartus Prime** | RTL synthesis and project compilation |
| **RTL Viewer** | Visualization of synthesized RTL hierarchy |

---
# Packet Format

The Router 1×3 follows a **packet-based communication protocol**, where each packet consists of a **Header**, **Payload**, and **Parity** byte. The header determines the destination output port and the payload length, while the parity byte is used for error detection.


## Packet Structure

```text
               Packet Format

 +----------+-------------------------+----------+
 |  Header  |      Payload Data       |  Parity  |
 +----------+-------------------------+----------+
    8 Bits        1 – 63 Bytes          8 Bits
```

The packet is transmitted in the following order:

1. Header
2. Payload
3. Parity


## Header Format

```text
                 Header Format

 +-----------------------------+----------+
 | Payload Length [7:2]         | DA [1:0] |
 +-----------------------------+----------+
        6 Bits                     2 Bits
```

### Destination Address

| DA | Selected FIFO | Output Port |
|----|---------------|-------------|
| `00` | FIFO0 | Output Port 0 |
| `01` | FIFO1 | Output Port 1 |
| `10` | FIFO2 | Output Port 2 |
| `11` | Invalid Address | Not Used |

The Synchronizer decodes the destination address and enables the corresponding FIFO.


### Payload Length

| Field | Description |
|--------|-------------|
| `Header[7:2]` | Payload Length |
| Range | 1 – 63 Bytes |

The FSM uses this field to determine when payload reception is complete and when the parity byte should be received.


## Payload

The payload contains the actual data to be transmitted.

- Variable length (1–63 Bytes)
- Stored in the selected FIFO
- Routed without modification


## Parity Byte

The parity byte is generated using a bitwise XOR operation on the header and all payload bytes.

```text
Parity = Header
       ⊕ Payload Byte 1
       ⊕ Payload Byte 2
       ⊕ ...
       ⊕ Payload Byte N
```

The Register module compares the received parity byte with the internally generated parity. If both values do not match, the **err** signal is asserted.


## Example Packet

```text
Header = 8'b00010101

Payload Length = Header[7:2]
               = 000101
               = 5 Bytes

Destination Address = Header[1:0]
                    = 01

Selected FIFO = FIFO1
```

Packet Sequence

```text
Header
Payload Byte 1
Payload Byte 2
Payload Byte 3
Payload Byte 4
Payload Byte 5
Parity Byte
```

---

# Router Architecture

The Router 1×3 is implemented using a modular Register Transfer Level (RTL) architecture. The design consists of four major functional blocks: the **FSM**, **Register**, **Synchronizer**, and **three independent FIFOs**. Together, these modules receive an incoming packet, decode its destination address, buffer the packet, and forward it to the appropriate output port.

<p align="center">
<img width="718" height="499" alt="Screenshot 2026-07-13 151201" src="https://github.com/user-attachments/assets/15ebf490-5cd5-4c75-9f7b-c16fca16e2b7" />
</p>

<p align="center">
<b>Figure 1.</b> Router 1×3 Architecture
</p>

The architecture is divided into two logical sections:

- **Control Path** – Managed by the FSM to coordinate packet reception, routing, and flow control.
- **Data Path** – Transfers packet data from the input interface to the selected output FIFO.

The functionality of each module is explained in detail in the following sections.

---

# Top Module

The **Top Module** integrates the FSM, Register, Synchronizer, and three FIFOs into a complete Router 1×3 design. It provides the external interface and connects all internal modules to implement the complete packet routing process.

## Instantiated Modules

- FSM
- Register
- Synchronizer
- FIFO0
- FIFO1
- FIFO2

## Inputs

| Signal | Description |
|---------|-------------|
| `clock` | System clock |
| `resetn` | Active-low synchronous reset |
| `pkt_valid` | Indicates a valid incoming packet |
| `data_in[7:0]` | Packet input data |
| `read_enb_0` | FIFO0 read enable |
| `read_enb_1` | FIFO1 read enable |
| `read_enb_2` | FIFO2 read enable |


## Outputs

| Signal | Description |
|---------|-------------|
| `data_out_0[7:0]` | FIFO0 output data |
| `data_out_1[7:0]` | FIFO1 output data |
| `data_out_2[7:0]` | FIFO2 output data |
| `vld_out_0` | FIFO0 valid output |
| `vld_out_1` | FIFO1 valid output |
| `vld_out_2` | FIFO2 valid output |
| `busy` | Router busy indication |
| `err` | Parity error indication |

---
# FSM Module

The **Finite State Machine (FSM)** is the controller of the Router 1×3. It controls the complete packet routing sequence by generating the control signals required for packet reception, FIFO management, parity processing, and packet completion. Based on the packet status and FIFO conditions, the FSM transitions through a series of predefined states to ensure correct packet routing.


## Responsibilities

- Detect the arrival of a new packet.
- Control header and payload reception.
- Generate FIFO write control signals.
- Handle FIFO full conditions.
- Resume packet transfer after FIFO availability.
- Control parity byte reception.
- Detect packet completion.
- Return the router to the idle state.


## FSM State Diagram

<p align="center">
<img width="629" height="383" alt="Screenshot 2026-07-18 154935" src="https://github.com/user-attachments/assets/bec4af5c-cfb2-4313-b858-d99cc126dfc3" />
</p>

<p align="center">
<b>Figure 2.</b> FSM State Diagram
</p>


## FSM States

### DETECT_ADDRESS

The router remains in the idle state until a valid packet is detected. The destination address is decoded and the selected FIFO is checked before packet reception begins.

**Next State:** `LOAD_FIRST_DATA`


### LOAD_FIRST_DATA

Receives the packet header, initializes packet reception, and enables writing to the selected FIFO.

**Next State:** `LOAD_DATA`


### LOAD_DATA

Receives payload bytes and continuously writes them into the selected FIFO while monitoring FIFO status.

**Possible Next States:**

- `LOAD_PARITY`
- `FIFO_FULL_STATE`


### FIFO_FULL_STATE

Entered whenever the selected FIFO becomes full during packet reception. Packet transfer is temporarily paused until FIFO space becomes available.

**Next State:** `LOAD_AFTER_FULL`


### LOAD_AFTER_FULL

Resumes packet transmission after the FIFO is no longer full and continues writing the remaining packet data.

**Possible Next States:**

- `LOAD_DATA`
- `LOAD_PARITY`


### LOAD_PARITY

Receives the parity byte after all payload bytes have been transferred.

**Next State:** `CHECK_PARITY_ERROR`


### CHECK_PARITY_ERROR

Compares the internally generated parity with the received parity byte. If both values match, the packet transfer is completed successfully; otherwise, the **err** signal is asserted.

**Next State:** `DETECT_ADDRESS`


## FSM Inputs

| Signal | Description |
|---------|-------------|
| `clock` | System clock |
| `resetn` | Active-low synchronous reset |
| `pkt_valid` | Indicates valid packet reception |
| `fifo_full` | Selected FIFO full indication |
| `fifo_empty` | Selected FIFO empty indication |
| `parity_done` | Indicates parity completion |
| `low_pkt_valid` | Indicates last payload byte |


## FSM Outputs

| Signal | Description |
|---------|-------------|
| `busy` | Router busy indication |
| `detect_add` | Header detection control |
| `ld_state` | Payload loading control |
| `laf_state` | Load-after-full control |
| `lfd_state` | Load-first-data control |
| `write_enb_reg` | FIFO write enable control |
| `rst_int_reg` | Internal register reset |


## State Transition Summary

| State | Primary Function |
|-------|------------------|
| DETECT_ADDRESS | Waits for a valid packet and decodes the destination address |
| LOAD_FIRST_DATA | Stores the packet header and starts packet reception |
| LOAD_DATA | Receives and forwards payload bytes |
| FIFO_FULL_STATE | Pauses transmission when the selected FIFO is full |
| LOAD_AFTER_FULL | Resumes packet transfer after FIFO availability |
| LOAD_PARITY | Receives the parity byte |
| CHECK_PARITY_ERROR | Verifies parity and completes packet processing |

The FSM ensures that every packet follows the correct routing sequence while coordinating the Register, Synchronizer, and FIFO modules throughout the packet transfer process.

---
# Register Module

The **Register Module** forms the primary data path of the Router 1×3. It receives every incoming packet byte and is responsible for storing the header, forwarding payload data, generating internal parity, and verifying the received parity byte. It also temporarily buffers data whenever the selected FIFO becomes full, ensuring that no packet data is lost during transmission.


## Responsibilities

- Capture the packet header.
- Forward payload bytes to the selected FIFO.
- Generate internal parity.
- Store the received parity byte.
- Detect parity errors.
- Buffer data during FIFO full conditions.
- Generate packet status signals.


## Internal Registers

| Register | Function |
|----------|----------|
| `header_reg` | Stores the packet header |
| `fifo_full_reg` | Buffers data when FIFO becomes full |
| `internal_parity_reg` | Generates parity during packet reception |
| `parity_reg` | Stores the received parity byte |


## Important Signals

| Signal | Description |
|---------|-------------|
| `dout` | Data forwarded to the FIFO |
| `parity_done` | Indicates completion of parity processing |
| `low_pkt_valid` | Indicates the final payload byte has been received |
| `err` | Asserted when a parity mismatch is detected |

The Register module acts as the bridge between the packet input interface and the FIFO, ensuring correct packet formatting and parity verification before data is written to the selected output buffer.


# Synchronizer Module

The **Synchronizer Module** connects the controller with the three output FIFOs. It decodes the destination address from the packet header, selects the appropriate FIFO, and generates the control signals required for packet routing.

Only one FIFO is enabled during a packet transfer, ensuring that packets are routed to the correct destination.


## Responsibilities

- Decode the destination address.
- Select the destination FIFO.
- Generate one-hot FIFO write enable signals.
- Monitor FIFO full status.
- Generate valid output signals.
- Generate independent soft reset signals.


## Destination Selection

| Destination Address | Selected FIFO |
|---------------------|---------------|
| `00` | FIFO0 |
| `01` | FIFO1 |
| `10` | FIFO2 |


## Important Signals

| Signal | Description |
|---------|-------------|
| `write_enb[2:0]` | FIFO write enable signals |
| `fifo_full` | Selected FIFO full indication |
| `soft_reset_0` | FIFO0 soft reset |
| `soft_reset_1` | FIFO1 soft reset |
| `soft_reset_2` | FIFO2 soft reset |
| `vld_out_0` | FIFO0 valid output |
| `vld_out_1` | FIFO1 valid output |
| `vld_out_2` | FIFO2 valid output |

The Synchronizer ensures proper communication between the controller and the output FIFOs while preventing multiple FIFOs from being written simultaneously.

---

# FIFO Module

The Router 1×3 contains **three independent FIFOs**, one for each output port. These FIFOs temporarily store packet data before it is transferred to the corresponding output interface. Each FIFO operates independently, allowing packets destined for different output ports to be buffered simultaneously.


## Responsibilities

- Store incoming packet data.
- Maintain packet order (FIFO principle).
- Support independent read and write operations.
- Generate full and empty status flags.
- Support soft reset operation.


## FIFO Specifications

| Parameter | Value |
|-----------|-------|
| Memory Depth | 16 Locations |
| Data Width | 9 Bits |
| Number of FIFOs | 3 |
| Read Operation | Synchronous |
| Write Operation | Synchronous |
| Reset | Active-Low Synchronous |
| Soft Reset | Supported |


## Internal Components

| Component | Function |
|-----------|----------|
| Memory Array | Stores packet data |
| Write Pointer | Points to the next write location |
| Read Pointer | Points to the next read location |
| Counter | Tracks FIFO occupancy |
| Full Flag | Indicates FIFO is full |
| Empty Flag | Indicates FIFO is empty |


## FIFO Operation

### Write Operation

When the write enable signal is asserted and the FIFO is not full, incoming packet data is stored in the memory array and the write pointer advances to the next location.

### Read Operation

When the read enable signal is asserted and the FIFO is not empty, the stored packet data is transferred to the output port and the read pointer advances.

### Soft Reset

A soft reset clears the FIFO memory, resets both pointers, clears the occupancy counter, and asserts the empty flag without affecting the remaining FIFOs.

The independent FIFO architecture allows each output port to buffer packets separately, ensuring reliable packet transfer and maintaining the correct order of data throughout the routing process.

---
# RTL Design (RTL Viewer)

The Router 1×3 design was synthesized using **Intel Quartus Prime**, and the generated **RTL Viewer** was used to verify the structural implementation of the design. The RTL hierarchy confirms that the router is implemented using a modular architecture consisting of the **FSM**, **Register**, **Synchronizer**, and **three independent FIFO modules**.

<p align="center">
<img width="929" height="452" alt="Screenshot 2026-07-15 112554" src="https://github.com/user-attachments/assets/ee2f28d0-4d3a-4808-b902-44f173c1137e" />

</p>

<p align="center">
<b>Figure 3.</b> RTL Viewer of Router 1×3
</p>


## RTL Hierarchy

The synthesized RTL contains the following modules:

- Router 1×3 (Top Module)
- FSM
- Register
- Synchronizer
- FIFO0
- FIFO1
- FIFO2

Each module performs a dedicated function while working together to achieve complete packet routing.


## RTL Observation

The RTL Viewer verifies the following:

- Correct hierarchical module instantiation.
- Proper connection between the control path and data path.
- Independent FIFO implementation for each output port.
- Modular RTL architecture for easy design maintenance and debugging.

---

# Simulation and Waveform Analysis

Simulation was performed using **ModelSim**. Each module was verified independently through waveform analysis before validating the complete Router 1×3 at the top level. The simulation confirms the correct interaction between all modules and successful packet routing.


# FIFO Waveform Analysis

<p align="center">
<img src="waveforms/fifo/fifo_waveform.png" width="900">
</p>

### Verified

- FIFO write operation
- FIFO read operation
- Write and read pointer updates
- Full and Empty flag generation
- Soft reset functionality

**Result:** FIFO functionality verified successfully.


# FSM Waveform Analysis

<p align="center">
<img src="waveforms/fsm/fsm_waveform.png" width="900">
</p>

### Verified

- FSM state transitions
- Packet reception sequence
- FIFO full handling
- Load-after-full operation
- Parity processing
- Return to idle state

**Result:** FSM operation verified successfully.


# Register Waveform Analysis

<p align="center">
<img src="waveforms/register/register_waveform.png" width="900">
</p>

### Verified

- Header storage
- Payload forwarding
- Internal parity generation
- Received parity storage
- Parity error detection
- Data buffering during FIFO full condition

**Result:** Register module verified successfully.


# Synchronizer Waveform Analysis

<p align="center">
<img src="waveforms/synchronizer/synchronizer_waveform.png" width="900">
</p>

### Verified

- Destination address decoding
- FIFO selection
- Write enable generation
- Valid output generation
- Soft reset generation

**Result:** Synchronizer module verified successfully.


# Top-Level Waveform Analysis (Normal Case)

<p align="center">
<img src="waveforms/router/router_normal_case.png" width="900">
</p>

### Verified

- Packet reception
- Destination decoding
- FIFO selection
- Payload transfer
- Packet output from the selected FIFO
- Successful packet routing without errors

**Result:** Normal packet routing verified successfully.


# Top-Level Waveform Analysis (Corner Cases)

<p align="center">
<img src="waveforms/router/router_corner_case.png" width="900">
</p>

### Verified

- Continuous packet transmission
- Multiple destination routing
- FIFO full condition handling
- Consecutive packet processing
- Stable router operation during different routing scenarios

**Result:** Corner case behavior verified successfully.
# Top-Level Waveform Analysis (Normal Case)

<p align="center">
<img src="Waveforms/top_level_normal.png" width="900">
</p>

### Objective

To verify the complete Router 1×3 operation by observing packet reception, destination decoding, FIFO selection, packet buffering, and data transmission through the integrated design.


### Signals Observed

- `pkt_valid`
- `data_in`
- `busy`
- `write_enb`
- `data_out_0`
- `data_out_1`
- `data_out_2`
- `vld_out_0`
- `vld_out_1`
- `vld_out_2`
- FSM states
- FIFO pointers
- Internal registers

---

### Waveform Observation

The waveform confirms the following operations:

- A valid packet is received at the input interface.
- The destination address is decoded successfully.
- The FSM progresses through the expected routing states.
- The Synchronizer enables the appropriate FIFO.
- Payload bytes are stored sequentially in the selected FIFO.
- Packet data is read correctly after the corresponding read enable signal is asserted.
- The transmitted packet appears at the correct output port while preserving packet order.
- No parity error is detected during packet transmission.

**Result:** Successful packet routing verified through waveform analysis.

---

# Top-Level Waveform Analysis (Corner Cases)

<p align="center">
<img src="Waveforms/top_level_corner_case.png" width="900">
</p>

### Objective

To observe the behavior of the Router 1×3 under different operating scenarios and verify stable operation during continuous packet transfers.

---

### Waveform Observation

The corner-case waveform demonstrates:

- Consecutive packet transmissions without reset.
- Routing of packets to different output FIFOs.
- Correct FIFO selection based on destination address.
- Proper FIFO read and write operations.
- Stable FSM transitions throughout multiple packet transfers.
- Correct synchronization between controller and datapath.
- Continuous packet processing without data corruption.
- Correct output generation after every packet transaction.

**Result:** Stable router operation verified through waveform analysis.

---

# Simulation Summary

The Router 1×3 design was verified through **ModelSim waveform analysis**. Individual modules were simulated independently before integrating the complete router. Internal and external signals were monitored to ensure correct interaction between all modules.

| Module | Verification |
|---------|--------------|
| FIFO | Write/read operations, pointer updates, and status flags verified |
| FSM | State transitions and control signal generation verified |
| Register | Packet buffering, parity generation, and error detection verified |
| Synchronizer | Destination decoding, FIFO selection, and soft reset generation verified |
| Top Module | Complete packet routing and module integration verified |
| Corner Cases | Continuous packet routing and stable operation verified |

---

# Repository Structure

```text
Router-1x3/
│
├── RTL/                 # Verilog source files
├── Testbench/           # Testbench files
├── Waveforms/           # ModelSim waveform screenshots
├── RTL_Viewer/          # Quartus RTL Viewer images
├── Images/              # Architecture and FSM diagrams
├── README.md
└── LICENSE
```

---

# Author

**VELMURUGAN R**

---

# Conclusion

The **Router 1×3** was successfully designed using **Verilog HDL** with a modular RTL architecture consisting of the **FSM**, **Register**, **Synchronizer**, and **three independent FIFOs**. The design routes packets based on the destination address, buffers data using dedicated FIFOs, and verifies data integrity through parity generation and checking.

Simulation was performed using **ModelSim**, where each module and the complete integrated router were analyzed through waveform observation. The simulation results confirm correct packet reception, destination decoding, FIFO operation, controller sequencing, parity verification, and overall packet routing behavior. RTL synthesis using **Intel Quartus Prime** further verifies the hierarchical implementation of the design.

This project demonstrates practical implementation of packet-based communication, finite state machine design, FIFO-based buffering, and modular RTL development, providing a strong foundation for digital design and FPGA-based communication systems.

---
