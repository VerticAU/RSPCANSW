<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Good2Give Donations Import</label>
    <protected>false</protected>
    <values>
        <field>Flow_API_Name__c</field>
        <value xsi:type="xsd:string">Good2Give_Import</value>
    </values>
    <values>
        <field>Input__c</field>
        <value xsi:type="xsd:string">{
  &quot;First_Name&quot;: &quot;Donor Firstname&quot;,
  &quot;Last_Name&quot;: &quot;Donor Lastname&quot;,
  &quot;Email&quot;: &quot;Donor Email&quot;,
  &quot;Date_of_Gift&quot;: {
    &quot;type&quot;: &quot;Date&quot;,
    &quot;format&quot;: &quot;dd/MM/yyyy&quot;,
    &quot;path&quot;: &quot;Donation Date&quot;
  },
  &quot;Amount&quot;: &quot;Donation Amount&quot;,
  &quot;Donation_Type&quot;: &quot;Donation Type&quot;,
  &quot;Source_Code&quot;: &quot;Source Code&quot;
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
