CREATE TYPE [dbo].[AssignmentResourceD] AS TABLE (
    [TypeID]   INT  NOT NULL,
    [Deadline] DATE NOT NULL);


GO
GRANT VIEW DEFINITION
    ON TYPE::[dbo].[AssignmentResourceD] TO [RP_DataAdmin]
    AS [dbo];


GO
GRANT REFERENCES
    ON TYPE::[dbo].[AssignmentResourceD] TO [RP_DataAdmin]
    AS [dbo];

