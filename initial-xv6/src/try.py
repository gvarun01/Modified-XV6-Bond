import matplotlib.pyplot as plt
import numpy as np

def read_data_from_file(filename):
    rows = []
    with open(filename, 'r') as file:
        for line in file:
            if line.strip():  # Ensure the line is not empty
                parts = line.split(',')
                if len(parts) == 3:  # Ensure the line has exactly 3 parts
                    try:
                        pid = int(parts[0].split(':')[1].strip())
                        queue = int(parts[1].split(':')[1].strip())
                        ticks = int(parts[2].split(':')[1].strip())
                        rows.append({'pid': pid, 'queue': queue, 'ticks': ticks})
                    except (IndexError, ValueError):
                        print(f"Skipping malformed line: {line.strip()}")
                else:
                    print(f"Skipping malformed line: {line.strip()}")
    return rows

def plot_data_from_file(filename):
    data = read_data_from_file(filename)
    
    # Normalize ticks so that they start from 0
    if not data:
        print("No data to plot.")
        return

    start_tick = data[0]['ticks']
    
    # Adjust ticks to start from 0
    for entry in data:
        entry['ticks'] -= start_tick

    # Filter data to include only the first 200 ticks
    filtered_data = [entry for entry in data if entry['ticks'] <= 200]
    
    if not filtered_data:
        print("No data within the first 200 ticks.")
        return

    # Prepare data for plotting
    pids = sorted(set(entry['pid'] for entry in filtered_data))  # Unique PIDs
    num_pids = len(pids)

    # Use a colormap to assign a unique color to each PID
    cmap = plt.get_cmap('tab20', num_pids)  # Get a colormap with enough distinct colors

    # Plot data
    plt.figure(figsize=(10, 6))
    
    for i, pid in enumerate(pids):
        pid_data = [entry for entry in filtered_data if entry['pid'] == pid]
        ticks = [entry['ticks'] for entry in pid_data]
        queues = [entry['queue'] for entry in pid_data]
        plt.plot(ticks, queues, label=f'PID {pid}', color=cmap(i))

    plt.xlabel('Ticks')
    plt.ylabel('Queue')
    plt.title('Process Queue Over Time (First 200 Ticks)')
    plt.legend()
    plt.grid(True)
    plt.show()

# Call the function with your file
plot_data_from_file('out')