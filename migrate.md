####分割方法思路
- - -

首先找到我们的主表：lagou_position_bk（删除了某些不合法的null值数据库，删除了重复字段的）
-	第一步首先把地区有关的信息分离出去，根据depth字段单独查询判断是否 = 0 or 1 or 3 来区别省、市、县，然后把查询出来的数据，用join进行连接查询合并到一个表中，最后用as创建表的方法把数据库迁移到新表lagou_city01中，在创建的过程中可以通过 as 关键字重新命名新表字段名（默认·是·迁移数据表的字段名）；第二个语句是插入语句把那些没有市或者区的数据插入到lagou_city01表中，因为创建表时迁移的数据是市或区是没有null值的。

```
create table lagou_city01 as
	select d.id, p.cityName as province, c.cityName as city, d.cityName as district  	from (select * from china_city where depth=3) d join china_city c on 
    d.parentId = c.id and c.depth=2 join china_city p on 
  	c.parentId = p.id and p.depth=1;
    
insert into lagou_city01
	select c.id, p.cityName as province, c.cityName as city, null as district 
    from (select * from china_city where depth=2) c join china_city p on 
    c.parentId = p.id and p.depth = 1;
    
select count(*) from lagou_city01;
```

-	第二步把与公司有关的信息分离出去，与地区表创建时数据迁移一样。
```
drop table if exists lagou_company;
create table lagou_company as
  select distinct t.company_id as cid,
                  t.company_short_name as short_name,
                  t.company_full_name  as full_name,
                  t.company_size  as size,
                  t.financestage
  from lagou_position_bk t;
```
 最后注意:

    分表过程中、分完的表，需要添加主键或索引，否则关联查询会特别特别慢
    使用 create as 语句分表会比较简单，但这个过程存在数据的复制，会比较占用硬盘存储
    除了 create as 语句，也可以在基表上进行数据操作（删改）。但是注意数据的备份，当心不慎操作导致的数据永久丢失
    备份迁移需要在系统停机的情况下进行
















