<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Clever Contacts</label>
    <protected>false</protected>
    <values>
        <field>Flow_API_Name__c</field>
        <value xsi:type="xsd:string">Clever_Contacts</value>
    </values>
    <values>
        <field>Input__c</field>
        <value xsi:type="xsd:string">{
  &quot;contactCompany&quot; : &quot;dto.contact.company&quot;,
  &quot;recurringDateEstablished&quot; : {
    &quot;trueValues&quot; : null,
    &quot;format&quot; : &quot;yyyy-MM-dd&quot;,
    &quot;type&quot; : &quot;Date&quot;,
    &quot;disregardBlankValue&quot; : true,
    &quot;trimValue&quot; : true,
    &quot;path&quot; : &quot;dto.donation.callDate&quot;
  },
  &quot;contactNewAddress3&quot; : &quot;dto.contact.newAddress3&quot;,
  &quot;contactNewBirthdate&quot; : {
    &quot;trueValues&quot; : null,
    &quot;format&quot; : &quot;yyyy-MM-dd&quot;,
    &quot;type&quot; : &quot;Date&quot;,
    &quot;disregardBlankValue&quot; : true,
    &quot;trimValue&quot; : true,
    &quot;path&quot; : &quot;dto.contact.newDOB&quot;
  },
  &quot;recurringDayOfMonth&quot; : &quot;dto.donation.debitPeriod&quot;,
  &quot;contactNewWorkPhone&quot; : &quot;dto.contact.newWorkPh&quot;,
  &quot;campaignName&quot; : &quot;dto.campaign.appealId&quot;,
  &quot;contactMiddleName&quot; : &quot;dto.contact.middleName&quot;,
  &quot;contactEmail2&quot; : &quot;dto.contact.email2&quot;,
  &quot;contactPostcode&quot; : &quot;dto.contact.postcode&quot;,
  &quot;contactNewAddress2&quot; : &quot;dto.contact.newAddress2&quot;,
&quot;donationCustom010&quot;: &quot;dto.donation.custom010&quot;,
  &quot;recurringStartDate&quot; : {
    &quot;trueValues&quot; : null,
    &quot;format&quot; : &quot;yyyy-MM-dd&quot;,
    &quot;type&quot; : &quot;Date&quot;,
    &quot;disregardBlankValue&quot; : true,
    &quot;trimValue&quot; : true,
    &quot;path&quot; : &quot;dto.donation.debitDate&quot;
  },
  &quot;contactNewPostcode&quot; : &quot;dto.contact.newPostcode&quot;,
  &quot;contactNewEmail&quot; : &quot;dto.contact.newEmail&quot;,
  &quot;contactNewState&quot; : &quot;dto.contact.newState&quot;,
  &quot;contactPosition&quot; : &quot;dto.contact.position&quot;,
  &quot;contactNewSuburb&quot; : &quot;dto.contact.newSuburb&quot;,
  &quot;contactHomePhone&quot; : &quot;dto.contact.homePh&quot;,
  &quot;contactEmail1&quot; : &quot;dto.contact.email1&quot;,
  &quot;contactNewTitle&quot; : &quot;dto.contact.newTitle&quot;,
  &quot;stripeSubscriptionId&quot; : &quot;dto.donation.CCToken&quot;,
  &quot;contactBirthdate&quot; : {
    &quot;trueValues&quot; : null,
    &quot;format&quot; : &quot;yyyy-MM-dd&quot;,
    &quot;type&quot; : &quot;Date&quot;,
    &quot;disregardBlankValue&quot; : true,
    &quot;trimValue&quot; : true,
    &quot;path&quot; : &quot;dto.contact.DOB&quot;
  },
  &quot;contactAddress3&quot; : &quot;dto.contact.address3&quot;,
  &quot;contactNewMobilePhone&quot; : &quot;dto.contact.newMobilePh&quot;,
  &quot;contactAddress2&quot; : &quot;dto.contact.address2&quot;,
  &quot;contactFirstName&quot; : &quot;dto.contact.firstName&quot;,
  &quot;contactNewAddress1&quot; : &quot;dto.contact.newAddress1&quot;,
  &quot;recurringAmount&quot; : &quot;dto.donation.RGAmount&quot;,
  &quot;contactLastName&quot; : &quot;dto.contact.surname&quot;,
  &quot;contactWorkPhone&quot; : &quot;dto.contact.workPh&quot;,
  &quot;recurringDebitPeriod&quot; : &quot;dto.donation.frequency&quot;,
  &quot;contactSuburb&quot; : &quot;dto.contact.suburb&quot;,
  &quot;contactAddress1&quot; : &quot;dto.contact.address1&quot;,
  &quot;contactNewFirstName&quot; : &quot;dto.contact.newFirstName&quot;,
  &quot;contactNewLastName&quot; : &quot;dto.contact.newSurname&quot;,
  &quot;contactNewOtherPhone&quot; : &quot;dto.contact.newOtherPh&quot;,
  &quot;contactNewHomePhone&quot; : &quot;dto.contact.newHomePh&quot;,
  &quot;contactState&quot; : &quot;dto.contact.state&quot;,
  &quot;contactNewMiddleName&quot; : &quot;dto.contact.newMiddleName&quot;,
  &quot;contactURN&quot; : &quot;dto.contact.URN&quot;,
  &quot;recurringPaymentMethod&quot; : &quot;dto.donation.paymentMethod&quot;
}</value>
    </values>
    <values>
        <field>Is_Active__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
    <values>
        <field>Output__c</field>
        <value xsi:type="xsd:string">paymentId,contactId,donationId,recurringId</value>
    </values>
    <values>
        <field>Tags__c</field>
        <value xsi:nil="true"/>
    </values>
</CustomMetadata>
