Class Busrecpacpatvida.BP.Klap.Sync.Process Extends Ens.BusinessProcessBPL [ ClassType = persistent, ProcedureBlock ]
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Busrecpacpatvida.Data.KlapControl' response='Ens.Response' height='2000' width='2000' >
<sequence xend='200' yend='350' >
<code name='Call Generacion' xpos='200' ypos='250' >
<![CDATA[

	set status = ##class(Busrecpacpatvida.Util.Util).SyncBP(process,request)

]]>
</code>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}

