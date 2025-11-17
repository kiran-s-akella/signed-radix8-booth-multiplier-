# Signed Radix-8 Booth Multiplier using 5:3 Compressor (8-bit)

## 1. Introduction
This repository implements a signed Radix-8 Booth-encoded multiplier for 8-bit operands encoding three bits at a time. The design uses 5:3 compressors to speed up the partial-product accumulation stage reducing the critical path. The project includes Verilog sources, a testbench, simulation scripts, and a results folder for RTL schematics and performance comparison.

## 2. Theory and Architecture

### 2.1 5:3 Compressor Module
A 5:3 compressor reduces five input bits and an input carry into three outputs (sum, carry, and higher carry) in one logic level. It essentially performs multi-operand reduction similar to Wallace or Dadda trees but with 5:3 blocks to balance fan-in and delay.

Key properties:
- Inputs: A, B, C, D, E (and optional carry-in)
- Outputs: S (sum), C0 (carry0), C1 (carry1) — position-weighted outputs
<img width="921" height="262" alt="image" src="https://github.com/user-attachments/assets/6ed1b92d-328d-437b-bdc1-b4dc81d96874" />


### 2.2 8-bit Structural Modelling
Top-level approach:
1. **Booth encoder** (Radix-8) groups multiplier bits in overlapping triplets to produce signed-digit partial product multiples: `-4, -3, -2, -1, 0, +1, +2, +3, +4` times multiplicand.
2. **Partial product generator** uses recoder outputs to select/negate shifted multiplicand partial products.
3. **Reduction tree** built from 5:3 compressors (and final fast adder) to compress partial products to two rows.
4. **Final adder** (e.g., ripple-carry / CLA) to produce the final signed product.

<img width="953" height="516" alt="image" src="https://github.com/user-attachments/assets/9d12c1c0-c73d-4076-9c66-b77f756d6534" />


## 3. HDL Implementation Code
- `src/compressor_5to3.v` — 5:3 compressor module
- `src/booth_encoder.v` — Radix-8 encoder
- `src/partial_product_gen.v` — partial product generation (sign/negation/shift)
- `src/radix8_booth_multiplier_8bit.v` — structural top (instantiates compressors & final adder)

> Paste your full Verilog for the Radix-8 Booth encoded multiplier in `src/radix8_booth_multiplier_8bit.v`.

### 3.1 Radix-8 Booth encoded multiplier design
(Place your Verilog file here; an example structural wrapper is included in `/src`.)

### 3.2 Testbench implementation
Test vectors and self-checking testbench provided in `tb/tb_radix8_booth_multiplier.v`. It tests a variety of signed operand combinations, edge-cases, and random vectors.

## 4. Simulation and Results

### 4.1 RTL Schematic
Use RTL Analysis (run linter) flow to generate the RTL schematic. Place figures in `docs/rtl_schematic.png`.

### 4.2 Functional verification
- Run the supplied testbench using Verilog or Gtkwave.
- Verify correctness against the structural model (e.g., reference behavioral multiplication).

### 4.3 Performance comparison
Create a table comparing:
- Latency (logic levels / ns)
- Area (LUTs / gate equivalents / synthesized cells)
- Max frequency (MHz)
- Power (static/dynamic) — if available

A CSV template is included at `docs/results_table.csv`.

## 5. Conclusion
Summarize observed improvements (e.g., reduction in reduction-tree depth, lower latency than 3:2-only designs) and trade-offs (area increase vs speed).

## 6. References
- [1] B. S., P. M., and V. M. B., “Design and Implementation of Signed Radix-8 Booth Encoded Multiplier Using 5:3 Compressor”


---

## Quick start (simulation)
### Vivado Verilog + GTKWave
```bash
# from repo root
cd sim
./run_iverilog.sh
# opens dump.vcd in gtkwave (script assumes gtkwave installed)

