#!/bin/sh

SEIL=/Applications/Seil.app/Contents/Library/bin/seil

# Map Caps Lock to F8
$SEIL set enable_capslock 1
$SEIL set keycode_capslock 100

# Map Right Command to PgUp
$SEIL set enable_command_r 1
$SEIL set keycode_command_r 116

# Map Right Option to PgDn
$SEIL set enable_option_r 1
$SEIL set keycode_option_r 121
