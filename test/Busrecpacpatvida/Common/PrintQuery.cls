Class Busrecpacpatvida.Common.PrintQuery Extends %RegisteredObject
{

ClassMethod PrintQuery(tQuery As %String, ByRef pIOParms, ByRef pFinalQuery As %String) As %Status
{
	Set tSC = $System.Status.OK()

	Try
	{
		set count = pIOParms
		set query = tQuery
		for i=1:1:(count+0)
		{
			set param = pIOParms(i)
			set query = $REPLACE(query,"?","'"_param_"'",1,1)		
			
		}
		set pFinalQuery = query
	}	
	Catch (oException)
	{
		Set tSC = oException.AsStatus()
	}
	Quit tSC
}

}

