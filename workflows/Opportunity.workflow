<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>npsp__Opportunity_Email_Acknowledgment</fullName>
        <description>Opportunity Email Acknowledgment</description>
        <protected>false</protected>
        <recipients>
            <field>npsp__Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>npsp__NPSP_Email_Templates/npsp__NPSP_Opportunity_Acknowledgment</template>
    </alerts>
    <fieldUpdates>
        <fullName>npsp__Opportunity_AcknowledgmentStatus_Update</fullName>
        <description>Sets the Acknowledgment Status to &quot;Acknowledged&quot;</description>
        <field>npsp__Acknowledgment_Status__c</field>
        <literalValue>Acknowledged</literalValue>
        <name>Opportunity Acknowledgment Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npsp__Opportunity_Acknowledgment_Date_Update</fullName>
        <description>sets the Acknowledgment Date to Today.</description>
        <field>npsp__Acknowledgment_Date__c</field>
        <formula>Today()</formula>
        <name>Opportunity Acknowledgment Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npsp__Opportunity_Copy_FMV_to_Amount</fullName>
        <description>Copy the Opportunities Fair Market Value field to the Amount field.</description>
        <field>Amount</field>
        <formula>npsp__Fair_Market_Value__c</formula>
        <name>Opportunity Copy FMV to Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Check Paperwork is received</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Bequest</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Paperwork_Received__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <description>90 days after all payments have been received on the Bequest Opportunity, if Paperwork received box is unchecked</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Check_Paperwork_Received_checkbox</name>
                <type>Task</type>
            </actions>
            <timeLength>90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Corporate Sponsorship stage %3D Proposal%2FReview</fullName>
        <actions>
            <name>Send_Proposal</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Sponsorship</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Proposal/Review</value>
        </criteriaItems>
        <description>When Corporate Sponsorship is in Proposal stage</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Donation %3D %3E %24200 to a CCD fundraiser</fullName>
        <actions>
            <name>Thank_CCD_Donor</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Donation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>greaterOrEqual</operation>
            <value>200</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Campaing_Id_Include_CCD__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Contact donates = &gt; $200 that is attributed to Fundraiser Campaign where ParentID contains Cupcake Day</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Donation Amount %3E%3D%241000</fullName>
        <actions>
            <name>Major_Donor_Thank_you_Call</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Primary_Contact_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Primary_Contact_Phone__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>greaterOrEqual</operation>
            <value>1000</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Donation</value>
        </criteriaItems>
        <description>Donation with Amount &gt;=$1000</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Donation Amount is greater than %24500 but less than %24999</fullName>
        <actions>
            <name>Call_Donor</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND (3 OR 4) AND 5</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>greaterThan</operation>
            <value>500</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>lessOrEqual</operation>
            <value>999</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Primary_Contact_Do_Not_Call__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Primary_Contact_Do_Not_Contact__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Donation</value>
        </criteriaItems>
        <description>IF( AND( Amount &gt;= 500, Amount &lt;= 999 ) AND npsp__Primary_Contact__r.DoNotCall = FALSE OR npsp__Primary_Contact__r.Do_Not_Contact__c = FALSE</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Donation amount is twice the largest gift</fullName>
        <actions>
            <name>Call_Donor_2</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Primary_Contact_Email__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Primary_Contact_Do_Not_Call__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Primary_Contact_2xLargest_Amount__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>In a single transaction when Contact(Donor) donates twice the amount of the largest gift</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Donation is amount double then last gift amount</fullName>
        <actions>
            <name>Email_Donor</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Amount_x2_the_last_gift__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Primary_Contact_Has_Opt_Out_Of_Email__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Primary_Contact_Email__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>In a single transaction when Contact(donor) donates twice the amount of their last gift</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>First donation for Contact</fullName>
        <actions>
            <name>Send_Welcome_Pack</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Is_This_First_Donation__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Donation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <description>For a contact when the first Opportunity of record type Donation is created and stage = Closed won</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Membership Enrolled</fullName>
        <actions>
            <name>Send_HEA_Welcome_Pack</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Membership</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Membership_Type__c</field>
            <operation>equals</operation>
            <value>Home Ever After</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Enrolled</value>
        </criteriaItems>
        <description>When Home Ever After Membership is confirmed a task should be triggered for the Bequest Administration Team to send Welcome Pack to the contact</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Membership Renewal</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Membership</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>OppEstateAccountCreatedDateGreater_200</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Estate</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Sum_Bequest_Opp_Amount_Outstanding__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_on_distributions</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Opportunity.Account_Created_Date__c</offsetFromField>
            <timeLength>200</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>OppEstateAccountCreatedDateGreater_365</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Estate</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Sum_Bequest_Opp_Payments_Made__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <timeLength>365</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Send Bequest Welcome Pack With Email</fullName>
        <actions>
            <name>Thank_you_Call_Email_to_Bequestor</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND (3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Bequest</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Pledged</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Primary_Contact_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Primary_Contact_Phone__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>When bequest is confirmed and the primary contact has either an email address or phone number then a Thank you call/email task should be created for the estate administration Queue. When this task status changes to Completed then a new task should be crea</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Bequest Welcome Pack Without Email</fullName>
        <actions>
            <name>Send_Welcome_Pack_2</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 3 AND 4) OR 5</booleanFilter>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Bequest</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Pledged</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Primary_Contact_Email__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Primary_Contact_Phone__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Run_Workflow_Rule_With_Name__c</field>
            <operation>equals</operation>
            <value>Send_Bequest_Welcome_Pack_Without_Email</value>
        </criteriaItems>
        <description>When bequest is confirmed and the primary contact has either an email address or phone number then a Thank you call/email task should be created for the estate administration Queue. When this task status changes to Completed then a new task should be crea</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Thank you call for awarded Grant</fullName>
        <actions>
            <name>Thank_you_Call</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Grant</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Awarded</value>
        </criteriaItems>
        <description>For opportunity record type = Grant when stage = Awarded create task for Grants Team</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>days 7 after corporate Sponsorship stage %3D Prospecting</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Sponsorship</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Prospecting</value>
        </criteriaItems>
        <description>When an corporate sponsorship is prospecting  tasks are triggered for the corporate relationship team to manage relationship with the corporate partner</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Check_in_with_Partner</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Opportunity.CreatedDate</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>npsp__Opportunity Copy FMV to Amount</fullName>
        <actions>
            <name>npsp__Opportunity_Copy_FMV_to_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND (3 AND 4)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.npsp__Fair_Market_Value__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.npsp__Fair_Market_Value__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Enable this rule to copy the Fair Market Value to the Amount field, when the Amount is zero or blank.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>npsp__Opportunity Email Acknowledgment</fullName>
        <actions>
            <name>npsp__Opportunity_Email_Acknowledgment</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>npsp__Opportunity_AcknowledgmentStatus_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>npsp__Opportunity_Acknowledgment_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Emails an acknowledgement to the Primary Contact for an Opportunity when the Acknowledgement Status is set to Email Acknowledgement Now.</description>
        <formula>TEXT(npsp__Acknowledgment_Status__c) = $Label.npsp__sendAcknowledgmentFireStatus &amp;&amp;  npsp__Primary_Contact__r.Email &lt;&gt; NULL &amp;&amp;  npsp__Primary_Contact__r.npsp__Do_Not_Contact__c &lt;&gt; True &amp;&amp;  npsp__Primary_Contact__r.HasOptedOutOfEmail &lt;&gt; True &amp;&amp;  npsp__Primary_Contact__r.npsp__Deceased__c &lt;&gt; True</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Call_Donor</fullName>
        <assignedTo>developer+rspcansw@vertic.com.au</assignedTo>
        <assignedToType>user</assignedToType>
        <description>{&quot;Group_Name__c&quot;: &quot;Support Coordinator Team&quot;, &quot;Activity_Days__c&quot;: &quot;5&quot;, &quot;Description&quot;: &quot;One-Off donation amount greater than $500 less than $999&quot;, &quot;WhoId_Field&quot;: &quot;npsp__Primary_Contact__c&quot;}</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Call Donor</subject>
    </tasks>
    <tasks>
        <fullName>Call_Donor_2</fullName>
        <assignedTo>developer+rspcansw@vertic.com.au</assignedTo>
        <assignedToType>user</assignedToType>
        <description>{&quot;Group_Name__c&quot;: &quot;Support Coordinator Team&quot;, &quot;Activity_Days__c&quot;: &quot;5&quot;, &quot;Description&quot;: &quot;One-Off donation amount double the largest gift amount&quot;, &quot;WhoId_Field&quot;: &quot;npsp__Primary_Contact__c&quot;}</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Call Donor</subject>
    </tasks>
    <tasks>
        <fullName>Check_Paperwork_Received_checkbox</fullName>
        <assignedTo>developer+rspcansw@vertic.com.au</assignedTo>
        <assignedToType>user</assignedToType>
        <description>{&quot;Group_Name__c&quot;: &quot;Estate Administration Team&quot;, &quot;Activity_Days__c&quot;: &quot;5&quot;, &quot;Description&quot;: &quot;90 days since all payments received and Bequest closed please ensure all paperwork is received.&quot;, &quot;WhoId_Field&quot;: &quot;npsp__Primary_Contact__c&quot;}</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Check Paperwork Received checkbox</subject>
    </tasks>
    <tasks>
        <fullName>Check_Paperwork_Received_checkbox_test</fullName>
        <assignedTo>developer+rspcansw@vertic.com.au</assignedTo>
        <assignedToType>user</assignedToType>
        <description>{&quot;WorkflowName&quot;: &quot;OpportunityWorkflow&quot;, &quot;GroupOwnerName&quot;: &quot;Estate Administration Team&quot;, &quot;ActivityDays&quot;:&quot;5&quot;, &quot;Description&quot;: &quot;90 days since all payments received and Bequest closed please ensure all paperwork is received.&quot;}</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Check Paperwork Received checkbox</subject>
    </tasks>
    <tasks>
        <fullName>Check_in_with_Partner</fullName>
        <assignedTo>developer+rspcansw@vertic.com.au</assignedTo>
        <assignedToType>user</assignedToType>
        <description>{&quot;Group_Name__c&quot;: &quot;Corporate Relationships Team&quot;, &quot;Activity_Days__c&quot;: &quot;5&quot;, &quot;Description&quot;: &quot;Sponsorship is still in Prospecting status please check-in with Partner&quot;, &quot;WhoId_Field&quot;: &quot;npsp__Primary_Contact__c&quot;}</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.npsp__Acknowledgment_Date__c</offsetFromField>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Check-in with Partner</subject>
    </tasks>
    <tasks>
        <fullName>Check_in_with_Partner_test</fullName>
        <assignedTo>developer+rspcansw@vertic.com.au</assignedTo>
        <assignedToType>user</assignedToType>
        <description>{&quot;Group_Name__c&quot;: &quot;Corporate Relationships Team&quot;, &quot;Activity_Days__c&quot;: &quot;5&quot;, &quot;Description&quot;: &quot;Sponsorship is still in Prospecting status please check-in with Partner&quot;, &quot;WhoId_Field&quot;: &quot;npsp__Primary_Contact__c&quot;}</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.Account_Created_Date__c</offsetFromField>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Check-in with Partner test</subject>
    </tasks>
    <tasks>
        <fullName>Email_Donor</fullName>
        <assignedTo>developer+rspcansw@vertic.com.au</assignedTo>
        <assignedToType>user</assignedToType>
        <description>{&quot;Group_Name__c&quot;: &quot;Support Coordinator Team&quot;, &quot;Activity_Days__c&quot;: &quot;5&quot;, &quot;Description&quot;: &quot;One-Off donation amount double the last gift amount&quot;, &quot;WhoId_Field&quot;: &quot;npsp__Primary_Contact__c&quot;}</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Email Donor</subject>
    </tasks>
    <tasks>
        <fullName>Major_Donor_Thank_you_Call</fullName>
        <assignedTo>developer+rspcansw@vertic.com.au</assignedTo>
        <assignedToType>user</assignedToType>
        <description>{&quot;Group_Name__c&quot;: &quot;Major Giving Team&quot;, &quot;Activity_Days__c&quot;: &quot;5&quot;, &quot;Description&quot;: &quot;Donor has donated $1000 or more in a single transaction&quot;, &quot;WhoId_Field&quot;: &quot;npsp__Primary_Contact__c&quot;}</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Major Donor Thank you Call</subject>
    </tasks>
    <tasks>
        <fullName>Pending_Bequest</fullName>
        <assignedTo>developer+rspcansw@vertic.com.au</assignedTo>
        <assignedToType>user</assignedToType>
        <description>{&quot;WorkflowName&quot;: &quot;OpportunityWorkflow&quot;, &quot;GroupOwnerName&quot;: &quot;Estate Administration Team&quot;, &quot;ActivityDays&quot;:&quot;5&quot;, &quot;Description&quot;: &quot;A year since Bequestor marked deceased, please update the Bequest&quot;}</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Pending Bequest</subject>
    </tasks>
    <tasks>
        <fullName>Send_HEA_Welcome_Pack</fullName>
        <assignedTo>developer+rspcansw@vertic.com.au</assignedTo>
        <assignedToType>user</assignedToType>
        <description>{&quot;Group_Name__c&quot;: &quot;Bequest Administration Team&quot;, &quot;Activity_Days__c&quot;: &quot;5&quot;, &quot;Description&quot;: &quot;&quot;, &quot;WhoId_Field&quot;: &quot;npsp__Primary_Contact__c&quot;}</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Send HEA Welcome Pack</subject>
    </tasks>
    <tasks>
        <fullName>Send_Proposal</fullName>
        <assignedTo>developer+rspcansw@vertic.com.au</assignedTo>
        <assignedToType>user</assignedToType>
        <description>{&quot;Group_Name__c&quot;: &quot;Corporate Relationships Team&quot;, &quot;Activity_Days__c&quot;: &quot;5&quot;, &quot;Description&quot;: &quot;Send sponsorship proposal for upcoming campaign&quot;, &quot;WhoId_Field&quot;: &quot;npsp__Primary_Contact__c&quot;}</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Send Proposal</subject>
    </tasks>
    <tasks>
        <fullName>Send_Welcome_Pack</fullName>
        <assignedTo>developer+rspcansw@vertic.com.au</assignedTo>
        <assignedToType>user</assignedToType>
        <description>{&quot;Group_Name__c&quot;: &quot;Support Coordinator Team&quot;, &quot;Activity_Days__c&quot;: &quot;5&quot;, &quot;Description&quot;: &quot;First One Off Donation&quot;, &quot;WhoId_Field&quot;: &quot;npsp__Primary_Contact__c&quot;}</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Send Welcome Pack</subject>
    </tasks>
    <tasks>
        <fullName>Send_Welcome_Pack_2</fullName>
        <assignedTo>developer+rspcansw@vertic.com.au</assignedTo>
        <assignedToType>user</assignedToType>
        <description>{&quot;Group_Name__c&quot;: &quot;Bequest Administration Team&quot;, &quot;Activity_Days__c&quot;: &quot;5&quot;, &quot;Description&quot;: &quot;Bequest has been confirmed please send welcome pack&quot;, &quot;WhoId_Field&quot;: &quot;npsp__Primary_Contact__c&quot;}</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Send Welcome Pack</subject>
    </tasks>
    <tasks>
        <fullName>Test</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Test</subject>
    </tasks>
    <tasks>
        <fullName>Thank_CCD_Donor</fullName>
        <assignedTo>developer+rspcansw@vertic.com.au</assignedTo>
        <assignedToType>user</assignedToType>
        <description>{&quot;Group_Name__c&quot;: &quot;Corporate Fundraising Team&quot;, &quot;Activity_Days__c&quot;: &quot;5&quot;, &quot;Description&quot;: &quot;Donor has donated $200 or more to a CCD fundraiser &quot;, &quot;WhoId_Field&quot;: &quot;npsp__Primary_Contact__c&quot;}</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Thank CCD Donor</subject>
    </tasks>
    <tasks>
        <fullName>Thank_you_Call</fullName>
        <assignedToType>owner</assignedToType>
        <description>{&quot;Activity_Days__c&quot;: &quot;5&quot;, &quot;Description&quot;: &quot;Grant Awarded&quot;, &quot;Skip_WhoId__c&quot;: &quot;true&quot;}</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Thank you Call</subject>
    </tasks>
    <tasks>
        <fullName>Thank_you_Call_Email_to_Bequestor</fullName>
        <assignedTo>developer+rspcansw@vertic.com.au</assignedTo>
        <assignedToType>user</assignedToType>
        <description>{&quot;Group_Name__c&quot;: &quot;Bequest Administration Team&quot;, &quot;Activity_Days__c&quot;: &quot;5&quot;, &quot;Description&quot;: &quot;Bequest has been confirmed please call/email Bequestor&quot;, &quot;Depended_Task_Name__c&quot;: &quot;Send_Bequest_Welcome_Pack&quot;, &quot;WhoId_Field&quot;: &quot;npsp__Primary_Contact__c&quot;}</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Thank you Call/Email to Bequestor</subject>
    </tasks>
    <tasks>
        <fullName>Update_on_distributions</fullName>
        <assignedTo>developer+rspcansw@vertic.com.au</assignedTo>
        <assignedToType>user</assignedToType>
        <description>{&quot;WorkflowName&quot;: &quot;AccountWorkflow200&quot;, &quot;GroupOwnerName&quot;: &quot;Estate Administration Team&quot;, &quot;ActivityDate&quot;:&quot;5&quot;, &quot;Description&quot;: &quot;Outstanding payments on related Bequest&quot;}</description>
        <dueDateOffset>205</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.Account_Created_Date__c</offsetFromField>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Update on distributions</subject>
    </tasks>
</Workflow>
