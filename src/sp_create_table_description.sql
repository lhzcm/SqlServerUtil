----------------------------------------------------------
--Procedure Name: cc sp_create_table_description,0,1
-- Author: Lkl
-- Date Generated: 2020年09月18日
-- Description:  通过表结构生成表描述
----------------------------------------------------------

create procedure [dbo].[sp_create_table_description]
@tablestr nvarchar(max)
as
set nocount on
set transaction isolation level read uncommitted
set xact_abort on

declare @table_name nvarchar(128) = ''
declare @table_model table(rid int, text nvarchar(max))
declare @table_column table(rid int identity, column_name varchar(128), text nvarchar(max))
declare @table_description table (rid int identity, text nvarchar(max))
declare @column_name varchar(128) = '', @column_description nvarchar(max), @i int = 0

insert into @table_model(rid, text)  
select rid, ltrim(result) from dbo.p_if_string_split(@tablestr, char(13) + char(10)) 

--获取表名
select top 1 @table_name = (select top 1 result from dbo.p_if_string_split(ltrim(substring(text, charindex('TABLE', UPPER(text)) + 5, len(text))), ' ')) 
from @table_model where charindex('CREATE', UPPER(text)) = 1  
if @@rowcount <= 0 return


insert into @table_description(text) select 'go'

--添加表注释
insert into @table_description(text) select replace(text, '''', '''''') from @table_model where charindex('--',ltrim(text), 1) = 1
if @@ROWCOUNT >= 0
begin
    update @table_description set text = 'execute sp_addextendedproperty N''MS_Description'', N''' + text 
	    where rid = (select top 1 rid from @table_description where rid > 1 order by rid asc) 
	update @table_description set text = text + ''', N''SCHEMA'', N''dbo'', N''TABLE'', N'''+@table_name+'''' 
	    where rid = (select top 1 rid from @table_description where rid > 1 order by rid desc)
end
insert into @table_description(text) select 'go'

--添加字段注释
insert into @table_column(column_name, text)
select substring(text, 1, charindex(' ', text) - 1), substring(text, charindex('--', text)+2, len(text)) from @table_model where charindex('--',ltrim(text), 1) > 1
while 1 = 1
begin
    set @i += 1
    select @column_name = column_name, @column_description = text from @table_column where rid = @i
	if @@rowcount <= 0 
	    break
	insert into @table_description(text) select 'execute sp_addextendedproperty N''MS_Description'', N''' + replace(@column_description, '''', '''''')
	+ ''', N''SCHEMA'', N''dbo'', N''TABLE'', N''' + @table_name + ''', N''COLUMN'', N''' + replace(replace(@column_name, '[', ''),']', '') + ''''
end

select text from @table_description

---------------------------------------------------------
--下面是表结构示例
---------------------------------------------------------
---- =============================================
---- TABLE Name: [t_act_phonecharge_userid_task]
---- Author: Lkl
---- Date Generated: 2021年09月03日 
---- Description: 用户礼券活动任务
---- =============================================
--CREATE TABLE t_act_phonecharge_userid_task (
--    rid int not null identity(1, 1) primary key,
--    type int not null default((0)),                    --任务类型，0：每日任务， 1：每周任务， 2：每月任务
--    reward bigint not null,                            --奖励数量
--    status int not null default((0)),                  --状态，0：正常， -1：停止
--    remark varchar(128) not null,                      --备注
--    writetime datetime not null default(getdate()),    --添加时间
--)

go

