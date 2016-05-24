import sys
import json
import csv

def main():
	with open(sys.argv[1], "r") as f:
		data = json.load(f)
	data["Datapoints"].sort(key=lambda x: x["Timestamp"])
	f = open("output.csv", "w")
	csv_file = csv.writer(f)
	for point in data["Datapoints"]:
		csv_file.writerow([point["Timestamp"], point["Average"], point["Unit"]])

	f.close()

if __name__ == '__main__': main()