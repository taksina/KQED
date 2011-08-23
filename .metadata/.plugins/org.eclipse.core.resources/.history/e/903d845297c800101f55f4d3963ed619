<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>GivingSummary_Update_MemYrStatus_Grace</fullName>
        <field>Member_Yr_Status__c</field>
        <literalValue>Grace</literalValue>
        <name>GivingSummary Update MemYrStatus-Grace</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GivingSummary_Update_MemYrStatus_Grace1</fullName>
        <field>IsGrace__c</field>
        <literalValue>1</literalValue>
        <name>GivingSummary Update MemYrStatus-Grace1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GivingSummary_Update_MemYrStatus_Lapsed</fullName>
        <field>Member_Yr_Status__c</field>
        <literalValue>Lapsed</literalValue>
        <name>GivingSummary Update MemYrStatus-Lapsed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>GivingSummary Update Mem Year Status - Grace</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Giving_Summary__c.Member_Yr_Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <criteriaItems>
            <field>Giving_Summary__c.Grace_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GivingSummary Update Mem Year Status - Lapsed</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Giving_Summary__c.Member_Yr_Status__c</field>
            <operation>equals</operation>
            <value>Grace</value>
        </criteriaItems>
        <criteriaItems>
            <field>Giving_Summary__c.Lapsed_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
