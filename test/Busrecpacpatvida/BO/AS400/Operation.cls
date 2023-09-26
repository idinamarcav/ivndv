Include EnsSQLTypes

Class Busrecpacpatvida.BO.AS400.Operation Extends Ens.BusinessOperation
{

// test test casa nueva

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method GetCalendario(pRequest As Busrecpacpatvida.Message.Klap.Request.GetCalendario, Output pResponse As Busrecpacpatvida.Message.Klap.Response.GetCalendario) As %Status
{
	set tSC = $System.Status.OK()
	
	set pResponse = ##class(Busrecpacpatvida.Message.Klap.Response.GetCalendario).%New()
	
	#Dim tResult as EnsLib.SQL.GatewayResultSet
	Try
	{
		set tQuery =	"SELECT * FROM "_^BCI.Config("Bibloteca","Files")_".CIACSCAL "_
						"WHERE FANOCA_CAL ='"_$E(pRequest.fecha,1,4)_"' "_
						"AND FMESCA_CAL='"_$E(pRequest.fecha,5,6)_"' "_
						"AND FDIACA_CAL = '"_$E(pRequest.fecha,7,8)_"'"

		$$$LOGINFO(tQuery)

		set tSC = ..Adapter.ExecuteQuery(.tResult,tQuery)
		Quit:$System.Status.IsError(tSC)

		if tResult.Next()			
		{
			
			/*
			//Se agrega feriado bancario
			if $E(calendarioItem.fecha,5,8)="1231"
			{uudeu
				set calendarioItem.indFeriado="S"
			}
			*/
		}
	}
	Catch (oException)
	{
		set tSC = oException.AsStatus()
	}	
	Quit tSC
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="Busrecpacpatvida.Message.Klap.Request.GetCalendario">
    <Method>GetCalendario</Method>
  </MapItem>
</MapItems>
}

}

