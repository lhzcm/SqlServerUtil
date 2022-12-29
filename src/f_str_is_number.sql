----------------------------------------------------------  
-- Function Name: cc f_str_is_number, 0 ,1  
-- Author: Lkl  
-- Date Generated: 2021年12月20日  
-- Description: 判断字符串是否是数字 
----------------------------------------------------------  
create function [dbo].[f_str_is_number](@input varchar(max))  
returns bit  
as  
begin
    if @input is null return 0
    declare @len int = len(@input), @i int = 0, @temp char(1)
	if @len <= 0 return 0

	while @i < @len
	begin
	    set @i += 1
		set @temp = substring(@input, @i, 1)
		if @temp not between '0' and '9'
		    return 0
	end
	return 1
end