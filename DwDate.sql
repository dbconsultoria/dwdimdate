IF NOT EXISTS ( SELECT  *
                FROM    sys.schemas
                WHERE   name = N'Dw' )
    EXEC('CREATE SCHEMA Dw');
GO

IF NOT EXISTS(SELECT 0 FROM sysobjects WHERE NAME ='DimDate' and xtype='U')
begin
	CREATE TABLE Dw.DimDate(
		dtData DATE not null
		,dtMonth smallint
		,dtDay smallint
		,dtYear int
		,dtQuarter tinyint
		,dtMonthName nvarchar(150)
		,dtWeekDayName nvarchar(150)
	);

	CREATE UNIQUE INDEX unData
	ON Dw.DimDate(dtData);
end;
go

TRUNCATE TABLE Dw.DimDate;

DECLARE 
	@dtdata DATE = '1900-01-01'
	,@count BIGINT = 0
	,@culture varchar(10)='pt-BR';--Other cultures... 'en-gb','en-US'


WHILE @COUNT <= 62000
BEGIN
	INSERT INTO Dw.DimDate(	dtData 
			,dtMonth 
			,dtDay 
			,dtYear
			,dtQuarter 
			,dtMonthName 
			,dtWeekDayName)
	SELECT 
		@dtdata
		,MONTH(@dtdata)
		,DAY(@dtdata)
		,YEAR(@dtdata)
		,DATEPART(QUARTER, @dtdata)
		,FORMAT( GETDATE(), 'MMMM', @culture )
		,FORMAT( GETDATE(), 'dddd', @culture )

	SELECT 
		@count+=1
		,@dtdata=DATEADD(DAY,1,@dtdata);
END;


SELECT * 
FROM Dw.DimDate
ORDER BY 1;