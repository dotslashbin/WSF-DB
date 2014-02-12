CREATE TYPE [dbo].[IDLink] AS TABLE (
    [LeftID]  INT NOT NULL,
    [RightID] INT NOT NULL);


GO
GRANT VIEW DEFINITION
    ON TYPE::[dbo].[IDLink] TO [RP_DataAdmin]
    AS [dbo];


GO
GRANT REFERENCES
    ON TYPE::[dbo].[IDLink] TO [RP_DataAdmin]
    AS [dbo];


GO
GRANT VIEW DEFINITION
    ON TYPE::[dbo].[IDLink] TO [RP_Customer]
    AS [dbo];


GO
GRANT REFERENCES
    ON TYPE::[dbo].[IDLink] TO [RP_Customer]
    AS [dbo];

