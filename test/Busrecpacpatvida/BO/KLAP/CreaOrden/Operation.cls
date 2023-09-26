Include Ensemble

Class Busrecpacpatvida.BO.KLAP.CreaOrden.Operation Extends EnsLib.REST.Operation
{

// test tedt dd  revision

Parameter INVOCATION = "Queue";

XData MessageMap
{
<MapItems>
<MapItem MessageType="Busrecpacpatvida.Data.KlapControl"> 
<Method>GeneraOrdenBatch</Method>
</MapItem>
<MapItem MessageType="Busrecpacpatvida.Message.KlapOC.Request.GeneraOrden"> 
<Method>GeneraOrdenSimple</Method>
</MapItem>
</MapItems>
}

Method GeneraOrdenBatch(pRequest As Busrecpacpatvida.Data.KlapControl, Output pResponse As Ens.Response) As %Status
{
	set tSC = $$$OK
	try
	{
		set key=""
		set count=0
		set cantidad = pRequest.Base.Count()
		for
		{
			set key= pRequest.Base.Next(key)
			quit:key=""
			set count=count+1
			set nRegistro = pRequest.Base.GetAt(key)
			#Dim nRegistro As Busrecpacpatvida.Data.KlapBase
			
			if (nRegistro.OrderId="") || (nRegistro.EstadoPago="")
			{
				/* REQUEST
				{
				  "referenceId": "string",
				  "token": "string",
				  "montoPago": 0
				}
				*/
				//Crea JSON
				set tBody = ##class(%ZEN.proxyObject).%New()
				set tBody."montoPago" = $PIECE(nRegistro.Monto,".",1)  //$E(nRegistro.Monto,1,*-2) ;sin decimas
				set tBody."referenceId" = nRegistro.ReferenceId
				set tBody."token" = nRegistro.Token
				set tSC = ..ObjectToJSONStream(tBody,.pData)
				quit:$$$ISERR(tSC)
				
				//Crea HTTP request
				set tHttpRequest = ##class(%Net.HttpRequest).%New()
				set tSC = tHttpRequest.SetHeader("Content-Type","application/json")
				quit:$$$ISERR(tSC)
				
				set tHttpRequest.EntityBody=pData
				
				$$$LOGINFO(count_" de "_cantidad_" "_$C(10)_tHttpRequest.EntityBody.Read())
				do tHttpRequest.EntityBody.Rewind()
				
				//Llamada a la API-REST
				set tSC = ..Adapter.SendFormDataArray(.tHttpResponse,"POST",tHttpRequest,,,..Adapter.URL)	
				Set:$$$ISERR(tSC)&&$IsObject(tHttpResponse)&&$IsObject(tHttpResponse.Data)&&tHttpResponse.Data.Size tSC=$$$ERROR($$$EnsErrGeneral,$$$StatusDisplayString(tSC)_":"_tHttpResponse.Data.Read())
				;quit:$$$ISERR(tSC)
				
				//Lectura de respuesta JSON
				#Dim tHttpResponse as %Net.HttpResponse
				$$$LOGINFO(count_" de "_cantidad_" "_$C(10)_tHttpResponse.Data.Read())
				do tHttpResponse.Data.Rewind()
				
				if tHttpResponse.StatusCode=200
				{
					//Transformar a Obj
					set tSC = ..JSONStreamToObject(tHttpResponse.Data,.tProxy)
					quit:$$$ISERR(tSC)
					if (tProxy."IsSuccess")
					{
						set nRegistro.OrderId = tProxy.Resultado."OrderId"
					}
					else
					{
						set nRegistro.EstadoPago = "rechazado"
						set nRegistro.ErrorDesc = tProxy.Mensaje
					}
					set nRegistro.IdAviso = count
				}else{
					//Nota: ante errores de la API el pago se da por rechazado ya que al no responder no existe una orden que consultar.
					//y tampoco sabemos desde KLAP cuanto demora la transaccion en reversar el pago en caso de que lo haga.
					
					$$$LOGINFO("Error HTTP: "_tHttpResponse.StatusCode_" - "_tHttpResponse.StatusLine)
					//set nRegistro.ESTADOPAGO = "error"
					set nRegistro.EstadoPago = "rechazado"
					set nRegistro.OrderId = "sin orden"
					set nRegistro.ErrorDesc = tHttpResponse.StatusCode_"-genera orden"
				}
				set tSC = nRegistro.%Save()
				
				/* RESPONSE OK
				{
				  "IsSuccess": true,
				  "Mensaje": "Resultado Klap Oneclick",
				  "Resultado": {
				    "Estado": "pending",
				    "OrderId": "1M5778d11ad7fd415e9137b25a60f562bc",
				    "ReferenceId": "00074905366_01"
				  }
				}
				RESPONSE ERROR
				{
				  "IsSuccess": false,
				  "Mensaje": "Ocurrió un error en la comunicación con Klap",
				  "Resultado": {
				    "code": "400003",
				    "message": "Conflicts creating order: Amount - Total is less than minimum [ $50 ] allowed for this operation"
				  }
				}
				*/
			}
		}
	}
	catch(ex)
	{
		set tSC = ex.AsStatus()
	}
	quit tSC
}

Method GeneraOrdenSimple(pRequest As Busrecpacpatvida.Message.KlapOC.Request.GeneraOrden, Output pResponse As Ens.Response) As %Status
{
	set tSC = $$$OK
	try
	{
		/*
		POST Request
		{
		"montoPago"0,
		"referenceId":"string",
		"token":"string"
		}
		*/
		
		//Crea JSON
		set tBody = ##class(%ZEN.proxyObject).%New()
		set tBody."montoPago" = $PIECE(pRequest.montoPago,".",1) //$E(pRequest.montoPago,1,*-2) ;sin decimas
		set tBody."referenceId" = pRequest.referenceId
		set tBody."token" = pRequest.token
		set tSC = ..ObjectToJSONStream(tBody,.pData)
		quit:$$$ISERR(tSC)
		
		//Crea HTTP request
		set tHttpRequest = ##class(%Net.HttpRequest).%New()
		set tSC = tHttpRequest.SetHeader("Content-Type","application/json")
		quit:$$$ISERR(tSC)
		
		set tHttpRequest.EntityBody=pData
		
		$$$LOGINFO(tHttpRequest.EntityBody.Read())
		do tHttpRequest.EntityBody.Rewind()
		
		//Llamada a la API-REST
		set tSC = ..Adapter.SendFormDataArray(.tHttpResponse,"POST",tHttpRequest,,,..Adapter.URL)	
		Set:$$$ISERR(tSC)&&$IsObject(tHttpResponse)&&$IsObject(tHttpResponse.Data)&&tHttpResponse.Data.Size tSC=$$$ERROR($$$EnsErrGeneral,$$$StatusDisplayString(tSC)_":"_tHttpResponse.Data.Read())
		;quit:$$$ISERR(tSC)
		
		//Lectura de respuesta JSON
		#Dim tHttpResponse as %Net.HttpResponse
		$$$LOGINFO(tHttpResponse.Data.Read())
		do tHttpResponse.Data.Rewind()
		
		/*
		RESPONSE OK
		{
		  "IsSuccess": true,
		  "Mensaje": "Resultado Klap Oneclick",
		  "Resultado": {
		    "Estado": "pending",
		    "OrderId": "1M75413e77a9744f74a2f893ab163ce74a",
		    "ReferenceId": "25843220_37"
		  }
		}
		RESPONSE ERROR
		{
		  "IsSuccess": false,
		  "Mensaje": "Ocurrió un error en la comunicación con Klap",
		  "Resultado": {
		    "code": "400003",
		    "message": "Conflicts creating order: Amount - Total is less than minimum [ $50 ] allowed for this operation"
		  }
		}
		
		200 OK
		400 ERROR DE CONEXION KLAP
		500 ERROR DE CONEXION A APIWEB
		*/
	}
	catch(ex)
	{
		set tSC = ex.AsStatus()
	}
	quit tSC
}

}

