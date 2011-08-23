public class PRR_DelegatedTasksview {
    public List<Task> getPRRTasks() {
        return [Select Id, Type, WhoId, WhatId, Subject, ActivityDate, Status, Priority, OwnerId,Owner.FirstName,Owner.LastName,Who.FirstName,Who.LastName,
            Description, AccountId, IsClosed, CreatedDate, CreatedById
            FROM Task where CreatedByID=:Userinfo.getUserID() and Type = 'Prospect Research Report Request' order by CreatedDate desc];
    }
}