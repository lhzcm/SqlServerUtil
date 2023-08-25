----------------------------------------------------------
-- Procedure Name: cc p_if_string_split, 0 ,1
-- Author: Lkl
-- Date Generated: 2021年06月22日
-- Description: 切分字符串
----------------------------------------------------------
create function [dbo].[p_if_string_split](
@input varchar(max) = '',
@separator varchar(128) = ''
)
returns @tb table(rid int identity, result varchar(max))
as
begin
	if @input is null or @separator is NULL
		return
	--匹配字符长度，len函数会忽略文字后面空格，需要特殊处理一下
	declare @len int = len(@separator) + (datalength(@separator) - datalength(rtrim(@separator)))
    --输入字符尾部空格长度
    declare @input_rtrim_len int = datalength(@input) - datalength(rtrim(@input))
	
	declare @index int = 1
	declare @tempindex int = 1

	while(1 = 1)
	begin
	    set @tempindex = charindex(@separator, @input, @index)
		if @tempindex = 0
		begin
		    if @index != 1
			    insert into @tb(result) select SUBSTRING(@input, @index, len(@input) - @index + 1 + @input_rtrim_len) 
			else
			    insert into @tb(result) select @input
			break
		end
		insert into @tb(result) select SUBSTRING(@input, @index, @tempindex - @index)
		set @index = @tempindex + @len
	end

	return
end

