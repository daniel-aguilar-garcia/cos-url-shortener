Class AQS.urlShortener.UrlREST Extends urlShortener.REST.Base
{

Parameter Version = "1.0.6";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<!-- Server Info -->
<Route Url="/" Method="GET" Call="GetInfo" Cors="true"/>
<!-- Swagger specs -->
<Route Url="/swagger" Method="GET" Call="SwaggerSpec" />
<!-- GET method to return JSON for a given url shortUrl-->
<Route Url="/:shortUrl" Method="GET" Call="GetUrl"/>
<!-- GET method to return JSON for a given url shortUrl-->
<Route Url="/info/:shortUrl" Method="GET" Call="GetUrlInfo"/>
<!-- Delete a url with id-->
<Route Url="/:id" Method="DELETE" Call="DeleteUrl"/>
<!-- Create a url-->
<Route Url="/" Method="POST" Call="CreateUrl"/>
<!-- GET method to return JSON for a given url id-->
<Route Url="/delete/:id" Method="GET" Call="DeleteUrl"/>


</Routes>
}

/// urlsREST general information
ClassMethod GetInfo() As %Status
{
  SET version = ..#Version
  SET info = {
    "version": (version)
  }
  RETURN ..%ProcessResult($$$OK, info)
}

/// Return one record of AQS.urlShortener.url
ClassMethod GetUrl(shortUrl As %String) As %Status
{
	  #dim tSC As %Status = $$$OK
    #dim id As %Integer

    #; Set the response header to plain text
    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set shortUrl=" "_shortUrl
    Set id=$Order(^Sample.UrlI("Index",shortUrl,""),-1)
    
    Set url = ##class(AQS.urlShortener.Url).%OpenId(id)
    
    If '$IsObject(url) Quit ..Http404()

    Set url.Clicked=1
    Do url.%Save()

    set %response.Redirect = url.LongUrl

    Quit tSC
}

/// Return one record of AQS.urlShortener.url
ClassMethod GetUrlInfo(index As %String) As %Status
{
	  #dim tSC As %Status = $$$OK
    #dim id As %Integer

    #; Set the response header to plain text
    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set index=" "_index
    Set id=$Order(^Sample.UrlI("Index",index,""),-1)
    
    Set url = ##class(AQS.urlShortener.Url).%OpenId(id)
    
    If '$IsObject(url) Quit ..Http404()

    Do url.%JSONExport()

    Quit tSC
}

/// Creates a new AQS.urlShortener.url record
ClassMethod CreateUrl() As %Status
{
	  #dim tSC As %Status = $$$OK

    Set url = ##class(AQS.urlShortener.Url).%New()
    Set data=%request.Content
    W ""
    Set url.ShortUrl=$ZCVT(##class(%PopulateUtils).StringMin(data.Length,data.Length),"U")
    Set url.Clicked=0
    Set url.ExpirationDate=$P($H,",",1)+data.ExpirationDays
    
    $$$TOE(tSC,url.%JSONImport(data))
    $$$TOE(tSC,url.%Save())
    
    Set %response.Status = 204
    Set %response.ContentType = ..#CONTENTTYPEJSON
    
    
    Do url.%JSONExport()

    Quit tSC
}

/// Delete a record with id in AQS.urlShortener.url
ClassMethod DeleteUrl(id As %String) As %Status
{
	  #dim tSC As %Status = $$$OK
    Set url = ##class(AQS.urlShortener.Url).%OpenId(id)
    If '$IsObject(url) Return ..Http404()

    $$$TOE(tSC,url.%DeleteId(id))

    Set %response.Status = 200

    Set %response.ContentType = ..#CONTENTTYPEJSON

    Quit tSC
}

ClassMethod SwaggerSpec() As %Status
{
  Do ##class(%REST.API).GetWebRESTApplication($NAMESPACE, %request.Application, .swagger)
  Do swagger.info.%Remove("x-ISC_Namespace")
  Set swagger.basePath = "/"
  Set swagger.info.title = "InterSystems IRIS REST URL SHORTENER CRUD"
  Set swagger.info.version = "0.1"
  Set swagger.host = "localhost:52773"
  Return ..%ProcessResult($$$OK, swagger)
}

}
