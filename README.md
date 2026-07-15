# Router-1x3


## Verilog RTL Design & Functional Verification

![Verilog](https://img.shields.io/badge/HDL-Verilog-blue)
![Simulation](https://img.shields.io/badge/Simulation-ModelSim-success)
![Status](https://img.shields.io/badge/Verification-Completed-brightgreen)

```{=html}
</p>
```

------------------------------------------------------------------------

## Overview

**Router-1x3** is a modular Verilog RTL implementation of a **1×3 packet
router**. The router forwards packets to one of three output FIFOs
according to the destination address encoded in the packet header.

The project focuses on **RTL Design** and **Functional Verification**
using directed testbenches and waveform analysis.

------------------------------------------------------------------------

## Features

-   Modular RTL Architecture
-   Three Independent Output FIFOs
-   FSM-Based Packet Control
-   Header Decoding
-   Packet Routing
-   Internal Parity Generation
-   Parity Error Detection
-   FIFO Full Handling
-   WAIT_TILL_EMPTY State
-   LOAD_AFTER_FULL State
-   Soft Reset Mechanism
-   Timeout Handling

------------------------------------------------------------------------

## Architecture

> Replace with the final architecture diagram.

![Architecture](images/architecture.png)

------------------------------------------------------------------------

## Packet Format

  Bits      Description
  --------- ---------------------
  \[7:2\]   Payload Length
  \[1:0\]   Destination Address

  Destination   FIFO
  ------------- -------
  00            FIFO0
  01            FIFO1
  10            FIFO2

------------------------------------------------------------------------

## RTL Modules

  Module         Responsibility
  -------------- -----------------------------------
  FSM            Packet flow control
  Register       Header, parity and error handling
  Synchronizer   FIFO selection and soft reset
  FIFO           Packet buffering
  Top            RTL integration

------------------------------------------------------------------------

## Verification

### Module-Level

-   FIFO Testbench
-   FSM Testbench
-   Register Testbench
-   Synchronizer Testbench

### Top-Level Functional

-   Packet Routing
-   FIFO Selection
-   Payload Transfer
-   Correct Parity

### Corner Cases

-   FIFO Full
-   WAIT_TILL_EMPTY
-   LOAD_AFTER_FULL
-   Reset During Packet
-   Reset During FIFO Full
-   Soft Reset Timeout
-   FIFO Wrap-Around
-   Simultaneous Read / Write
-   Read While Writing
-   Back-to-Back Packets
-   Illegal `pkt_valid`

------------------------------------------------------------------------

## Verification Summary

  Test                         Status
  --------------------------- --------
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
  Timeout                        ✅
  Simultaneous Read / Write      ✅
  FIFO Wrap-Around               ✅
  Read While Writing             ✅
  Protocol Robustness            ✅

------------------------------------------------------------------------

## Waveforms

ModelSim waveforms were captured for: - Normal Packet - FIFO Full -
WAIT_TILL_EMPTY - LOAD_AFTER_FULL - Parity Error - Timeout - Reset
During Packet - FIFO Wrap-Around - Simultaneous Read / Write

------------------------------------------------------------------------

## Tools

  Tool                 Usage
  -------------------- --------------------------------
  Verilog HDL          RTL Design
  ModelSim             Simulation & Waveform Analysis
  Visual Studio Code   Code Editing

------------------------------------------------------------------------

## Author

**VELMURUGAN R**
