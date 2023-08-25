----------------------------------------------------------      
-- Function Name: cc f_value_to_jsonstr, 0 ,1      
-- Author: Lkl      
-- Date Generated: 2022年12月14日      
-- Description: 把对应类型转化成json字符串      
----------------------------------------------------------      
create function [dbo].[f_value_to_jsonstr](@value sql_variant)  
returns varchar(max)  
as  
begin  
    if @value is null return 'null'  
    return case SQL_VARIANT_PROPERTY(@value, 'BaseType')  
        when 'bit' then case when cast(@value as bit) = 1 then 'true' else 'false' end   
        when 'int' then convert(varchar, @value)  
        when 'bigint' then convert(varchar, @value)  
        when 'smallint' then convert(varchar, @value)  
        when 'decimal' then convert(varchar, @value)  
        when 'float' then convert(varchar, @value)  
        when 'datetime' then '"'+convert(varchar, @value, 121)+'"'  
        when 'date' then '"'+convert(varchar, @value, 120)+'"'  
        else '"'+convert(varchar(max), @value)+'"'  
    end  
end 
go
----------------------------------------------------------    
-- Function Name: cc sp_tojson, 0 ,1    
-- Author: Lkl    
-- Date Generated: 2022年12月14日    
-- Description: 把参数转化成json字符串    
-- Depends: dbo.f_value_to_jsonstr  
----------------------------------------------------------    
create procedure sp_tojson
@jsonstr varchar(max) output,
@param1 varchar(128) = null, @value1 sql_variant = null,
@param2 varchar(128) = null, @value2 sql_variant = null,
@param3 varchar(128) = null, @value3 sql_variant = null,
@param4 varchar(128) = null, @value4 sql_variant = null,
@param5 varchar(128) = null, @value5 sql_variant = null,
@param6 varchar(128) = null, @value6 sql_variant = null,
@param7 varchar(128) = null, @value7 sql_variant = null,
@param8 varchar(128) = null, @value8 sql_variant = null,
@param9 varchar(128) = null, @value9 sql_variant = null,
@param10 varchar(128) = null, @value10 sql_variant = null,
@param11 varchar(128) = null, @value11 sql_variant = null,
@param12 varchar(128) = null, @value12 sql_variant = null,
@param13 varchar(128) = null, @value13 sql_variant = null,
@param14 varchar(128) = null, @value14 sql_variant = null,
@param15 varchar(128) = null, @value15 sql_variant = null,
@param16 varchar(128) = null, @value16 sql_variant = null 
as    
begin    
set @jsonstr = '{'    
if @param1 is null goto finish
set @jsonstr += '"' + @param1 + '":' + dbo.f_value_to_jsonstr(@value1)
if @param2 is null goto finish
set @jsonstr += ',"' + @param2 + '":' + dbo.f_value_to_jsonstr(@value2)
if @param3 is null goto finish
set @jsonstr += ',"' + @param3 + '":' + dbo.f_value_to_jsonstr(@value3)
if @param4 is null goto finish
set @jsonstr += ',"' + @param4 + '":' + dbo.f_value_to_jsonstr(@value4)
if @param5 is null goto finish
set @jsonstr += ',"' + @param5 + '":' + dbo.f_value_to_jsonstr(@value5)
if @param6 is null goto finish
set @jsonstr += ',"' + @param6 + '":' + dbo.f_value_to_jsonstr(@value6)
if @param7 is null goto finish
set @jsonstr += ',"' + @param7 + '":' + dbo.f_value_to_jsonstr(@value7)
if @param8 is null goto finish
set @jsonstr += ',"' + @param8 + '":' + dbo.f_value_to_jsonstr(@value8)
if @param9 is null goto finish
set @jsonstr += ',"' + @param9 + '":' + dbo.f_value_to_jsonstr(@value9)
if @param10 is null goto finish
set @jsonstr += ',"' + @param10 + '":' + dbo.f_value_to_jsonstr(@value10)
if @param11 is null goto finish
set @jsonstr += ',"' + @param11 + '":' + dbo.f_value_to_jsonstr(@value11)
if @param12 is null goto finish
set @jsonstr += ',"' + @param12 + '":' + dbo.f_value_to_jsonstr(@value12)
if @param13 is null goto finish
set @jsonstr += ',"' + @param13 + '":' + dbo.f_value_to_jsonstr(@value13)
if @param14 is null goto finish
set @jsonstr += ',"' + @param14 + '":' + dbo.f_value_to_jsonstr(@value14)
if @param15 is null goto finish
set @jsonstr += ',"' + @param15 + '":' + dbo.f_value_to_jsonstr(@value15)
if @param16 is null goto finish
set @jsonstr += ',"' + @param16 + '":' + dbo.f_value_to_jsonstr(@value16)
finish:
set @jsonstr += '}'
end     
go