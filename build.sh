#!/bin/bash

if [ ! -d "data" ]; then
	mkdir data
fi

sudo docker build -t odroid_u3/graphite_statsd .
