/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_digitallogiclab2 (
    input  wire [7:0] ui_in,    // Dedicated inputs (A)
    output wire [7:0] uo_out,   // Output: priority encoded result (C)
    input  wire [7:0] uio_in,   // IOs: Input path (B)
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // Concatenate ui_in and uio_in to form the 16-bit input.
  // ui_in corresponds to the upper 8 bits (A[7:0]) and uio_in to the lower 8 bits (B[7:0]).
  wire [15:0] in = {ui_in, uio_in};

  reg [7:0] addr;
  integer i;
  reg found;

  // Combinational block to perform priority encoding.
  always @(*) begin
    // default: no bit found
    addr  = 8'd0;
    found = 1'b0;
   
    // Special case: if all bits are zero, output 1111 0000.
    if (in == 16'b0) begin
      addr = 8'b1111_0000;
    end else begin
      // Iterate from the most-significant bit (bit 15) to the least-significant (bit 0)
      for (i = 15; i >= 0; i = i - 1) begin
        // Only update addr if we haven't found a 1 yet.
        if (!found && in[i]) begin
          addr  = i[7:0]; // Assign the index (i) as the address.
          found = 1'b1;   // Set found flag to avoid updating addr further.
        end
      end
    end
  end

  // Drive the dedicated output with the encoded address.
  assign uo_out  = addr;
  // Unused IO outputs set to 0.
  assign uio_out = 8'd0;
  assign uio_oe  = 8'd0;

  // List all unused inputs to prevent warnings.
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
