<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Million Paws Walk</label>
    <protected>false</protected>
    <values>
        <field>Flow_API_Name__c</field>
        <value xsi:type="xsd:string">millionPawsWalk</value>
    </values>
    <values>
        <field>Input__c</field>
        <value xsi:type="xsd:string">{
  &quot;organisationPhone&quot; : &quot;dto.organisation.phone&quot;,
  &quot;ticketAduitAmount&quot; : &quot;dto.ticket.aduitAmount&quot;,
  &quot;donationAmount&quot; : &quot;dto.donation.amount&quot;,
  &quot;organisationZIP&quot; : &quot;dto.organisation.postalCode&quot;,
  &quot;ticketAduit&quot; : &quot;dto.ticket.aduit&quot;,
  &quot;ticketQuantity&quot; : &quot;dto.ticket.quantity&quot;,
  &quot;donationUTMLink&quot; : &quot;dto.donation.content&quot;,
  &quot;fundraiserType&quot; : &quot;dto.campaign.type&quot;,
  &quot;fundraiserParentld&quot; : &quot;dto.campaign.parent&quot;,
  &quot;donationUTMSource&quot; : &quot;dto.donation.source&quot;,
  &quot;contactStreet&quot; : &quot;dto.contact.street&quot;,
  &quot;ticketsConcessionAmount&quot; : &quot;dto.ticket.concessionAmount&quot;,
  &quot;contactPhone&quot; : &quot;dto.contact.phone&quot;,
  &quot;organisationName&quot; : &quot;dto.organisation.name&quot;,
  &quot;contactEmail&quot; : &quot;dto.contact.email&quot;,
  &quot;donationReceiptNumber&quot; : &quot;dto.donation.raceiptNumber&quot;,
  &quot;ticketsConcession&quot; : &quot;dto.ticket.concession&quot;,
  &quot;contactPostalCode&quot; : &quot;dto.contact.postalCode&quot;,
  &quot;ticketFamily&quot; : &quot;dto.ticket.family&quot;,
  &quot;ticketChildAmount&quot; : &quot;dto.ticket.childAmount&quot;,
  &quot;ticketChild&quot; : &quot;dto.ticket.child&quot;,
  &quot;contactCity&quot; : &quot;dto.contact.city&quot;,
  &quot;ticketAmount&quot; : &quot;dto.ticket.amount&quot;,
  &quot;contactFirstName&quot; : &quot;dto.contact.firstName&quot;,
  &quot;contactState&quot; : &quot;dto.contact.state&quot;,
  &quot;organisationStreet&quot; : &quot;dto.organisation.street&quot;,
  &quot;contactCountry&quot; : &quot;dto.contact.country&quot;,
  &quot;fundraiserStatus&quot; : &quot;dto.campaign.status&quot;,
  &quot;funraiserChannel&quot; : &quot;dto.campaign.channel&quot;,
  &quot;ticketFamilyAmount&quot; : &quot;dto.ticket.familyAmount&quot;,
  &quot;ticketLocation&quot; : &quot;dto.ticket.location&quot;,
  &quot;stripeTransactionId&quot; : &quot;dto.stripe.paymentId&quot;,
  &quot;organisationWebsite&quot; : &quot;dto.organisation.website&quot;,
  &quot;donationStage&quot; : &quot;dto.donation.stage&quot;,
  &quot;contactLastName&quot; : &quot;dto.contact.lastName&quot;,
  &quot;paymentMethod&quot; : &quot;dto.payment.method&quot;,
  &quot;fundraiserId&quot; : &quot;dto.campaign.id&quot;,
  &quot;organisationCity&quot; : &quot;dto.organisation.city&quot;,
  &quot;paypalTransactionId&quot; : &quot;dto.paypal.transactionId&quot;
}</value>
    </values>
    <values>
        <field>Is_Active__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
    <values>
        <field>Output__c</field>
        <value xsi:type="xsd:string">contactId,donationId,campaignId,raceiptNumber</value>
    </values>
    <values>
        <field>Tags__c</field>
        <value xsi:nil="true"/>
    </values>
</CustomMetadata>
