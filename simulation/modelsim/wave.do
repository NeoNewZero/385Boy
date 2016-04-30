onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /timer/clk
add wave -noupdate /timer/Reset
add wave -noupdate /timer/int_a
add wave -noupdate /timer/address
add wave -noupdate /timer/din
add wave -noupdate /timer/TAC
add wave -noupdate /timer/irq
add wave -noupdate /timer/TMA
add wave -noupdate /timer/we_n
add wave -noupdate /timer/DIV
add wave -noupdate /timer/TIMA
add wave -noupdate /timer/state
add wave -noupdate /timer/clk
add wave -noupdate /timer/Reset
add wave -noupdate /timer/int_a
add wave -noupdate /timer/address
add wave -noupdate /timer/din
add wave -noupdate /timer/TMA
add wave -noupdate /timer/we_n
add wave -noupdate /timer/TAC
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {483883 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {468906 ps} {501720 ps}
view wave 
wave clipboard store
wave create -driver freeze -pattern clock -initialvalue HiZ -period 100ps -dutycycle 50 -starttime 0ns -endtime 1000ns sim:/timer/clk 
wave create -driver freeze -pattern constant -value 0 -starttime 0ns -endtime 1000ns sim:/timer/Reset 
wave create -driver freeze -pattern constant -value 0 -starttime 0ns -endtime 1000ns sim:/timer/int_a 
wave create -driver freeze -pattern constant -value 16'hff05 -range 15 0 -starttime 0ns -endtime 1000ns sim:/timer/address 
WaveExpandAll -1
wave create -driver freeze -pattern constant -value 8'h0F -range 7 0 -starttime 0ns -endtime 1000ns sim:/timer/din 
WaveExpandAll -1
wave create -driver freeze -pattern constant -value 8'b00000100 -range 7 0 -starttime 0ns -endtime 1000ns sim:/timer/TAC 
wave create -driver freeze -pattern constant -value 8'h10 -range 7 0 -starttime 0ns -endtime 1000ns sim:/timer/TMA 
WaveExpandAll -1
wave create -driver freeze -pattern constant -value 1 -starttime 0ns -endtime 1000ns sim:/timer/we_n 
wave edit change_value -start 740ps -end 2173ps -value 1 Edit:/timer/Reset 
wave create -driver freeze -pattern constant -value 8'h08 -range 7 0 -starttime 0ns -endtime 1000ns sim:/timer/TAC 
WaveExpandAll -1
wave edit change_value -start 548451ps -end 553843ps -value 1 Edit:/timer/int_a 
wave edit change_value -start 483883ps -end 484538ps -value 0 Edit:/timer/we_n 
WaveCollapseAll -1
wave clipboard restore
