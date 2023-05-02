#!/bin/bash

deepspeed resnet.py --deepspeed --deepspeed_config ds_config.json --log-interval 20$@
