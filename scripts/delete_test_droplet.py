#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Nov 15 17:18:34 2019

@author: Paolo Cozzi <paolo.cozzi@ibba.cnr.it>

A script to remove a droplet from DO. work with droplet name

"""

import logging
import digitalocean

logging.basicConfig(
    format=(
        '%(asctime)s\t%(levelname)s:\t%(name)s line %(lineno)s\t%(message)s'),
    level=logging.INFO)

logger = logging.getLogger(__name__)

# this is the droplet I'm looking for
DROPLET_NAME = "wp5image-test"

# get a manager object
manager = digitalocean.Manager()

# get the required droplets
droplets = list(
    filter(
        lambda droplet: droplet.name == DROPLET_NAME,
        manager.get_all_droplets()
    )
)

# now check my domains
for domain in manager.get_all_domains():
    # search for the record I don't want
    records = filter(
        lambda record: record.name in ['test', 'injecttest'],
        domain.get_records())

    for record in records:
        logger.warning("Removing %s from %s" % (
            (record.name, record.domain, record.type, record.data), domain))

        if not record.destroy():
            raise Exception("problem while removing record: %s" % (
                [record.name, record.domain, record.type, record.data]))

if len(droplets) == 1:
    # get my droplet
    droplet = droplets[0]

    logger.warning("Destroying droplet %s" % (droplet))

    if not droplet.destroy():
        raise Exception("problem while removing droplet: %s" % (droplet))
