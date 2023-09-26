Class Busrecpacpatvida.Message.Klap.Response.GetCalendario Extends (%Persistent, %XML.Adaptor)
{

Property fecha As %String;

Property numDiaSemana As %String;

Property esFeriado As %String;

Storage Default
{
<Data name="GetCalendarioDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>fecha</Value>
</Value>
<Value name="3">
<Value>numDiaSemana</Value>
</Value>
<Value name="4">
<Value>esFeriado</Value>
</Value>
</Data>
<DataLocation>^Busrecpacpat2ED2.GetCalendarioD</DataLocation>
<DefaultData>GetCalendarioDefaultData</DefaultData>
<IdLocation>^Busrecpacpat2ED2.GetCalendarioD</IdLocation>
<IndexLocation>^Busrecpacpat2ED2.GetCalendarioI</IndexLocation>
<StreamLocation>^Busrecpacpat2ED2.GetCalendarioS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

