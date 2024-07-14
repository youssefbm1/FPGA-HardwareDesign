onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/dut/clk
add wave -noupdate /testbench/dut/reset_n
add wave -noupdate -divider Target
add wave -noupdate /testbench/dut/avs_write
add wave -noupdate /testbench/dut/avs_writedata
add wave -noupdate /testbench/dut/avs_readdata
add wave -noupdate /testbench/dut/avs_address
add wave -noupdate -divider {MM Registers}
add wave -noupdate -expand /testbench/dut/R
add wave -noupdate /testbench/dut/key_reg
add wave -noupdate /testbench/dut/src_addr_reg
add wave -noupdate /testbench/dut/dest_addr_reg
add wave -noupdate /testbench/dut/num_blk_reg
add wave -noupdate /testbench/dut/ctrl_reg
add wave -noupdate /testbench/dut/start_dma
add wave -noupdate -divider Initiator
add wave -noupdate /testbench/dut/avm_write
add wave -noupdate /testbench/dut/avm_read
add wave -noupdate /testbench/dut/avm_waitrequest
add wave -noupdate /testbench/dut/avm_writedata
add wave -noupdate /testbench/dut/avm_readdata
add wave -noupdate /testbench/dut/avm_address
add wave -noupdate -divider Interrupt
add wave -noupdate /testbench/dut/irq
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1093007 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {0 ps} {1365 ns}
