<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Status_to_Partially_Received</fullName>
        <field>Status__c</field>
        <literalValue>Partially Received</literalValue>
        <name>Set Status to Partially Received</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_to_Received</fullName>
        <field>Status__c</field>
        <literalValue>Received</literalValue>
        <name>Set Status to Received</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>PO Partially Received</fullName>
        <actions>
            <name>Set_Status_to_Partially_Received</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  Num_of_Units_Received__c &gt; 0,  Num_of_Units_Not_Received__c &gt; 0 )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PO Received</fullName>
        <actions>
            <name>Set_Status_to_Received</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  Num_of_Units_Received__c &gt; 0,  Num_of_Units_Not_Received__c = 0 )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
