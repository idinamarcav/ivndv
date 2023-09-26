Class Busrecpacpatvida.Data.KlapAgenda Extends (%Persistent, %XML.Adaptor)
{

Property FechaCobranza As %String [ SqlColumnNumber = 2 ];

Property FechaHabilSig As %String [ SqlColumnNumber = 3 ];

Property EstadoEjecucion As %String [ InitialExpression = "PEN", SqlColumnNumber = 4 ];

Query ConsultaPorDia(vFechaHabil) As %SQLQuery
{
	SELECT * FROM BUSRECPACPATVIDA_DATA.KLAPAGENDA WHERE ESTADOEJECUCION = 'PEN' AND FECHAHABILSIG = :vFechaHabil
}

Query ConsultaPendiente() As %SQLQuery
{
	SELECT * FROM BUSRECPACPATVIDA_DATA.KLAPAGENDA WHERE ESTADOEJECUCION = 'PEN'
}

Storage Default
{
<Data name="KlapAgendaDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FechaCobro</Value>
</Value>
<Value name="3">
<Value>FechaHabilSig</Value>
</Value>
<Value name="4">
<Value>EstadoEjecucion</Value>
</Value>
<Value name="5">
<Value>FechaCobranza</Value>
</Value>
</Data>
<DataLocation>^BusrecpacpatvidFF9E.KlapAgendaD</DataLocation>
<DefaultData>KlapAgendaDefaultData</DefaultData>
<IdLocation>^BusrecpacpatvidFF9E.KlapAgendaD</IdLocation>
<IndexLocation>^BusrecpacpatvidFF9E.KlapAgendaI</IndexLocation>
<StreamLocation>^BusrecpacpatvidFF9E.KlapAgendaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

