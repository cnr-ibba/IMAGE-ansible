#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Nov 11 16:32:08 2018

@author: Paolo Cozzi <cozzi@ibba.cnr.it>
"""

import os
import dosa

# read token from environment
API_KEY = os.environ['DIGITALOCEAN_ACCESS_TOKEN']

# get a client object
client = dosa.Client(api_key=API_KEY)

# List all droplets
print(client.droplets.list())

# get ssh keys
result = client.keys.list()
keys = [key['id'] for key in result[1]["ssh_keys"]]

# create a new droplet
status, result = client.droplets.create(
    name='wp5image-test',
    region='fra1',
    size='s-1vcpu-1gb',
    image='docker-18-04',
    ssh_keys=keys,
    private_networking=True)

# get droplet_id
new_droplet_id = result['droplet']['id']
print(new_droplet_id)
