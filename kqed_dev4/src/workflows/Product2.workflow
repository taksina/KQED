<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Deactivate_a_Premium_or_Premium_Package</fullName>
        <field>IsActive</field>
        <literalValue>0</literalValue>
        <name>Deactivate a Premium or Premium Package</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ProductCode</fullName>
        <field>ProductCode</field>
        <formula>LEFT(TEXT(Premium_Category__c),1) &amp;  ProductCodeNumber__c</formula>
        <name>ProductCode</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Auto-create ProductCode</fullName>
        <actions>
            <name>ProductCode</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ProductCode = &apos;0&apos;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Deactivate a Premium or Premium Package</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Product2.IsActive</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
