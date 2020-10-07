<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Regular Giving Donation</label>
    <protected>false</protected>
    <values>
        <field>Flow_API_Name__c</field>
        <value xsi:type="xsd:string">Regular_Giving_Donation</value>
    </values>
    <values>
        <field>Input__c</field>
        <value xsi:type="xsd:string">{
  &quot;contactLastName&quot; : &quot;dto.contact.lastName&quot;,
  &quot;donationReceiptNumber&quot; : &quot;dto.donation.raceiptNumber&quot;,
  &quot;recurringDonationName&quot; : &quot;dto.recurring.name&quot;,
  &quot;contactPhone&quot; : &quot;dto.contact.phone&quot;,
  &quot;donationUTMLink&quot; : &quot;dto.donation.content&quot;,
  &quot;contactEmail&quot; : &quot;dto.contact.email&quot;,
  &quot;organisationPhone&quot; : &quot;dto.organisation.phone&quot;,
  &quot;stripepaymentId&quot; : &quot;dto.stripe.paymentId&quot;,
  &quot;donationStage&quot; : &quot;dto.donation.stage&quot;,
  &quot;paymentSubscriptionId&quot; : &quot;dto.stripe.subscriptionId&quot;,
  &quot;recurringInstallmentFrequency&quot; : &quot;dto.recurring.installmentFrequency&quot;,
  &quot;recurringInstallmentPeriod&quot; : &quot;dto.recurring.installmentPeriod&quot;,
  &quot;recurringDateEstablished&quot; : {
    &quot;trueValues&quot; : null,
    &quot;format&quot; : &quot;yyyy-MM-dd&quot;,
    &quot;type&quot; : &quot;Date&quot;,
    &quot;disregardBlankValue&quot; : true,
    &quot;trimValue&quot; : true,
    &quot;path&quot; : &quot;dto.recurring.dateEstablished&quot;
  },
  &quot;organisationCity&quot; : &quot;dto.organisation.city&quot;,
  &quot;contactFirstName&quot; : &quot;dto.contact.firstName&quot;,
  &quot;organisationStreet&quot; : &quot;dto.organisation.street&quot;,
  &quot;organisationZIP&quot; : &quot;dto.organisation.postalCode&quot;,
  &quot;recurringDayOfMonth&quot; : &quot;dto.recurring.dayOfMonth&quot;,
  &quot;contactState&quot; : &quot;dto.contact.state&quot;,
  &quot;contactStreet&quot; : &quot;dto.contact.street&quot;,
  &quot;paypalTransactionId&quot; : &quot;dto.paypal.transactionId&quot;,
  &quot;recurringDonationAmount&quot; : &quot;dto.recurring.amount&quot;,
  &quot;organisationName&quot; : &quot;dto.organisation.name&quot;,
  &quot;contactPostalCode&quot; : &quot;dto.contact.postalCode&quot;,
  &quot;recurringType&quot; : &quot;dto.recurring.type&quot;,
  &quot;contactCountry&quot; : &quot;dto.contact.country&quot;,
  &quot;donationUTMSource&quot; : &quot;dto.donation.source&quot;,
  &quot;contactCity&quot; : &quot;dto.contact.city&quot;,
  &quot;paymentMethod&quot; : &quot;dto.payment.method&quot;,
  &quot;recurringEffectiveDate&quot; : {
    &quot;trueValues&quot; : null,
    &quot;format&quot; : &quot;yyyy-MM-dd&quot;,
    &quot;type&quot; : &quot;Date&quot;,
    &quot;disregardBlankValue&quot; : true,
    &quot;trimValue&quot; : true,
    &quot;path&quot; : &quot;dto.recurring.dateEffective&quot;
  },
  &quot;organisationWebsite&quot; : &quot;dto.organisation.website&quot;
}</value>
    </values>
    <values>
        <field>Is_Active__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
    <values>
        <field>Output__c</field>
        <value xsi:type="xsd:string">contactId,raceiptNumber,donationId</value>
    </values>
    <values>
        <field>Tags__c</field>
        <value xsi:nil="true"/>
    </values>
</CustomMetadata>
