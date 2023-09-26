/// 
Class Busrecpacpatvida.BP.Klap.Rendicion.Process Extends Ens.BusinessProcessBPL [ ClassType = persistent, ProcedureBlock ]
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Busrecpacpatvida.Data.KlapControl' response='Ens.Response' height='2000' width='2000' >
<sequence xend='200' yend='350' >
<scope name='Scope Generacion' xpos='200' ypos='250' xend='200' yend='1350' >

<call name='Enviar Rendicion' target='BCI ORA KLAP Operation' async='0' xpos='200' ypos='650' disabled="false">
<request type='Busrecpacpatvida.Data.KlapControl' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' />
</call>
<faulthandlers>
<catchall name='Catch All' xpos='200' ypos='1200' xend='200' yend='350' >
<trace value='"%LastError "_   $System.Status.GetErrorCodes(..%Context.%LastError)_   " : "_   $System.Status.GetOneStatusText(..%Context.%LastError)' xpos='200' ypos='250' />
</catchall>
</faulthandlers>
</scope>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}

