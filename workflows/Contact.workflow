<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>GW_Volunteers__Volunteer_Signup_Notification_Email_Alert_Contact</fullName>
        <description>Volunteer Signup Notification Email Alert - Contact</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GW_Volunteers__Volunteers_Email_Templates/GW_Volunteers__Volunteer_Signup_Notification</template>
    </alerts>
    <alerts>
        <fullName>GW_Volunteers__Volunteer_Signup_Thank_You_Email_Alert_Contact</fullName>
        <description>Volunteer Signup Thank You Email Alert - Contact</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GW_Volunteers__Volunteers_Email_Templates/GW_Volunteers__Volunteer_Signup_Thank_You</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Create_New2Task_For_Birthday_Card</fullName>
        <field>Create_New_Task_For_Birthday_Card__c</field>
        <literalValue>1</literalValue>
        <name>Update Create New Task For Birthday Card</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Create_New_Task_False</fullName>
        <field>Create_New_Task_For_Birthday_Card__c</field>
        <literalValue>0</literalValue>
        <name>Update Create New Task For Birthday Card</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Create_New_Task_For_Birthda2</fullName>
        <field>Create_New_Task_For_Birthday_Card__c</field>
        <literalValue>0</literalValue>
        <name>Update Create New Task For Birthday Card</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Create_New_Task_For_Birthday</fullName>
        <description>Update Create New Task For Birthday Card After 15days</description>
        <field>Create_New_Task_For_Birthday_Card__c</field>
        <literalValue>0</literalValue>
        <name>Update Create New Task For Birthday Card</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Create_New_Task_For_Birthday_Card</fullName>
        <field>Create_New_Task_For_Birthday_Card__c</field>
        <literalValue>1</literalValue>
        <name>Update Create New Task For Birthday Card</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>caseman__Clear_Watch_List_Date</fullName>
        <field>caseman__WatchListDate__c</field>
        <name>Clear Watch List Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>caseman__Set_Watch_List_Date</fullName>
        <field>caseman__WatchListDate__c</field>
        <formula>TODAY()</formula>
        <name>Set Watch List Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>caseman__Update_Preferred_Phone_Number</fullName>
        <field>caseman__PreferredPhoneNumber__c</field>
        <formula>IF( ISPICKVAL(caseman__PreferredPhoneField__c, &apos;Home Phone&apos;),  HomePhone,
IF( ISPICKVAL(caseman__PreferredPhoneField__c, &apos;Phone&apos;),    Phone,
IF( ISPICKVAL(caseman__PreferredPhoneField__c, &apos;Mobile Phone&apos;),    MobilePhone,
IF( ISPICKVAL(caseman__PreferredPhoneField__c, &apos;Other Phone&apos;),  OtherPhone , caseman__PreferredPhoneNumber__c))))</formula>
        <name>Update Preferred Phone Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__ContactAlternateEmailUpdate</fullName>
        <field>npe01__AlternateEmail__c</field>
        <formula>Email</formula>
        <name>Contact.AlternateEmail.Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__ContactHomePhoneUpdate</fullName>
        <field>HomePhone</field>
        <formula>Phone</formula>
        <name>Contact.HomePhone.Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__ContactMobilePhoneUpdate</fullName>
        <field>MobilePhone</field>
        <formula>Phone</formula>
        <name>Contact.MobilePhone.Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__ContactOtherEmailUpdate</fullName>
        <field>OtherPhone</field>
        <formula>Phone</formula>
        <name>Contact.OtherEmail.Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__ContactPersonalEmailUpdate</fullName>
        <field>npe01__HomeEmail__c</field>
        <formula>Email</formula>
        <name>Contact.PersonalEmail.Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__ContactPreferredEmail</fullName>
        <field>Email</field>
        <formula>CASE( 
npe01__Preferred_Email__c , 

&quot;Work&quot;, 
if(len(npe01__WorkEmail__c)&gt;0, npe01__WorkEmail__c, 
if(len(npe01__HomeEmail__c)&gt;0, npe01__HomeEmail__c, 
npe01__AlternateEmail__c)), 

&quot;Personal&quot;, 
if(len(npe01__HomeEmail__c)&gt;0, npe01__HomeEmail__c, 
if(len(npe01__WorkEmail__c)&gt;0, npe01__WorkEmail__c, 
npe01__AlternateEmail__c)), 

&quot;Home&quot;, 
if(len(npe01__HomeEmail__c)&gt;0, npe01__HomeEmail__c, 
if(len(npe01__WorkEmail__c)&gt;0, npe01__WorkEmail__c, 
npe01__AlternateEmail__c)), 

&quot;Alternate&quot;, 
if(len(npe01__AlternateEmail__c)&gt;0, npe01__AlternateEmail__c, 
if(len(npe01__WorkEmail__c)&gt;0, npe01__WorkEmail__c, 
npe01__HomeEmail__c)), 

If(LEN(npe01__WorkEmail__c)&gt;0 , npe01__WorkEmail__c , 
if(LEN( npe01__HomeEmail__c)&gt;0, npe01__HomeEmail__c, 
npe01__AlternateEmail__c 
)))</formula>
        <name>Contact.PreferredEmail</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__ContactPreferredPhone</fullName>
        <description>Populates the standard Phone field displayed on activities based on the Preferred Phone field value.</description>
        <field>Phone</field>
        <formula>CASE(
  npe01__PreferredPhone__c ,
&quot;Work&quot;,
  npe01__WorkPhone__c  ,
&quot;Home&quot;,
 HomePhone,
&quot;Mobile&quot;,
 MobilePhone,
&quot;Other&quot;,
 OtherPhone,
If(LEN( npe01__WorkPhone__c )&gt;0 , npe01__WorkPhone__c  ,
if(LEN(  HomePhone)&gt;0,  HomePhone,
if(LEN( MobilePhone)&gt;0, MobilePhone,
OtherPhone
))))</formula>
        <name>Contact.PreferredPhone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__ContactWorkEmailUpdate</fullName>
        <field>npe01__WorkEmail__c</field>
        <formula>Email</formula>
        <name>Contact.WorkEmail.Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__ContactWorkPhoneUpdate</fullName>
        <field>npe01__WorkPhone__c</field>
        <formula>Phone</formula>
        <name>Contact.WorkPhone.Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__PreferredPhonetoWork</fullName>
        <field>npe01__PreferredPhone__c</field>
        <literalValue>Work</literalValue>
        <name>Preferred Phone to Work</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__SetPrefEmailtoWork</fullName>
        <field>npe01__Preferred_Email__c</field>
        <literalValue>Work</literalValue>
        <name>Set Pref Email to Work</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__SetWorkEmailtoEmail</fullName>
        <field>npe01__WorkEmail__c</field>
        <formula>Email</formula>
        <name>Set Work Email to Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__WorkPhonetoPhone</fullName>
        <field>npe01__WorkPhone__c</field>
        <formula>Phone</formula>
        <name>Work Phone to Phone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npo02__ContactPreferredPhone_WithHousehold</fullName>
        <description>FOR USE WITH HOUSEHOLDS. Populates the standard Phone field displayed on activities based on the Preferred Phone field value.</description>
        <field>Phone</field>
        <formula>CASE( 
npe01__PreferredPhone__c , 
&quot;Work&quot;, 
npe01__WorkPhone__c , 
&quot;Household&quot;,
 npo02__Formula_HouseholdPhone__c ,
&quot;Home&quot;, 
HomePhone, 
&quot;Personal&quot;,
HomePhone,
&quot;Mobile&quot;, 
MobilePhone, 
&quot;Other&quot;, 
OtherPhone, 
If(LEN( npe01__WorkPhone__c )&gt;0 , npe01__WorkPhone__c , 
if(LEN( HomePhone)&gt;0, HomePhone, 
if(LEN( MobilePhone)&gt;0, MobilePhone, 
OtherPhone 
))))</formula>
        <name>Contact.PreferredPhone_WithHousehold</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>10 Days Before Birthday Send Birthday Card To Contact</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Contact.npsp__Deceased__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Birthdate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Create_New_Task_For_Birthday_Card__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>When the TODAY() is 10 days before the contact date of birth, create task to send birthday card</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Create_New_Task_For_Birthday</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Send_Birthday_Card_Before_10_days</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Contact.Date_To_Send_Birthday_Card__c</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>14 Days Before Contact Birthday With Bequest Pledged Opportunity Send Card To Contact</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Bequest_Pledged_Opportunity_Id__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.npsp__Deceased__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Create_New_Task_For_Birthday_Card__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Create_New_Task_For_Birthday_Card</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Send_Birthday_Card</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Contact.Date_To_Send_Birthday_Card__c</offsetFromField>
            <timeLength>-2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Bequest 365 days after contact deceased</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Contact.npsp__Deceased__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Bequest_Pledged_Opportunity_Id__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Count_Estate_Account_With_Deceased__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <description>365 days since Contact (with Bequest) marked deceased, if there is no Estate created then create a task for Estate Administration Team</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Pending_Bequest</name>
                <type>Task</type>
            </actions>
            <timeLength>365</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Delay 16 Days To Create New Workflow Send Birthday Card to Contact</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Create_New_Task_For_Birthday_Card__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Delay 16 Days To Recurring Send Birthday Card To Contact</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Create_New_Task_False</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>16</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Donor Anniversary Has Email</fullName>
        <actions>
            <name>Send_Donor_Anniversary_Email</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3) AND 4</booleanFilter>
        <criteriaItems>
            <field>Contact.npsp_plus__Years_of_Support__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.npe01__HomeEmail__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.npe01__WorkEmail__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.HasOptedOutOfEmail</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>If email address on contact record is not null then on the anniversary (one year since first gift) create task for Support Coordinator Team</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Donor Anniversary Hasn%27t Email</fullName>
        <actions>
            <name>Donor_Anniversary_Mail</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.npsp_plus__Years_of_Support__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.npe01__HomeEmail__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.npe01__WorkEmail__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.HasOptedOutOfEmail</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>If email address on contact record is null then on the anniversary (one year since first gift) create a task on contact so supporter care officer can post a letter detailing their impact over the years</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Notification to Estate Team</fullName>
        <active>true</active>
        <formula>npsp__Deceased__c  = TRUE</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GW_Volunteers__Volunteer Signup - Contact</fullName>
        <actions>
            <name>GW_Volunteers__Volunteer_Signup_Notification_Email_Alert_Contact</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>GW_Volunteers__Volunteer_Signup_Thank_You_Email_Alert_Contact</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>GW_Volunteers__Volunteer_Signup_Thank_You_Sent_Contact</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>When a contact is updated or created from VolunteersSignup(FS) or VolunteersJobListing(FS), thank them and notify the volunteer manager.  Note if you are not using VolunteersSignup(FS), you can de-activate this rule to avoid multiple emails being sent.</description>
        <formula>GW_Volunteers__Volunteer_Last_Web_Signup_Date__c =  TODAY()</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Recurring Donation Status marked Lapsed 2years ago and makes a new donation</fullName>
        <actions>
            <name>Thank_youCall</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>Check if Donor has a RD

IF RD status = Lapsed check months since lapsed if greater than 24 months 

Then create the task</description>
        <formula>AND(Date_Status_Lapsed__c  &gt;  (TODAY() - 730), Last_Opportunity_Id__c  &lt;&gt; &apos;&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>caseman__Contact Phone Changed</fullName>
        <actions>
            <name>caseman__Update_Preferred_Phone_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>OR( ISCHANGED( caseman__PreferredPhoneField__c ), ISCHANGED( caseman__PreferredPhoneNumber__c ), ISCHANGED( Phone ), ISCHANGED(  HomePhone  ), ISCHANGED(  MobilePhone  ), ISCHANGED(  OtherPhone  ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>caseman__Watch List Checked</fullName>
        <actions>
            <name>caseman__Set_Watch_List_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.caseman__WatchList__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>caseman__Watch List Unchecked</fullName>
        <actions>
            <name>caseman__Clear_Watch_List_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.caseman__WatchList__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>npe01__Contact%2EEmailChanged_Alternate</fullName>
        <actions>
            <name>npe01__ContactAlternateEmailUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If the standard Email field is newly entered or changed AND the Preferred Email picklist is set to Alternate THEN Salesforce will fill in the Alternate Email field with the email address entered in the standard Email field.</description>
        <formula>AND(      ISPICKVAL( npe01__Preferred_Email__c ,&quot;Alternate&quot;),      OR(           AND(                ISNEW(),                LEN(Email)&gt;0           ),           ISCHANGED( Email )      ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>npe01__Contact%2EEmailChanged_Personal</fullName>
        <actions>
            <name>npe01__ContactPersonalEmailUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If the standard Email field is newly entered or changed AND the Preferred Email picklist is set to Personal or Home THEN Salesforce will fill in the Personal Email field with the email address entered in the standard Email field.</description>
        <formula>AND(     OR( ISPICKVAL( npe01__Preferred_Email__c ,&quot;Personal&quot;),ISPICKVAL( npe01__Preferred_Email__c ,&quot;Home&quot;)),      OR(           AND(                ISNEW(),                LEN(Email)&gt;0           ),           ISCHANGED( Email )      ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>npe01__Contact%2EEmailChanged_Work</fullName>
        <actions>
            <name>npe01__ContactWorkEmailUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If the standard Email field is newly entered or changed AND the Preferred Email picklist is set to Work THEN Salesforce will fill in the Work Email field with the email address entered in the standard Email field.</description>
        <formula>AND(      ISPICKVAL( npe01__Preferred_Email__c ,&quot;Work&quot;),      OR(           AND(                ISNEW(),                LEN(Email)&gt;0           ),           ISCHANGED( Email )      ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>npe01__Contact%2EPhoneChanged_Home</fullName>
        <actions>
            <name>npe01__ContactHomePhoneUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If the standard Phone field is newly entered or changed AND the Preferred Phone picklist is set to Home THEN Salesforce will fill in the Home Phone field with the phone number entered in the standard Phone field.</description>
        <formula>AND(      ISPICKVAL( npe01__PreferredPhone__c ,&quot;Home&quot;),      OR(           AND(                ISNEW(),                LEN(Phone)&gt;0           ),           ISCHANGED( Phone )      ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>npe01__Contact%2EPhoneChanged_Mobile</fullName>
        <actions>
            <name>npe01__ContactMobilePhoneUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If the standard Phone field is newly entered or changed AND the Preferred Phone picklist is set to Mobile THEN Salesforce will fill in the Mobile Phone field with the phone number entered in the standard Phone field.</description>
        <formula>AND(      ISPICKVAL( npe01__PreferredPhone__c ,&quot;Mobile&quot;),      OR(           AND(                ISNEW(),                LEN(Phone)&gt;0           ),           ISCHANGED( Phone )      ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>npe01__Contact%2EPhoneChanged_Other</fullName>
        <actions>
            <name>npe01__ContactOtherEmailUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If the standard Phone field is newly entered or changed AND the Preferred Phone picklist is set to Other THEN Salesforce will fill in the Other Phone field with the phone number entered in the standard Phone field.</description>
        <formula>AND(      ISPICKVAL( npe01__PreferredPhone__c ,&quot;Other&quot;),      OR(           AND(                ISNEW(),                LEN(Phone)&gt;0           ),           ISCHANGED( Phone )      ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>npe01__Contact%2EPhoneChanged_Work</fullName>
        <actions>
            <name>npe01__ContactWorkPhoneUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If the standard Phone field is newly entered or changed AND the Preferred Phone picklist is set to Work THEN Salesforce will fill in the Work Phone field with the phone number entered in the standard Phone field.</description>
        <formula>AND(      ISPICKVAL( npe01__PreferredPhone__c ,&quot;Work&quot;),      OR(           AND(                ISNEW(),                LEN(Phone)&gt;0           ),           ISCHANGED( Phone )      ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>npe01__Contact%2EPreferred_Email%5F%5Fc</fullName>
        <actions>
            <name>npe01__ContactPreferredEmail</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow OVERWRITES the existing value in the standard Email field based on the Preferred Email field value.  This rule needs to be turned on manually after an Upgrade to this package.</description>
        <formula>OR( LEN(Email)=0, ISCHANGED(npe01__Preferred_Email__c) , ISCHANGED(npe01__WorkEmail__c) , ISCHANGED(npe01__HomeEmail__c) , ISCHANGED(npe01__AlternateEmail__c)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>npe01__Contact%2EPreferred_Phone%5F%5Fc</fullName>
        <actions>
            <name>npe01__ContactPreferredPhone</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow OVERWRITES the existing value in the standard Phone field based on the Preferred Phone field value.  This rule needs to be turned on manually after an Upgrade to this package.</description>
        <formula>OR(  LEN(Phone)=0, ISCHANGED(npe01__PreferredPhone__c) ,  ISCHANGED(npe01__WorkPhone__c) ,  ISCHANGED(HomePhone) ,  ISCHANGED(MobilePhone) , ISCHANGED(OtherPhone)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>npe01__Email only%3A Paste to Work</fullName>
        <actions>
            <name>npe01__SetPrefEmailtoWork</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>npe01__SetWorkEmailtoEmail</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.npe01__Preferred_Email__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.npe01__HomeEmail__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.npe01__AlternateEmail__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.npe01__WorkEmail__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>If there is a value in the standard Email field AND no values in any NPSP email fields or Preferred Email, then Salesforce updates two fields: Work Email is updated with the email address in the standard Email field and Preferred Email is set to Work.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>npe01__Phone only%3A Paste to Work</fullName>
        <actions>
            <name>npe01__PreferredPhonetoWork</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>npe01__WorkPhonetoPhone</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Contact.Phone</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.npe01__PreferredPhone__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.npe01__WorkPhone__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.MobilePhone</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.HomePhone</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.OtherPhone</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>If there is a value in the standard Phone field AND no values in any NPSP phone fields or Preferred Phone, then Salesforce updates two fields: Work Phone is updated with the phone number in the standard Phone field and Preferred Phone is set to Work.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>npo02__Contact%2EPreferred_Phone%5F%5Fc WithHousehold</fullName>
        <active>true</active>
        <description>DEPRICATED: This workflow does not do anything yet.</description>
        <formula>1=2</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <tasks>
        <fullName>Donor_Anniversary_Mail</fullName>
        <assignedTo>developer+rspcansw@vertic.com.au</assignedTo>
        <assignedToType>user</assignedToType>
        <description>{&quot;Group_Name__c&quot;: &quot;Support Coordinator Team&quot;, &quot;Activity_Days__c&quot;: &quot;5&quot;, &quot;Description&quot;: &quot;Contact has no email address post donor anniversary letter.&quot;, &quot;Skip_WhatId__c&quot;: &quot;true&quot;}</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Donor Anniversary Mail</subject>
    </tasks>
    <tasks>
        <fullName>GW_Volunteers__Volunteer_Signup_Thank_You_Sent_Contact</fullName>
        <assignedToType>owner</assignedToType>
        <description>An automatic thank you email has been sent to the contact for signing up to be a volunteer.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Volunteer Signup Thank You Sent - Contact</subject>
    </tasks>
    <tasks>
        <fullName>Pending_Bequest</fullName>
        <assignedTo>developer+rspcansw@vertic.com.au</assignedTo>
        <assignedToType>user</assignedToType>
        <description>{&quot;Group_Name__c&quot;: &quot;Estate Administration Team&quot;, &quot;Activity_Days__c&quot;: &quot;5&quot;, &quot;Description&quot;: &quot;A year since Bequestor marked deceased, please update the Bequest&quot;, &quot;WhoId_Field&quot;: &quot;Bequest_Pledged_Opportunity_Id__c&quot;}</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Pending Bequest</subject>
    </tasks>
    <tasks>
        <fullName>Pending_Bequest2</fullName>
        <assignedTo>developer+rspcansw@vertic.com.au</assignedTo>
        <assignedToType>user</assignedToType>
        <description>{&quot;WorkflowName&quot;: &quot;ContactOpportunityWorkflow&quot;, &quot;GroupOwnerName&quot;: &quot;Estate Administration Team&quot;, &quot;ActivityDays&quot;:&quot;5&quot;, &quot;Description&quot;: &quot;A year since Bequestor marked deceased, please update the Bequest&quot;}</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Pending Bequest</subject>
    </tasks>
    <tasks>
        <fullName>Send_Birthday_Card</fullName>
        <assignedTo>developer+rspcansw@vertic.com.au</assignedTo>
        <assignedToType>user</assignedToType>
        <description>{ &quot;Activity_Days__c&quot;: &quot;5&quot;, &quot;WhatId_Field&quot;: &quot;Bequest_Pledged_Opportunity_Id__c&quot;, &quot;Description&quot;: &quot; &quot;}</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Send Birthday Card</subject>
    </tasks>
    <tasks>
        <fullName>Send_Birthday_Card8</fullName>
        <assignedToType>owner</assignedToType>
        <description>{ &quot;Activity_Days__c&quot;: &quot;5&quot;, &quot;WhatId_Field&quot;: &quot;Bequest_Pledged_Opportunity_Id__c&quot;, &quot;Description&quot;: &quot; &quot;}</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Send Birthday Card</subject>
    </tasks>
    <tasks>
        <fullName>Send_Birthday_Card_Before_10_days</fullName>
        <assignedToType>owner</assignedToType>
        <description>{ &quot;Activity_Days__c&quot;: &quot;5&quot;, &quot;Description&quot;: &quot; &quot;}</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Send Birthday Card Before 10 days</subject>
    </tasks>
    <tasks>
        <fullName>Send_Donor_Anniversary_Email</fullName>
        <assignedTo>developer+rspcansw@vertic.com.au</assignedTo>
        <assignedToType>user</assignedToType>
        <description>{&quot;Group_Name__c&quot;: &quot;Support Coordinator Team&quot;, &quot;Activity_Days__c&quot;: &quot;5&quot;, &quot;Description&quot;: &quot;Please send donor an anniversary email.&quot;, &quot;Skip_WhatId__c&quot;: &quot;true&quot;}</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Send Donor Anniversary Email</subject>
    </tasks>
    <tasks>
        <fullName>Thank_youCall</fullName>
        <assignedTo>developer+rspcansw@vertic.com.au</assignedTo>
        <assignedToType>user</assignedToType>
        <description>{&quot;Group_Name__c&quot;: &quot;Support Coordinator Team&quot;, &quot;Activity_Days__c&quot;: &quot;5&quot;, &quot;Description&quot;: &quot;Donor with lapsed regular gift has made a donation&quot;, &quot;WhatId_Field&quot;: &quot;Last_Opportunity_Id__c&quot;}</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Thank you Call</subject>
    </tasks>
    <tasks>
        <fullName>Thank_you_Call</fullName>
        <assignedTo>developer+rspcansw@vertic.com.au</assignedTo>
        <assignedToType>user</assignedToType>
        <description>{&quot;Group_Name__c&quot;: &quot;Support Coordinator Team&quot;, &quot;Activity_Days__c&quot;: &quot;5&quot;, &quot;Description&quot;: &quot;Donor with lapsed regular gift has made a donation&quot;, &quot;Depended_Task_Name__c&quot;: &quot;Send_Bequest_Welcome_Pack&quot;, &quot;WhatId_Field&quot;: &quot;Last_Opportunity_Id__c&quot;}</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Thank you Call</subject>
    </tasks>
</Workflow>
