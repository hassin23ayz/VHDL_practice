
# PlanAhead Launch Script for Post PAR Floorplanning, created by Project Navigator

create_project -name switches_LEDs -dir "/home/ayex/firmware_proj/VHDL_practice/xilinx-projects/switches_LEDs/planAhead_run_4" -part xc3s250evq100-5
set srcset [get_property srcset [current_run -impl]]
set_property design_mode GateLvl $srcset
set_property edif_top_file "/home/ayex/firmware_proj/VHDL_practice/xilinx-projects/switches_LEDs/switches_LEDs.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {/home/ayex/firmware_proj/VHDL_practice/xilinx-projects/switches_LEDs} }
set_property target_constrs_file "constraints.ucf" [current_fileset -constrset]
add_files [list {constraints.ucf}] -fileset [get_property constrset [current_run]]
link_design
read_xdl -file "/home/ayex/firmware_proj/VHDL_practice/xilinx-projects/switches_LEDs/switches_LEDs.ncd"
if {[catch {read_twx -name results_1 -file "/home/ayex/firmware_proj/VHDL_practice/xilinx-projects/switches_LEDs/switches_LEDs.twx"} eInfo]} {
   puts "WARNING: there was a problem importing \"/home/ayex/firmware_proj/VHDL_practice/xilinx-projects/switches_LEDs/switches_LEDs.twx\": $eInfo"
}
