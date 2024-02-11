import sys

def splitter(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()

    for i in range(500):
        start = i * 100
        end = start + 100
        file_name = f'../assets/levels/level{i+1:03}.tsv'

        with open(file_name, 'w') as output_file:
            output_file.writelines(lines[start:end])

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python splitter.py <input_file>")
        sys.exit(1)
    splitter(sys.argv[1])