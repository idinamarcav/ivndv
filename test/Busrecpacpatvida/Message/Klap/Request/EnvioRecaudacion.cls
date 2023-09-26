Class Busrecpacpatvida.Message.Klap.Request.EnvioRecaudacion Extends (%Persistent, %XML.Adaptor)
{

Property IdControl As %String [ SqlColumnNumber = 2 ];

Storage Default
{
<Data name="EnvioRecaudacionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IdControl</Value>
</Value>
</Data>
<DataLocation>^Busrecpacp8E1D.EnvioRecaudAAF2D</DataLocation>
<DefaultData>EnvioRecaudacionDefaultData</DefaultData>
<IdLocation>^Busrecpacp8E1D.EnvioRecaudAAF2D</IdLocation>
<IndexLocation>^Busrecpacp8E1D.EnvioRecaudAAF2I</IndexLocation>
<StreamLocation>^Busrecpacp8E1D.EnvioRecaudAAF2S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

