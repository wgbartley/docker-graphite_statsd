#!/bin/bash

sudo docker run -t -i --name=Graphite -h graphite \
	    -v $(pwd)/data:/storage \
	    -p 8000:8000 -p 2003:2003 -p 8125:8125/udp \
	    odroid_u3/graphite_statsd /bin/bash
