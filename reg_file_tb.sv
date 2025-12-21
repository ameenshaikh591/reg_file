`timescale 1ns/1ns
`define CLOCK_HALF_PERIOD 5ns

module reg_file_tb;

  localparam int ADDR_WIDTH = 3;
  localparam int REG_WIDTH  = 32;
  localparam int NUM_REGS   = 1 << ADDR_WIDTH;

  // Port signals
  logic i_clk;
  logic [ADDR_WIDTH-1:0] i_reg_a_addr_r, i_reg_b_addr_r;
  logic [ADDR_WIDTH-1:0] i_reg_addr_w;
  logic [REG_WIDTH-1:0]  i_reg_val_w;
  logic                  i_write_en;
  logic [REG_WIDTH-1:0]  o_reg_a_val_r, o_reg_b_val_r;
  logic [REG_WIDTH-1:0]  reg_val;

  // DUT
  reg_file #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .REG_WIDTH(REG_WIDTH)
  ) dut (
    .i_clk(i_clk),
    .i_reg_a_addr_r(i_reg_a_addr_r),
    .i_reg_b_addr_r(i_reg_b_addr_r),
    .i_reg_addr_w(i_reg_addr_w),
    .i_reg_val_w(i_reg_val_w),
    .i_write_en(i_write_en),
    .o_reg_a_val_r(o_reg_a_val_r),
    .o_reg_b_val_r(o_reg_b_val_r)
  );

  // Clock
  initial begin
    i_clk = 0;
    forever begin
      #`CLOCK_HALF_PERIOD;
      i_clk = ~i_clk;
    end
  end

  // Clocking block: ONLY the synchronous write-side
  clocking cb @(posedge i_clk);
    default input #1ns output #1ns;
    output i_reg_addr_w, i_reg_val_w, i_write_en;
  endclocking

  // -------------------------
  // Read tasks (combinational)
  // -------------------------
  task automatic read_reg_a(
      input  int reg_num,
      output logic [REG_WIDTH-1:0] val
  );
    i_reg_a_addr_r = reg_num[ADDR_WIDTH-1:0];
    #1; // allow combinational settle
    val = o_reg_a_val_r;
  endtask

  task automatic read_reg_b(
      input  int reg_num,
      output logic [REG_WIDTH-1:0] val
  );
    i_reg_b_addr_r = reg_num[ADDR_WIDTH-1:0];
    #1;
    val = o_reg_b_val_r;
  endtask

  task automatic read_reg_a_b(
    input  int reg_a_num,
    input  int reg_b_num,
    output logic [REG_WIDTH-1:0] a_val,
    output logic [REG_WIDTH-1:0] b_val
  );
    i_reg_a_addr_r = reg_a_num[ADDR_WIDTH-1:0];
    i_reg_b_addr_r = reg_b_num[ADDR_WIDTH-1:0];
    #1;
    a_val = o_reg_a_val_r;
    b_val = o_reg_b_val_r;
  endtask

  task automatic write_reg(
    input int reg_num,
    input logic [REG_WIDTH-1:0] val
  );
    cb.i_reg_addr_w <= reg_num[ADDR_WIDTH-1:0];
    cb.i_reg_val_w  <= val;
    cb.i_write_en   <= 1'b1;
    @cb;                 // write happens on this edge
    cb.i_write_en   <= 1'b0;
  endtask

  task automatic verify_reg_val(
    input int reg_num,
    input logic [REG_WIDTH-1:0] expected_val,
    input logic [REG_WIDTH-1:0] actual_val
  );
    if (actual_val !== expected_val) begin
      $error("[ERROR]: expected=%0h, actual=%0h, register %0d", expected_val, actual_val, reg_num);
      $fatal;
    end
  endtask

  task automatic test_write_read_all_regs();
    logic [REG_WIDTH-1:0] reg_a_val;
    logic [REG_WIDTH-1:0] reg_b_val;

    for (int i = 0; i < NUM_REGS; i++) begin
      write_reg(i, REG_WIDTH'(i));
    end

    for (int i = 0; i < NUM_REGS; i += 2) begin
      read_reg_a_b(i, i+1, reg_a_val, reg_b_val);
      verify_reg_val(i,   REG_WIDTH'(i),   reg_a_val);
      verify_reg_val(i+1, REG_WIDTH'(i+1), reg_b_val);
    end
  endtask

  task automatic initialize_inputs();
    i_reg_a_addr_r = '0;
    i_reg_b_addr_r = '0;

    cb.i_write_en <= 1'b0;
    cb.i_reg_addr_w <= '0;
    cb.i_reg_val_w  <= '0;

    @cb;
  endtask

  initial begin
    $dumpfile("reg_file.vcd");
    $dumpvars(0, reg_file_tb);

    initialize_inputs();


    // Tests
    test_write_read_all_regs();
    
    $display("ALL TESTS PASSED");

    $finish;
  end

endmodule



