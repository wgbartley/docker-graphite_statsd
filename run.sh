#!/bin/bash

sudo docker run -t -d --name=Graphite -h graphite \
	    -p 8080:80 \
	    -v $(pwd)/data:/storage \
	    odroid_u3/graphite_statsd
