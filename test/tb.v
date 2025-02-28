`default_nettype none
`timescale 1ns / 1ps

/* Testbench for Priority Encoder Module */
module tb ();

  // Dump the signals to a VCD file for waveform analysis.
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // Testbench signals
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;    // A[7:0] - Upper 8 bits of input
  reg [7:0] uio_in;   // B[7:0] - Lower 8 bits of input
  wire [7:0] uo_out;  // Encoded output C[7:0]
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // Instantiate the Priority Encoder Module
  tt_um_digitallogiclab2 user_project (

`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif

      .ui_in  (ui_in),    
      .uo_out (uo_out),   
      .uio_in (uio_in),   
      .uio_out(uio_out),  
      .uio_oe (uio_oe),   
      .ena    (ena),      
      .clk    (clk),      
      .rst_n  (rst_n)     
  );

  // Test Procedure
  initial begin
    // Initialize signals
    clk = 0;
    rst_n = 1;
    ena = 1;
    
    // Test Case 1: In[15:0] = 0010 1010 1111 0001 
    // Expected C[7:0] = 0000 1101 (13 in decimal) because the first set bit is at bit 13.
    ui_in  = 8'b00101010; 
    uio_in = 8'b11110001; 
    #10;
    $display("Test 1: In = %b%b, C = %b", ui_in, uio_in, uo_out);
    if (uo_out !== 8'b00001101) $display("Test 1 Failed!");

    // Test Case 2: In[15:0] = 0000 0000 0000 0001 (Expected C[7:0] = 0000 0000)
    ui_in  = 8'b00000000; 
    uio_in = 8'b00000001; 
    #10;
    $display("Test 2: In = %b%b, C = %b", ui_in, uio_in, uo_out);
    if (uo_out !== 8'b00000000) $display("Test 2 Failed!");

    // Test Case 3: In[15:0] = 0000 0000 0000 0000 (Expected C[7:0] = 1111 0000)
    ui_in  = 8'b00000000; 
    uio_in = 8'b00000000; 
    #10;
    $display("Test 3: In = %b%b, C = %b", ui_in, uio_in, uo_out);
    if (uo_out !== 8'b11110000) $display("Test 3 Failed!");

    // Extra Test Case: In[15:0] = 1100 0000 0000 0000 (Expected C[7:0] = 0000 1111, 15 in decimal)
    ui_in  = 8'b11000000; 
    uio_in = 8'b00000000; 
    #10;
    $display("Test 4: In = %b%b, C = %b", ui_in, uio_in, uo_out);
    if (uo_out !== 8'b00001111) $display("Test 4 Failed!");

    // All tests completed
    $display("All tests completed.");
    $finish;
  end

  // Generate a clock signal (not required in this design but good practice)
  always #5 clk = ~clk;

endmodule
