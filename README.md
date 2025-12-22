**Parameterized Register File**

**High Level Description**

This module implements a parameterized register file with configurable register width and address width. 
It provides two independent read ports and a single write port.

**Features**
- Parameterized register width (REG_WIDTH)
- Parameterized address width (ADDR_WIDTH)
- Two combinational read ports
- One synchronous write port
- Read-after-write bypass

**Interface**

| Signal | Direction | Width | Description |
|------|----------|------|------------|
| `i_clk` | Input | 1 | Clock input (rising edge) |
| `i_reg_a_addr_r` | Input | `ADDR_WIDTH` | Read address for port A |
| `i_reg_b_addr_r` | Input | `ADDR_WIDTH` | Read address for port B |
| `i_reg_addr_w` | Input | `ADDR_WIDTH` | Write address |
| `i_reg_val_w` | Input | `REG_WIDTH` | Write data |
| `i_write_en` | Input | 1 | Write enable |
| `o_reg_a_val_r` | Output | `REG_WIDTH` | Read data for port A |
| `o_reg_b_val_r` | Output | `REG_WIDTH` | Read data for port B |

**Timing & Semantics**

- Writes occur synchronously on the rising/positive edge of `i_clk` when `i_write_en` is asserted.
- Reads are combinational and continuously reflect the state of the selected register(s).
- If a read address matches the write address while `i_write_en` is asserted, the read output reflects the write data, even before the register updates.

**Verification**

The module is verified using a SystemVerilog testbench that:
- Writes to all registers and verifies the stored values
- Checks dual-port read correctness
- Verifies same cycle read-after-write behavior

**Diagram**











