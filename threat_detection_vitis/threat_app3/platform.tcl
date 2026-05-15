# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct C:\Xilinx\ECE_520\Sandbox\threat_detection_vitis\threat_app3\platform.tcl
# 
# OR launch xsct and run below command.
# source C:\Xilinx\ECE_520\Sandbox\threat_detection_vitis\threat_app3\platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {threat_app3}\
-hw {C:\Xilinx\ECE_520\Sandbox\threat_detector_final_soc\threat_detector_bd_wrapper2.xsa}\
-proc {ps7_cortexa9_0} -os {standalone} -out {C:/Xilinx/ECE_520/Sandbox/threat_detection_vitis}

platform write
platform generate -domains 
platform active {threat_app3}
domain active {zynq_fsbl}
bsp reload
bsp setdriver -ip ps7_cortexa9_0 -driver none -ver {}
bsp write
bsp reload
catch {bsp regenerate}
domain active {standalone_domain}
bsp reload
bsp setdriver -ip threat_detector_0 -driver none -ver {}
bsp write
bsp reload
catch {bsp regenerate}
domain active {zynq_fsbl}
bsp setdriver -ip ps7_cortexa9_0 -driver cpu_cortexa9 -ver 2.11
bsp setdriver -ip threat_detector_0 -driver none -ver {}
bsp write
bsp reload
catch {bsp regenerate}
platform generate
platform config -updatehw {C:/Xilinx/ECE_520/Sandbox/threat_detector_final_soc/threat_detector_bd_wrapper2.xsa}
platform generate -domains 
