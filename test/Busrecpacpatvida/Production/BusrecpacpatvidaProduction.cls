Class Busrecpacpatvida.Production.BusrecpacpatvidaProduction Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Busrecpacpatvida.Production.BusrecpacpatvidaProduction" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="JGService" Category="" ClassName="EnsLib.JavaGateway.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="Port">13034</Setting>
    <Setting Target="Host" Name="Address">127.0.0.1</Setting>
  </Item>
  <Item Name="BCI ORA KLAP Operation" Category="KLAPVIDA" ClassName="Busrecpacpatvida.BO.Oracle.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="Credentials">ACSEL_QA</Setting>
    <Setting Target="Adapter" Name="DSN">jdbc:oracle:thin:@d01.bciseguros.cl:1523:d01</Setting>
    <Setting Target="Adapter" Name="JDBCClasspath">/home/irisusr/oracle/ojdbc6.jar</Setting>
    <Setting Target="Adapter" Name="JDBCDriver">oracle.jdbc.driver.OracleDriver</Setting>
    <Setting Target="Adapter" Name="JGService">JGService</Setting>
    <Setting Target="Adapter" Name="RegistryID">ORA_ACSEL:QA||q01.bciseguros.cl||1</Setting>
    <Setting Target="Adapter" Name="ConnectionAttributes">;cursor hold=false</Setting>
    <Setting Target="Adapter" Name="StayConnected">1</Setting>
  </Item>
  <Item Name="BCI AS400 KLAP Operation" Category="KLAPVIDA" ClassName="Busrecpacpatvida.BO.AS400.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="Credentials">UGPWENS2</Setting>
    <Setting Target="Adapter" Name="DSN">jdbc:as400://100.1.1.1/ELKAN</Setting>
    <Setting Target="Adapter" Name="JDBCClasspath">/home/irisusr/AS400/lib/jt400.jar</Setting>
    <Setting Target="Adapter" Name="JDBCDriver">com.ibm.as400.access.AS400JDBCDriver</Setting>
    <Setting Target="Adapter" Name="JGService">JGService</Setting>
  </Item>
  <Item Name="KLAP SYNC Process" Category="KLAPVIDA" ClassName="Busrecpacpatvida.BP.Klap.Sync.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="KLAP GENERACION Process" Category="KLAPVIDA" ClassName="Busrecpacpatvida.BP.Klap.Generacion.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="KLAP RECAUDACION Process" Category="KLAPVIDA" ClassName="Busrecpacpatvida.BP.Klap.Recaudacion.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="KLAP RENDICION Process" Category="KLAPVIDA" ClassName="Busrecpacpatvida.BP.Klap.Rendicion.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="KLAP VIDA Service" Category="KLAPVIDA" ClassName="Busrecpacpatvida.BS.KlapService" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="CallInterval">9999999999</Setting>
  </Item>
  <Item Name="KLAP OC CONSULTA ORDEN Operation" Category="KLAPVIDA" ClassName="Busrecpacpatvida.BO.KLAP.ConsultaOrden.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="HTTPServer">webklap.qa.bciseguros.cl</Setting>
    <Setting Target="Adapter" Name="URL">Api/ResultadoKlapOCRecurrenteVida</Setting>
    <Setting Target="Host" Name="FailureTimeout">1200</Setting>
    <Setting Target="Adapter" Name="ResponseTimeout">60</Setting>
    <Setting Target="Adapter" Name="SSLConfig">ISC.FeatureTracker.SSL.Config</Setting>
    <Setting Target="Adapter" Name="HTTPPort"></Setting>
  </Item>
  <Item Name="KLAP OC GENERA ORDEN Operation" Category="KLAPVIDA" ClassName="Busrecpacpatvida.BO.KLAP.CreaOrden.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="webklap.bciseguros.cl webklap.qa.bciseguros.cl webklap.desa.bciseguros.cl" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="HTTPServer">webklap.qa.bciseguros.cl</Setting>
    <Setting Target="Adapter" Name="URL">Api/PagoKlapOCRecurrenteVidar</Setting>
    <Setting Target="Host" Name="FailureTimeout">1200</Setting>
    <Setting Target="Adapter" Name="ResponseTimeout">60</Setting>
    <Setting Target="Adapter" Name="SSLConfig">ISC.FeatureTracker.SSL.Config</Setting>
  </Item>
</Production>
}

}

