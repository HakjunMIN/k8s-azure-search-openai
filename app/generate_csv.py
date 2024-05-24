import csv
import os

# Load the .env file
with open('.env', 'r') as file:
    lines = file.readlines()

# Prepare the data for the CSV
data = []
for line in lines:
    if line.strip() and not line.startswith('#'):  # Ignore empty lines and comments
        key, value = line.strip().split('=', 1)
        key = key.replace('_', '-')
        data.append([key, value.strip('"')])

# Write the data to a CSV file
with open('secrets.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['secret_name', 'secret_value'])
    writer.writerows(data)