Class Busrecpacpatvida.Data.KlapControl Extends (%Persistent, %XML.Adaptor)
{

Property IdControl As %String [ SqlColumnNumber = 2, SqlFieldName = IDCONTROL ];

Property FechaProceso As %String [ SqlColumnNumber = 3, SqlFieldName = FECPROCESO ];

Property HoraControl As %String [ SqlColumnNumber = 4, SqlFieldName = HORACONTROL ];

Property TipoRecaudacion As %String [ SqlColumnNumber = 5, SqlFieldName = TIPORECAUDACION ];

Property CantidadAvisos As %String [ InitialExpression = 0, SqlColumnNumber = 6, SqlFieldName = CANTAVISOS ];

Property Base As array Of Busrecpacpatvida.Data.KlapBase(STORAGEDEFAULT = "array") [ SqlColumnNumber = 7, SqlFieldName = BASE ];

// , XMLPROJECTION = "NONE");

Query ConsultaYaProcesado(vFechaCobranza) As %SQLQuery
{
	SELECT * FROM Busrecpacpatvida_Data.KlapControl WHERE FECPROCESO =:vFechaCobranza
}

Storage Default
{
<Data name="Base">
<Attribute>Base</Attribute>
<Structure>subnode</Structure>
<Subscript>"Base"</Subscript>
</Data>
<Data name="KlapControlDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IdControl</Value>
</Value>
<Value name="3">
<Value>FechaProceso</Value>
</Value>
<Value name="4">
<Value>HoraControl</Value>
</Value>
<Value name="5">
<Value>TipoRecaudacion</Value>
</Value>
<Value name="6">
<Value>CantidadAvisos</Value>
</Value>
</Data>
<DataLocation>^BusrecpacpatviFF9E.KlapControlD</DataLocation>
<DefaultData>KlapControlDefaultData</DefaultData>
<IdLocation>^BusrecpacpatviFF9E.KlapControlD</IdLocation>
<IndexLocation>^BusrecpacpatviFF9E.KlapControlI</IndexLocation>
<StreamLocation>^BusrecpacpatviFF9E.KlapControlS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

