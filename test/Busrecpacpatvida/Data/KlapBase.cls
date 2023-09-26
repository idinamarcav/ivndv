Class Busrecpacpatvida.Data.KlapBase Extends (%Persistent, %XML.Adaptor)
{

Property IdControl As %String(XMLPROJECTION = "NONE") [ SqlColumnNumber = 2 ];

Property IdAviso As %String(XMLPROJECTION = "NONE") [ SqlColumnNumber = 3 ];

Property SeqEnc As %String [ SqlColumnNumber = 4 ];

Property Monto As %String [ SqlColumnNumber = 5 ];

Property ReferenceId As %String [ SqlColumnNumber = 6 ];

Property Token As %String [ SqlColumnNumber = 7 ];

Property OrderId As %String [ SqlColumnNumber = 8 ];

Property CodigoKlap As %String [ SqlColumnNumber = 9 ];

Property EstadoPago As %String [ SqlColumnNumber = 10 ];

Property CausalRechazo As %String(MAXLEN = "") [ SqlColumnNumber = 11 ];

Property ErrorDesc As %String [ SqlColumnNumber = 12 ];

Property NumIntento As %String(XMLPROJECTION = "NONE") [ InitialExpression = 0, SqlColumnNumber = 13 ];

Property EstadoEnvío As %Boolean [ InitialExpression = 0, SqlColumnNumber = 14 ];

Query ConsultaCantOrdenes(vIdControl) As %SQLQuery
{
	SELECT COUNT(ID) AS CANT FROM BUSRECPACPATVIDA_DATA.KLAPBASE
	WHERE IDCONTROL = :vIdControl
	AND ORDERID IS NOT NULL
}

/// NUMRINT <--FILTRO QUE ASIGNA LA CANTIDAD DE REINTENTOS A CONSULTAR
Query ConsultaOrden(vIdControl) As %SQLQuery
{
	SELECT TOP 1 * FROM BUSRECPACPATVIDA_DATA.KLAPBASE
	WHERE IDCONTROL = :vIdControl
	AND ORDERID IS NOT NULL
	AND (ESTADOPAGO IS NULL OR ESTADOPAGO = 'pendiente' OR (ESTADOPAGO = 'error' AND ERRORDESC LIKE '%-consulta orden'))
	AND NUMINTENTO <= 3
}

Query ConsultaCantValidados(vIdControl) As %SQLQuery
{
	SELECT COUNT(ID) AS COUNTVALID FROM BUSRECPACPATVIDA_DATA.KLAPBASE
	WHERE IDCONTROL = :vIdControl
	AND ORDERID IS NOT NULL
	AND(ESTADOPAGO IS NOT NULL OR ESTADOPAGO != 'error')
}

Storage Default
{
<Data name="KlapBaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IdControl</Value>
</Value>
<Value name="3">
<Value>IdAviso</Value>
</Value>
<Value name="4">
<Value>SeqEnc</Value>
</Value>
<Value name="5">
<Value>Monto</Value>
</Value>
<Value name="6">
<Value>ReferenceId</Value>
</Value>
<Value name="7">
<Value>Token</Value>
</Value>
<Value name="8">
<Value>OrderId</Value>
</Value>
<Value name="9">
<Value>CodigoKlap</Value>
</Value>
<Value name="10">
<Value>EstadoPago</Value>
</Value>
<Value name="11">
<Value>CausalRechazo</Value>
</Value>
<Value name="12">
<Value>ErrorDesc</Value>
</Value>
<Value name="13">
<Value>NumIntento</Value>
</Value>
<Value name="14">
<Value>EstadoEnvío</Value>
</Value>
</Data>
<DataLocation>^BusrecpacpatvidaFF9E.KlapBaseD</DataLocation>
<DefaultData>KlapBaseDefaultData</DefaultData>
<IdLocation>^BusrecpacpatvidaFF9E.KlapBaseD</IdLocation>
<IndexLocation>^BusrecpacpatvidaFF9E.KlapBaseI</IndexLocation>
<StreamLocation>^BusrecpacpatvidaFF9E.KlapBaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

