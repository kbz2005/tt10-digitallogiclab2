# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_priority_encoder(dut):
    """ Testbench for Priority Encoder Module """
    dut._log.info("Start Priority Encoder Test")

    # Set the clock period to 10ns (100 MHz)
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Initialize signals
    dut.rst_n.value = 1
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    # Test Case 1: In[15:0] = 0010 1010 1111 0001 (Expected C[7:0] = 0000 1011)
    dut.ui_in.value = 0b00101010
    dut.uio_in.value = 0b11110001
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value.integer == 0b00001011, "Test 1 Failed!"

    # Test Case 2: In[15:0] = 0000 0000 0000 0001 (Expected C[7:0] = 0000 0000)
    dut.ui_in.value = 0b00000000
    dut.uio_in.value = 0b00000001
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value.integer == 0b00000000, "Test 2 Failed!"

    # Test Case 3: In[15:0] = 0000 0000 0000 0000 (Expected C[7:0] = 1111 0000)
    dut.ui_in.value = 0b00000000
    dut.uio_in.value = 0b00000000
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value.integer == 0b11110000, "Test 3 Failed!"

    # Extra Test Case: In[15:0] = 1100 0000 0000 0000 (Expected C[7:0] = 15)
    dut.ui_in.value = 0b11000000
    dut.uio_in.value = 0b00000000
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value.integer == 0b00001111, "Test 4 Failed!"

    dut._log.info("All tests completed successfully.")
