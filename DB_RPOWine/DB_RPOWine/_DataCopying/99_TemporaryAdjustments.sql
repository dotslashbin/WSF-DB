--select * from Publication
update Publication set PublisherIDFuture = PublisherID where PublisherIDFuture is null
GO
update Publication set PublisherID = 1
update Publication set PublisherID = 0 where Name like '%seminar%'
update Publication set PublisherID = 2 where Name = 'Wine Journal'
GO