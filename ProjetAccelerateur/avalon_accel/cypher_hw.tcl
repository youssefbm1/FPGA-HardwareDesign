# TCL File Generated by Component Editor 21.1
# Thu Jun 27 19:25:07 CEST 2024
# DO NOT MODIFY


# 
# cypher "cypher0" v1.0
#  2024.06.27.19:25:07
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module cypher
# 
set_module_property DESCRIPTION ""
set_module_property NAME cypher
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME cypher0
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL new_component
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file present.sv SYSTEM_VERILOG PATH present.sv TOP_LEVEL_FILE
add_fileset_file present_ctrl.sv SYSTEM_VERILOG PATH present_ctrl.sv
add_fileset_file present_dp.sv SYSTEM_VERILOG PATH present_dp.sv
add_fileset_file present_pkg.sv SYSTEM_VERILOG PATH present_pkg.sv
add_fileset_file SBox.sv SYSTEM_VERILOG PATH SBox.sv


# 
# parameters
# 


# 
# display items
# 

