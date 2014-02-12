CREATE TABLE [dbo].[WF] (
    [ObjectTypeID] INT           NOT NULL,
    [ObjectID]     INT           NOT NULL,
    [StatusID]     SMALLINT      NOT NULL,
    [AssignedByID] INT           NOT NULL,
    [AssignedToID] INT           NOT NULL,
    [AssignedDate] DATETIME      CONSTRAINT [DF_WF_AssignedDate] DEFAULT (getdate()) NOT NULL,
    [Note]         VARCHAR (MAX) NULL,
    CONSTRAINT [PK_WF] PRIMARY KEY CLUSTERED ([ObjectTypeID] ASC, [ObjectID] ASC) ON [WF],
    CONSTRAINT [FK_WF_Users] FOREIGN KEY ([AssignedByID]) REFERENCES [dbo].[Users] ([UserId]),
    CONSTRAINT [FK_WF_Users1] FOREIGN KEY ([AssignedToID]) REFERENCES [dbo].[Users] ([UserId]),
    CONSTRAINT [FK_WF_WF_ObjectTypes] FOREIGN KEY ([ObjectTypeID]) REFERENCES [dbo].[WF_ObjectTypes] ([ID]),
    CONSTRAINT [FK_WF_WF_Statuses] FOREIGN KEY ([StatusID]) REFERENCES [dbo].[WF_Statuses] ([ID])
) TEXTIMAGE_ON [WF];




GO
CREATE TRIGGER [dbo].[WF_OnUpdate] ON [dbo].[WF] FOR UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	declare @ObjID int, @ObjTypeID int, @DT datetime
	select @ObjID=ObjectID, @ObjTypeID=ObjectTypeID, @DT = AssignedDate from deleted 
	
	if exists(select * from deleted d 
		left join (select * from inserted) f 
			on d.StatusID = f.StatusID and d.AssignedByID = f.AssignedByID and d.AssignedToID = f.AssignedToID
				and isnull(d.Note, '') = isnull(f.Note, '')
		where f.StatusID is NULL) begin

		if exists(select * from WFHist where @ObjID=ObjectID and @ObjTypeID=ObjectTypeID and @DT = AssignedDate)
			select @DT = dateadd(ms,1,@DT)
		insert into WFHist (ObjectTypeID, ObjectID, StatusID, AssignedByID, AssignedToID, AssignedDate, Note)
		select d.ObjectTypeID, d.ObjectID, d.StatusID, d.AssignedByID, d.AssignedToID, @DT, d.Note
		from deleted d

	end

  --  if update(StatusID) or update(AssignedByID) or update(AssignedToID) begin
		--insert into WFHist (ObjectTypeID, ObjectID, StatusID, AssignedByID, AssignedToID, AssignedDate, Note)
		--select d.ObjectTypeID, d.ObjectID, d.StatusID, d.AssignedByID, d.AssignedToID, d.AssignedDate, d.Note
		--from deleted d
  --  end

END