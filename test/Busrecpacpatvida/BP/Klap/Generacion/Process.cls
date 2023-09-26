/// 
Class Busrecpacpatvida.BP.Klap.Generacion.Process Extends Ens.BusinessProcessBPL [ ClassType = persistent, ProcedureBlock ]
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition CAMBIO
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Busrecpacpatvida.Data.KlapControl' response='Ens.Response' height='2000' width='2000' >
<context>
<property name='Klap' type='Busrecpacpatvida.Data.KlapControl' instantiate='0' />
<property name='ObtenerRecaudacion' type='%Boolean' initialexpression='0' instantiate='0' />
<property name='validaTermino' type='%String' initialexpression='"N"' instantiate='0' />
<property name='iterator' type='%Integer' initialexpression='1' instantiate='0' />
</context>
<sequence xend='200' yend='1350' >
<scope name='Scope Generacion' xpos='200' ypos='250' xend='200' yend='1250' >
<call name='Ejecutar Generacion' target='BCI ORA KLAP Operation' async='0' xpos='200' ypos='350' >
<annotation><![CDATA[ACSEL.PEK_PKG_RECAUDACION.INTERFAZ_RECAUDACION]]></annotation>
<request type='Busrecpacpatvida.Message.Klap.Request.GetRecaudacion' >
<assign property="callrequest.FechaProceso" value="request.FechaProceso" action="set" />
</request>
<response type='Ens.Response' />
</call>
<while name='Valida Termino' condition='(context.validaTermino="N")&amp;&amp;(context.iterator&lt;=10)' xpos='200' ypos='450' xend='200' yend='900' >
<annotation>Prc_Valida_Termino_Recaudacion</annotation>
<trace name='iteracion' value='"Try Itera "_context.iterator' xpos='200' ypos='250' />
<assign name="Iterator" property="context.iterator" value="context.iterator+1" action="set" xpos='200' ypos='350' >
<annotation><![CDATA[Numero intento]]></annotation>
</assign>
<call name='Consulta Termino' target='BCI ORA KLAP Operation' async='0' xpos='200' ypos='450' >
<request type='Busrecpacpatvida.Message.TerminoRecaudacion.Request.TerminoRecaudacionRequest' />
<response type='Busrecpacpatvida.Message.TerminoRecaudacion.Response.TerminoRecaudacionResponse' >
<assign property="context.validaTermino" value="callresponse.resultadoTermino" action="set" />
</response>
</call>
<if name='Generacion OK?' condition='(context.validaTermino="S")' xpos='200' ypos='550' xend='200' yend='800' >
<false>
<delay name='Reintento Control PS1' duration='"PT30S"' xpos='335' ypos='700' />
</false>
</if>
</while>
<call name='Obtener Cobros' target='BCI ORA KLAP Operation' async='0' xpos='200' ypos='550' >
<annotation><![CDATA[ACSEL.PEK_PKG_RECAUDACION.INTERFAZ_ENVIOS]]></annotation>
<request type='Busrecpacpatvida.Message.Klap.Request.EnvioRecaudacion' >
<assign property="callrequest.IdControl" value="request.IdControl" action="set" />
</request>
<response type='Ens.Response' />
</call>
<assign name="Cantidad de cobros" property="request.CantidadAvisos" value="request.Base.Count()" action="set" xpos='200' ypos='650' />
<if name='Generación ok?' condition='request.CantidadAvisos&gt;0' xpos='200' ypos='750' xend='200' yend='1000' >
<true>
<call name='Klap Recaudacion' target='KLAP RECAUDACION Process' async='0' xpos='470' ypos='900' >
<annotation><![CDATA[KLAP RECAUDACION Process]]></annotation>
<request type='Busrecpacpatvida.Data.KlapControl' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' />
</call>
</true>
<false>
<trace name='Sin registros' value='"Sin registros"' xpos='200' ypos='900' />
</false>
</if>
<faulthandlers>
<catchall name='Catch All' xpos='200' ypos='1100' xend='200' yend='350' >
<trace value='"%LastError "_   $System.Status.GetErrorCodes(..%Context.%LastError)_   " : "_   $System.Status.GetOneStatusText(..%Context.%LastError)' xpos='200' ypos='250' />
</catchall>
</faulthandlers>
</scope>
</sequence>
</process>
}

}

