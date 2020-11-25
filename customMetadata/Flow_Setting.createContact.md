<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Create Contact</label>
    <protected>false</protected>
    <values>
        <field>Flow_API_Name__c</field>
        <value xsi:type="xsd:string">Create_Contact</value>
    </values>
    <values>
        <field>Input__c</field>
        <value xsi:type="xsd:string">{
  &quot;contactCountry&quot; : &quot;dto.contact.country&quot;,
  &quot;contactState&quot; : &quot;dto.contact.state&quot;,
  &quot;contactLastName&quot; : &quot;dto.contact.lastName&quot;,
  &quot;contactCity&quot; : &quot;dto.contact.city&quot;,
  &quot;contactPhone&quot; : &quot;dto.contact.phone&quot;,
  &quot;contactEmail&quot; : &quot;dto.contact.email&quot;,
  &quot;contactStreet&quot; : &quot;dto.contact.street&quot;,
  &quot;contactFirstName&quot; : &quot;dto.contact.firstName&quot;
}</value>
    </values>
    <values>
        <field>Is_Active__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
    <values>
        <field>Output__c</field>
        <value xsi:type="xsd:string">contactId</value>
    </values>
    <values>
        <field>Tags__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>Type__c</field>
        <value xsi:type="xsd:string">REST</value>
    </values>
</CustomMetadata>
