<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>caseman__Set_Completed_Date</fullName>
        <field>caseman__CompletedDate__c</field>
        <formula>NOW()</formula>
        <name>Set Completed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>caseman__Task Completed</fullName>
        <actions>
            <name>caseman__Set_Completed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR( AND (ISNEW(), ISPICKVAL(Status, &apos;Completed&apos; )), AND (ISCHANGED(Status), ISPICKVAL(Status, &apos;Completed&apos;)) )</formula>
        <triggerType>onAllChanges</triggerType>
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
</Workflow>
