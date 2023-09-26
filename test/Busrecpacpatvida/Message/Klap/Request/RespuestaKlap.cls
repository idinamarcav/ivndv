Class Busrecpacpatvida.Message.Klap.Request.RespuestaKlap Extends (%Persistent, %XML.Adaptor)
{

Property token As %String;

Property encabezadoSeg As %Numeric;

Property status As %Numeric;

Property total As %Numeric;

Property orderid As %String;

Property idtrx As %String;

Property code As %Numeric;

Storage Default
{
<Data name="RespuestaKlapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>token</Value>
</Value>
<Value name="3">
<Value>encabezadoSeg</Value>
</Value>
<Value name="4">
<Value>status</Value>
</Value>
<Value name="5">
<Value>total</Value>
</Value>
<Value name="6">
<Value>orderid</Value>
</Value>
<Value name="7">
<Value>idtrx</Value>
</Value>
<Value name="8">
<Value>code</Value>
</Value>
</Data>
<DataLocation>^Busrecpacpat8E1D.RespuestaKlapD</DataLocation>
<DefaultData>RespuestaKlapDefaultData</DefaultData>
<IdLocation>^Busrecpacpat8E1D.RespuestaKlapD</IdLocation>
<IndexLocation>^Busrecpacpat8E1D.RespuestaKlapI</IndexLocation>
<StreamLocation>^Busrecpacpat8E1D.RespuestaKlapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

