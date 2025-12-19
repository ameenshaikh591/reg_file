module reg_file (
    parameter REG_WIDTH = 32,
    parameter REG_ADDR_LENGTH = 8
) (
    input logic i_clk,

    input logic [REG_ADDR_LENGTH - 1 :0] i_reg_a_addr_r,
    input logic [REG_ADDR_LENGTH - 1 : 0] i_reg_b_addr_r,

    input logic [REG_ADDR_LENGTH - 1 : 0] i_reg_addr_w,
    input logic [REG_WIDTH - 1 : 0] i_reg_val_w,
    input logic i_write_en,

    output logic [REG_WIDTH - 1 : 0] o_reg_a_r,
    output logic [REG_WIDTH - 1 : 0] o_reg_b_r
);


endmodule