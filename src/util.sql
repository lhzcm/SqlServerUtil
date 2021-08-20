--查询表的数据量和空间占用信息
CREATE TABLE #Temp (NAME nvarchar(100),ROWS char(20),reserved varchar(18) ,Data varchar(18) ,index_size varchar(18) ,Unused varchar(18) )
INSERT #Temp EXEC SP_MSFOREACHTABLE 'exec sp_spaceused "?"' 
SELECT * FROM #Temp ORDER BY CONVERT(INT,REPLACE(DATA,'KB','')) DESC
DROP TABLE #Temp

