<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Fundraiser Sign Up</label>
    <protected>false</protected>
    <values>
        <field>Flow_API_Name__c</field>
        <value xsi:type="xsd:string">fundraiserSignUp</value>
    </values>
    <values>
        <field>Input__c</field>
        <value xsi:type="xsd:string">{
  &quot;contactFirstName&quot; : &quot;dto.contact.firstName&quot;,
  &quot;contactPostalCode&quot; : &quot;dto.contact.postalCode&quot;,
  &quot;contactCountry&quot; : &quot;dto.contact.country&quot;,
  &quot;contactCity&quot; : &quot;dto.contact.city&quot;,
  &quot;contactStreet&quot; : &quot;dto.contact.street&quot;,
  &quot;contactPhone&quot; : &quot;dto.contact.phone&quot;,
  &quot;contactState&quot; : &quot;dto.contact.state&quot;,
  &quot;contactLastName&quot; : &quot;dto.contact.lastName&quot;,
  &quot;contactEmail&quot; : &quot;dto.contact.email&quot;,

  &quot;campaignName&quot; : &quot;dto.campaign.name&quot;,
  &quot;campaignType&quot; : &quot;dto.campaign.type&quot;,
  &quot;campaignId&quot; : &quot;dto.campaign.id&quot;,
  &quot;campaignStatus&quot; : &quot;dto.campaign.status&quot;,
  &quot;campaingParent&quot; : &quot;dto.campaign.parent&quot;
 
}</value>
    </values>
    <values>
        <field>Is_Active__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
    <values>
        <field>Output__c</field>
        <value xsi:type="xsd:string">contactId,campaignOutPut</value>
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
