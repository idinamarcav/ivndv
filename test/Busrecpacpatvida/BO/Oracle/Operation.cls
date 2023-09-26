Include EnsSQLTypes

Class Busrecpacpatvida.BO.Oracle.Operation Extends (Ens.BusinessOperation, CoreApi.Util.Utilidad)
{

// test

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method GetRecaudacion(pRequest As Busrecpacpatvida.Message.Klap.Request.GetRecaudacion, Output pResponse As Ens.Response) As %Status
{
	set tSC = $System.Status.OK()
	Try 
	{
		set fechaProceso = $System.SQL.TODATE(pRequest.FechaProceso,"YYYYMMDD")
		set fechaProceso = $System.SQL.TOCHAR(fechaProceso,"DD-MONTH-YYYY")
		set tSp="{ call ACSEL.PEK_PKG_RECAUDACION.INTERFAZ_RECAUDACION(?,?,?)}"
								  
		set tParams = 3
		
		set tParams(1)= fechaProceso
		set tParams(1,"SqlType")=$$$SqlVarchar
		set tParams(1,"IOType")=1
		
		set tParams(2)= ""
		set tParams(2,"SqlType")=$$$SqlVarchar
		set tParams(2,"IOType")=4
		
		set tParams(3)= ""
		set tParams(3,"SqlType")=$$$SqlVarchar
		set tParams(3,"IOType")=4
		
        set printquery = ""
		do ##class(Busrecpacpatvida.Common.PrintQuery).PrintQuery(tSp,.tParams,.printquery)
		$$$LOGINFO(printquery)
		
		set tSC = ..Adapter.ExecuteProcedureParmArray(.snapshot,.tOut, tSp,"ioo",.tParams)
		quit:$$$ISERR(tSC)
		
		#DIM tOut as %Library.ListOfDataTypes
		$$$LOGINFO("CodStatus: "_tOut.GetAt(1))
		$$$LOGINFO("GloStatus: "_tOut.GetAt(2))
	}
	catch (ex)  
	{
		set tSC = ex.AsStatus()	  
	}	
	Quit tSC
}

Method GetEnvio(pRequest As Busrecpacpatvida.Message.Klap.Request.EnvioRecaudacion, Output pResponse As Ens.Response) As %Status
{
	Set sc = $SYSTEM.Status.OK()	
	Try 
	{
		set KlapControl = ##class(Busrecpacpatvida.Data.KlapControl).%OpenId(pRequest.IdControl)
		set tSp="{ call ACSEL.PEK_PKG_RECAUDACION.INTERFAZ_ENVIOS(?,?,?)}"
		$$$LOGINFO(tSp)
								  
		set tParams = 3
		 
		set tParams(1)= ""
		set tParams(1,"SqlType")=$$$SqlVarchar
		set tParams(1,"IOType")=4
		
		set tParams(2)= ""
		set tParams(2,"SqlType")=$$$SqlInteger
		set tParams(2,"IOType")=4
		
		set tParams(3,"LOB")=0
		set tParams(3,"SqlType")=$$$SqlWLongVarchar
		set tParams(3,"IOType")=4
		
        ;set printquery = ""
		;do ##class(Busrecpacpatvida.Common.PrintQuery).PrintQuery(tSp,.tParams,.printquery)
		;$$$LOGINFO(printquery)
		
	    set tRTs = ##class(%ListOfObjects).%New()
		set snapshot = ##class(EnsLib.SQL.Snapshot).%New()
		set snapshot.MaxRowsToGet = -1
		set sc = tRTs.Insert(snapshot)		
				
		$$$LOGINFO("BEFORE EXECUTE PROCEDURE")
		set sc=..Adapter.ExecuteProcedureParmArray(.tRTs ,.pOutParam,tSp,"ooo",.tParams )		
		$$$LOGINFO("AFTER EXECUTE PROCEDURE")
		
		If ($SYSTEM.Status.IsError(sc))	{
			set pResponseNOK = ##class(CoreApi.Message.Response).%New()
			set pResponseNOK.estado="500"
			set pResponseNOK.encontrado="NOK"
			set pResponseNOK.comentario=$SYSTEM.Status.GetErrorText(sc)
			$$$LOGWARNING("sc ===> "_$SYSTEM.Status.GetErrorText(sc))
			$$$LOGINFO("sc ===> "_$SYSTEM.Status.GetErrorText(sc))
			set pResponseNOK.sessionId=..%SessionId
			set pResponseNOK.data=""
			set pResponse=pResponseNOK
			set sc = $SYSTEM.Status.OK()
			Quit
		}
		//Lectura columnas
		for i=1:1:snapshot.ColCount	{
			set ^scampos(i)=snapshot.GetColumnName(i)
		}
		
		If (snapshot.Next()){
			set rows=snapshot.RowCount			
	    	
	    	For i=1:1:rows	{
			    set data=##class(Busrecpacpatvida.Data.KlapBase).%New()
			    set data.IdControl=pRequest.IdControl
				set data.Monto =..Normalize(snapshot.GetData(1,i))
				set data.SeqEnc =..Normalize(snapshot.GetData(2,i))
				set data.ReferenceId =..Normalize(snapshot.GetData(3,i))
				set data.Token =..Normalize(snapshot.GetData(4,i))
				
				set key = data.SeqEnc
				set sc = KlapControl.Base.SetAt(data,key)		
				Quit:$$$ISERR(sc)
			
				do KlapControl.%Save()
	    	}
		}
	}
	catch (ex)  
	{
		set sc = ex.AsStatus()	  
	}	
	Quit sc
}

Method SendRespuesta(pRequest As Busrecpacpatvida.Data.KlapControl, Output pResponse As Ens.Response) As %Status
{
	set sc = $System.Status.OK()	
	Try 
	{
		
	    set key=""
		//set count=0
		set cantidad = pRequest.Base.Count()
		$$$LOGINFO("CANTIDAD REGISTRO A INSERTAR: "_cantidad)
		for
		{
		    set key= pRequest.Base.Next(key)
			quit:key=""
			set nRegistro = pRequest.Base.GetAt(key)			
			#Dim nRegistro As Busrecpacpatvida.Data.KlapBase
			
			
		    $$$LOGINFO("CONSULTAR ESTADO ENVIO")	
		    Set obj=##class(Busrecpacpatvida.Data.KlapBase).%OpenId(nRegistro.%Id())
		    
		    if (obj.EstadoEnvío = 0)
		    {				
				set tSp="{ call ACSEL.PEK_PKG_RECAUDACION.RESPUESTAS_KLAP_IRIS(?,?,?,?,?,?,?,?,?)}"									  
				set tParams = 9			 
				set tParams(1)= nRegistro.Token
				Set tParams(1,"SqlType")=12
				Set tParams(1,"IOType")=1
				
				set tParams(2)= nRegistro.SeqEnc
				set tParams(2,"SqlType")=4
				set tParams(2,"IOType")=1
							
				set tParams(3)= nRegistro.EstadoPago
				set tParams(3,"SqlType")=12
				set tParams(3,"IOType")=1
				
				set tParams(4)= nRegistro.Monto
				set tParams(4,"SqlType")=4
				set tParams(4,"IOType")=1
				
				set tParams(5)= nRegistro.OrderId
				set tParams(5,"SqlType")=12
				set tParams(5,"IOType")=1
				
				set tParams(6)= nRegistro.ReferenceId
				set tParams(6,"SqlType")=12
				set tParams(6,"IOType")=1
				
				set tParams(7)= nRegistro.CodigoKlap
				set tParams(7,"SqlType")=4
				set tParams(7,"IOType")=1
									
			    Set tParams(8)=""
				Set tParams(8,"SqlType")=4
				Set tParams(8,"IOType")=4
				
				Set tParams(9)=""
				Set tParams(9,"SqlType")=12
				Set tParams(9,"IOType")=4
				
				Set tRTs = ##class(%ListOfObjects).%New()
		        set printquery = ""
				do ##class(Busrecpacpatvida.Common.PrintQuery).PrintQuery(tSp,.tParams,.printquery)
				$$$LOGINFO(printquery)		  	
			    
			    $$$LOGINFO("BEFORE EXECUTE PROCEDURE"_sc)
				kill ^IRIS.Temp.EnsRuntimeAppData($NAMESPACE,..%ConfigName,"%QCols")
				Set sc=..Adapter.ExecuteProcedureParmArray(.tRTs ,.pOutParam,tSp,,.tParams )		
				quit:$$$ISERR(sc)
				$$$LOGINFO("AFTER EXECUTE PROCEDURE")			
				
				#DIM tOut as %Library.ListOfDataTypes
				
				$$$LOGINFO("GetAt1: "_pOutParam.GetAt(1))		
				$$$LOGINFO("GetAt2: "_pOutParam.GetAt(2))
					
				If (..Normalize(pOutParam.GetAt(1))="0" )
				{				
				  $$$LOGINFO("ACTUALIZAR TABLA ESTADO ENVIO")	
			      Set sc= ..updateKlapBaseEstadoEnvio(nRegistro.%Id())
			      If ($SYSTEM.Status.IsError(sc)){
				  	 $$$LOGWARNING("Error en updateKlapBaseEstadoEnvio token "_nRegistro.%Id())
				     quit:$$$ISERR(sc)
			       }	
				}				
			}
		}
	}
	catch (ex)  
	{
		set sc = ex.AsStatus()	  
	}	
	Quit sc
}

Method ValidaTerminoRecaudacion(pRequest As Busrecpacpatvida.Message.TerminoRecaudacion.Request.TerminoRecaudacionRequest, Output pResponse As Busrecpacpatvida.Message.TerminoRecaudacion.Response.TerminoRecaudacionResponse) As %Status
{
	Set sc = $SYSTEM.Status.OK()	
	Try 
	{
			
	    set pResponse = ##class(Busrecpacpatvida.Message.TerminoRecaudacion.Response.TerminoRecaudacionResponse).%New()
		
		set tSp="SELECT ACSEL.PEK_PKG_UTILS.Prc_Valida_Termino_Recaudacion FROM DUAL"
	    set tRTs = ##class(%ListOfObjects).%New()
		set snapshot = ##class(EnsLib.SQL.Snapshot).%New()
		set snapshot.MaxRowsToGet = -1
		set sc = tRTs.Insert(snapshot)		
				
		$$$LOGINFO("BEFORE EXECUTE PROCEDURE")
		set sc=..Adapter.ExecuteQuery(.snapshot,tSp)		
		$$$LOGINFO("AFTER EXECUTE PROCEDURE")
		
		
		If (snapshot.Next()){			  
		   set pResponse.resultadoTermino =..Normalize(snapshot.GetData(1))		    	
		}
		
	}
	catch (ex)  
	{
		set sc = ex.AsStatus()	  
	}	
	Quit sc
}

ClassMethod updateKlapBaseEstadoEnvio(id) As %Status
{
	Set sc = $System.Status.OK()			
	Try {
		Set obj=##class(Busrecpacpatvida.Data.KlapBase).%OpenId(id)
		Set obj.EstadoEnvío=1
		Set sc=obj.%Save()
	} Catch(ex){
		Set sc = ex.AsStatus()
	}
	Quit sc
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="Busrecpacpatvida.Message.Klap.Request.GetRecaudacion">
		<Method>GetRecaudacion</Method>
	</MapItem>
	<MapItem MessageType="Busrecpacpatvida.Message.Klap.Request.EnvioRecaudacion">
		<Method>GetEnvio</Method>
	</MapItem>
	<MapItem MessageType="Busrecpacpatvida.Data.KlapControl">
		<Method>SendRespuesta</Method>
	</MapItem>	
		<MapItem MessageType="Busrecpacpatvida.Message.TerminoRecaudacion.Request.TerminoRecaudacionRequest">
		<Method>ValidaTerminoRecaudacion</Method>
	</MapItem>
</MapItems>
}

}

