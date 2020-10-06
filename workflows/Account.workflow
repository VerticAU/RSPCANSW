<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Estate200days</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Estate</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Estate_Balance__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <description>If Account created date is greater than 200 days and Estate Balance is not Null then a task is triggered for the Estate Administrator Team to update Distributions</description>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_on_distributions</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Account.Account_Created_Date__c</offsetFromField>
            <timeLength>200</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Estate365days</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Estate</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Estate_Received_Till_Date__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <description>If Account created date is greater than 365 days and estate received till date is Null then a task is triggered for the Estate Administrator Team to follow up Probate</description>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Follow_up_Probate_1</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Account.CreatedDate</offsetFromField>
            <timeLength>365</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>Follow_up_Probate_1</fullName>
        <assignedTo>developer+rspcansw@vertic.com.au</assignedTo>
        <assignedToType>user</assignedToType>
        <description>{&quot;Group_Name__c&quot;: &quot;Estate Administration Team&quot;, &quot;Activity_Days__c&quot;: &quot;5&quot;, &quot;Description&quot;: &quot;No payment received in the last one year on the estate, follow up on Probate.&quot;, &quot;WhoId_Field&quot;: &quot;npe01__One2OneContact__c&quot;}</description>
        <dueDateOffset>370</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Account.Account_Created_Date__c</offsetFromField>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Follow up Probate</subject>
    </tasks>
    <tasks>
        <fullName>Update_on_distributio8ns</fullName>
        <assignedTo>developer+rspcansw@vertic.com.au</assignedTo>
        <assignedToType>user</assignedToType>
        <description>{&quot;Group_Name__c&quot;: &quot;Estate Administration Team&quot;, &quot;Activity_Days__c&quot;:&quot;5&quot;, &quot;Description&quot;: &quot;Outstanding payments on related Bequest&quot;, &quot;WhoId_Field&quot;: &quot;npe01__One2OneContact__c&quot;}</description>
        <dueDateOffset>370</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Account.Account_Created_Date__c</offsetFromField>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Update on distributions</subject>
    </tasks>
    <tasks>
        <fullName>Update_on_distributions</fullName>
        <assignedTo>developer+rspcansw@vertic.com.au</assignedTo>
        <assignedToType>user</assignedToType>
        <description>{&quot;Group_Name__c&quot;: &quot;Estate Administration Team&quot;, &quot;Activity_Days__c&quot;:&quot;5&quot;, &quot;Description&quot;: &quot;Outstanding payments on related Bequest&quot;, &quot;WhoId_Field&quot;: &quot;npe01__One2OneContact__c&quot;}</description>
        <dueDateOffset>205</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Account.Account_Created_Date__c</offsetFromField>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Update on distributions</subject>
    </tasks>
</Workflow>
