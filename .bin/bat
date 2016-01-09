#!/bin/bash
# Copyright (C) 2007 William Poetra Yoga Hadisoeseno <williampoetra@gmail.com>
# This file is licensed under the GPL v2. E-mail me if you have any ideas of
# other licenses to use (BSD, GPL v3, Public Domain, etc.), I'm open :)

# IDEAS
# - make an ncurses interface, and also maybe gtk+ and qt
# - add option to enable modifying the charge control variables

TP_SMAPI_BASE=/sys/devices/platform/smapi

# function to simplify reading from files
# syntax: read_file <variable> <filename> <check_return_value 0/1> <translate 0/1> [[value] [translation_string]]
read_file()
{
  local VARIABLE
  local FILENAME
  local CHECK_RETURN
  local TRANSLATE
  local VAL
  local RET

  VARIABLE="$1"; shift
  FILENAME="$1"; shift
  CHECK_RETURN="$1"; shift
  TRANSLATE="$1"; shift

  VAL=`cat "$FILENAME" 2> /dev/null`
  RET=$?

  if [[ "$CHECK_RETURN" == "1" ]] && [[ $RET -gt 0 ]]
  then
    RESULT="[unavailable]"
  elif [ "$TRANSLATE" == "1" ]
  then
    RESULT="unknown ($RET)"
    while [ -n "$1" ]
    do
      if [ "$VAL" == "$1" ]
      then
        RESULT="$2"
        break
      fi
      shift 2
    done
  else
    RESULT="$VAL"
  fi

  eval "$VARIABLE="'"'"$RESULT"'"'
#  eval "$VARIABLE=$RESULT"
}

give_units()
{
  local VARIABLE
  local UNIT
  local VALUE
  local RESULT

  VARIABLE="$1"
  UNIT="$2"
  eval "VALUE=\$$VARIABLE"

  if (echo "$VALUE" | grep -qs "^-\?[0-9]")
  then
    RESULT="$VALUE $UNIT"
  else
    RESULT="$VALUE"
  fi

  eval "$VARIABLE="'"'"$RESULT"'"'
}

replace_val()
{
  local VARIABLE
  local OLD_VALUE
  local NEW_VALUE
  local VALUE
  local RESULT

  VARIABLE="$1"
  OLD_VALUE="$2"
  NEW_VALUE="$3"

  eval "VALUE=\$$VARIABLE"

  if [ "$VALUE" == "$OLD_VALUE" ]
  then
    RESULT="$NEW_VALUE"
  else
    RESULT="$VALUE"
  fi

  eval "$VARIABLE="'"'"$RESULT"'"'
}

show_help()
{
  cat << EOF

  thinkpad-smapi.sh - Show SMAPI information on ThinkPad laptops, through
                      the exported SMAPI information by the tp_smapi module.

  -a      Show all available information
  -b [n]  Show all available information for battery [n]
  -h      Show this help text
  -m      Show miscellaneous information

EOF
}

show_misc()
{
  cd $TP_SMAPI_BASE

  read_file PCI_POWER_SAVINGS "enable_pci_power_saving_on_boot" 1 1 1 "enabled" 0 "disabled"
  read_file AC_ADAPTER "ac_connected" 1 1 1 "connected" 0 "disconnected"

  cat << EOF
MISCELLANEOUS INFORMATION
=========================

PCI power savings on boot: $PCI_POWER_SAVINGS
AC adapter status: $AC_ADAPTER

EOF
}

show_batt()
{
  SLOT=$1
  cd $TP_SMAPI_BASE/BAT$SLOT

  TMP=`cat installed`
  if [ $TMP -eq 1 ]
  then
    BATT_INSTALLED="yes"
  else
    BATT_INSTALLED="no"
  fi

  BATT_STATE=`cat state`

  if [ $BATT_INSTALLED == "yes" ]
  then

    read_file BARCODING "barcoding" 1 0
    read_file BATT_CHEMISTRY "chemistry" 1 0
    read_file DESIGN_CAPACITY "design_capacity" 1 0
    read_file DESIGN_VOLTAGE "design_voltage" 1 0
    read_file MANUFACTURE_DATE "manufacture_date" 1 0
    read_file BATT_FRU "model" 1 0
    read_file MANUFACTURER "manufacturer" 1 0
    read_file BATT_SERIAL "serial" 1 0

    read_file FIRST_USE_DATE "first_use_date" 1 0
    read_file CYCLE_COUNT "cycle_count" 1 0
    read_file LAST_FULL_CAPACITY "last_full_capacity" 1 0
    read_file CURRENT_1MIN "current_avg" 1 0
    read_file POWER_1MIN "power_avg" 1 0

    read_file CAPACITY_MWH "remaining_capacity" 1 0
    read_file CAPACITY_PERCENT "remaining_percent" 1 0
    read_file REMAINING_RUNNING_TIME "remaining_running_time" 1 0
    read_file CURRENT_NOW "current_now" 1 0
    read_file POWER_NOW "power_now" 1 0
    read_file BATT_TEMPERATURE "temperature" 1 0
    read_file BATT_VOLTAGE "voltage" 1 0
    read_file REMAINING_CHARGING_TIME "remaining_charging_time" 1 0

    # fixups
    give_units DESIGN_CAPACITY "mWh"
    give_units DESIGN_VOLTAGE "mV"
    give_units CURRENT_NOW "mA"
    give_units POWER_NOW "mW"
    give_units CURRENT_1MIN "mA"
    give_units POWER_1MIN "mW"
    give_units LAST_FULL_CAPACITY "mWh"
    give_units REMAINING_RUNNING_TIME "min"
    give_units REMAINING_CHARGING_TIME "min"
    give_units CAPACITY_PERCENT "%"
    give_units BATT_TEMPERATURE "mC"
    give_units BATT_VOLTAGE "mV"

    # some more
    replace_val REMAINING_RUNNING_TIME "not_discharging" "[not discharging]"
    replace_val REMAINING_CHARGING_TIME "not_charging" "[not charging]"

  else

    BATT_FRU=
    MANUFACTURER=   
    BATT_SERIAL=
    BARCODING=
    BATT_CHEMISTRY=
    DESIGN_CAPACITY=
    DESIGN_VOLTAGE=
    MANUFACTURE_DATE=

    FIRST_USE_DATE=
    CYCLE_COUNT=
    LAST_FULL_CAPACITY=
    CURRENT_1MIN=
    POWER_1MIN=

    CAPACITY_MWH=
    CAPACITY_PERCENT=
    REMAINING_RUNNING_TIME=
    CURRENT_NOW=
    POWER_NOW=
    BATT_TEMPERATURE=
    BATT_VOLTAGE=
    REMAINING_CHARGING_TIME=

  fi

  read_file START_CHARGE_THRESH "start_charge_thresh" 1 0
  read_file STOP_CHARGE_THRESH "stop_charge_thresh" 1 0
  read_file INHIBIT_CHARGE_MIN "inhibit_charge_minutes" 1 0
  read_file BATT_FORCE_DISCHARGE "force_discharge" 1 1 1 "yes" 0 "no"

# installed*, state*, dump
# barcoding, chemistry, design_capacity, design_voltage, manufacture_date, model, manufacturer, serial
# first_use_date, cycle_count, last_full_capacity, current_avg, power_avg
# remaining_capacity, remaining_percent, remaining_running_time, current_now, power_now, temperature, voltage, remaining_charging_time
# start_charge_thresh*, stop_charge_thresh*, inhibit_charge_minutes*, force_discharge*

  cat << EOF
BATTERY $SLOT INFORMATION
=====================

Battery slot:
  Battery present: $BATT_INSTALLED
  Battery state: $BATT_STATE

EOF

  if [ "$BATT_INSTALLED" == "yes" ]
  then
    cat << EOF
Embedded info:
  FRU P/N: $BATT_FRU
  Barcoding: $BARCODING
  Serial number: $BATT_SERIAL
  OEM Manufacturer: $MANUFACTURER
  Chemistry: $BATT_CHEMISTRY
  Manufacture date: $MANUFACTURE_DATE
  Design capacity & voltage: $DESIGN_CAPACITY, $DESIGN_VOLTAGE

Battery health:
  First use date: $FIRST_USE_DATE
  Cycle count: $CYCLE_COUNT
  Last full capacity: $LAST_FULL_CAPACITY
  Average current / power (past 1 minute): $CURRENT_1MIN, $POWER_1MIN

Battery status:
  Remaining capacity: $CAPACITY_MWH mWh ($CAPACITY_PERCENT)
  Remaining running time: $REMAINING_RUNNING_TIME
  Running current & power: $CURRENT_NOW, $POWER_NOW
  Temperature: $BATT_TEMPERATURE
  Voltage: $BATT_VOLTAGE
  Remaining charging time: $REMAINING_CHARGING_TIME

EOF
  fi

  cat << EOF
Battery charging control:
  Start charging at: $START_CHARGE_THRESH %
  Stop charging at: $STOP_CHARGE_THRESH %
  Prevent charging for: $INHIBIT_CHARGE_MIN min
  Force battery discharge: $BATT_FORCE_DISCHARGE

EOF
}

SHOW_ALL=
SHOW_BATT=
SHOW_MISC=
GOT_OPTS=

while getopts ab:hm OPT
do
  GOT_OPTS=y
  case ${OPT} in
  a) SHOW_ALL=y;;
  b) if [ ${OPTARG} -eq 0 -o ${OPTARG} -eq 1 ]
     then
       SHOW_BATT=${OPTARG}
     else
       SHOW_BATT=y
     fi
     ;;
  h) show_help
     exit 0
     ;;
  m) SHOW_MISC=y;;
  \?) show_help
     exit 1
     ;;
  esac
done

if [ "$GOT_OPTS" != y ]
then
  show_help
  exit 1
fi

if [ "$SHOW_ALL" == y ]
then
  show_misc
  show_batt 0
  show_batt 1
else
  if [ -n "$SHOW_MISC" ]
  then
    show_misc
  fi
  if [ -n "$SHOW_BATT" ]
  then
    show_batt $SHOW_BATT
  fi
fi