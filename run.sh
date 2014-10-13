#!/bin/bash

sudo docker run -t -d --name=Graphite \
	    -p 8080:80 \
	    -v $(pwd)/data:/storage \
	    odroid_u3/graphite_statsd
