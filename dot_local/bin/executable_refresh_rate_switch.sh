#!/bin/bash

POWER_SOURCE="$(< /sys/class/power_supply/ADP0/online)"

case "$POWER_SOURCE" in
    "0") kscreen-doctor output.eDP-1.mode.2880x1800@60 > /dev/null 2>&1 ;;
    "1") kscreen-doctor output.eDP-1.mode.2880x1800@90 > /dev/null 2>&1 ;;
esac
