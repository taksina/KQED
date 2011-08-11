<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Corp_Support_Opportunity_Total</fullName>
        <description>Takes all the media type amounts and totals them in the Premium/Benefit Amount field</description>
        <field>Amount</field>
        <formula>Med_1_Amt__c  +  Med_2_Amt__c  +  Med_3_Amt__c  +  Med_4_Amt__c  +  Med_5_Amt__c</formula>
        <name>Corp Support Opportunity Total</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Corp Support Opportunity Total</fullName>
        <actions>
            <name>Corp_Support_Opportunity_Total</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CreatedById</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Will take all the media amounts and add them together and then place them in the Premium/Benefit Total field</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
