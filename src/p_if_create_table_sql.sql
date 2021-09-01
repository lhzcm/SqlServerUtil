----------------------------------------------------------
-- Procedure Name: cc p_if_create_table_sql, 0 ,1
-- Author: Lkl
-- Date Generated: 2021年08月10日
-- Description: 获取创建table的sql
----------------------------------------------------------
create function [dbo].[p_if_create_table_sql](
@tablename varchar(128)
)
returns @show table(text varchar(max))
as
begin
declare @tbcolumn table(
    rid int identity, 
	default_object_id int,
	column_name varchar(256), 
	max_length int, 
	precision int, 
	scale int, 
	is_nullable bit, 
	system_type_id int, 
	system_type_presc int,
	system_type_scale int,
	system_max_length int,
	type_name varchar(128), 
	collation_name varchar(128),
	is_identity bit
)
declare @i int = 0
declare @column_name varchar(256), 	
@max_length int, 
@precision int, 
@scale int, 
@is_nullable bit, 
@system_type_id int, 
@system_type_presc int,
@system_type_scale int,
@system_max_length int,
@type_name varchar(128), 
@collation_name varchar(128),
@is_identity bit,
@identity varchar(64) = '',
@tb_object_id int,
@default_object_id int

declare @tb table(rid int identity, text varchar(max))
declare @columntext varchar(1024) = ''

--获取表的object_id
select @tb_object_id = object_id from sys.tables where name = @tablename
if @@rowcount <= 0
    return
--获取每一列的信息
insert into @tbcolumn(default_object_id, column_name, max_length, precision, scale,
is_nullable, system_type_id, system_type_presc, system_type_scale, system_max_length,
type_name, collation_name, is_identity)
select c.default_object_id, c.name, c.max_length, c.precision, c.scale,
c.is_nullable, c.system_type_id, ty.precision, ty.scale, ty.max_length, 
ty.name, c.collation_name, c.is_identity from sys.tables t 
join sys.columns c on t.object_id = c.object_id 
join sys.types ty on c.system_type_id = ty.system_type_id 
where t.name = @tablename order by c.column_id asc

--循环添加每一列的显示
insert into @tb(text) select 'CREATE TABLE ' + @tablename + ' ('
while 1 = 1
begin
    set @i += 1
	select @column_name = column_name, @max_length = max_length, @precision = precision, @scale = scale, 
	@is_nullable = is_nullable, @system_type_id = system_type_id, @system_type_presc = system_type_presc,
	@system_type_scale = system_type_scale, @system_max_length = system_max_length, @type_name = type_name, 
	@collation_name = collation_name, @is_identity = is_identity, @default_object_id = default_object_id from @tbcolumn where rid = @i
	if @@ROWCOUNT <= 0
	    break
	--添加列名和类型
	set @columntext = '    [' +  @column_name + '] ' + @type_name
	if @precision != @system_type_presc or @scale != @system_type_scale
	begin
	    set @columntext += '(' + ltrim(@precision)
		if @scale != @system_type_scale
		    set @columntext += ',' + ltrim(@scale)
	    set @columntext += ')'
	end
	else if @max_length != @system_max_length
	begin
	    set @columntext += '(' + ltrim(@max_length) + ')'
	end
	--添加是否不为空
	if @is_nullable = 0
	    set @columntext += ' not null'
	--添加自增
	if @is_identity = 1
	begin
	    declare @seed_value sql_variant = 0, @increment_value sql_variant = 0
		select @seed_value = seed_value, @increment_value = increment_value from sys.identity_columns where object_id = @tb_object_id
	    set @columntext += ' identity(' + convert(varchar, @seed_value) + ', ' + convert(varchar, @increment_value) + ')'
	end
	--添加默认值
	if @default_object_id > 0
	begin
	    set @columntext += ' default' + (select definition from sys.default_constraints where object_id = @default_object_id)
	end
	if exists(select 1 from @tbcolumn where rid = @i + 1) or exists(select 1 from sys.indexes where object_id = @tb_object_id and is_primary_key = 1)
	    set @columntext += ','
	insert into @tb(text) values(@columntext)
end
--添加主键
declare @key_name varchar(1024), @index_id int, @type_desc varchar(128), @keys varchar(1024) = ''
select @key_name = name, @index_id = index_id, @type_desc = type_desc from sys.indexes where object_id = @tb_object_id and is_primary_key = 1
if @@rowcount > 0
begin
    set @columntext = '    constraint ' + @key_name + ' primary key '+ @type_desc +'('
	set @keys  = isnull(rtrim((select col_name(object_id, column_id) + ', ' 
	    from sys.index_columns where object_id = @tb_object_id and index_id = @index_id order by key_ordinal for xml path(''))), ' ')
    set @columntext += substring(@keys, 1, len(@keys)-1) + ')'
	insert into @tb(text) values(@columntext)
end
insert into @tb(text) select ')'
--添加索引
declare @indextb table(rid int identity, index_id int, keyname varchar(256), type_desc varchar(128))
insert into @indextb(index_id, keyname, type_desc) 
select index_id, name, type_desc from sys.indexes where object_id = @tb_object_id and is_primary_key = 0 
set @i = 0
while 1 = 1
begin
    set @i += 1
	select @key_name = keyname, @index_id = index_id, @type_desc = type_desc from @indextb where rid = @i
	if @@rowcount <= 0 break
	insert into @tb(text) select 'go'

    set @columntext = 'create ' + @type_desc + ' index ' + @key_name + ' on ' + @tablename+'('
	set @keys  = isnull(rtrim((select col_name(object_id, column_id) + ', ' 
	    from sys.index_columns where object_id = @tb_object_id and index_id = @index_id order by key_ordinal for xml path(''))), ' ')
    set @columntext += substring(@keys, 1, len(@keys)-1) + ')'
	insert into @tb(text) values(@columntext)
end
insert @show(text) select text from @tb order by rid asc
return
end