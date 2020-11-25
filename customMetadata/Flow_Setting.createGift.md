<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Create Gift</label>
    <protected>false</protected>
    <values>
        <field>Flow_API_Name__c</field>
        <value xsi:type="xsd:string">websiteIntegration</value>
    </values>
    <values>
        <field>Input__c</field>
        <value xsi:type="xsd:string">{
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
&quot;giftcontactId&quot;: &quot;dto.contact.id&quot;


}</value>
    </values>
    <values>
        <field>Is_Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Output__c</field>
        <value xsi:type="xsd:string">giftId</value>
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
