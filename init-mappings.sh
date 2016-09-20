#!/bin/bash

INDEXNAME=$index_name
MAPPINGSNAME=$mappings_name

/wait-for-step.sh
/execute-step.sh

wget $file_url

BASENAME=$(basename $file_url)

for i in {30..0}; do
    if curl elasticsearch:9200; then
	curl -XPUT "elasticsearch:9200/$INDEXNAME"
        curl -XPUT "elasticsearch:9200/$INDEXNAME/_mapping/$MAPPINGSNAME" -d @"$BASENAME"
        break;
    fi
    sleep 2
done

/finish-step.sh
