import os
import re
import pandas as pd

# Define the folder for calibration coeff data and data spreadsheet
cal_folder = 'Calibration Coeff'
excel_file = 'Lab1Data.xlsx'

# Initialize an Excel writer
excel_writer = pd.ExcelWriter(excel_file, engine='xlsxwriter')

# Create a dictionary to store data for each frequency
frequency_data = {}

# Loop through each .txt file in the folder
for filename in os.listdir(cal_folder):
    if filename.endswith('.txt'):
        parts = filename.split()  # Split the filename into parts
        if len(parts) == 2:  # Check if the filename has two parts
            frequency = parts[1]  # Extract the frequency (without Hz) from the filename
            frequency = frequency[:-4]
            trial_name = f'{frequency} Hz'
            txt_file_path = os.path.join(cal_folder, filename)  # Full path to the .txt file
            
            # Read the .txt file into a DataFrame
            data = pd.read_csv(txt_file_path, names=[parts[0]], header=None)
            
            # Store the data in the frequency_data dictionary
            if frequency in frequency_data:
                frequency_data[frequency].append(data)
            else:
                frequency_data[frequency] = [data]

# Write data to Excel sheets
for frequency, data_list in frequency_data.items():
    # Concatenate the data frames for P0 and Q data
    merged_data = pd.concat(data_list, axis=1)
    
    # Write the data to an Excel sheet
    merged_data.to_excel(excel_writer, sheet_name=f'{frequency} Hz', index=False)

# Define the folder for velocity profile data
vel_folder = 'Velocity Profile'

# Define number pattern of profile filenames
number_pattern = r'[\d\.]+'

# Create a dictionary to store data for both positions
pos_data = {}

# Loop through each .txt file in the folder
for filename in os.listdir(vel_folder):
    if filename.endswith('.txt'):
        parts = filename.split()  # Split the filename into parts
        if len(parts) >= 2:  # Check if the filename has two or more parts
            # Determine position of measurement
            if 'Ft' in filename:
                pos = 'Front'
            elif 'BK' in filename:
                pos = 'Back'
            trial_name = pos
            vertical_pos = re.findall(number_pattern, filename)
            txt_file_path = os.path.join(vel_folder, filename)  # Full path to the .txt file
            
            # Read the .txt file into a DataFrame
            data = pd.read_csv(txt_file_path, names=[vertical_pos[0]], header=None)
            
            # Store the data in the pos_data dictionary
            if pos in pos_data:
                pos_data[pos].append(data)
            else:
                pos_data[pos] = [data]

# Write data to Excel sheets
for pos, data_list in pos_data.items():
    # Concatenate the data frames
    merged_data = pd.concat(data_list, axis=1)
    
    # Write the data to an Excel sheet
    merged_data.to_excel(excel_writer, sheet_name=pos, index=False)

# Save the Excel file
excel_writer.close()

print(f'Data has been saved to {excel_file}')