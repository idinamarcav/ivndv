Class Busrecpacpatvida.Message.Klap.Request.GetRecaudacion Extends (%Persistent, %XML.Adaptor)
{

Property FechaProceso As %String;

Storage Default
{
<Data name="GetRecaudacionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FechaCobranza</Value>
</Value>
<Value name="3">
<Value>FechaProceso</Value>
</Value>
</Data>
<DataLocation>^Busrecpacpa8E1D.GetRecaudacionD</DataLocation>
<DefaultData>GetRecaudacionDefaultData</DefaultData>
<IdLocation>^Busrecpacpa8E1D.GetRecaudacionD</IdLocation>
<IndexLocation>^Busrecpacpa8E1D.GetRecaudacionI</IndexLocation>
<StreamLocation>^Busrecpacpa8E1D.GetRecaudacionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

