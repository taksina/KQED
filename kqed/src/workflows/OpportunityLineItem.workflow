<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Copy_Inventory_Status</fullName>
        <field>Inventory_Status_mirror__c</field>
        <formula>Inventory_Status__c</formula>
        <name>Copy Inventory Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Shipment_Status</fullName>
        <field>Shipment_Status_mirror__c</field>
        <formula>Shipment_Status__c</formula>
        <name>Copy Shipment Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>OLI NEW%2FCREATED</fullName>
        <actions>
            <name>Copy_Inventory_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_Shipment_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
