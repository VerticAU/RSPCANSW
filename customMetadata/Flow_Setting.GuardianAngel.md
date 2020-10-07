<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Guardian Angel</label>
    <protected>false</protected>
    <values>
        <field>Flow_API_Name__c</field>
        <value xsi:type="xsd:string">Guardian_Angel</value>
    </values>
    <values>
        <field>Input__c</field>
        <value xsi:type="xsd:string">{
  &quot;giftMessage&quot; : &quot;dto.gift.message&quot;,
  &quot;organisationCity&quot; : &quot;dto.organisation.city&quot;,
  &quot;paypalTransactionId&quot; : &quot;dto.paypal.transactionId&quot;,
  &quot;organisationStreet&quot; : &quot;dto.organisation.street&quot;,
  &quot;giftAnimalType&quot; : &quot;dto.gift.animalType&quot;,
  &quot;giftAnimalName&quot; : &quot;dto.gift.animalName&quot;,
  &quot;paymentId&quot; : &quot;dto.stripe.paymentId&quot;,
  &quot;donationReceiptNumber&quot; : &quot;dto.donation.raceiptNumber&quot;,
  &quot;contactEmail&quot; : &quot;dto.contact.email&quot;,
  &quot;paymentMethod&quot; : &quot;dto.payment.method&quot;,
  &quot;contactPhone&quot; : &quot;dto.contact.phone&quot;,
  &quot;donationUTMLink&quot; : &quot;dto.donation.content&quot;,
  &quot;contactLastName&quot; : &quot;dto.contact.lastName&quot;,
  &quot;giftName&quot; : &quot;dto.gift.name&quot;,
  &quot;donationAmount&quot; : &quot;dto.donation.amount&quot;,
  &quot;contactFirstName&quot; : &quot;dto.contact.firstName&quot;,
  &quot;giftAnimaAdoptID&quot; : &quot;dto.gift.id&quot;,
  &quot;contactState&quot; : &quot;dto.contact.state&quot;,
  &quot;contactCountry&quot; : &quot;dto.contact.country&quot;,
  &quot;contactStreet&quot; : &quot;dto.contact.street&quot;,
  &quot;donationUTMSource&quot; : &quot;dto.donation.source&quot;,
  &quot;contactCity&quot; : &quot;dto.contact.city&quot;,
  &quot;organisationWebsite&quot; : &quot;dto.organisation.website&quot;,
  &quot;contactPostalCode&quot; : &quot;dto.contact.postalCode&quot;,
  &quot;giftAmount&quot; : &quot;dto.gift.amount&quot;,
  &quot;giftFromName&quot; : &quot;dto.gift.fromeName&quot;,
  &quot;donationStage&quot; : &quot;dto.donation.stage&quot;,
  &quot;organisationPhone&quot; : &quot;dto.organisation.phone&quot;,
  &quot;organisationName&quot; : &quot;dto.organisation.name&quot;
}</value>
    </values>
    <values>
        <field>Is_Active__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
    <values>
        <field>Output__c</field>
        <value xsi:type="xsd:string">giftId,raceiptNumber,contactId,donationId</value>
    </values>
    <values>
        <field>Tags__c</field>
        <value xsi:nil="true"/>
    </values>
</CustomMetadata>
