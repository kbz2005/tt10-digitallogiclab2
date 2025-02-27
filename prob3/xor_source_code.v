/*
 * XOR Encrypter
 * INPUTS: Two 8-bit inputs
 *     - ui_in corresponds to the message
 *     - uio_in corresponds to the key
 * OUTPUTS:
 *     - uo_out corresponds to the XOR-encrypted message
 */

`default_nettype none

module tt_um_xor_encrypter (
    input  wire [7:0] ui_in,    // Message (plaintext input)
    output wire [7:0] uo_out,   // Encrypted output (ciphertext)
    input  wire [7:0] uio_in,   // Key (encryption key)
    output wire [7:0] uio_out,  // IO Output path (not used)
    output wire [7:0] uio_oe,   // IO Enable (0 = input mode)
    input  wire       ena,      // Always 1 when the design is powered (ignored)
    input  wire       clk,      // Clock (not used)
    input  wire       rst_n     // Reset (active low, not used)
);

  // XOR encryption: Ciphertext = Message ⊕ Key
  assign uo_out  = ui_in ^ uio_in; // XOR operation
  assign uio_out = 0;              // Unused IO output
  assign uio_oe  = 0;              // Set IO as input mode

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule

