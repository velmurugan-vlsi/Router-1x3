# Router-1x3

```{=html}
<p align="center">
```
# Router-1x3

### Verilog RTL Design & Functional Verification

![Verilog](https://img.shields.io/badge/HDL-Verilog-blue)
![Simulation](https://img.shields.io/badge/Simulation-ModelSim-success)
![Editor](https://img.shields.io/badge/Editor-VS_Code-007ACC)
![Status](https://img.shields.io/badge/Verification-Completed-brightgreen)

```{=html}
</p>
```

------------------------------------------------------------------------

## Table of Contents

-   Project Overview
-   Features
-   Architecture
-   Packet Format
-   Router Operation
-   Module Description
-   Project Structure
-   Verification Methodology
-   Verification Coverage
-   Waveform Gallery
-   Tools Used
-   Simulation
-   Author

------------------------------------------------------------------------

# Project Overview

**Router-1x3** is a modular Verilog RTL implementation of a **1×3 packet
router**.

The router receives packets from a single input interface and forwards
them to one of three output FIFOs according to the destination address
encoded in the packet header.

The design was verified completely through **module-level
verification**, **top-level functional verification**, **corner-case
verification**, and **ModelSim waveform analysis**.

> **Scope**
>
> -   RTL Design
> -   Functional Verification
> -   Waveform Validation
>

------------------------------------------------------------------------

# Features

-   Modular RTL Architecture
-   1 Input → 3 Output Router
-   Three Independent Output FIFOs
-   FSM Based Control Logic
-   Header Decoding
-   Packet Routing
-   Internal Parity Generation
-   Parity Error Detection
-   FIFO Full Handling
-   WAIT_TILL_EMPTY Handling
-   LOAD_AFTER_FULL Recovery
-   Soft Reset Support
-   Timeout Handling
-   Directed Verification Environment

------------------------------------------------------------------------

# Architecture

> Insert the final architecture diagram here.

``` text
images/architecture.png
```

------------------------------------------------------------------------

# Packet Format

  Bits      Description
  --------- ---------------------
  \[7:2\]   Payload Length
  \[1:0\]   Destination Address

Destination Address

  Address   Output FIFO
  --------- -------------
  00        FIFO0
  01        FIFO1
  10        FIFO2

Packet Structure

Header → Payload → Parity

------------------------------------------------------------------------

# Router Operation

1.  Receive Header
2.  Decode Destination Address
3.  Select Target FIFO
4.  Store Payload
5.  Generate Internal Parity
6.  Receive Packet Parity
7.  Compare Parity
8.  Assert Error (if required)
9.  Output Packet through selected FIFO

------------------------------------------------------------------------

# RTL Modules

## FSM

Responsible for overall packet flow.

Functions

-   Address Detection
-   State Control
-   FIFO Full Handling
-   WAIT_TILL_EMPTY
-   LOAD_AFTER_FULL
-   Parity Processing

States

-   DECODE_ADDRESS
-   LOAD_FIRST_DATA
-   LOAD_DATA
-   FIFO_FULL_STATE
-   LOAD_AFTER_FULL
-   LOAD_PARITY
-   CHECK_PARITY_ERROR
-   WAIT_TILL_EMPTY

------------------------------------------------------------------------

## Register

Responsible for packet processing.

Functions

-   Header Storage
-   Payload Forwarding
-   Internal Parity Generation
-   Packet Parity Storage
-   Error Detection
-   low_pkt_valid Generation
-   parity_done Generation

------------------------------------------------------------------------

## Synchronizer

Responsible for communication between FSM and FIFOs.

Functions

-   FIFO Selection
-   Write Enable Generation
-   Valid Output Generation
-   Soft Reset Generation
-   FIFO Full Detection

------------------------------------------------------------------------

## FIFO

Three independent FIFOs.

Configuration

-   Depth : 16
-   Width : 9 bits

Stored Data

-   8-bit Data
-   1-bit Header Flag

Functions

-   Packet Buffering
-   Read
-   Write
-   Full Detection
-   Empty Detection

------------------------------------------------------------------------

## Top Module

Integrates

-   FSM
-   Register
-   Synchronizer
-   FIFO0
-   FIFO1
-   FIFO2

------------------------------------------------------------------------

# Project Structure

``` text
Router-1x3/
│
├── README.md
├── LICENSE
├── .gitignore
│
├── rtl/
│   ├── fifo.v
│   ├── fsm.v
│   ├── register.v
│   ├── syncronizer.v
│   └── top.v
│
├── testbench/
│   ├── fifo_tb.v
│   ├── fsm_tb.v
│   ├── register_tb.v
│   ├── router_sync_tb.v
│   ├── router_tb.v
│   └── router_corner_tb.v
│
├── images/
├── waveforms/
└── docs/
```

------------------------------------------------------------------------

# Verification Methodology

## Module-Level Verification

Each RTL module was verified independently before top-level integration.

  Module         Testbench
  -------------- ------------------
  FIFO           fifo_tb.v
  FSM            fsm_tb.v
  Register       register_tb.v
  Synchronizer   router_sync_tb.v

## Top-Level Functional Verification

The functional testbench verifies:

-   FIFO0 Routing
-   FIFO1 Routing
-   FIFO2 Routing
-   Header Processing
-   Payload Transfer
-   Correct Parity
-   Packet Read Operation

## Corner-Case Verification

The corner-case testbench verifies:

-   FIFO Full
-   WAIT_TILL_EMPTY
-   LOAD_AFTER_FULL
-   Reset During Packet
-   Reset During FIFO Full
-   Timeout (Soft Reset)
-   FIFO Wrap-Around
-   Simultaneous Read / Write
-   Read While Writing
-   Back-to-Back Packets
-   Illegal pkt_valid Handling

------------------------------------------------------------------------

# Verification Coverage

  Category                     Status
  --------------------------- --------
  Normal Packet                  ✅
  FIFO0 Routing                  ✅
  FIFO1 Routing                  ✅
  FIFO2 Routing                  ✅
  Correct Parity                 ✅
  Parity Error                   ✅
  FIFO Full                      ✅
  WAIT_TILL_EMPTY                ✅
  LOAD_AFTER_FULL                ✅
  Reset During Packet            ✅
  Reset During FIFO Full         ✅
  Soft Reset                     ✅
  Timeout                        ✅
  Simultaneous Read / Write      ✅
  FIFO Wrap Around               ✅
  Read While Writing             ✅
  Protocol Robustness            ✅

------------------------------------------------------------------------

# Waveform Gallery

Add waveform screenshots inside the **waveforms/** folder.

Recommended screenshots:

-   Normal Packet
-   FIFO Full
-   WAIT_TILL_EMPTY
-   LOAD_AFTER_FULL
-   Parity Error
-   Timeout
-   Reset During Packet
-   FIFO Wrap Around
-   Simultaneous Read/Write

------------------------------------------------------------------------

# Tools Used

  Tool                 Purpose
  -------------------- --------------------------------
  Verilog HDL          RTL Design
  ModelSim             Simulation & Waveform Analysis
  Visual Studio Code   Source Code Development

------------------------------------------------------------------------

# Simulation

Compile RTL

``` tcl
vlog rtl/fifo.v
vlog rtl/register.v
vlog rtl/syncronizer.v
vlog rtl/fsm.v
vlog rtl/top.v
```

Compile Testbench

``` tcl
vlog testbench/router_tb.v
```

Run

``` tcl
vsim router1x3_tb
run -all
```

------------------------------------------------------------------------

# Author

**VELMURUGAN R**

Aspiring Design Verification Engineer

------------------------------------------------------------------------

