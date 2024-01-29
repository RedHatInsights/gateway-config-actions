#!/usr/bin/env python3
import json
import os

import yaml
import yaml.error


# get the input and convert it to int
CONFIG_DIR = "configs"

for env in ("prod", "stage", "dev", "ocm"):
    config_file = f"{CONFIG_DIR}/{env}/routes.yml"
    try:
        with open(f"{CONFIG_DIR}/{env}/routes.yml") as input_file:
            backends = yaml.safe_load(input_file)
    except OSError:
        raise Exception(f"Error opening config map at {config_file}")
    except yaml.error.YAMLError as e:
        raise Exception(f"Error parsing config map as YAML: {e}")

    assert isinstance(backends, list), "YAML file does not contain a list of backends."

    routes_mapping = {
        backend["route"]: backend["origin"]
        for backend in backends
    }
    print(routes_mapping)

    file_path = f"_private/configs/{env}/routes.json"

    dir_name = os.path.dirname(file_path)

    # Check if the directory exists
    if not os.path.exists(dir_name):
        # If not, create it
        os.makedirs(dir_name)

    with open(file_path, "w") as json_file:
        json.dump(routes_mapping, json_file)
    
    print("Done.")
