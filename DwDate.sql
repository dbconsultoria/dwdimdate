IF NOT EXISTS ( SELECT  *
                FROM    sys.schemas
                WHERE   name = N'Dw' )
    EXEC('CREATE SCHEMA Dw');
GO

IF NOT EXISTS(SELECT 0 FROM sysobjects WHERE NAME ='DimDate' and xtype='U')
begin
	create TABLE Dw.DimDate(
		dtData DATE not null
		,dtMonth smallint
		,dtDay smallint
		,dtYear int
		,dtQuarter tinyint
		,dtSemester tinyint
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
			,dtSemester
			,dtMonthName 
			,dtWeekDayName)
	SELECT 
		@dtdata
		,MONTH(@dtdata)
		,DAY(@dtdata)
		,YEAR(@dtdata)
		,DATEPART(QUARTER, @dtdata)
		,CASE WHEN month(@dtdata) < 7 then  1 else 2 end
		,FORMAT( @dtdata, 'MMMM', @culture )
		,FORMAT( @dtdata, 'dddd', @culture )

	SELECT 
		@count+=1
		,@dtdata=DATEADD(DAY,1,@dtdata);
END;


SELECT * 
FROM Dw.DimDate
ORDER BY 1;
