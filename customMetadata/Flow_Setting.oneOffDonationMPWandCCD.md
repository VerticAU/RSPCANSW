<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>One off donation (MPW and CCD)</label>
    <protected>false</protected>
    <values>
        <field>Flow_API_Name__c</field>
        <value xsi:type="xsd:string">oneOffDonationMPWandCCD</value>
    </values>
    <values>
        <field>Input__c</field>
        <value xsi:type="xsd:string">{
  &quot;organisationStreet&quot; : &quot;dto.organisation.street&quot;,
  &quot;contactFirstName&quot; : &quot;dto.contact.firstName&quot;,
  &quot;contactEmail&quot; : &quot;dto.contact.email&quot;,
  &quot;contactState&quot; : &quot;dto.contact.state&quot;,
  &quot;organisationZIP&quot; : &quot;dto.organisation.postalCode&quot;,
  &quot;paypalTransactionId&quot; : &quot;dto.paypal.transactionId&quot;,
  &quot;contactLastName&quot; : &quot;dto.contact.lastName&quot;,
  &quot;contactPostalCode&quot; : &quot;dto.contact.postalCode&quot;,
  &quot;donationAmount&quot; : &quot;dto.donation.amount&quot;,
  &quot;campaingParent&quot; : &quot;dto.campaign.campaingParent&quot;,
  &quot;contactCity&quot; : &quot;dto.contact.city&quot;,
  &quot;organisationName&quot; : &quot;dto.organisation.name&quot;,
  &quot;organisationCity&quot; : &quot;dto.organisation.city&quot;,
  &quot;contactStreet&quot; : &quot;dto.contact.street&quot;,
  &quot;organisationPhone&quot; : &quot;dto.organisation.phone&quot;,
  &quot;organisationWebsite&quot; : &quot;dto.organisation.website&quot;,
  &quot;donationUtmName&quot; : &quot;dto.donation.campaingName&quot;,
  &quot;donationUTMSource&quot; : &quot;dto.donation.source&quot;,
  &quot;donationUTMLink&quot; : &quot;dto.donation.content&quot;,
  &quot;paymentMethod&quot; : &quot;dto.payment.method&quot;,
  &quot;stripeTransactionId&quot; : &quot;dto.stripe.paymentId&quot;,
  &quot;donationDate&quot; : {
    &quot;trueValues&quot; : null,
    &quot;format&quot; : &quot;yyyy-MM-dd&quot;,
    &quot;type&quot; : &quot;Date&quot;,
    &quot;disregardBlankValue&quot; : true,
    &quot;trimValue&quot; : true,
    &quot;path&quot; : &quot;dto.donation.date&quot;
  },
  &quot;donationReceiptNumber&quot; : &quot;dto.donation.raceiptNumber&quot;,
  &quot;contactCountry&quot; : &quot;dto.contact.country&quot;,
  &quot;donationStage&quot; : &quot;dto.donation.stage&quot;,
  &quot;contactPhone&quot; : &quot;dto.contact.phone&quot;
}</value>
    </values>
    <values>
        <field>Is_Active__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
    <values>
        <field>Output__c</field>
        <value xsi:type="xsd:string">organisationId,raceiptNumber,donationId,contactId</value>
    </values>
    <values>
        <field>Tags__c</field>
        <value xsi:nil="true"/>
    </values>
</CustomMetadata>
