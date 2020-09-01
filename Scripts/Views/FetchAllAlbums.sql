IF EXISTS(select 1 from sys.views where name='FetchAllAlbums' and type='v')
	DROP VIEW [dbo].[FetchAllAlbums];
GO

CREATE VIEW [dbo].[FetchAllAlbums]
AS
	SELECT alb.*, at.Name as Type 
	  FROM dbo.Album AS alb 
INNER JOIN dbo.AlbumType AS at ON at.Id = alb.TypeId
GO
