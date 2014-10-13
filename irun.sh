#!/bin/bash

sudo docker run -t -i --name=Graphite \
	    -p 8080:80 -p 2003:2003 -p 8125:8125/udp \
	    odroid_u3/graphite_statsd /bin/bash

	    #-v $(pwd)/data/opt/graphite/:/opt/graphite/ \
	    #-v $(pwd)/data/etc/nginx/:/etc/nginx/ \
	    #-v $(pwd)/data/opt/statsd/:/opt/statsd/ \
	    #-v $(pwd)/data/etc/logrotate.d/:/etc/logrotate.d/ \
	    #-v $(pwd)/data/var/log/:/var/log/ \
