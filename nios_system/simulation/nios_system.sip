set_global_assignment -entity "nios_system" -library "lib_nios_system" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "nios_system" -library "lib_nios_system" -name IP_TOOL_VERSION "15.1"
set_global_assignment -entity "nios_system" -library "lib_nios_system" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_nios_system" -name SPD_FILE [file join $::quartus(sip_path) "../nios_system.spd"]
set_global_assignment -library "lib_nios_system" -name MISC_FILE [file join $::quartus(sip_path) "../../nios_system.qsys"]
