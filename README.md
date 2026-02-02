# Low-Power 8-Tap FIR Filter

This project implements an optimized 8-tap Finite Impulse Response (FIR) filter in Verilog. The design focuses on reducing power consumption through architectural choices and specific RTL-level low-power techniques.

## Power Optimization Results

The implementation achieved a **63% reduction in power consumption** compared to a standard baseline filter. This was achieved through:

* **Optimized Pipeline Architecture**: Strategic placement of registers to balance throughput and switching activity.
* **Clock Gating & Enable Logic**: Use of `en` and `y_mult` signals to prevent unnecessary toggling in the shifter and multiplier stages.
* **FSM Optimizations**: A simplified control unit to minimize logic transitions.
* **Validation**: Efficiency was verified via gate-level switching activity analysis during the synthesis flow.

---

## Hardware Architecture

The design is split into a clear **Datapath (DP)** and **Control Unit (FSM)** structure.

### 1. Datapath (`dp.v`)

* **Shifter Stage**: An 8-level shift register chain (`x_shift`) that moves input data only when the `en` signal is active.
* **Multiplier Array**: Eight signed multipliers that calculate the product of the shifted data and the filter coefficients (`b0` through `b7`).
* **Accumulator**: A combinatorial tree that sums the truncated (floored) 8-bit results from the multipliers to produce the final output `y`.

### 2. Control Unit (`fsm.v`)

A streamlined synchronous controller that manages the flow of data.

* **Ready/Valid Handshaking**: Provides status signals to indicate when the system is operational and when the output data is stable.
* **Signal Gating**: Controls the `y_mult` signal to ensure multipliers only operate when valid data is present in the pipeline.

### 3. Top Level (`top.v`)

Integrates the FSM and Datapath, mapping the external interface (clock, reset, enable, and data) to the internal optimized logic.

---

## Signal Definitions

| Signal | Type | Description |
| --- | --- | --- |
| `clk` | Input | System Clock |
| `rst` | Input | Asynchronous Reset |
| `en` | Input | System Enable (Gates the shifter and multipliers) |
| `x [7:0]` | Input | 8-bit Signed Input Data |
| `b0 - b7` | Input | 8-bit Filter Coefficients |
| `y [7:0]` | Output | 8-bit Signed Filtered Output |
| `ready` | Output | Indicates the filter is ready for input |
| `valid` | Output | Indicates valid data is available at output `y` |

## Technical Implementation Details

* **Bit-Width**: 8-bit signed inputs and coefficients.
* **Truncation**: Multiplier outputs are 16-bit, with the result floored to 8 bits (`[14:7]`) before accumulation to maintain resource efficiency.
* **Switching Activity**: The code includes commented-out sections (like `x_clr` and `y_clr`) to show the evolution toward a design that minimizes unnecessary signal resets, further reducing the power profile.

---
