<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Full Time Offer Letter</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Job_Application__c.Picklist__c</field>
            <operation>equals</operation>
            <value>Hired</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
