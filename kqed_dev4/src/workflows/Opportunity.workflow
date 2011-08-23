<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Corporate_Support_Opportunity_Total</fullName>
        <field>Amount</field>
        <formula>Med_1_Amt__c  +  Med_2_Amt__c  +  Med_3_Amt__c  +  Med_4_Amt__c  +  Med_5_Amt__c</formula>
        <name>Corporate Support Opportunity Total</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Corporate Support Opportunity Total</fullName>
        <actions>
            <name>Corporate_Support_Opportunity_Total</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Med_1_Amt__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
