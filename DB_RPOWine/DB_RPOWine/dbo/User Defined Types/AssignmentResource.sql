CREATE TYPE [dbo].[AssignmentResource] AS TABLE (
    [UserId]       INT          NOT NULL,
    [UserRoleID]   INT          NULL,
    [UserRoleName] VARCHAR (30) NULL,
    [Deadline]     DATE         NULL);


GO
GRANT VIEW DEFINITION
    ON TYPE::[dbo].[AssignmentResource] TO [RP_DataAdmin]
    AS [dbo];


GO
GRANT REFERENCES
    ON TYPE::[dbo].[AssignmentResource] TO [RP_DataAdmin]
    AS [dbo];

