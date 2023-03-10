Class AQS.urlShortener.Url Extends (%Persistent, %JSON.Adaptor, %Populate)
{

Property ShortUrl As %String;

Property LongUrl As %String(MAXLEN = 250);

Property Campaing As %String;

Property Length As %Integer;

Property Clicked As %Boolean;

Property ExpirationDays As %Integer;

Property ExpirationDate As %Integer;

/// Index
Index Index On ShortUrl;

Index Campaing On Campaing;

Index Clicked On Clicked;

Index ExpirationDate On ExpirationDate;

ClassMethod AddTestData(amount As %Integer = 10)
{
    d ..Populate(amount)
}

Storage Default
{
<Data name="UrlDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ShortUrl</Value>
</Value>
<Value name="3">
<Value>LongUrl</Value>
</Value>
<Value name="4">
<Value>Campaing</Value>
</Value>
<Value name="5">
<Value>Length</Value>
</Value>
<Value name="6">
<Value>Clicked</Value>
</Value>
<Value name="7">
<Value>ExpirationDays</Value>
</Value>
<Value name="8">
<Value>ExpirationDate</Value>
</Value>
</Data>
<DataLocation>^UrlShortenerD</DataLocation>
<DefaultData>UrlDefaultData</DefaultData>
<IdLocation>^UrlShortenerD</IdLocation>
<IndexLocation>^UrlShortenerI</IndexLocation>
<StreamLocation>^UrlShortenerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

ClassMethod DeleteExpiredUrl()
{
    #Dim ExpirationDate
    #Dim exit
    #Dim today

    Set exit=0
    Set today=$p($H,",",1)

    Set ExpirationDate=""
    For{
        Set ExpirationDate=$O(^UrlShortenerI("ExpirationDate",ExpirationDate))
        Quit:(ExpirationDate="")!(exit=1)

        If (ExpirationDate <= today)
        {
            Set id=$O(^UrlShortenerI("ExpirationDate",ExpirationDate,""))
            Do:(id'="") ##class(AQS.urlShortener.Url).%DeleteId(id)
        }Else{
            Set exit=1
        }
    }

    Quit
}

}
