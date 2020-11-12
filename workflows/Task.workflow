<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Donation Bequest Enquiry Step 2 - Send Bequest Information</fullName>
        <actions>
            <name>Send_Bequest_Information</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Next_Workflow_Name__c</field>
            <operation>equals</operation>
            <value>Enquiry Step 2 Send Bequest Information</value>
        </criteriaItems>
        <description>This is Dependent Task if Task - Donation Bequest Enquiry Step 1 - Call/Email Bequestor completed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Follow_up_Bequestor</fullName>
        <assignedTo>developer+rspcansw@vertic.com.au</assignedTo>
        <assignedToType>user</assignedToType>
        <description>{&quot;Group_Name__c&quot;: &quot;Bequest Administration Team&quot;, &quot;Activity_Days__c&quot;: &quot;5&quot;, &quot;Description&quot;: &quot; Bequest Information sent 14 days ago, follow up required&quot;, &quot;WhoId_Field&quot;: &quot;npsp__Primary_Contact__c&quot;}</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Task.ActivityDate</offsetFromField>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Follow up Bequestor</subject>
    </tasks>
    <tasks>
        <fullName>Send_Bequest_Information</fullName>
        <assignedTo>developer+rspcansw@vertic.com.au</assignedTo>
        <assignedToType>user</assignedToType>
        <description>{&quot;Group_Name__c&quot;: &quot;Bequest Administration Team&quot;, &quot;Activity_Days__c&quot;: &quot;5&quot;, &quot;Description&quot;: &quot; &quot;}</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Send Bequest Information</subject>
    </tasks>
</Workflow>
