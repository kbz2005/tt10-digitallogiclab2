`default_nettype none
`timescale 1ns / 1ps

/* Testbench for XOR Encryption Module */
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
  reg [7:0] ui_in;    // Message input
  reg [7:0] uio_in;   // Key input
  wire [7:0] uo_out;  // Encrypted output
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // Instantiate the XOR Encryption Module
  tt_um_xor_encrypter user_project (

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
    
    // Test Case 1: Encrypt and Decrypt "A" (Binary: 01000001) with Key 01010101
    ui_in  = 8'b01000001; // Message = 'A'
    uio_in = 8'b01010101; // Key
    #10;
    $display("Test 1 - Encrypt: Message = %b, Key = %b, Encrypted = %b", ui_in, uio_in, uo_out);
    if (uo_out !== (ui_in ^ uio_in)) $display("Test 1 Failed!");

    // Decrypt
    ui_in  = uo_out; // Ciphertext
    #10;
    $display("Test 1 - Decrypt: Ciphertext = %b, Key = %b, Decrypted = %b", ui_in, uio_in, uo_out);
    if (uo_out !== 8'b01000001) $display("Test 1 Failed!");

    // Test Case 2: Encrypt and Decrypt 'X' (Binary: 01011000) with Key 10101010
    ui_in  = 8'b01011000; // Message = 'X'
    uio_in = 8'b10101010; // Key
    #10;
    $display("Test 2 - Encrypt: Message = %b, Key = %b, Encrypted = %b", ui_in, uio_in, uo_out);
    if (uo_out !== (ui_in ^ uio_in)) $display("Test 2 Failed!");

    // Decrypt
    ui_in  = uo_out; // Ciphertext
    #10;
    $display("Test 2 - Decrypt: Ciphertext = %b, Key = %b, Decrypted = %b", ui_in, uio_in, uo_out);
    if (uo_out !== 8'b01011000) $display("Test 2 Failed!");

    // All tests completed
    $display("All tests completed.");
    $finish;
  end

  // Generate a clock signal (not required in this design but good practice)
  always #5 clk = ~clk;

endmodule

