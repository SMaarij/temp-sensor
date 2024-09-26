## Clock Signal
set_property PACKAGE_PIN E3 [get_ports clk]        
set_property IOSTANDARD LVCMOS33 [get_ports clk]

## Reset Button (assuming you use button BTNC as reset)
set_property PACKAGE_PIN C12 [get_ports rst]       
set_property IOSTANDARD LVCMOS33 [get_ports rst]

## Start Button (assuming you use button BTNL for starting the temperature read)
set_property PACKAGE_PIN P17 [get_ports start_button]  
set_property IOSTANDARD LVCMOS33 [get_ports start_button]

## I2C SDA and SCL Lines
set_property PACKAGE_PIN C15 [get_ports sda]       
set_property IOSTANDARD LVCMOS33 [get_ports sda]

set_property PACKAGE_PIN C14 [get_ports scl]       
set_property IOSTANDARD LVCMOS33 [get_ports scl]

## 7-Segment Display Segment Control (CA to CG and DP)
set_property PACKAGE_PIN T10 [get_ports {seg[0]}]  
set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]

set_property PACKAGE_PIN R10 [get_ports {seg[1]}]  
set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]

set_property PACKAGE_PIN K16 [get_ports {seg[2]}]  
set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]

set_property PACKAGE_PIN K13 [get_ports {seg[3]}]  
set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]

set_property PACKAGE_PIN P15 [get_ports {seg[4]}]  
set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]

set_property PACKAGE_PIN T11 [get_ports {seg[5]}]  
set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]

set_property PACKAGE_PIN L18 [get_ports {seg[6]}]  
set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]

set_property PACKAGE_PIN H15 [get_ports {seg[7]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {seg[7]}]

## 7-Segment Display Anode Control (AN0 to AN3)
set_property PACKAGE_PIN J17 [get_ports {an[0]}]   
set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]

set_property PACKAGE_PIN J18 [get_ports {an[1]}]   
set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]

set_property PACKAGE_PIN T9  [get_ports {an[2]}]   
set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]

set_property PACKAGE_PIN J14 [get_ports {an[3]}]   
set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]

set_property PACKAGE_PIN P14 [get_ports {an[4]}]   
set_property IOSTANDARD LVCMOS33 [get_ports {an[4]}]

set_property PACKAGE_PIN T14 [get_ports {an[5]}]   
set_property IOSTANDARD LVCMOS33 [get_ports {an[5]}]

set_property PACKAGE_PIN K2 [get_ports {an[6]}]   
set_property IOSTANDARD LVCMOS33 [get_ports {an[6]}]

set_property PACKAGE_PIN U13 [get_ports {an[7]}]   
set_property IOSTANDARD LVCMOS33 [get_ports {an[7]}]
