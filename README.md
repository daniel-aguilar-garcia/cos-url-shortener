
## This project is based in the project intersystems-community/iris-rest-api-templates (a template of a REST API application built with ObjectScript in InterSystems IRIS)

[![Quality Gate Status](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Fcos-url-shortener&metric=alert_status)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Fcos-url-shortener)

[![Quality gate](https://community.objectscriptquality.com/api/project_badges/quality_gate?project=intersystems_iris_community%2Fcos-url-shortener)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Fcos-url-shortener)

## Use

Clone/git pull the repo into any local directory e.g. like it is shown below 
(here I show all the examples related to this repository, but I assume you have your own derived from the template):

```
$ git clone https://github.com/daniel-aguilar-garcia/cos-url-shortener.git
```

Open the terminal in this directory and run:

```
$ docker-compose up -d --build
```


## How to Work With it

# Testing POST request

Create a POST request e.g. in Postman with raw data in JSON. e.g.

```
{"LongUrl":"https://www.google.es","Campaing":"TEST", "Length":6, "ExpirationDays": 7}
```

Adjust the authorization if needed - it is basic for container with default login and password for IRIR Community edition container

and send the POST request to localhost:52773/

This will create a record in AQS.urlShortener.Url class of IRIS.


# Testing Navigate to Long Url requests

To navigate to the long url associated for a particular record provide the id in GET request like 'localhost:52773/shortUrl' . E.g.:

```
localhost:52773/RPLMMG
```

This will redirect the user to the long url associated to the short link.


# Testing GET requests

To request the data for a particular record provide the id in GET request like 'localhost:52773/info/id' . E.g.:

```
localhost:52773/info/RPLMMG
```

This will return JSON data for the url associated to the short link RPLMMG, something like that:

```
{"ShortUrl":"RPLMMG","LongUrl":"https://www.google.es","Campaing":"TEST","Length":6,"Clicked":false,"ExpirationDays":7,"ExpirationDate":66517}
```


# Testing DELETE request

For delete request this REST API expects only the id of the record to delete. E.g. if the id=5 the following DELETE call will delete the record:

```
localhost:52773/delete/5
```

# Task autodelete expired links

For autodelete expired links just create a task in the portal an call this method.

```
##class(AQS.urlShortener.Url).DeleteExpiredUrl()
```

