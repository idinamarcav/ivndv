Class Busrecpacpatvida.Message.RespuestaKlap.Request.RespuestaKlapRequest Extends (%Persistent, %XML.Adaptor)
{

Property token As %String;

Property encabezadoSeg As %Numeric;

Property status As %String;

Property total As %Numeric;

Property orderid As %String;

Property idtrx As %String;

Property code As %Numeric;

Storage Default
{
<Data name="RespuestaKlapRequestDefaultData">
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
<DataLocation>^Busrecpacp1D9A.RespuestaKlaBEDD</DataLocation>
<DefaultData>RespuestaKlapRequestDefaultData</DefaultData>
<IdLocation>^Busrecpacp1D9A.RespuestaKlaBEDD</IdLocation>
<IndexLocation>^Busrecpacp1D9A.RespuestaKlaBEDI</IndexLocation>
<StreamLocation>^Busrecpacp1D9A.RespuestaKlaBEDS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

