CREATE TYPE [dbo].[IDList] AS TABLE (
    [ID] INT NOT NULL);


GO
GRANT VIEW DEFINITION
    ON TYPE::[dbo].[IDList] TO [RP_DataAdmin]
    AS [dbo];


GO
GRANT REFERENCES
    ON TYPE::[dbo].[IDList] TO [RP_DataAdmin]
    AS [dbo];


GO
GRANT VIEW DEFINITION
    ON TYPE::[dbo].[IDList] TO [RP_Customer]
    AS [dbo];


GO
GRANT REFERENCES
    ON TYPE::[dbo].[IDList] TO [RP_Customer]
    AS [dbo];

