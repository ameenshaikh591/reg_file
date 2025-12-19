module reg_file (
    parameter int REG_WIDTH = 32,
    parameter int ADDR_WIDTH = 8
) (
    input logic i_clk,

    input logic [ADDR_WIDTH - 1 :0] i_reg_a_addr_r,
    input logic [ADDR_WIDTH - 1 : 0] i_reg_b_addr_r,

    input logic [ADDR_WIDTH - 1 : 0] i_reg_addr_w,
    input logic [REG_WIDTH - 1 : 0] i_reg_val_w,
    input logic i_write_en,

    output logic [REG_WIDTH - 1 : 0] o_reg_a_val_r,
    output logic [REG_WIDTH - 1 : 0] o_reg_b_val_r
);


    logic [REG_WIDTH - 1 : 0] registers []


endmodule