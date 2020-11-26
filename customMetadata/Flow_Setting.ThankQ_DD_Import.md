<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>ThankQ DD Import</label>
    <protected>false</protected>
    <values>
        <field>Flow_API_Name__c</field>
        <value xsi:type="xsd:string">ThankQ_DD_Import</value>
    </values>
    <values>
        <field>Input__c</field>
        <value xsi:type="xsd:string">{
&quot;PledgeID&quot;: &quot;PLEDGEID&quot;,
&quot;SerialNumber&quot;: &quot;SERIALNUMBER&quot;,
&quot;PaymentType&quot;: &quot;PAYMENTTYPE&quot;,
&quot;PaymentFrequency&quot;: &quot;PAYMENTFREQUENCY&quot;,
&quot;StartDate&quot;: {
  &quot;type&quot;: &quot;Date&quot;,
  &quot;format&quot;: &quot;yyyy-MM-dd&quot;,
  &quot;path&quot;: &quot;STARTDATE&quot;
},
&quot;EndDate&quot;: {
  &quot;type&quot;: &quot;Date&quot;,
  &quot;format&quot;: &quot;yyyy-MM-dd&quot;,
  &quot;path&quot;: &quot;ENDDATE&quot;
},
&quot;Amount&quot;: &quot;INSTALMENTVALUE&quot;,
&quot;AccountName&quot;: &quot;ACCOUNTNAME&quot;,
&quot;BSB&quot;: &quot;SORTCODE&quot;,
&quot;AccountNumber&quot;: &quot;ACCOUNTNUMBER&quot;,
&quot;Token&quot;: &quot;CREDITCARDTOKEN&quot;,
&quot;TokenGateway&quot;: &quot;TOKENGATEWAY&quot;
}</value>
    </values>
    <values>
        <field>Is_Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Output__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>Tags__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>Type__c</field>
        <value xsi:type="xsd:string">Data Import</value>
    </values>
</CustomMetadata>
