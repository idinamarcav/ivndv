Class Busrecpacpatvida.Message.KlapOC.Request.ConsultaOrden Extends (%Persistent, %XML.Adaptor)
{

Property OrderId As %String;

Storage Default
{
<Data name="ConsultaOrdenDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OrderId</Value>
</Value>
</Data>
<DataLocation>^Busrecpacpat570B.ConsultaOrdenD</DataLocation>
<DefaultData>ConsultaOrdenDefaultData</DefaultData>
<IdLocation>^Busrecpacpat570B.ConsultaOrdenD</IdLocation>
<IndexLocation>^Busrecpacpat570B.ConsultaOrdenI</IndexLocation>
<StreamLocation>^Busrecpacpat570B.ConsultaOrdenS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

