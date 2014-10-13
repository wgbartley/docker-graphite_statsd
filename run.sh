#!/bin/bash

sudo docker run -t -d --name=Graphite -h graphite \
	    -p 8000:8000 -p 2003:2003 -p 8125:8125/udp \
	    -v $(pwd)/data:/storage \
	    odroid_u3/graphite_statsd
