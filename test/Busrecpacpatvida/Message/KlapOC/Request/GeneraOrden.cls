Class Busrecpacpatvida.Message.KlapOC.Request.GeneraOrden Extends (%Persistent, %XML.Adaptor)
{

Property referenceId As %String;

Property token As %String;

Property montoPago As %String;

Storage Default
{
<Data name="GeneraOrdenDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>referenceId</Value>
</Value>
<Value name="3">
<Value>token</Value>
</Value>
<Value name="4">
<Value>montoPago</Value>
</Value>
</Data>
<DataLocation>^Busrecpacpatvi570B.GeneraOrdenD</DataLocation>
<DefaultData>GeneraOrdenDefaultData</DefaultData>
<IdLocation>^Busrecpacpatvi570B.GeneraOrdenD</IdLocation>
<IndexLocation>^Busrecpacpatvi570B.GeneraOrdenI</IndexLocation>
<StreamLocation>^Busrecpacpatvi570B.GeneraOrdenS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

