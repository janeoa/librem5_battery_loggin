#!/bin/bash

# Check if file exists, create with header if it doesn't
if [ ! -f battery.csv ]; then
  echo "date, timestamp, voltage, battery-temp, battery, charge, current, current_avg, cpu0_freq, cpu1_freq, cpu2_freq, cpu3_freq, cpu0_load, cpu1_load, cpu2_load, cpu3_load, thermal_zone0, thermal_zone1, thermal_zone2, thermal_zone3, thermal_zone4, thermal_zone5" > battery.csv
fi

# Define battery path
BATT_PATH="/sys/class/power_supply/max170xx_battery"

# Loop to add new data every 10 seconds
while true; do
  # Get timestamp once
  current_date=$(date)
  timestamp=$(date +%s)
  
  # Get CPU frequencies - using awk which we know is available
  cpu0_freq=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq 2>/dev/null | awk '{printf "%.2f", $1/1000000}')
  cpu1_freq=$(cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_cur_freq 2>/dev/null | awk '{printf "%.2f", $1/1000000}')
  cpu2_freq=$(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_cur_freq 2>/dev/null | awk '{printf "%.2f", $1/1000000}')
  cpu3_freq=$(cat /sys/devices/system/cpu/cpu3/cpufreq/scaling_cur_freq 2>/dev/null | awk '{printf "%.2f", $1/1000000}')
  
  # Get CPU loads with the method we know works
  cpu0_load=$(grep "^cpu0 " /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} {printf "%.1f", usage}')
  cpu1_load=$(grep "^cpu1 " /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} {printf "%.1f", usage}')
  cpu2_load=$(grep "^cpu2 " /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} {printf "%.1f", usage}')
  cpu3_load=$(grep "^cpu3 " /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} {printf "%.1f", usage}')
  
  # Read battery data - using direct file reads to reduce process spawning
  voltage=$(cat $BATT_PATH/voltage_now)
  capacity=$(cat $BATT_PATH/capacity)
  charge=$(cat $BATT_PATH/charge_now)
  current=$(cat $BATT_PATH/current_now)
  current_avg=$(cat $BATT_PATH/current_avg)
  temperature=$(cat $BATT_PATH/temp)
  
  # Read thermal zone temperatures
  thermal_zone0=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null || echo "N/A")
  thermal_zone1=$(cat /sys/class/thermal/thermal_zone1/temp 2>/dev/null || echo "N/A")
  thermal_zone2=$(cat /sys/class/thermal/thermal_zone2/temp 2>/dev/null || echo "N/A")
  thermal_zone3=$(cat /sys/class/thermal/thermal_zone3/temp 2>/dev/null || echo "N/A")
  thermal_zone4=$(cat /sys/class/thermal/thermal_zone4/temp 2>/dev/null || echo "N/A")
  thermal_zone5=$(cat /sys/class/thermal/thermal_zone5/temp 2>/dev/null || echo "N/A")
  
  # Write to file once
  echo "$current_date, $timestamp, $voltage, $temperature, $capacity, $charge, $current, $current_avg, $cpu0_freq,$cpu1_freq,$cpu2_freq,$cpu3_freq, $cpu0_load%,$cpu1_load%,$cpu2_load%,$cpu3_load%, $thermal_zone0, $thermal_zone1, $thermal_zone2, $thermal_zone3, $thermal_zone4, $thermal_zone5" >> battery.csv
  
  echo "Battery and CPU stats recorded at $current_date"
  sleep 10
done
