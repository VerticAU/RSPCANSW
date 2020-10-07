<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Million Paws Walk Fundraiser Donation</label>
    <protected>false</protected>
    <values>
        <field>Flow_API_Name__c</field>
        <value xsi:type="xsd:string">Million_Paws_Walk_Fundraiser_Donation</value>
    </values>
    <values>
        <field>Input__c</field>
        <value xsi:type="xsd:string">{
  &quot;donationCloseDate&quot; : {
    &quot;trueValues&quot; : null,
    &quot;format&quot; : &quot;yyyy-MM-dd&quot;,
    &quot;type&quot; : &quot;Date&quot;,
    &quot;disregardBlankValue&quot; : true,
    &quot;trimValue&quot; : true,
    &quot;path&quot; : &quot;dto.donation.date&quot;
  },
  &quot;paypalTransactionId&quot; : &quot;dto.paypal.transactionId&quot;,
  &quot;contactPostalCode&quot; : &quot;dto.contact.postalCode&quot;,
  &quot;contactState&quot; : &quot;dto.contact.state&quot;,
  &quot;campaignStatus&quot; : &quot;dto.campaign.status&quot;,
  &quot;donationAmount&quot; : &quot;dto.donation.amount&quot;,
  &quot;contactFirstName&quot; : &quot;dto.contact.firstName&quot;,
  &quot;donationReceiptNumber&quot; : &quot;dto.donation.raceiptNumber&quot;,
  &quot;contactCountry&quot; : &quot;dto.contact.country&quot;,
  &quot;donationUTMLink&quot; : &quot;dto.donation.content&quot;,
  &quot;contactEmail&quot; : &quot;dto.contact.email&quot;,
  &quot;campaingParent&quot; : &quot;dto.campaign.parent&quot;,
  &quot;stripeTransactionId&quot; : &quot;dto.stripe.paymentId&quot;,
  &quot;contactLastName&quot; : &quot;dto.contact.lastName&quot;,
  &quot;donationUTMSource&quot; : &quot;dto.donation.source&quot;,
  &quot;contactPhone&quot; : &quot;dto.contact.phone&quot;,
  &quot;funraiserChannel&quot; : &quot;dto.campaign.channel&quot;,
  &quot;donationStage&quot; : &quot;dto.donation.stage&quot;,
  &quot;contactStreet&quot; : &quot;dto.contact.street&quot;,
  &quot;campaignName&quot; : &quot;dto.campaign.name&quot;,
  &quot;campaignId&quot; : &quot;dto.campaign.id&quot;,
  &quot;contactCity&quot; : &quot;dto.contact.city&quot;
}</value>
    </values>
    <values>
        <field>Is_Active__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
    <values>
        <field>Output__c</field>
        <value xsi:type="xsd:string">contactId,donationId,raceiptNumber</value>
    </values>
    <values>
        <field>Tags__c</field>
        <value xsi:nil="true"/>
    </values>
</CustomMetadata>
