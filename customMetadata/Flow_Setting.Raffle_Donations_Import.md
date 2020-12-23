<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Raffle Donations Import</label>
    <protected>false</protected>
    <values>
        <field>Flow_API_Name__c</field>
        <value xsi:type="xsd:string">Raffle_Donations_Import</value>
    </values>
    <values>
        <field>Input__c</field>
        <value xsi:type="xsd:string">{
  &quot;Title&quot;: &quot;Title&quot;,
  &quot;First_Name&quot;: &quot;First Name&quot;,
  &quot;Last_Name&quot;: &quot;Surname / Organisation&quot;,
  &quot;Postal_Address_Street&quot;: &quot;Address 1&quot;, 
  &quot;Postal_Suburb&quot;: &quot;Suburb&quot;,
  &quot;Postal_State&quot;: &quot;State&quot;,
  &quot;Postal_Post_Code&quot;: &quot;Postcode&quot;,
  &quot;Home_Phone&quot;: &quot;Tel (eve)&quot;,
  &quot;Work_Phone&quot;: &quot;Work phone&quot;,
  &quot;Mobile_Phone&quot;: &quot;Mobile&quot;,
  &quot;Email&quot;: &quot;Email&quot;,
  &quot;Date_of_Gift&quot;: {
    &quot;type&quot;: &quot;Date&quot;,
    &quot;format&quot;: &quot;dd/MM/yyyy&quot;,
    &quot;path&quot;: &quot;Date of Payment&quot;
  },
  &quot;Amount&quot;: &quot;Payment Amount&quot;,
  &quot;Payment_Type&quot;: &quot;Payment Type&quot;,
  &quot;Source_Code&quot;: &quot;Source Code&quot;,
  &quot;Region&quot;: &quot;Region&quot;
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
