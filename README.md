# Router 1×3 using Verilog HDL

> Replace the **Architecture** section with your uploaded architecture
> diagram.

## 1. Project Overview

The Router 1×3 is a packet-based digital router implemented in Verilog
HDL. It accepts packets from a single input interface and forwards each
packet to one of three output ports according to the destination address
encoded in the header.

The design is divided into four major functional blocks: - FSM
Controller - Register Block - Synchronizer - Three Independent FIFOs

Major features: - Three output ports - Packet buffering - Parity
generation and checking - FIFO full handling - Soft reset support -
Error detection - Back-to-back packet handling

------------------------------------------------------------------------

## 2. Packet Format

     ---------------------------------------------------------
    | Header | Payload (1–63 Bytes) | Parity |
     ---------------------------------------------------------

    Header

    7 6 | 5 4 3 2 1 0
    ----+--------------
    DA  | Payload Length

    DA:
    00 -> FIFO0
    01 -> FIFO1
    10 -> FIFO2
    11 -> Invalid

    Parity = Header XOR all payload bytes

The header is transmitted first while `pkt_valid` is HIGH. Payload bytes
follow immediately. After the last payload byte, `pkt_valid` becomes LOW
and the final byte is interpreted as the parity byte.

------------------------------------------------------------------------

## 3. Architecture

Insert the uploaded architecture block diagram here.

The architecture contains one controller (FSM), one Register block, one
Synchronizer, and three independent FIFOs. The FSM supervises packet
reception, the Register stores and verifies packet information, the
Synchronizer selects the correct destination FIFO, and the FIFOs buffer
outgoing packets.

------------------------------------------------------------------------

## 4. Top Module

The top module instantiates every submodule and connects all data and
control paths.

Inputs: - clock - resetn - pkt_valid - data_in\[7:0\] - read_enb_0 -
read_enb_1 - read_enb_2

Outputs: - data_out_0 - data_out_1 - data_out_2 - vld_out_0 -
vld_out_1 - vld_out_2 - busy - err

------------------------------------------------------------------------

## 5. FSM Module

The FSM controls the complete packet reception process.

### DETECT_ADDRESS

Waits for a new packet, captures the destination address from the
header, checks the destination FIFO status, and selects the next
operating state.

### LOAD_FIRST_DATA

Loads the header into the Register block, initializes packet reception,
and writes the first byte into the selected FIFO.

### LOAD_DATA

Accepts payload bytes one by one and writes them into the destination
FIFO while monitoring FIFO status.

### FIFO_FULL_STATE

Pauses packet loading whenever the selected FIFO becomes full. Incoming
data is temporarily held until storage space becomes available.

### LOAD_AFTER_FULL

Resumes payload transfer once the FIFO is no longer full and continues
packet reception from the stored byte.

### LOAD_PARITY

Accepts the transmitted parity byte after the payload is complete.

### CHECK_PARITY_ERROR

Compares internally generated parity with the received parity byte and
asserts `err` if a mismatch is detected.

------------------------------------------------------------------------

## 6. Register Module

The Register block is responsible for packet formatting and parity
generation.

Functions: - Captures header, payload, and parity bytes. - Separates
header from payload. - Stores the current data byte. - Generates running
parity. - Stores received parity. - Detects parity mismatch. - Generates
`parity_done` and `low_pkt_valid`.

------------------------------------------------------------------------

## 7. Synchronizer Module

The Synchronizer interfaces the controller with the three FIFOs.

Functions: - Decodes destination address. - Generates one-hot FIFO write
enable. - Monitors FIFO full and empty signals. - Produces `vld_out_0`,
`vld_out_1`, and `vld_out_2`. - Generates soft reset signals for stalled
FIFOs.

Only one FIFO is enabled for writing during a packet transfer.

------------------------------------------------------------------------

## 8. FIFO Module

Each destination has an independent FIFO.

Responsibilities: - Stores packet bytes. - Maintains read/write
pointers. - Indicates full and empty status. - Supports simultaneous
write and read on different clock cycles. - Clears stored data during
soft reset.

Signals: - write_enb - read_enb - full - empty - data_out

------------------------------------------------------------------------

## 9. Simulation

Verified cases: - Normal packet transfer - FIFO0 routing - FIFO1
routing - FIFO2 routing - Back-to-back packets - FIFO full handling -
FIFO empty handling - Parity error detection - Soft reset

Waveforms confirm correct FSM transitions, FIFO selection, packet
buffering, parity checking, and output generation.

------------------------------------------------------------------------

## 10. Conclusion

The Router 1×3 successfully routes packets to one of three output FIFOs
based on the destination address. The modular architecture simplifies
verification and maintenance while ensuring reliable packet buffering,
parity verification, FIFO management, and error reporting.
