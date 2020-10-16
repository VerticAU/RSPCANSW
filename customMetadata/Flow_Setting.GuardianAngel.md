<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Guardian Angel</label>
    <protected>false</protected>
    <values>
        <field>Flow_API_Name__c</field>
        <value xsi:type="xsd:string">websiteIntegration</value>
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
&quot;giftcontactId&quot; : &quot;dto.contact.id&quot;,



&quot;organisationPhone&quot; : &quot;dto.organisation.phone&quot;,
&quot;organisationCity&quot; : &quot;dto.organisation.city&quot;,
&quot;organisationStreet&quot; : &quot;dto.organisation.street&quot;,
&quot;organisationZIP&quot; : &quot;dto.organisation.postalCode&quot;,
&quot;organisationName&quot; : &quot;dto.organisation.name&quot;,
&quot;organisationWebsite&quot; : &quot;dto.organisation.website&quot;,


&quot;paymentFee&quot;: &quot;dto.payment.fee&quot;,
&quot;paymentTransactionId&quot; : &quot;dto.stripe.paymentId&quot;,
&quot;paypalTransactionId&quot; : &quot;dto.paypal.transactionId&quot;,
&quot;paymentSubscriptionId&quot; : &quot;dto.stripe.subscriptionId&quot;,
&quot;paymentMethod&quot; : &quot;dto.payment.method&quot;,


&quot;donationAmount&quot; : &quot;dto.donation.amount&quot;,
&quot;donationStage&quot;: &quot;dto.donation.stage&quot;,
&quot;donationCloseDate&quot;: {
&quot;trueValues&quot;: null,
&quot;format&quot;: &quot;yyyy-MM-dd&quot;,
&quot;type&quot;: &quot;Date&quot;,
&quot;disregardBlankValue&quot;: true,
&quot;trimValue&quot;: true,
&quot;path&quot;: &quot;dto.donation.date&quot;
},
&quot;donationCampaignCode&quot;: &quot;dto.donation.campaign.code&quot;,
&quot;donationParentCampaignCode&quot;: &quot;dto.donation.campaign.parentCode&quot;,
&quot;donationCampaignFundraiserId&quot;: &quot;dto.donation.campaign.fundraiserId&quot;,
&quot;donationCampaignFundraiserURL&quot;: &quot;dto.donation.campaign.fundraiserURL&quot;,



&quot;utmCampaign&quot;: &quot;dto.utm.campaign&quot;,
&quot;utmSource&quot;: &quot;dto.utm.source&quot;,
&quot;utmAdContent&quot;: &quot;dto.utm.adContent&quot;,
&quot;utmMedium&quot;: &quot;dto.utm.medium&quot;,
&quot;utmTestVariant&quot;: &quot;dto.utm.testVariant&quot;,
  &quot;utmTerm&quot;: &quot;dto.utm.term&quot;,


&quot;giftCampaignCode&quot;: &quot;dto.gift.campaign.code&quot;,
&quot;giftParentCampaignCode&quot;: &quot;dto.gift.campaign.parentCode&quot;,
&quot;giftCampaignFundraiserId&quot;: &quot;dto.gift.campaign.fundraiserId&quot;,
&quot;giftCampaignFundraiserURL&quot;: &quot;dto.gift.campaign.fundraiserURL&quot;,
&quot;giftMessage&quot; : &quot;dto.gift.message&quot;,
&quot;giftAnimalType&quot; : &quot;dto.gift.animalType&quot;,
&quot;giftAnimalName&quot; : &quot;dto.gift.animalName&quot;,
&quot;giftName&quot; : &quot;dto.gift.name&quot;,
&quot;giftAnimaAdoptID&quot; : &quot;dto.gift.id&quot;,
&quot;giftAmount&quot; : &quot;dto.gift.amount&quot;,
&quot;giftFromName&quot; : &quot;dto.gift.fromeName&quot;,



&quot;campaignCode&quot;: &quot;dto.campaign.code&quot;,
&quot;parentCampaignCode&quot;: &quot;dto.campaign.parentCode&quot;,
&quot;fundraiserId&quot;: &quot;dto.campaign.fundraiserId&quot;,
&quot;fundraiserURL&quot;: &quot;dto.campaign.fundraiserURL&quot;



}</value>
    </values>
    <values>
        <field>Is_Active__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
    <values>
        <field>Output__c</field>
        <value xsi:type="xsd:string">giftId,receiptNumber,contactId,donationId</value>
    </values>
    <values>
        <field>Tags__c</field>
        <value xsi:nil="true"/>
    </values>
</CustomMetadata>
