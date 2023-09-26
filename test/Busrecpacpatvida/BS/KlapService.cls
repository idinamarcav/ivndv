Class Busrecpacpatvida.BS.KlapService Extends (Ens.BusinessService, Busrecpacpatvida.Util.Util)
{

Parameter ADAPTER = "Ens.InboundAdapter";

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
    Set tSC = $System.Status.OK()
    Try
    {  //metodo
        set FActualH = $System.SQL.TODATE("20230721","YYYYMMDD") ;+$H
        set FActual = $System.SQL.TOCHAR(FActualH,"YYYYMMDD")
        set HoraControl = $PIECE($System.SQL.TOCHAR($H,"DDMMYYYY:HH24MISS"),":",2)
        
        #;Consulta si existe alguna recaudacion pendiente en agendaTESTok otro cambio
        do ..execEmbedQuery("Busrecpacpatvida.Data.KlapAgenda","ConsultaPorDia",FActual,.tRS)
        if tRS.Next()
        {
            #;Si existe recaudacion pendiente
            set obj=tRS.GetObject()
            #Dim obj As Busrecpacpatvida.Data.KlapAgenda

            $$$TRACE("Se envía recaudacion agendada [F.REC: "_obj.FechaCobranza_" | F.ACT: "_obj.FechaHabilSig_"]")
            set tSC = ..EnviaRecaudacion(obj.FechaCobranza,HoraControl)
            Quit:$$$ISERR(tSC)
            
            #;Despues de enviar, se marca como terminado la recaudacion pendiente en agenda
            set ActualizaAgenda = ##class(Busrecpacpatvida.Data.KlapAgenda).%OpenId(obj.%Id())
            set ActualizaAgenda.EstadoEjecucion = "TER"
            set tSC = ActualizaAgenda.%Save()
            Quit:$$$ISERR(tSC)
        }
        else
        {
            #;Si no existe recaudacion pendiente
            #Dim GetFeriadoRes As Busrecpacpatvida.Message.Klap.Response.GetCalendario
			set DiasCobranza = ^Ens.LookupTable("klap_fechascobranza","VIDA")
             
            set GetFeriadoReq = ##class(Busrecpacpatvida.Message.Klap.Request.GetCalendario).%New()
            set GetFeriadoReq.fecha = FActual
            set tSC = ..SendRequestSync("BCI AS400 KLAP Operation",GetFeriadoReq,.GetFeriadoRes)
            Quit:$$$ISERR(tSC)
            
            #;Si el dia actual es no habil
            if (GetFeriadoRes.esFeriado="S") || (GetFeriadoRes.numDiaSemana="6") || (GetFeriadoRes.numDiaSemana="7")
            {
	            #;Si el dia actual no habil es una fecha de cobranza (bci-vida 02 y 18)
				set DiaActualH = FActualH
				if $FIND(DiasCobranza,$System.SQL.TOCHAR(DiaActualH,"DD"))>0
				{
					#;Determinar el dia habil mas proximo para agendar ejecucion
					set DiaSiguienteH = DiaActualH
					set diaFeriado = "S"
		            while (diaFeriado="S") || (diaSemana="6") || (diaSemana="7")
		            {
		                set GetFeriadoReq = ##class(Busrecpacpatvida.Message.Klap.Request.GetCalendario).%New()
		                set GetFeriadoReq.fecha = $System.SQL.TOCHAR(DiaSiguienteH,"YYYYMMDD")                          
		                set tSC = ..SendRequestSync("BCI AS400 KLAP Operation",GetFeriadoReq,.GetFeriadoRes)
		                Quit:$$$ISERR(tSC)
		                
		                set diaMes = $EXTRACT(GetFeriadoRes.fecha,7,8)
		                set diaFeriado = GetFeriadoRes.esFeriado
		                set diaSemana = GetFeriadoRes.numDiaSemana
		                
		                set DiaSiguienteH = DiaSiguienteH+1
		            }
		            if (GetFeriadoReq.fecha'=FActual)
		            {
		                $$$TRACE("Dia de cobranza no habil [F.ACT: "_FActual_"], fecha habil agendada: ["_GetFeriadoReq.fecha_"]")
		                set GuardaAgenda = ##class(Busrecpacpatvida.Data.KlapAgenda).%New()
		                set GuardaAgenda.FechaCobranza = FActual
	                	set GuardaAgenda.FechaHabilSig = GetFeriadoReq.fecha
		                set tSC = GuardaAgenda.%Save()
		                Quit:$$$ISERR(tSC)
		            }
				}
		       	else
				{
					$$$TRACE("NO ENVIO - NO HABIL [FECHA]->"_FActual)
				}
	        }
	       	else
			{
				$$$TRACE("ENVIO RECAUDACION NORMAL [FECHA]->"_FActual)                      
				set tSC = ..EnviaRecaudacion(FActual,HoraControl)                          
				Quit:$$$ISERR(tSC)
			}
        }
    }
    Catch (oException)
    {
        set tSC = oException.AsStatus()
    }
    Quit tSC
}

Method EnviaRecaudacion(pFechaProceso As %String, pHoraControl As %String) As %Status
{
    Set tSC = $System.Status.OK()
    Try
    {
		#;Consulta si ya existe una ejecucion para la fecha actual
        set tRS=##class(%ResultSet).%New("Busrecpacpatvida.Data.KlapControl:ConsultaYaProcesado")
        set tSC = tRS.Prepare()
        Quit:$$$ISERR(tSC)
        set tSC = tRS.Execute(pFechaProceso)
        Quit:$$$ISERR(tSC)
        
        if tRS.Next()
        {
            $$$TRACE("Fecha de ejecucion existente en base, ya fue ejecutada?")
            
            //borrar
            set KlapControl = ##class(Busrecpacpatvida.Data.KlapControl).%New()
            set KlapControl.FechaProceso = pFechaProceso
            set KlapControl.HoraControl = pHoraControl
            
            set tSC = KlapControl.%Save()
            Quit:$$$ISERR(tSC)
            set KlapControl.IdControl = KlapControl.%Id()
            
            set tSC = ..SendRequestSync("KLAP SYNC Process",KlapControl,.response)
            Quit:$$$ISERR(tSC)
			//borrar
        }
        else
        {
            set KlapControl = ##class(Busrecpacpatvida.Data.KlapControl).%New()
            set KlapControl.FechaProceso = pFechaProceso
            set KlapControl.HoraControl = pHoraControl
            
            set tSC = KlapControl.%Save()
            Quit:$$$ISERR(tSC)
            set KlapControl.IdControl = KlapControl.%Id()
            
            set tSC = ..SendRequestSync("KLAP SYNC Process",KlapControl,.response)
            Quit:$$$ISERR(tSC)
        }
        
    }
    Catch (oException)
    {
        set tSC = oException.AsStatus()
    }
    Quit tSC
}

}

