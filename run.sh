#!/bin/bash

sudo docker run -t -d --name=Graphite -h graphite \
	    -p 8000:8000 \
	    -v $(pwd)/data:/storage \
	    odroid_u3/graphite_statsd
