Class Busrecpacpatvida.Util.Util Extends %RegisteredObject
{

ClassMethod SyncBP(pAux As Ens.BusinessProcessBPL, pRequest As Busrecpacpatvida.Data.KlapControl) As %Status
{
	Set tSC=$System.Status.OK()
	Set tProcess = "KLAP GENERACION Process"
	Try
	{
		if tProcess '= ""
		{
			set tSC=pAux.SendRequestSync(tProcess,pRequest,.pResponse)
			Quit:$System.Status.IsError(tSC)
		}
	}
	Catch (oException)
	{
		Set tSC=oException.AsStatus()
	}
	Quit tSC
}

ClassMethod execQuery(pQuery As %String, pTRS As %ResultSet) As %Status
{
	set tSC	= $System.Status.OK()
	Try
	{
		set pTRS = ##class(%ResultSet).%New()		
		set tSC = pTRS.Prepare(pQuery)			
		Quit:$$$ISERR(tSC)		
		set tSC = pTRS.Execute()
		Quit:$$$ISERR(tSC)
	}
	Catch (oException)
	{
		Set tSC = oException.AsStatus()
	}
	Quit tSC
}

ClassMethod execEmbedQuery(pClase As %String, pQuery As %String, pParam As %String, pTRS As %ResultSet) As %Status
{
	set tSC	= $System.Status.OK()
	Try
	{
		set pTRS = ##class(%ResultSet).%New(pClase_":"_pQuery)		
		set tSC = pTRS.Prepare()			
		Quit:$$$ISERR(tSC)		
		set tSC = pTRS.Execute(pParam)
		Quit:$$$ISERR(tSC)
	}
	Catch (oException)
	{
		Set tSC = oException.AsStatus()
	}
	Quit tSC
}

}

