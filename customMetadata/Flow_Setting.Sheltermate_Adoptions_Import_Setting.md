<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Sheltermate Adoptions Import Setting</label>
    <protected>false</protected>
    <values>
        <field>Flow_API_Name__c</field>
        <value xsi:type="xsd:string">Sheltermate_Adoptions_Import</value>
    </values>
    <values>
        <field>Input__c</field>
        <value xsi:type="xsd:string">{
  &quot;Title&quot;: &quot;Title&quot;,
  &quot;First_Name&quot;: &quot;First Name&quot;,
  &quot;Last_Name&quot;: &quot;Last Name&quot;,
  &quot;Company&quot;: &quot;Company&quot;,
  &quot;Postal_Address_Street&quot;: &quot;Postal Address&quot;,
  &quot;Postal_Suburb&quot;: &quot;Postal Suburb&quot;,
  &quot;Postal_State&quot;: &quot;Postal State&quot;,
  &quot;Postal_Post_Code&quot;: &quot;Postal Post Code&quot;,
  &quot;Home_Phone&quot;: &quot;Home phone&quot;,
  &quot;Work_Phone&quot;: &quot;Work phone&quot;,
  &quot;Mobile_Phone&quot;: &quot;Mobile phone&quot;,
  &quot;Email&quot;: &quot;Email&quot;,
  &quot;Date_of_Birth&quot;: {
    &quot;type&quot;: &quot;Date&quot;,
    &quot;format&quot;: &quot;dd/MM/yyyy&quot;,
    &quot;path&quot;: &quot;Person DOB&quot;
    
  },
  &quot;Animal_Id&quot;: &quot;AnimalID&quot;,
  &quot;Animal_Type&quot;: &quot;Type&quot;,
  &quot;Animal_Name&quot;: &quot;Animal Name&quot;,
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
