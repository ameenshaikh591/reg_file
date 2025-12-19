module reg_file (
    parameter int REG_WIDTH = 32,
    parameter int ADDR_WIDTH = 4
) (
    input logic i_clk,

    input logic [ADDR_WIDTH - 1 : 0] i_reg_a_addr_r,
    input logic [ADDR_WIDTH - 1 : 0] i_reg_b_addr_r,

    input logic [ADDR_WIDTH - 1 : 0] i_reg_addr_w,
    input logic [REG_WIDTH - 1 : 0] i_reg_val_w,
    input logic i_write_en,

    output logic [REG_WIDTH - 1 : 0] o_reg_a_val_r,
    output logic [REG_WIDTH - 1 : 0] o_reg_b_val_r
);
    localparam int NUM_REGS = 1 << ADDR_WIDTH;

    logic [REG_WIDTH - 1 : 0] registers [NUM_REGS - 1 : 0];

    always_comb begin
        o_reg_a_val_r = registers[i_reg_a_addr_r];
        o_reg_b_val_r = registers[i_reg_b_addr_r];
    end

    always_ff @(posedge i_clk) begin
        if (i_write_en) begin
            registers[i_reg_addr_w] <= i_reg_val_w;
        end
    end

endmodule