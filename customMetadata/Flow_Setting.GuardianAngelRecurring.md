<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Guardian Angel Recurring</label>
    <protected>false</protected>
    <values>
        <field>Flow_API_Name__c</field>
        <value xsi:type="xsd:string">Guardian_Angel_Recurring</value>
    </values>
    <values>
        <field>Input__c</field>
        <value xsi:type="xsd:string">{
  &quot;paymentSubscriptionId&quot; : &quot;dto.stripe.subscriptionId&quot;,
  &quot;contactEmail&quot; : &quot;dto.contact.email&quot;,
  &quot;contactStreet&quot; : &quot;dto.contact.street&quot;,
  &quot;giftAnimalName&quot; : &quot;dto.gift.animalName&quot;,
  &quot;recurringDonationAmount&quot; : &quot;dto.recurring.amount&quot;,
  &quot;giftAnimaAdoptID&quot; : &quot;dto.gift.id&quot;,
  &quot;recurringInstallmentFrequency&quot; : &quot;dto.recurring.installmentFrequency&quot;,
  &quot;paypalTransactionId&quot; : &quot;dto.paypal.transactionId&quot;,
  &quot;contactFirstName&quot; : &quot;dto.contact.firstName&quot;,
  &quot;recurringDonationName&quot; : &quot;dto.recurring.name&quot;,
  &quot;recurringInstallmentPeriod&quot; : &quot;dto.recurring.installmentPeriod&quot;,
  &quot;recurringEffectiveDate&quot; : {
    &quot;trueValues&quot; : null,
    &quot;format&quot; : &quot;yyyy-MM-dd&quot;,
    &quot;type&quot; : &quot;Date&quot;,
    &quot;disregardBlankValue&quot; : true,
    &quot;trimValue&quot; : true,
    &quot;path&quot; : &quot;dto.recurring.dateEffective&quot;
  },
  &quot;contactState&quot; : &quot;dto.contact.state&quot;,
  &quot;giftAnimalType&quot; : &quot;dto.gift.animalType&quot;,
  &quot;donationUTMSource&quot; : &quot;dto.donation.source&quot;,
  &quot;donationUTMLink&quot; : &quot;dto.donation.content&quot;,
  &quot;recurringDayOfMonth&quot; : &quot;dto.recurring.dayOfMonth&quot;,
  &quot;contactCity&quot; : &quot;dto.contact.city&quot;,
  &quot;recurringDateEstablished&quot; : {
    &quot;trueValues&quot; : null,
    &quot;format&quot; : &quot;yyyy-MM-dd&quot;,
    &quot;type&quot; : &quot;Date&quot;,
    &quot;disregardBlankValue&quot; : true,
    &quot;trimValue&quot; : true,
    &quot;path&quot; : &quot;dto.recurring.dateEstablished&quot;
  },
  &quot;giftAmount&quot; : &quot;dto.gift.amount&quot;,
  &quot;giftMessage&quot; : &quot;dto.gift.message&quot;,
  &quot;contactLastName&quot; : &quot;dto.contact.lastName&quot;,
  &quot;contactPhone&quot; : &quot;dto.contact.phone&quot;,
  &quot;recurringType&quot; : &quot;dto.recurring.type&quot;,
  &quot;giftFromName&quot; : &quot;dto.gift.fromeName&quot;,
  &quot;donationReceiptNumber&quot; : &quot;dto.donation.raceiptNumber&quot;,
  &quot;contactCountry&quot; : &quot;dto.contact.country&quot;,
  &quot;contactPostalCode&quot; : &quot;dto.contact.postalCode&quot;
}</value>
    </values>
    <values>
        <field>Is_Active__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
    <values>
        <field>Output__c</field>
        <value xsi:type="xsd:string">contactId,giftId,raceiptNumber,recurringId</value>
    </values>
    <values>
        <field>Tags__c</field>
        <value xsi:nil="true"/>
    </values>
</CustomMetadata>
