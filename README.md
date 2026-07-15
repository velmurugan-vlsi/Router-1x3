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
# FSM Module

The **Finite State Machine (FSM)** is the central controller of the Router 1×3 architecture. It supervises every stage of packet reception and determines the sequence of operations required to successfully route a packet from the input interface to the selected output FIFO. Rather than transferring data directly, the FSM generates the control signals that coordinate the Register, Synchronizer, and FIFO modules.

The controller continuously monitors the packet status, FIFO availability, parity completion, and internal control signals. Based on these inputs, it transitions through predefined states that collectively implement the complete packet routing algorithm. This centralized control simplifies the overall architecture by separating decision-making from data processing.

---

## Responsibilities

The FSM is responsible for:

- Detecting the arrival of a new packet.
- Decoding the packet reception sequence.
- Controlling header and payload loading.
- Managing FIFO write operations.
- Handling FIFO full conditions.
- Resuming packet transfer after FIFO availability.
- Controlling parity byte reception.
- Generating internal control signals.
- Returning the router to the idle state after packet completion.

---

## FSM State Diagram

> **Insert FSM State Diagram Here**

---

## FSM States

### 1. DETECT_ADDRESS

The **DETECT_ADDRESS** state is the idle state of the router. During this state, the FSM continuously monitors the `pkt_valid` signal for the arrival of a new packet. Once a valid header is detected, the destination address is extracted and the status of the selected FIFO is checked before initiating packet reception.

**Responsibilities**

- Wait for packet arrival.
- Detect valid header.
- Decode destination address.
- Check destination FIFO availability.
- Generate `detect_add`.

**Next State**

- `LOAD_FIRST_DATA`

---

### 2. LOAD_FIRST_DATA

This state marks the beginning of packet reception. The header byte is stored in the Register module and simultaneously forwarded to the destination FIFO. Initial control signals required for payload reception are also generated.

**Responsibilities**

- Store packet header.
- Enable FIFO write.
- Initialize payload transfer.
- Generate `lfd_state`.

**Next State**

- `LOAD_DATA`

---

### 3. LOAD_DATA

During this state, payload bytes are accepted sequentially from the input interface and forwarded to the selected FIFO. The FSM remains in this state until the payload transmission is complete or the FIFO becomes full.

**Responsibilities**

- Accept payload bytes.
- Enable FIFO write operation.
- Monitor FIFO status.
- Continue until `pkt_valid` becomes LOW.

**Possible Transitions**

- `LOAD_PARITY`
- `FIFO_FULL_STATE`

---

### 4. FIFO_FULL_STATE

Whenever the selected FIFO becomes full during packet reception, the FSM temporarily suspends packet transmission. Incoming data is buffered internally while the controller waits for free space to become available.

This mechanism prevents packet corruption caused by FIFO overflow.

**Responsibilities**

- Stop FIFO writes.
- Preserve incoming packet data.
- Wait until FIFO is no longer full.

**Next State**

- `LOAD_AFTER_FULL`

---

### 5. LOAD_AFTER_FULL

Once space becomes available inside the FIFO, packet transmission resumes from the point where it was suspended. The buffered data is written into the FIFO before normal payload reception continues.

**Responsibilities**

- Resume interrupted packet transfer.
- Write buffered byte.
- Continue payload reception.

**Next State**

- `LOAD_DATA`
- `LOAD_PARITY`

---

### 6. LOAD_PARITY

After all payload bytes have been received, the transmitter sends the parity byte. During this state, the Register module stores the received parity while simultaneously completing the internally generated parity calculation.

**Responsibilities**

- Receive parity byte.
- Complete packet reception.
- Generate `parity_done`.

**Next State**

- `CHECK_PARITY_ERROR`

---

### 7. CHECK_PARITY_ERROR

The final state compares the internally generated parity with the received parity byte. If both values match, packet reception is completed successfully. Otherwise, the `err` signal is asserted to indicate a parity mismatch.

After comparison, the FSM returns to the idle state and waits for the next packet.

**Responsibilities**

- Compare parity values.
- Generate error indication.
- Reset internal control logic.
- Return router to idle state.

---

## FSM Inputs

| Signal | Description |
|---------|-------------|
| clock | System clock |
| resetn | Active-low synchronous reset |
| pkt_valid | Indicates valid packet reception |
| fifo_full | Selected FIFO full indication |
| fifo_empty | Selected FIFO empty indication |
| parity_done | Indicates parity completion |
| low_pkt_valid | Indicates last payload byte |

---

## FSM Outputs

| Signal | Description |
|---------|-------------|
| busy | Router busy indication |
| detect_add | Header detection control |
| ld_state | Payload loading control |
| laf_state | Load-after-full control |
| lfd_state | Load-first-data control |
| write_enb_reg | FIFO write enable control |
| rst_int_reg | Internal register reset |

---

# Register Module

The **Register Module** forms the primary data path of the Router 1×3. It receives every incoming byte from the input interface and performs packet formatting, temporary storage, parity generation, and error detection before forwarding the packet to the selected FIFO.

Unlike the FSM, which performs only control operations, the Register module processes the actual packet data. Throughout packet reception, it continuously updates the internal parity value while preserving packet ordering.

---

## Responsibilities

- Capture packet header.
- Receive payload bytes.
- Store parity byte.
- Generate internal parity.
- Detect parity mismatch.
- Buffer data during FIFO full condition.
- Forward packet data to FIFO.

---

## Internal Registers

### Header Register

Stores the first byte of every packet.

The destination address and payload length are extracted from this register and used throughout packet reception.

---

### FIFO Full Register

Temporarily stores the incoming byte whenever the selected FIFO becomes full.

Once FIFO space becomes available, the buffered byte is forwarded to the FIFO before normal transmission resumes.

---

### Internal Parity Register

Generates packet parity by performing a continuous XOR operation on every received packet byte except the transmitted parity byte.

---

### Packet Parity Register

Stores the received parity byte transmitted by the sender.

After packet reception, this value is compared against the internally generated parity.

---

## Major Outputs

| Signal | Description |
|---------|-------------|
| dout | Data forwarded to FIFO |
| parity_done | Indicates parity completion |
| low_pkt_valid | Indicates payload completion |
| err | Parity error indication |

---

# Synchronizer Module

The **Synchronizer Module** provides the interface between the control path and the three output FIFOs. Its primary purpose is to decode the destination address, select the appropriate FIFO, and generate the required control signals for packet routing.

Although only one packet is received at a time, the router contains three independent FIFOs. The Synchronizer ensures that only the destination FIFO receives write requests while the remaining FIFOs remain inactive.

---

## Responsibilities

- Decode destination address.
- Select destination FIFO.
- Generate one-hot write enable.
- Generate valid output signals.
- Monitor FIFO status.
- Generate soft reset signals.
- Report FIFO full condition to FSM.

---

## Destination Selection

| Destination Address | Selected FIFO |
|---------------------|---------------|
| 00 | FIFO0 |
| 01 | FIFO1 |
| 10 | FIFO2 |

Only one FIFO is enabled during a packet transfer.

---

## Major Outputs

| Signal | Description |
|---------|-------------|
| write_enb[2:0] | FIFO write enable |
| fifo_full | Selected FIFO full status |
| soft_reset_0 | FIFO0 soft reset |
| soft_reset_1 | FIFO1 soft reset |
| soft_reset_2 | FIFO2 soft reset |
| vld_out_0 | FIFO0 valid output |
| vld_out_1 | FIFO1 valid output |
| vld_out_2 | FIFO2 valid output |

---

# FIFO Module

Three identical FIFO modules are used to buffer packets before they are transmitted through the output ports. Each FIFO operates independently, allowing packets destined for different outputs to be stored simultaneously.

Each FIFO has a storage capacity of **16 locations**, with every location storing **9 bits**. Along with the 8-bit packet data, an additional control bit is stored to distinguish header information during packet processing.

The FIFO follows the **First-In First-Out (FIFO)** principle, ensuring that packet ordering is preserved from input to output.

---

## Responsibilities

- Store incoming packet bytes.
- Maintain packet order.
- Support independent read and write operations.
- Generate empty and full indications.
- Support soft reset.
- Provide data to output interface.

---

## Internal Components

### FIFO Memory

Stores incoming packet bytes.

Memory Size:

- 16 Locations
- 9-bit Width

---

### Write Pointer

Indicates the next memory location available for storing incoming data.

The pointer increments after every successful write operation.

---

### Read Pointer

Tracks the next packet byte to be read from memory.

The pointer increments after every successful read operation.

---

### Counter

Maintains the number of packet entries currently stored inside the FIFO.

The counter updates after every read and write operation and is used to generate the Full and Empty status signals.

---

## Status Flags

### Empty Flag

Asserted whenever no valid packet data is stored inside the FIFO.

---

### Full Flag

Asserted whenever all FIFO locations are occupied.

Once Full becomes HIGH, further write operations are prevented until data is read from the FIFO.

---

## Soft Reset

Each FIFO supports an independent soft reset generated by the Synchronizer module.

During a soft reset:

- FIFO memory is cleared.
- Read pointer is reset.
- Write pointer is reset.
- Counter is cleared.
- Empty flag is asserted.

This mechanism allows inactive FIFOs to be safely cleared without affecting the remaining FIFOs.

---

## FIFO Characteristics

| Parameter | Value |
|-----------|-------|
| Number of FIFOs | 3 |
| Memory Depth | 16 Locations |
| Data Width | 9 Bits |
| Read Operation | Synchronous |
| Write Operation | Synchronous |
| Reset | Active-Low Synchronous |
| Soft Reset | Supported |
| Full Detection | Supported |
| Empty Detection | Supported |
# RTL Design (RTL Viewer)

The synthesized RTL hierarchy generated using **Intel Quartus Prime RTL Viewer** provides a structural representation of the Router 1×3 architecture. Unlike the behavioral RTL source code, the RTL Viewer illustrates how the design is interpreted by the synthesis tool and how individual modules are interconnected to form the complete hardware architecture.

The synthesized design confirms that the Router 1×3 has been implemented using a modular hierarchical approach, where each functional block performs a dedicated operation within the routing process. This modular organization improves readability, simplifies debugging, and enables each hardware block to be verified independently before integration.

<p align="center">
<img src="RTL_Viewer/router_rtl_viewer.png" width="900">
</p>

<p align="center">
<b>Figure 1.</b> Synthesized RTL hierarchy of the Router 1×3
</p>

---

## RTL Hierarchy

The RTL Viewer shows the following major hardware blocks.

```
                    Router 1×3

                        │

      ┌─────────────────┼──────────────────┐

      │                 │                  │

     FSM            Register         Synchronizer

                                            │

                        ┌───────────┬───────────┬───────────┐

                        │           │           │

                     FIFO0       FIFO1       FIFO2
```

Each module performs a dedicated function within the overall routing process.

---

## RTL Architecture Analysis

### FSM

The FSM appears as an independent control block connected to the Register and Synchronizer modules.

Its outputs generate all control signals required for packet reception, including:

- detect_add
- ld_state
- laf_state
- lfd_state
- write_enb_reg
- busy
- rst_int_reg

The RTL hierarchy confirms that the controller is completely separated from the datapath.

---

### Register

The Register module receives the incoming packet directly from the input interface.

Its outputs connect to:

- Synchronizer
- FIFO Data Inputs
- Error Output

The RTL hierarchy clearly shows that packet formatting and parity generation are isolated within this module.

---

### Synchronizer

The Synchronizer acts as the interface between the controller and the three FIFOs.

Its synthesized outputs include:

- write_enb[2:0]
- fifo_full
- soft_reset_0
- soft_reset_1
- soft_reset_2
- vld_out_0
- vld_out_1
- vld_out_2

This confirms that FIFO selection is performed centrally rather than individually inside each FIFO.

---

### FIFOs

The RTL Viewer shows three independent FIFO instances.

Each FIFO receives

- Data
- Write Enable
- Read Enable
- Soft Reset

and independently generates

- Data Output
- Full Flag
- Empty Flag

The hierarchical organization confirms that each output port possesses an independent packet buffer.

---

## Design Hierarchy

The synthesized hierarchy verifies that the Router 1×3 has been implemented using a clean modular design methodology.

Advantages include:

- Easy module reuse
- Independent module simulation
- Simplified debugging
- Improved maintainability
- Clear separation between datapath and controller

---

# Simulation and Waveform Analysis

The Router 1×3 RTL design was simulated using **ModelSim**. The correctness of each module was analyzed by observing the generated simulation waveforms and monitoring both internal and external signals.

The objective of the simulation was to verify that every module behaved according to the intended RTL design and that the integrated router successfully transferred packets from the input interface to the selected output FIFO.

The simulation process consisted of two stages.

- Individual module simulation
- Top-level integrated simulation

Each module was first simulated independently to verify its internal functionality before being integrated into the complete router.

---

# FIFO Waveform Analysis

<p align="center">
<img src="Waveforms/fifo_waveform.png" width="900">
</p>

The FIFO module was simulated independently to verify correct packet storage and retrieval.

The waveform demonstrates the complete FIFO operation, including reset initialization, write operations, read operations, pointer movement, occupancy count, and status flag generation.

---

## Signals Observed

- clock
- resetn
- soft_reset
- write_enb
- read_enb
- data_in
- data_out
- full
- empty
- write_ptr
- read_ptr
- count

---

## Waveform Observations

The waveform confirms the following behavior.

- FIFO initializes correctly after reset.
- Empty flag is asserted after reset.
- Incoming data is written only when write enable is asserted.
- Write pointer increments after every successful write.
- FIFO memory stores packet data sequentially.
- Read pointer increments after every successful read.
- Output data follows FIFO ordering.
- Counter correctly tracks FIFO occupancy.
- Empty flag asserts after all stored data has been read.
- Soft reset clears the FIFO memory and resets internal pointers.

The observed waveform confirms correct FIFO functionality.

---

# FSM Waveform Analysis

<p align="center">
<img src="Waveforms/fsm_waveform.png" width="900">
</p>

The FSM waveform demonstrates the operation of the router controller throughout packet reception.

The controller transitions through different routing states depending on packet status and FIFO conditions.

---

## Signals Observed

- state
- next_state
- busy
- detect_add
- ld_state
- laf_state
- lfd_state
- write_enb_reg
- rst_int_reg
- fifo_full
- pkt_valid

---

## Waveform Observations

The waveform confirms that:

- The controller initializes correctly after reset.
- A valid packet causes transition from DETECT_ADDRESS to LOAD_FIRST_DATA.
- Payload bytes are accepted while the FSM remains in LOAD_DATA.
- FIFO full conditions force the FSM into FIFO_FULL_STATE.
- Packet reception resumes through LOAD_AFTER_FULL.
- The parity byte is accepted in LOAD_PARITY.
- The controller compares parity values in CHECK_PARITY_ERROR.
- The FSM returns to DETECT_ADDRESS after packet completion.

The observed state transitions match the intended packet reception sequence.

---

# Register Waveform Analysis

<p align="center">
<img src="Waveforms/register_waveform.png" width="900">
</p>

The Register module waveform verifies packet storage and parity generation.

---

## Signals Observed

- header_reg
- fifo_full_reg
- internal_parity_reg
- parity_reg
- dout
- parity_done
- low_pkt_valid
- err

---

## Waveform Observations

The waveform demonstrates that:

- Header byte is captured correctly.
- Payload bytes are forwarded sequentially.
- Internal parity is generated continuously.
- Received parity byte is stored.
- Parity comparison occurs after packet completion.
- Error signal remains LOW for correct packets.
- Buffered data is retained during FIFO full conditions.
- Packet transmission resumes correctly after FIFO availability.

The Register module performs both packet buffering and parity verification as intended.

---

# Synchronizer Waveform Analysis

<p align="center">
<img src="Waveforms/synchronizer_waveform.png" width="900">
</p>

The Synchronizer waveform verifies destination decoding and FIFO selection.

---

## Signals Observed

- write_enb
- fifo_full
- vld_out_0
- vld_out_1
- vld_out_2
- soft_reset_0
- soft_reset_1
- soft_reset_2

---

## Waveform Observations

The waveform confirms:

- Destination address is decoded correctly.
- Only one FIFO write enable is active during packet transfer.
- Valid output is generated for the selected FIFO.
- FIFO full status is correctly reported.
- Soft reset signals are generated independently.
- FIFO selection changes according to the destination address.

This confirms proper routing control between the controller and the FIFOs.

---

# Top-Level Waveform Analysis (Normal Packet Transfer)

<p align="center">
<img src="Waveforms/top_normal.png" width="900">
</p>

The complete Router 1×3 was simulated to verify packet transfer through the integrated design.

This simulation demonstrates the interaction between all internal modules during a normal packet transmission.

---

## Signals Observed

- data_in
- pkt_valid
- busy
- data_out_0
- data_out_1
- data_out_2
- write_enb
- FSM states
- FIFO pointers
- FIFO memory
- header register
- parity register

---

## Waveform Observations

The waveform shows the complete packet routing sequence.

- Packet header is received.
- Destination address is decoded.
- Payload length is extracted.
- FSM begins packet reception.
- Register stores packet bytes.
- Synchronizer enables the selected FIFO.
- FIFO stores incoming data.
- Output data becomes available after read enable.
- Packet ordering is preserved.
- No parity error is generated.
- FSM returns to the idle state after packet completion.

The integrated simulation confirms correct interaction between all modules.

---

# Top-Level Waveform Analysis (Corner Cases)

<p align="center">
<img src="Waveforms/top_corner_cases.png" width="900">
</p>

A dedicated simulation was performed to observe router behavior under multiple operating scenarios beyond a single packet transfer.

The purpose of this simulation was to confirm that the router continues to operate correctly during extended packet transmissions and changing routing conditions.

---

## Waveform Observations

The corner-case simulation demonstrates:

- Multiple packets transmitted sequentially.
- Different destination addresses selected correctly.
- Packet routing to FIFO0, FIFO1, and FIFO2.
- Continuous packet reception without requiring reset.
- FIFO memory updated correctly for successive packets.
- Read and write pointers operate correctly throughout the simulation.
- Valid output signals generated for the selected destination.
- FSM repeatedly returns to the idle state after each packet.
- Internal control signals remain synchronized with packet transmission.
- Packet ordering is preserved throughout multiple transactions.

The waveform confirms stable operation of the integrated Router 1×3 under extended simulation conditions.

---

## Simulation Summary

| Module | Simulation Purpose | Status |
|----------|-------------------|--------|
| FIFO | Verify storage, read/write operations, status flags, and pointer updates | ✅ Verified through waveform analysis |
| FSM | Verify state transitions and control signal generation | ✅ Verified through waveform analysis |
| Register | Verify packet buffering, parity generation, and error detection | ✅ Verified through waveform analysis |
| Synchronizer | Verify destination decoding, FIFO selection, and soft reset generation | ✅ Verified through waveform analysis |
| Top Module (Normal Case) | Verify integrated packet routing through all modules | ✅ Verified through waveform analysis |
| Top Module (Corner Cases) | Verify router operation under multiple packet transfer scenarios | ✅ Verified through waveform analysis |
# Author

**VELMURUGAN R**
---
# Conclusion

The **Router 1×3** project demonstrates the implementation of a packet-based routing architecture using a modular Register Transfer Level (RTL) design methodology in **Verilog HDL**. The design successfully routes incoming packets from a single input interface to one of three independent output ports based on the destination address contained within the packet header.

The architecture is composed of four major functional modules—**FSM**, **Register**, **Synchronizer**, and **FIFO**—each performing a dedicated role in packet reception, routing, buffering, and error detection. The separation of control logic from the datapath results in a clean, maintainable, and reusable hardware architecture that simplifies both development and debugging.

Simulation was carried out using **ModelSim**, where the behavior of every individual module, as well as the complete integrated router, was analyzed through simulation waveforms. The observed waveforms verified correct packet reception, destination decoding, FIFO selection, packet buffering, parity generation, parity comparison, FIFO control, and overall packet routing behavior under both normal operating conditions and additional routing scenarios.

RTL synthesis was completed using **Intel Quartus Prime**, and the generated RTL Viewer confirmed the hierarchical organization of the design and the correct interconnection between all functional modules. The synthesized structure closely matches the intended RTL architecture, demonstrating that the design is fully synthesizable and organized using a modular hardware design approach.

Overall, this project provided practical experience in several important aspects of digital system design, including:

- Modular RTL Design
- Finite State Machine (FSM) Design
- FIFO-Based Memory Architecture
- Packet-Based Data Communication
- Parity Generation and Error Detection
- Control Path and Data Path Design
- Simulation Waveform Analysis
- RTL Synthesis and Hardware Hierarchy Visualization

The Router 1×3 serves as a comprehensive digital design project that integrates multiple fundamental hardware concepts into a single system. It represents a strong foundation for understanding packet routing architectures and demonstrates practical RTL design techniques commonly applied in FPGA and digital hardware development.
