# Usage with Vitis IDE:
# In Vitis IDE create a Single Application Debug launch configuration,
# change the debug type to 'Attach to running target' and provide this 
# tcl script in 'Execute Script' option.
# Path of this script: C:\Xilinx\ECE_520\Sandbox\threat_detection_vitis\threat_detection_app_system\_ide\scripts\systemdebugger_threat_detection_app_system_standalone.tcl
# 
# 
# Usage with xsct:
# To debug using xsct, launch xsct and run below command
# source C:\Xilinx\ECE_520\Sandbox\threat_detection_vitis\threat_detection_app_system\_ide\scripts\systemdebugger_threat_detection_app_system_standalone.tcl
# 
connect -url tcp:127.0.0.1:3121
targets -set -nocase -filter {name =~"APU*"}
rst -system
after 3000
targets -set -filter {jtag_cable_name =~ "Digilent Zybo Z7 210351AF24D9A" && level==0 && jtag_device_ctx=="jsn-Zybo Z7-210351AF24D9A-13722093-0"}
fpga -file C:/Xilinx/ECE_520/Sandbox/threat_detection_vitis/threat_detection_app/_ide/bitstream/threat_detector_bd_wrapper2.bit
targets -set -nocase -filter {name =~"APU*"}
loadhw -hw C:/Xilinx/ECE_520/Sandbox/threat_detection_vitis/threat_app3/export/threat_app3/hw/threat_detector_bd_wrapper2.xsa -mem-ranges [list {0x40000000 0xbfffffff}] -regs
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*"}
source C:/Xilinx/ECE_520/Sandbox/threat_detection_vitis/threat_detection_app/_ide/psinit/ps7_init.tcl
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "*A9*#0"}
dow C:/Xilinx/ECE_520/Sandbox/threat_detection_vitis/threat_detection_app/Debug/threat_detection_app.elf
configparams force-mem-access 0
targets -set -nocase -filter {name =~ "*A9*#0"}
con
