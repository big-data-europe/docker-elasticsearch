# Elasticsearch docker
Docker image to:
* Download and start an Elasticsearch instance
* Initiate an index and submit the index schema (mappings) via a JSON file

## Using Docker Compose
Add the following services to your `docker-compose.yml` to integrate an Elasticsearch instance in [your BDE pipeline](https://github.com/big-data-europe/app-bde-pipeline): 
```
elasticsearch:
  image: elasticsearch:2.3
  command: elasticsearch -Des.network.host=0.0.0.0
  ports:
    - "9200:9200"
    - "9300:9300"
elasticsearch-mapping-init:
  environment:
    - file_url=https://raw.githubusercontent.com/big-data-europe/pilot-sc4-flink-kafka-consumer/master/elasticsearch_fcd_mapping.json
    - index_name=thessaloniki
    - mappings_name=floating-cars
  build:
    context: .
  links:
    - elasticsearch
```
In addition to Elasticsearch version (for example, 2.3 used above), set the values of the following variables (see `environment` above):
* `file_url`: the link to the JSON file containing the [mappings definition](https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping.html) (currently, the file must exist online, so the expected value should look like: http(s)://example.com/path/to/file.json).
* `index_name`:  give your index a name
* `mappings_name`: give your mappings a name

## Running the image
Simply run the following command (of course, Docker and Docker Compose are assumed being installed a priori):

    sudo docker-compose up -d

In order to verify your installation is properly working, submit the following HTTP request:

    http://localhost:9200

If it returns a JSON object, something starting with:
```
  {  
    "name" : "Allison Blaire",
    ...
```
... then your Elasticsearch instance is up and running. 

Next, to check if your mappings have been successfully received and validated (syntactically), submit the following HTTP request:

    http://localhost:9200/{index_name}/_mapping/{mappings_name}
  
... replacing `{index_name}` and `{mappings_name}` with the values set previously in the `docker-compose.yml` file.

If it returns a JSON object, something starting with:

    {"{index_name}":{"mappings":{"{mappings_name}-cars":{"...
    
... then you are all set.

    
    
**Note:** this installs a single-node Elasticsearch instance.
