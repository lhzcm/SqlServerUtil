----------------------------------------------------------
-- Procedure Name: cc p_if_string_split, 0 ,1
-- Author: Lkl
-- Date Generated: 2021年06月22日
-- Description: 切分字符串
----------------------------------------------------------
ALTER function [dbo].[p_if_string_split](
@input varchar(max) = '',
@separator varchar(128) = ''
)
returns @tb table(rid int identity, result varchar(max))
as
begin
    declare @len int = len(@separator)

	declare @index int = 1
	declare @tempindex int = 1

	while(1 = 1)
	begin
	    set @tempindex = charindex(@separator, @input, @index)
		if @tempindex = 0
		begin
		    if @index != 1
			    insert into @tb(result) select SUBSTRING(@input, @index, len(@input) - @index + 1) 
			else
			    insert into @tb(result) select @input
			break
		end
		insert into @tb(result) select SUBSTRING(@input, @index, @tempindex - @index)
		set @index = @tempindex + @len
	end

	return
end

