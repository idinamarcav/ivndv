/// 
Class Busrecpacpatvida.BP.Klap.Recaudacion.Process Extends Ens.BusinessProcessBPL [ ClassType = persistent, ProcedureBlock ]
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Busrecpacpatvida.Data.KlapControl' response='Ens.Response' height='2000' width='2000' >
<context>
<property name='Klap' type='Busrecpacpatvida.Data.KlapControl' instantiate='0' />
<property name='statusValid' type='%Boolean' initialexpression='0' instantiate='0' />
<property name='iteValid' type='%Integer' initialexpression='1' instantiate='0' />
<property name='countValid' type='%Integer' initialexpression='0' instantiate='0' />
<property name='k1' type='%String' initialexpression='1' instantiate='0' />
<property name='iteratorPago' type='%Integer' initialexpression='0' instantiate='0' />
<property name='KlapBase' type='Busrecpacpatvida.Data.KlapBase' instantiate='0' />
</context>
<sequence xend='200' yend='1100' >
<scope name='Scope Recaudacion' xpos='200' ypos='250' xend='200' yend='1000' >
<call name='Consultar Orden' target='KLAP OC CONSULTA ORDEN Operation' async='1' xpos='200' ypos='350' >
<annotation><![CDATA[KLAP OC CONSULTA ORDEN Operation]]></annotation>
<request type='Busrecpacpatvida.Data.KlapControl' >
<assign property="callrequest" value="request" action="set" />
</request>
</call>
<foreach name='Crear Orden' property='request.Base' key='context.k1' xpos='200' ypos='450' xend='200' yend='650' disabled="true">
<annotation><![CDATA[por cada aviso]]></annotation>
<assign name="Reset Iterator" property="context.iteratorPago" value="1" action="set" xpos='200' ypos='250' />
<assign name="nPago" property="context.KlapBase" value="request.Base.GetAt(context.k1)" action="set" xpos='200' ypos='350' />
<trace name='Item' value='"Item: "_context.k1_" Seq: "_request.Base.GetAt(context.k1).SeqEnc' xpos='200' ypos='450' />
<call name='Genera Orden A' target='KLAP OC GENERA ORDEN Operation' async='0' xpos='200' ypos='550' >
<request type='Busrecpacpatvida.Message.KlapOC.Request.GeneraOrden' >
<assign property="callrequest.referenceId" value="context.KlapBase.ReferenceId" action="set" />
<assign property="callrequest.token" value="context.KlapBase.Token" action="set" />
<assign property="callrequest.montoPago" value="context.KlapBase.Monto" action="set" />
</request>
<response type='Ens.Response' />
</call>
</foreach>
<call name='Crear Ordenes' target='KLAP OC GENERA ORDEN Operation' async='0' xpos='200' ypos='550' >
<annotation><![CDATA[KLAP OC GENERA ORDEN Operation]]></annotation>
<request type='Busrecpacpatvida.Data.KlapControl' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' />
</call>
<while name='Control Ordenes' condition='(context.iteValid&lt;=999999)&amp;&amp;(&apos;context.statusValid)' xpos='200' ypos='650' xend='200' yend='1000' >
<annotation>Validación todas las ordenes con estado</annotation>
<trace name='iteracion' value='"Try Validacion: "_context.iteValid' xpos='200' ypos='250' />
<assign name="Iterator" property="context.iteValid" value="context.iteValid+1" action="set" xpos='200' ypos='350' />
<code name='Consulta totalidad de estados' xpos='200' ypos='450' >
<![CDATA[
	set rsOrden=##class(%ResultSet).%New("Busrecpacpatvida.Data.KlapBase:ConsultaCantValidados")
	set tSC = rsOrden.Prepare()
	Quit:$System.Status.IsError(tSC)
	set tSC = rsOrden.Execute(request.IdControl)
	Quit:$System.Status.IsError(tSC)
	if rsOrden.Next()
	{
		set context.countValid = rsOrden.Data("COUNTVALID")
		if context.countValid = request.CantidadAvisos
		{
		  	set context.statusValid = 1
		}
	}
]]>
</code>
<trace name='Cantidad Actual' value='"Validacion "_context.countValid_" de "_request.CantidadAvisos' xpos='200' ypos='550' />
<if name='Control Ordenes OK?' condition='(context.statusValid)' xpos='200' ypos='650' xend='200' yend='900' >
<false>
<delay name='Reintento Control Ordenes' duration='"PT30S"' xpos='335' ypos='800' />
</false>
</if>
</while>
<call name='Aplicar Rendicion' target='KLAP RENDICION Process' async='0' xpos='200' ypos='750' >
<annotation><![CDATA[KLAP RENDICION Process]]></annotation>
<request type='Busrecpacpatvida.Data.KlapControl' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' />
</call>
<faulthandlers>
<catchall name='Catch All' xpos='200' ypos='850' xend='200' yend='350' >
<trace value='"%LastError "_   $System.Status.GetErrorCodes(..%Context.%LastError)_   " : "_   $System.Status.GetOneStatusText(..%Context.%LastError)' xpos='200' ypos='250' />
</catchall>
</faulthandlers>
</scope>
</sequence>
</process>
}

}

