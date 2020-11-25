<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Membership Payment</label>
    <protected>false</protected>
    <values>
        <field>Flow_API_Name__c</field>
        <value xsi:type="xsd:string">membershipPayment</value>
    </values>
    <values>
        <field>Input__c</field>
        <value xsi:type="xsd:string">{
  &quot;campaignCode&quot;: &quot;dto.campaign.code&quot;,
  &quot;contactStreet&quot;: &quot;dto.contact.street&quot;,
  &quot;membershipCloseDate&quot;: {
    &quot;trueValues&quot;: null,
    &quot;format&quot;: &quot;yyyy-MM-dd&quot;,
    &quot;type&quot;: &quot;Date&quot;,
    &quot;disregardBlankValue&quot;: true,
    &quot;trimValue&quot;: true,
    &quot;path&quot;: &quot;dto.membership.closeDate&quot;
  },
  &quot;paypalTransactionId&quot;: &quot;dto.paypal.transactionId&quot;,
  &quot;contactFirstName&quot;: &quot;dto.contact.firstName&quot;,
  &quot;contactLastName&quot;: &quot;dto.contact.lastName&quot;,
  &quot;stripepaymentId&quot;: &quot;dto.stripe.paymentId&quot;,
  &quot;membershipStartDate&quot;: {
    &quot;trueValues&quot;: null,
    &quot;format&quot;: &quot;yyyy-MM-dd&quot;,
    &quot;type&quot;: &quot;Date&quot;,
    &quot;disregardBlankValue&quot;: true,
    &quot;trimValue&quot;: true,
    &quot;path&quot;: &quot;dto.membership.startDate&quot;
  },
  &quot;membershipStage&quot;: &quot;dto.membership.stage&quot;,
  &quot;contactEmail&quot;: &quot;dto.contact.email&quot;,
  &quot;donationReceiptNumber&quot;: &quot;dto.donation.raceiptNumber&quot;,
  &quot;contactPostalCode&quot;: &quot;dto.contact.postalCode&quot;,
  &quot;utmCampaign&quot;: &quot;dto.utm.campaign&quot;,
  &quot;utmSource&quot;: &quot;dto.utm.source&quot;,
  &quot;utmAdContent&quot;: &quot;dto.utm.adContent&quot;,
  &quot;utmMedium&quot;: &quot;dto.utm.medium&quot;,
  &quot;utmTestVariant&quot;: &quot;dto.utm.testVariant&quot;,
  &quot;utmTerm&quot;: &quot;dto.utm.term&quot;,
  &quot;contactMemberNumber&quot;: &quot;dto.contact.memberNumber&quot;,
  &quot;contactState&quot;: &quot;dto.contact.state&quot;,
  &quot;membershipName&quot;: &quot;dto.membership.name&quot;,
  &quot;contactCity&quot;: &quot;dto.contact.city&quot;,
  &quot;contactbirthday&quot;: &quot;dto.contact.birthday&quot;,
  &quot;donationUTMLink&quot;: &quot;dto.donation.content&quot;,
  &quot;donationStage&quot;: &quot;dto.donation.stage&quot;,
  &quot;membershipAmount&quot;: &quot;dto.membership.amount&quot;,
  &quot;donationAmount&quot;: &quot;dto.donation.amount&quot;,
  &quot;contactCountry&quot;: &quot;dto.contact.country&quot;,
  &quot;donationDate&quot;: {
    &quot;trueValues&quot;: null,
    &quot;format&quot;: &quot;yyyy-MM-dd&quot;,
    &quot;type&quot;: &quot;Date&quot;,
    &quot;disregardBlankValue&quot;: true,
    &quot;trimValue&quot;: true,
    &quot;path&quot;: &quot;dto.donation.date&quot;
  },
  &quot;membershipType&quot;: &quot;dto.membership.type&quot;,
  &quot;donationUTMSource&quot;: &quot;dto.donation.source&quot;,
  &quot;contactPhone&quot;: &quot;dto.contact.phone&quot;,
  &quot;membershipOrigin&quot;: &quot;dto.membership.origin&quot;,
  &quot;membershipLocalVolunteerBranch&quot;: &quot;dto.membership.localVolunteerBranch&quot;
}</value>
    </values>
    <values>
        <field>Is_Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Output__c</field>
        <value xsi:type="xsd:string">contactId,memberNumber,membershipId,donationId,raceiptNumber</value>
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
