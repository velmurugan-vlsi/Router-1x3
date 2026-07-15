# Router 1×3 using Verilog HDL

## Overview

This project implements a 1×3 packet router in Verilog HDL. It routes
packets from a single input interface to one of three output FIFOs based
on the destination address in the packet header.

## Architecture

Insert the RTL architecture image here.

Major modules: - FSM - Register - Synchronizer - FIFO_0 - FIFO_1 -
FIFO_2

## Packet Format

  Byte      Description
  --------- --------------------------------------
  Header    Destination Address + Payload Length
  Payload   User Data
  Parity    XOR(Header + Payload)

Header: - Bits\[7:6\] : Destination Address - Bits\[5:0\] : Payload
Length

DA: - 00 -\> FIFO0 - 01 -\> FIFO1 - 10 -\> FIFO2

## Router FSM

Controls packet reception, loading, FIFO-full handling, parity
processing and state transitions.

## Router Register

Stores header and payload bytes, generates parity, compares received
parity and asserts error.

## Synchronizer

Decodes destination address, selects FIFO, generates write enables,
valid outputs and soft resets.

## FIFOs

Three independent FIFOs buffer packets for each output channel with
full/empty detection.

## Data Flow

Input -\> Register -\> FSM -\> Synchronizer -\> FIFO0/FIFO1/FIFO2 -\>
Outputs
