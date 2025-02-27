# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_xor_encrypter(dut):
    """ Testbench for XOR Encryption Module """
    dut._log.info("Start XOR Encryption Test")

    # Set the clock period to 10ns (100 MHz)
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Initialize signals
    dut.rst_n.value = 1
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    # Test Case 1: Encrypt and Decrypt 'A' (Binary: 01000001) with Key 01010101
    dut.ui_in.value = 0b01000001  # Message = 'A'
    dut.uio_in.value = 0b01010101  # Key
    await ClockCycles(dut.clk, 1)
    encrypted_value = dut.uo_out.value.integer
    cocotb.log.info(f"Test 1 - Encrypt: Message = {dut.ui_in.value}, Key = {dut.uio_in.value}, Encrypted = {encrypted_value}")
    assert encrypted_value == (dut.ui_in.value.integer ^ dut.uio_in.value.integer), "Test 1 Encryption Failed!"

    # Decrypt
    dut.ui_in.value = encrypted_value  # Ciphertext
    await ClockCycles(dut.clk, 1)
    decrypted_value = dut.uo_out.value.integer
    cocotb.log.info(f"Test 1 - Decrypt: Ciphertext = {dut.ui_in.value}, Key = {dut.uio_in.value}, Decrypted = {decrypted_value}")
    assert decrypted_value == 0b01000001, "Test 1 Decryption Failed!"

    # Test Case 2: Encrypt and Decrypt 'X' (Binary: 01011000) with Key 10101010
    dut.ui_in.value = 0b01011000  # Message = 'X'
    dut.uio_in.value = 0b10101010  # Key
    await ClockCycles(dut.clk, 1)
    encrypted_value = dut.uo_out.value.integer
    cocotb.log.info(f"Test 2 - Encrypt: Message = {dut.ui_in.value}, Key = {dut.uio_in.value}, Encrypted = {encrypted_value}")
    assert encrypted_value == (dut.ui_in.value.integer ^ dut.uio_in.value.integer), "Test 2 Encryption Failed!"

    # Decrypt
    dut.ui_in.value = encrypted_value  # Ciphertext
    await ClockCycles(dut.clk, 1)
    decrypted_value = dut.uo_out.value.integer
    cocotb.log.info(f"Test 2 - Decrypt: Ciphertext = {dut.ui_in.value}, Key = {dut.uio_in.value}, Decrypted = {decrypted_value}")
    assert decrypted_value == 0b01011000, "Test 2 Decryption Failed!"

    cocotb.log.info("All tests completed successfully.")
