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
  
  &quot;contactFirstName&quot; : &quot;dto.contact.firstName&quot;,
  &quot;contactEmail&quot; : &quot;dto.contact.email&quot;,
  &quot;contactStreet&quot; : &quot;dto.contact.street&quot;,
  &quot;contactCountry&quot; : &quot;dto.contact.country&quot;,
  &quot;contactPostalCode&quot; : &quot;dto.contact.postalCode&quot;,	
  &quot;contactState&quot; : &quot;dto.contact.state&quot;,
  &quot;contactCity&quot; : &quot;dto.contact.city&quot;,
  &quot;contactLastName&quot; : &quot;dto.contact.lastName&quot;,
  &quot;contactPhone&quot; : &quot;dto.contact.phone&quot;,
  
 
  &quot;recurringType&quot; : &quot;dto.recurring.type&quot;,
  &quot;recurringDayOfMonth&quot; : &quot;dto.recurring.dayOfMonth&quot;,
  &quot;recurringDonationAmount&quot; : &quot;dto.recurring.amount&quot;,
  &quot;recurringInstallmentFrequency&quot; : &quot;dto.recurring.installmentFrequency&quot;,
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
  &quot;recurringDateEstablished&quot; : {
    &quot;trueValues&quot; : null,
    &quot;format&quot; : &quot;yyyy-MM-dd&quot;,
    &quot;type&quot; : &quot;Date&quot;,
    &quot;disregardBlankValue&quot; : true,
    &quot;trimValue&quot; : true,
    &quot;path&quot; : &quot;dto.recurring.dateEstablished&quot;
  },
  
  
  &quot;giftFromName&quot; : &quot;dto.gift.fromeName&quot;,
  &quot;giftAnimalType&quot; : &quot;dto.gift.animalType&quot;,
  &quot;giftAnimaAdoptID&quot; : &quot;dto.gift.id&quot;,
  &quot;giftAnimalName&quot; : &quot;dto.gift.animalName&quot;,
  &quot;giftAmount&quot; : &quot;dto.gift.amount&quot;,
  &quot;giftMessage&quot; : &quot;dto.gift.message&quot;,


  &quot;utmCampaign&quot;: &quot;dto.utm.campaign&quot;,
  &quot;utmSource&quot;: &quot;dto.utm.source&quot;,
&quot;utmAdContent&quot;: &quot;dto.utm.adContent&quot;,
&quot;utmMedium&quot;: &quot;dto.utm.medium&quot;,
&quot;utmTestVariant&quot;: &quot;dto.utm.testVariant&quot;,

&quot;campaignCode&quot;: &quot;dto.campaign.code&quot;,
&quot;parentCampaignCode&quot;: &quot;dto.campaign.parentCode&quot;,
&quot;campaignFundraiserId&quot;: &quot;dto.campaign.fundraiserId&quot;,
&quot;campaignFundraiserURL&quot;: &quot;dto.campaign.fundraiserURL&quot;,


  &quot;donationReceiptNumber&quot; : &quot;dto.donation.raceiptNumber&quot;,
  

&quot;paymentFee&quot;: &quot;dto.payment.fee&quot;,
  &quot;paypalTransactionId&quot; : &quot;dto.paypal.transactionId&quot;,
  &quot;paymentSubscriptionId&quot; : &quot;dto.stripe.subscriptionId&quot;
}</value>
    </values>
    <values>
        <field>Is_Active__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
    <values>
        <field>Output__c</field>
        <value xsi:type="xsd:string">contactId,giftId,raceiptNumber,recurringId,donationId</value>
    </values>
    <values>
        <field>Tags__c</field>
        <value xsi:nil="true"/>
    </values>
</CustomMetadata>
