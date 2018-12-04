show databases;
drop table test_add;
create table test_add
(
	id int,
	strs varchar(100)
);

select * from test_add;

-- 设置sql语句结束语
delimiter //
-- 创建一个存储过程
create procedure test_add(in num int)
begin
	-- 用于计算的函数
	declare i int default 0;
	-- 用于接收随机生成的函数
	declare rand_str varchar(255);
	-- 循环次数根据传进来的值
	while i<num do 
		-- 随机生成一个字符
		set rand_str = substring('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ123456789',floor(1 +62 * rand ()));
		-- 循环一次加1
		set i=i+1;
		-- 循环一次插入一条语句
		insert into test_add values (i,rand_str);
	end while;
end//

delimiter ;

-- 运行
call test_add();

--删除存储过程
drop procedure test_add;


-- 编写一个随机获取字符串的函数
delimiter //

create function rand_str(size int , type int)
	returns varchar(255)
	begin
		declare seed varchar(255)；
		declare seed_no varchar(255) default '1234567890';
		declare seed_en varchar(255) default 'qwertyuiopasdfghjklzxcvbnm';
		
		declare ret varchar(255) default '';
		declare i int default 0;
		
		set seed = case type 
						when 1 then seed_en
						when 2 then seed_no
						else concat(seed_en, seed_no) end;
						
		while i < size do
			set ret = concat(ret, substring(seed, floor(length(seed) * rand() + 1),1))
			set i = i + 1;
		end while;
		
		return ret;
	end//
	
delimiter ;

select rand_str();


delimiter // 

drop procedure pp1 
create procedure pp2(indert into varchar)



