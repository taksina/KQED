<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Campaign_End_Date</fullName>
        <description>Campaign End Date Has Passed - Change Status</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Campaign_Notifications/Lapsed_Campaign</template>
    </alerts>
    <alerts>
        <fullName>Campaign_End_Date_has_Passed_Campaign_is_Still_Active</fullName>
        <description>Campaign End Date has Passed - Campaign is Still Active</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Campaign_Notifications/Lapsed_Campaign</template>
    </alerts>
    <rules>
        <fullName>Campaign End Date</fullName>
        <actions>
            <name>Campaign_End_Date</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Campaign.End_Time_Date__c</field>
            <operation>lessOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Once a campaign has reached the end date send an email to the campaign owner to change the status to completed or update the end date to a future date.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
