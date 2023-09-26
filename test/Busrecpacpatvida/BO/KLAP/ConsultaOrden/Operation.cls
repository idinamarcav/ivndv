Include Ensemble

Class Busrecpacpatvida.BO.KLAP.ConsultaOrden.Operation Extends EnsLib.REST.Operation
{

Parameter INVOCATION = "Queue";

XData MessageMap
{
<MapItems>
<MapItem MessageType="Busrecpacpatvida.Data.KlapControl"> 
<Method>ConsultaOrdenBatch</Method>
</MapItem>
<MapItem MessageType="Busrecpacpatvida.Message.KlapOC.Request.ConsultaOrden"> 
<Method>ConsultaOrdenSimple</Method>
</MapItem>
</MapItems>
}

Method ConsultaOrdenBatch(pRequest As Busrecpacpatvida.Data.KlapControl, Output pResponse As Ens.Response) As %Status
{
	set tSC = $$$OK
	try
	{
		set consultar=0
		while('consultar){
			set rsOperacion=##class(%ResultSet).%New("Busrecpacpatvida.Data.KlapBase:ConsultaCantOrdenes")
			set tSC = rsOperacion.Prepare()
			Quit:$System.Status.IsError(tSC)
			set tSC = rsOperacion.Execute(pRequest.IdControl)
			Quit:$System.Status.IsError(tSC)

			if rsOperacion.Next()
			{
				set cantidad = rsOperacion.Get("CANT")
				set valPorcentual = (10 / 100) * pRequest.CantidadAvisos
				
				// se comienza a consultar cuando el valor de los registros con ordenes creadas supera el 10%
				if cantidad > valPorcentual	{
					set consultar=1
				}else {
					HANG 10
				}
			}
		}
		set end=""
		while('end){			
			//$$$LOGINFO("FailureTimeout "_..FailureTimeout)
			set rsOrden=##class(%ResultSet).%New("Busrecpacpatvida.Data.KlapBase:ConsultaOrden")
			set tSC = rsOrden.Prepare()
			Quit:$System.Status.IsError(tSC)
			set tSC = rsOrden.Execute(pRequest.IdControl)
			Quit:$System.Status.IsError(tSC)

			if rsOrden.Next()
			{
				set orden = rsOrden.GetObject()
				#Dim orden As Busrecpacpatvida.Data.KlapBase
				
				//Si la consulta es un reintento por error o pendiente, le damos un tiempo a la API para consultar otra vez.
				if (orden.EstadoPago = "error") || (orden.EstadoPago = "pendiente")
				{
				    HANG 10
				}

				set tHttpRequest = ##class(%Net.HttpRequest).%New()
				set tSC = tHttpRequest.SetHeader("Content-Type","application/json")
				quit:$$$ISERR(tSC)
				
				set auxURL = ..Adapter.URL _"/"_orden.OrderId
				$$$LOGINFO(orden.IdAviso_" de "_pRequest.CantidadAvisos_" "_$C(10)_..Adapter.HTTPServer_"/"_auxURL)
				set tSC = ..Adapter.SendFormDataArray(.tHttpResponse,"GET",tHttpRequest,,,auxURL)
				Set:$$$ISERR(tSC)&&$IsObject(tHttpResponse)&&$IsObject(tHttpResponse.Data)&&tHttpResponse.Data.Size tSC=$$$ERROR($$$EnsErrGeneral,$$$StatusDisplayString(tSC)_":"_tHttpResponse.Data.Read())
				//quit:$$$ISERR(tSC)
				
				do tHttpResponse.Data.Rewind()
				#Dim tHttpResponse as %Net.HttpResponse
				set tDataRes=tHttpResponse.Data.Read()
				
				set OrdenObj = ##class(Busrecpacpatvida.Data.KlapBase).%OpenId(orden.%Id())
				if tHttpResponse.StatusCode=200
				{
					$$$LOGINFO(orden.IdAviso_" de "_pRequest.CantidadAvisos_" "_$C(10)_tDataRes)
					
					//Transformar a Obj
					set tSC = ..JSONStreamToObject(tDataRes,.tProxy)
					quit:$$$ISERR(tSC)
					
					if (tProxy."IsSuccess")
					{
						set OrdenObj.CodigoKlap = ##class(Ens.Rule.FunctionSet).Pad($ZSTRIP(tProxy.Resultado."codigoKlap","<>W"),-6,0)
						set OrdenObj.EstadoPago = $CASE(tProxy.Resultado."EstadoOrden",
												  "rejected":"rechazado",
												  "expired":"rechazado",
												  "refunded":"rechazado",
												  "refund":"rechazado",
												  "failed":"rechazado",
												  "pending":"pendiente",
												  "completed":"completado",
												  :tProxy.Obj."status")
						if OrdenObj.EstadoPago = "rechazado"
						{
							set OrdenObj.CausalRechazo = tProxy.Resultado."MensajeError"
						}
						
						//Forzar causales QA-Ciclo-3
						set force = 0
						if force
						{
							if ($E(OrdenObj.ReferenceId,1,*-3) = "26011560") || (OrdenObj.ReferenceId = "26011562")
							{
								set OrdenObj.CodigoKlap = "110051"
								set OrdenObj.EstadoPago = "rechazado"
							}
							if $E(OrdenObj.ReferenceId,1,*-3) = "26011920"
							{
								set OrdenObj.CodigoKlap = "120041"
								set OrdenObj.EstadoPago = "rechazado"
							}
							if $E(OrdenObj.ReferenceId,1,*-3) = "26011562"
							{
								set OrdenObj.CodigoKlap = "110021"
								set OrdenObj.EstadoPago = "rechazado"
							}
							if $E(OrdenObj.ReferenceId,1,*-3) = "26011563"
							{
								set OrdenObj.CodigoKlap = "110081"
								set OrdenObj.EstadoPago = "rechazado"
							}
						}
						
						
					}
					else
					{
						set OrdenObj.ErrorDesc = tProxy.Resultado."MensajeError" // CONSULTAR A TITO !!!
					}
				}else{
					$$$LOGINFO(orden.IdAviso_" de "_pRequest.CantidadAvisos_" "_$C(10)_"HTTPError "_tHttpResponse.StatusCode_$C(10)_tDataRes)
					set OrdenObj.EstadoPago = "error"
					set OrdenObj.ErrorDesc = tHttpResponse.StatusCode_"-consulta orden"
					set OrdenObj.NumIntento = OrdenObj.NumIntento+1
				}
				set tSC = OrdenObj.%Save()
				quit:$$$ISERR(tSC)
			}
			else
			{
				set end = 1
			}
		}
	}
	catch(ex)
	{
		set tSC = ex.AsStatus()
	}
	quit tSC
}

Method ConsultaOrdenSimple(pRequest As Busrecpacpatvida.Message.KlapOC.Request.ConsultaOrden, Output pResponse As Ens.Response) As %Status
{
	set tSC = $$$OK
	try
	{
		set tHttpRequest = ##class(%Net.HttpRequest).%New()
		set tSC = tHttpRequest.SetHeader("Content-Type","application/json")
		quit:$$$ISERR(tSC)
		
		set auxURL = ..Adapter.URL _"/"_pRequest.OrderId
		$$$LOGINFO(..Adapter.HTTPServer_"/"_auxURL)
		set tSC = ..Adapter.SendFormDataArray(.tHttpResponse,"GET",tHttpRequest,,,auxURL)
		quit:$$$ISERR(tSC)
		
		Set:$$$ISERR(tSC)&&$IsObject(tHttpResponse)&&$IsObject(tHttpResponse.Data)&&tHttpResponse.Data.Size tSC=$$$ERROR($$$EnsErrGeneral,$$$StatusDisplayString(tSC)_":"_tHttpResponse.Data.Read())
		do tHttpResponse.Data.Rewind()
		
		#Dim tHttpResponse as %Net.HttpResponse
		set tDataRes=tHttpResponse.Data.Read()
		
		set tSC = ..JSONStreamToObject(tDataRes,.tProxy)
		quit:$$$ISERR(tSC)
		
		if tHttpResponse.StatusCode=200	{
			$$$LOGINFO(tDataRes)
		}else{
			$$$LOGINFO("ErrHTTP "_tHttpResponse.StatusCode_" | "_tDataRes)
		}
	}
	catch(ex)
	{
		set tSC = ex.AsStatus()
	}
	quit tSC
}

}

