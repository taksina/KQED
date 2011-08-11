<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Old_Address_ON</fullName>
        <field>Address_Status__c</field>
        <literalValue>Old Address</literalValue>
        <name>Old Address ON</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Old_Address_ON</fullName>
        <actions>
            <name>Old_Address_ON</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Address__c.Address_End_Date__c</field>
            <operation>greaterThan</operation>
            <value>1/1/2000</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
