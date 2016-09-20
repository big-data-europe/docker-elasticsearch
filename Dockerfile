FROM ubuntu

RUN apt-get update && \
	apt-get install -y wget && \
	rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
	apt-get install -y curl

COPY init-mappings.sh /

ENTRYPOINT ["/init-mappings.sh"]
