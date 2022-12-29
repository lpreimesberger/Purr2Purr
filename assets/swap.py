import json

with open("names.json") as f:
    data = json.load(f)
    print("const names = [")
    for i in data["data"]:
        print(f"\t'{i}',")
    print("];")