import sys
import os
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.dates as mdates

if len(sys.argv) != 2:
    print("Usage: python main.py <path_to_csv>")
    sys.exit(1)
    
# Read the CSV file
file_path = sys.argv[1]
df = pd.read_csv(file_path, sep=',', skipinitialspace=True)

# Convert timestamp to datetime for better plotting
df['datetime'] = pd.to_datetime(df['timestamp'], unit='s')

# Process CPU load columns (removing % and converting to float)
load_columns = ['cpu0_load', 'cpu1_load', 'cpu2_load', 'cpu3_load']
for col in load_columns:
    df[col] = df[col].str.rstrip('%').astype(float)

# Calculate total CPU load
df['total_cpu_load'] = df[load_columns].sum(axis=1)

freq_columns = ['cpu0_freq', 'cpu1_freq', 'cpu2_freq', 'cpu3_freq']
max_freq_per_row = df[freq_columns].max(axis=1)

# Create a figure with three subplots
fig, (ax1, ax2, ax3, ax4) = plt.subplots(4, 1, figsize=(12, 10), sharex=True)

# Plot battery percentage
ax1.plot(df['datetime'], df['battery'], 'b-', label='Battery %')
ax1.set_ylabel('Battery %')
ax1.set_title('Battery Percentage over Time')
ax1.grid(True)
ax1.legend()

# Plot sum of CPU loads
ax2.plot(df['datetime'], df['total_cpu_load'], 'g-', label='Total CPU Load %')
ax2.set_ylabel('CPU Load % (out of 400%)')
ax2.set_title('Total CPU Load over Time')
ax2.grid(True)
ax2.legend()

# Plot current
ax3.plot(df['datetime'], df['current_avg']/1000, 'r-', label='Current (mA)')
ax3.set_xlabel('Time')
ax3.set_ylabel('Current')
ax3.set_title('Current over Time')
ax3.grid(True)
ax3.legend()

# Plot max frequency
ax4.plot(df['datetime'], max_freq_per_row, 'r-', label='Max Frequency (GHz)')
ax4.set_xlabel('Time')
ax4.set_ylabel('Frequency (GHz)')
ax4.set_title('Max Core Frequency over Time')
ax4.grid(True)
ax4.legend()

# Format the x-axis to show dates nicely
plt.gcf().autofmt_xdate()
date_format = mdates.DateFormatter('%Y-%m-%d %H:%M:%S')
ax3.xaxis.set_major_formatter(date_format)

# Adjust layout
plt.tight_layout()

# Save the figure
filename = os.path.splitext(os.path.basename(file_path))[0]
plt.savefig(f"{filename}.png")
plt.close()
# Show the plot
# plt.show()
