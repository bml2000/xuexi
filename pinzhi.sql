
select @@sql_mode
ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION

----------------------------
#生成门店上线日期表
drop table wl_ognid_firstdate;
create table wl_ognid_firstdate
select `sh_shbill`.`fdi_ognid` AS `fdi_ognid`,min(`sh_shbill`.`fdd_paydate`) AS `first_date` from `sh_shbill` group by `sh_shbill`.`fdi_ognid`;
select * from wl_ognid_firstdate

#门店查询
select
  b.fdc_brandname '品牌',
  a.fdi_ognid,
  a.fdc_ognno '平台门店ID',
  a.fdc_ognnewno '门店财务编号',
  a.fdc_ognname '门店名称',
  a.fdc_ognadd '门店地址',
  a.fdc_ogncontract '联系人',
  a.fdc_ognmobile '手机',
  a.fdc_province '省份',
  a.fdc_city '城市',
  a.fdi_ogntype '经营',  -- 2直营；3加盟； 4# 联营
  case when a.fdi_ogntype=2 then '直营' 
       when    a.fdi_ogntype=3 then '加盟'
	      when		a.fdi_ogntype=4 then '联营'
          else 'error' end  as '经营模式',
 a.fdb_state '状态' , -- 0正常；1停用；2删除
  case when  a.fdb_state=0 then '正常'
       when  a.fdb_state=1  then '停用'
       when  a.fdb_state=2  then '删除'
        else '其他'  end as '门店状态',
   a.fdi_dnregionid AS 架构id,
   c.fdc_otname as 门店类型,
   a.fdi_lat as 经度,
   a.fdi_lon  as 维度,
   d.first_date as 营业开始日期,
   a.fdb_isonline as 在线标识
from
  sys_organizations a
  join sys_brand b on a.fdi_brandid = b.fdi_brandid
  left  join sys_organizationstype c on a.fdi_otid=c.fdi_otid
   left  join wl_ognid_firstdate  d on a.fdi_ognid=d.fdi_ognid
where b.fdi_brandid in (3) 
order by
  b.fdc_brandname,a.fdb_state ,  a.fdc_city  
  
  
#生成门店最早营业日期
create view  v_wl_ognid_firstdate    #
as  select fdi_ognid,min(fdd_paydate) as first_date 
from sh_shbill group by fdi_ognid  

  

# 单位表  
select fdi_brandid,fdi_dnid,fdc_dnname  from sys_dictionary where fdi_dntype=2 
and fdi_brandid in (1,3 )   -- 1 -彤德莱火锅， 3-鱼谦
and  fdb_status =0   -- 0  正常   2-停用
order by fdi_order
 
# 门店区域（大厅）表
select  fdi_ognid,fdi_blid,fdc_blname,fdi_operatingarea,fdi_members from sys_businessloc where fdc_blname='大厅'
 
#门店类别 （商超、街边）
select fdi_otid, fdc_otname from sys_organizationstype
 
# 二级类菜品类别表
select  fdi_brandid,fdi_rcid,fdc_rcname  from sys_reportcategory  
where fdi_brandid in (1,3) 
and fdb_status=0  
order by fdi_brandid, fdi_order

#菜品类别 一二级对应表
select b.fdi_rcid as 1strcid, b.fdc_rcname as 1st ,a.fdi_rcid,a.fdc_rcname,a.fdi_order  
from  sys_reportcategory a  join sys_reportcategory b on a.fdi_fatherid=b.fdi_rcid
where a.fdi_brandid in (1,3) 
and a.fdb_status=0  order by  a.fdi_order



#菜谱C端显示类
select fdi_brandid,fdi_recccid,fdc_reccname,fdi_order  from  sys_computercategory
where fdi_brandid in (1,3) 
and fdb_status=0      -- 0-可用 1-停用 2-删除
order by fdi_order

#人员查询
select 
fdi_epid,
fdc_epno,
fdc_epcardno,  -- 卡号
fdc_epname,  -- 姓名
fdc_eptel,  -- 手机号
fdb_islocked, -- 0-正常， 1-锁定
fdb_status  -- 0 -正常 1 - 停用  2- 删除
from  sys_userinfo

#做法查询
select a.fdi_brandid, a.fdi_practiceid ,
a.fdc_practicename, -- 名称
a.fdi_practicetypeid ,
b.fdc_practicetypename, -- 类型名称
b.fdb_choicetype   --  选择类型
from sys_practice  a  join  sys_practicetype b on a.fdi_practicetypeid=b.fdi_id 
where a.fdi_brandid in (1,3) 
and a.fdb_status=0
and b.fdb_status=0
order by a.fdi_brandid, a.fdi_practicetypeid ,a.fdi_order ;

 
#门店组织架构  大区=门店  

select  a.fdi_dnid,b.fdc_dnname as local ,a.fdc_dnname 
from sys_dictionary a  join sys_dictionary b on a.fdi_fatherid =b.fdi_dnid where a.fdi_dntype=1 and a.fdb_status=0;
--  去掉闭店大区和门店
select  a.fdi_dnid,b.fdc_dnname,IF(right(b.fdc_dnname,4)='（闭店）',
left(b.fdc_dnname,CHAR_LENGTH(b.fdc_dnname)-4),
b.fdc_dnname) as local,
IF(right(a.fdc_dnname,4)='（闭店）',
left(a.fdc_dnname,CHAR_LENGTH(a.fdc_dnname)-4),
a.fdc_dnname),
a.fdc_dnname from sys_dictionary a  join sys_dictionary b on a.fdi_fatherid =b.fdi_dnid where a.fdi_dntype=1 and a.fdb_status=0



	
	

  
# 菜品信息表  -- 
--  fdi_brandid=3    -- 1 -彤德莱火锅， 3-鱼谦
--  fdb_status=2    --  0- 堂食 ， 1-停用，2-外卖
select fdi_brandid,fdb_status,fdi_brandid,fdi_dishesid,fdi_rcid, fdc_dishesno,fdc_dishesname from  sys_dishes 
where  fdb_status=0   
order  by  fdi_brandid, fdi_order 

#菜品类别及菜品
select a.fdi_brandid,a.fdi_dishesid,a.fdi_rcid,b.fdc_rcname,a.fdc_dishesno,a.fdc_dishesname ,a.fdb_packflag 
from  sys_dishes a 
left join sys_reportcategory   b on a.fdi_brandid=b.fdi_brandid  and a.fdi_rcid=b.fdi_rcid
where  a.fdb_status=0   -- 0- 堂食 2-外卖 1-停用
-- and b.fdb_status=0  
and a.fdi_brandid in (1,3) 
order  by  a.fdi_brandid, b.fdi_order 


#套餐定义查询
select b.fdc_rcname as 套餐类别,
a.fdc_dishesno as 编号,    
a.fdc_dishesname  as  套餐名称,
c.fdi_packaged as 套餐明细id,
c.fdi_rpdid  as 辅菜组id,
g.fdc_rpdname as 组名 ,
g.fdb_rpdtype as 选择  ,  -- 1 可选  ， 2-必选
g.fdi_count as 必须数量,
g.fdi_mincount as 辅菜最少数量,
g.fdi_maxcount  as 辅菜最大数量,
c.fdi_maxcount  as 数量上限,
c.fdi_practiceid as 做法 ,
h.fdc_practicename as 做法名,
c.fdi_pdtype as  主辅标识, --  1-主  2-辅
e.fdc_dishesname as 套内菜品,
f.fdc_dnname  as  单位
from sys_dishes  a  
left join sys_reportcategory  b on a.fdi_rcid=b.fdi_rcid
left join sys_packagedetailed c on a.fdi_dishesid=c.fdi_pdid
left join sys_auxiliarydishestype g on g.fdi_rpdid=c.fdi_rpdid
left join sys_dishes  d on  d.fdi_dishesid=c.fdi_pdid
left join sys_dishes  e on e.fdi_dishesid =c.fdi_dishesid 
left join sys_dictionary f  on  f.fdi_dnid=c.fdi_dnid
left join sys_practice h on  h.fdi_practiceid=c.fdi_practiceid
where   a.fdb_status=0   -- 堂食
and  a.fdb_packflag=1   -- 套餐
and a.fdi_brandid in (3)
order by a.fdi_brandid,a.fdc_dishesno


#菜谱主表
select fdi_brandid,fdi_menuid,fdc_menuname,fdb_status,fdd_menustarttime ,fdb_takeoutfoodflag 
from sys_menu 
where   fdi_brandid in (1,3)
and fdb_status =0    --  0 -正常  2--删除
and  fdb_takeoutfoodflag=0  -- 0-堂食，  1-外卖
order by fdi_brandid,fdi_order 

#菜谱明细表
select 
a.fdi_menuid, 
a.fdc_menuname,
a.fdb_takeoutfoodflag, -- 0-堂食  1-外卖
b.fdi_dishesid, -- 菜品id
b.fdi_dnid,  -- 单位
b.fdm_price,  -- 单价
b.fdm_memberprice, -- 会员价
b.fdm_ratedcost,  -- 成本
b.fdi_order,  -- 排序
b.fdm_ordercommission, -- 点餐员提成
b.fdc_dishAlias -- 菜品别名
from  sys_menu a join   sys_menudishesprice b on   a. fdi_menuid=b.fdi_menuid
where   a.fdi_brandid in (1,3)
and a.fdb_status =0    --  0 -正常  2--删除
and  a.fdb_takeoutfoodflag=0  -- 0-堂食，  1-外卖
order by a.fdi_brandid,a.fdi_order,b.fdi_order

##菜谱明细表（类别 单位)

select 
a.fdi_menuid, 
a.fdc_menuname,  -- 菜谱名称
a.fdb_takeoutfoodflag, -- 0-堂食  ，1-外卖
d.fdc_rcname,   --  二级菜品类
f.fdc_reccname , -- C 端菜品类
c.fdb_packflag,  -- 套餐标识 0 -菜品，  1 -套餐 
b.fdi_dishesid, -- 菜品id
c.fdc_dishesno,  -- 菜品编码
c.fdc_dishesname, -- 菜品名称
b.fdc_dishAlias, -- 菜品别名
b.fdi_dnid,  -- 单位
e.fdc_dnname,  -- 单位名称
b.fdm_price,  -- 单价
b.fdm_memberprice, -- 会员价
b.fdm_ordercommission, -- 点餐员提成
b.fdi_order  -- 排序
from  sys_menu a join   sys_menudishesprice b on   a. fdi_menuid=b.fdi_menuid
left join sys_dishes c  on b.fdi_dishesid=c.fdi_dishesid
left join sys_reportcategory   d on c.fdi_rcid=d.fdi_rcid
left join  sys_dictionary  e on b.fdi_dnid =e.fdi_dnid
left join sys_computercategory  f on f.fdi_recccid=b.fdi_recccid
where   a.fdi_brandid in (3) and e.fdi_dntype=2 
and a.fdb_status =0    -- 菜谱状态 0 -正常  2--删除
and e.fdb_status=0    -- c端显示类 0 -可用 1-停用 2-删除
and  a.fdb_takeoutfoodflag=0  -- 菜谱 0-堂食，  1-外卖
order by a.fdi_brandid, a.fdi_menuid,d.fdi_order


# 新建堂食营业区对应最新菜谱
create view v_wl_menu_lastday as 
select fdi_blid,max(b.fdd_menustarttime) as menu_starttime -- 最新启用日期的菜谱对应日期
from sys_businesslocmenu a  join sys_menu b on a.fdi_menuid=b.fdi_menuid
group by a.fdi_blid

#门店关联菜谱表
select 
b.fdi_blid,
b.fdi_ognid,
a.fdi_menuid
from sys_businesslocmenu a join   sys_businessloc b on a.fdi_blid=b.fdi_blid
left join sys_menu c on a.fdi_menuid=c.fdi_menuid
left join sys_organizations d on b.fdi_ognid=d.fdi_ognid
left join   v_wl_menu_lastday e on e.fdi_blid=a.fdi_blid
where  c.fdb_status=0
and  b.fdb_status=0
and b.fdc_blname='大厅'
and e.menu_starttime=c.fdd_menustarttime


#门店（堂食营业区)对应菜谱
select 
b.fdi_blid,
d.fdi_brandid,
d.fdi_ognid,
d.fdc_ognname '门店名称',
b.fdc_blname,
c.fdi_menuid ,
c.fdc_menuname '菜谱名称' ,
c.fdd_menustarttime
from sys_businesslocmenu a join   sys_businessloc b on a.fdi_blid=b.fdi_blid
join sys_menu c on a.fdi_menuid=c.fdi_menuid
join sys_organizations d on b.fdi_ognid=d.fdi_ognid
join  v_wl_menu_lastday e on e.fdi_blid=a.fdi_blid
where d.fdb_state=0
and d.fdi_brandid in (1,3) 
and   c.fdb_status=0
and  b.fdb_status=0
and b.fdc_blname='大厅'
and e.menu_starttime=c.fdd_menustarttime
order by d.fdi_brandid,d.fdc_city


## 提成菜品查询
select 
a.fdc_menuname,
c.fdi_dishesid,
c.fdc_dishesname, -- 菜谱名称
b.fdm_ordercommission -- 点餐员提成
from  sys_menu a join   sys_menudishesprice b on   a. fdi_menuid=b.fdi_menuid
left join sys_dishes c  on b.fdi_dishesid=c.fdi_dishesid
left join sys_reportcategory   d on c.fdi_rcid=d.fdi_rcid
left join  sys_dictionary  e on b.fdi_dnid =e.fdi_dnid
where  a.fdi_brandid in (3)  --  1-火锅 3- 鱼谦
and e.fdi_dntype=2   -- 单位名称类
-- and a.fdi_menuid in (144)
-- and  a.fdc_menuname like ('%天津新%') 
and a.fdb_status =0    -- 菜谱状态 0 -正常  2--删除
and  a.fdb_takeoutfoodflag=0  -- 菜谱 0-堂食，  1-外卖
and b.fdm_ordercommission>0
group  by a.fdc_menuname,c.fdi_dishesid,c.fdc_dishesname, b.fdm_ordercommission

#套餐菜品
select fdi_brandid,fdb_status,fdi_brandid,fdi_dishesid,fdi_rcid, fdc_dishesno,fdc_dishesname,fdb_packflag 
from  sys_dishes 
where  fdb_status=0   
and  fdi_brandid=3   
and fdb_packflag=1
order  by  fdi_brandid, fdi_order 


#折扣方案
select fdi_brandid,fdi_dsid,fdc_dsname,
fdi_dstype, -- 折扣方案 1.折扣方案 2. 单菜品折扣 3.会员营销
fdb_status,  -- 状态 0 启用 1 停用 2 删除
fdi_order,
fdb_dishesflag, -- 所有菜品类
fdb_periodtimeflag, -- 所有时段
fdb_validityperiodflag, -- 每星期几
fdc_validityperiod, -- 有效期
fdb_discounttype, -- 折扣类型
fdm_dispercent, -- 折扣率
fdb_platformflag , -- 平台
fdb_dnflag, -- 是否选择折扣理由
fdb_memberflag,  -- 会员
fdc_mutualpmid -- 互斥id
from sys_discountscheme
where  fdi_brandid  in(1,3)
order by fdi_brandid,fdi_dsid

#折扣对应菜品
select 
a.fdi_dsid, -- 折扣方案id
a.fdi_rcid,  -- 菜品类别id
b.fdc_rcname, -- 菜品类别名称
a.fdi_dishesid, -- 菜品id
c.fdc_dishesname, -- 菜品名称
a.fdm_discount,  -- 折扣 
a.fdb_status   -- 状态
from
sys_discountschemedishes a
left join sys_reportcategory   b on b.fdi_rcid=a.fdi_rcid
left join sys_dishes c  on c.fdi_dishesid=a.fdi_dishesid
and a.fdb_status=0


#折扣方案-菜品表
select a.fdi_brandid,
a.fdi_dsid,
a.fdc_dsno,  -- 编码
a.fdc_dsname,
a.fdi_dstype, -- 折扣方案 1.折扣方案 2. 单菜品折扣 3.会员营销
a.fdb_status,  -- 状态 0 启用 1 停用 2 删除
a.fdi_order,
fdb_ogntype, -- 1-桌台类型， 2- 营业区
a.fdb_dishesflag, -- 所有菜品类
a.fdb_periodtimeflag, -- 所有时段
a.fdb_validityperiodflag, -- 每星期几
a.fdc_validityperiod, -- 有效期
a.fdb_discounttype, -- 折扣类型
a.fdm_dispercent, -- 折扣率
a.fdb_platformflag , -- 平台
a.fdb_dnflag, -- 是否选择折扣理由
a.fdb_memberflag , -- 会员
b.fdi_dsid, -- 折扣方案id
b.fdi_rcid,  -- 菜品类别id
c.fdc_rcname, -- 菜品类别名称
b.fdi_dishesid, -- 菜品id
d.fdc_dishesname, -- 菜品名称
b.fdm_discount,  -- 折扣 
a.fdc_mutualpmid  -- 互斥id
from sys_discountscheme a
left join sys_discountschemedishes b on a.fdi_dsid =b.fdi_dsid
left join sys_reportcategory   c on c.fdi_rcid=b.fdi_rcid
left join sys_dishes d  on d.fdi_dishesid=b.fdi_dishesid
where  a.fdi_brandid  in(1,3)
and a.fdb_status=0
-- and a.fdi_dsid=105
order by a.fdi_brandid,a.fdi_dsid

#折扣对应门店表
select b.fdi_brandid,
b.fdc_dsno,   --  折扣方案号
b.fdc_dsname,  --  折扣方案名
c.fdc_ognname 
from sys_ogndiscountscheme a
left join  sys_discountscheme  b on a.fdi_dsid=b.fdi_dsid
left join sys_organizations c on a.fdi_ognid=c.fdi_ognid
where b.fdi_brandid in (1,3)
order by b.fdi_brandid,b.fdd_updatetime desc




#特价菜品明细表
select 
fdi_programid,	-- 优惠方案id
fdi_dishesid,  -- 	菜品id
fdi_dnid, -- 单位id
fdi_menuid, -- 	int(11)	菜谱id
fdi_crowdid, -- 	特价菜对应的 人群id
fdb_dishesflag, -- 	菜品类别 0、普通菜品 1、餐标菜品
fdm_specialofferprice	 -- 	特价金额
from
sys_specialdishes

#特价方案
select 
a.fdi_programid,	-- 优惠方案id
e.fdc_programno, -- 方案编码
e.fdc_validtime , -- 有效日期
a.fdi_dishesid,  -- 	菜品id
c.fdc_dishesno,
c.fdc_dishesname,
a.fdi_dnid, -- 单位id
b.fdc_dnname,
a.fdi_menuid,
d.fdc_menuname, -- 	int(11)	菜谱id
fdi_crowdid, -- 	特价菜对应的 人群id
fdb_dishesflag, -- 	菜品类别 0、普通菜品 1、餐标菜品
fdm_specialofferprice	 -- 	特价金额
from sys_specialdishes a
left join sys_dictionary  b on a.fdi_dnid=b.fdi_dnid
left join sys_dishes c  on c.fdi_dishesid=a.fdi_dishesid
left join sys_menu d  on d.fdi_menuid=a.fdi_menuid
left join sys_marketingprogram e on a.fdi_programid=e.fdi_programid
where  e.fdi_brandid in (1,3)
 and  d.fdb_status=0 
and  e.fdb_programtype=3

#买赠方案
SELECT 
fdi_programid,	-- 	优惠方案id
a.fdi_dishesid,	
c.fdc_dishesno,
c.fdc_dishesname,
-- a.fdi_dnid,  -- 单位
b.fdc_dnname,
a.fdm_count,  -- 	购买数量
-- a.fdi_benefitdishesid,	-- 	优惠菜品id
d.fdc_dishesname as 优惠菜品,
-- fdi_benefitdnid,	-- 	赠送菜品的单位id
e.fdc_dnname as 优惠单位,
fdm_benefitvalue -- 赠送数量、优惠折扣
from sys_benefit a
left join sys_dictionary  b on a.fdi_dnid=b.fdi_dnid
left join sys_dishes c  on c.fdi_dishesid=a.fdi_dishesid
left join sys_dishes d  on d.fdi_dishesid=a.fdi_benefitdishesid
left join sys_dictionary  e on e.fdi_dnid=a.fdi_benefitdnid

#营销方案
select 
fdi_brandid,
fdi_programid,	-- 	满赠优惠方案id
fdc_programno, -- 编码
fdc_programname, -- 方案名称
fdb_programtype, -- 优惠方案类型
 case when  fdb_programtype=1 then '满减'
       when  fdb_programtype=4 then '买赠'
       when  fdb_programtype=5 then '再买优惠'
        else '其他'  end as '活动类型',
fdb_guestflag, -- 	适用人群 1所有人 2普客 3会员
fdb_platformflag, -- 	适用平台 1通用 2仅适用于线上 3仅适用于线下
fdc_validtime, -- 	有效日期 分号间隔
fdb_timeflag, -- 	适用日期级别  1每逢星期几 2每月几号  3每一天
fdb_status,  -- 	状态
fdi_order, -- 	排序
fdc_applytimes, -- 适用时间段  分号间隔
fdi_ogntype,	 -- 适用门店类型，1桌台类型 2营业区 
fdi_limitnum, -- 	限购数量
fdb_isingredientsgive, -- 	买赠方案赠送的菜品或者再买优惠优惠的菜品的配料是否参与折扣 0-否 1-是
fdb_favourabletype	-- 	再买优惠的优惠方式 0-优先优惠价格高的菜品 1-优先优惠价格低的菜品
from  sys_marketingprogram
where fdb_status=0
-- and fdi_ogntype=2
and fdi_brandid in (1,3)
and fdb_programtype<>3
order by fdb_programtype


#营销方案对应门店 营业区表
select b.fdi_brandid,
b.fdb_programtype,
 case when  b.fdb_programtype=1 then '满减'
       when  b.fdb_programtype=4 then '买赠'
       when  b.fdb_programtype=5 then '再买优惠'
        else '其他'  end as '活动类型',
b.fdc_programno,   --  折扣方案号
b.fdc_programname,  
b.fdc_validtime , 
a.fdi_ognid,
c.fdc_ognname as 门店名,
d.fdc_blname as 营业区
from  sys_ognmarketingprogram a 
left join  sys_marketingprogram b on b.fdi_programid=a.fdi_programid
left join sys_organizations c on a.fdi_ognid=c.fdi_ognid
left join sys_businessloc d on  d.fdi_blid=a.fdi_rtid
where b.fdi_brandid in (1,3)
and b.fdb_programtype<>3
order by  b.fdb_programtype





#支付方式
SELECT 
fdi_pmid,	 -- 支付方式id
fdc_pmno,	-- 	编码
fdc_pmname,	
fdi_pmtype,	
fdm_money,   -- 代金券金额
fdb_isnoshishouflag,	-- 	是否计入实收
fdm_shishoupercent,	-- 	实收比列 默认100
fdb_shishoutype,  --	计入实收方式 0、按比例设置实收 1、按固定值计入实收
fdb_ispaymentremark,  -- 	支付方式是否需要自定义备注 0-否 1-是
fdb_status, -- 	状态
fdi_order	  -- 	排序
from sys_payment
where fdb_status =0



#支付方式对应门店
SELECT 
a.fdi_pmid,	 -- 支付方式id
a.fdc_pmno,	-- 	编码
a.fdc_pmname,	
a.fdi_pmtype,	
a.fdm_money,   -- 代金券金额
a.fdb_isnoshishouflag,	-- 	是否计入实收
a.fdm_shishoupercent,	-- 	实收比列 默认100
a.fdb_shishoutype,  --	计入实收方式 0、按比例设置实收 1、按固定值计入实收
a.fdb_ispaymentremark,  -- 	支付方式是否需要自定义备注 0-否 1-是
a.fdb_status, -- 	状态
a.fdi_order,	  -- 	排序
c.fdi_ognid,
c.fdc_ognname
from sys_payment a  
left join sys_ognpayment b on a.fdi_pmid=b.fdi_pmid
left join  sys_organizations c on b.fdi_ognid=c.fdi_ognid
where a.fdi_pmtype in (8,9)




-------------------------------------------------------------------

####储值菜品查询

按区域查询
set @start_day = '2021-03-21';
set @end_day = '2021-04-20';
set @region = '华北大区';
set @location  = (select fdi_dnid   from v_wl_local  where fdc_dnname =@region );
-- 
select 
d.fdc_dnname as 区域,
c.fdc_ognno as 门店编码,
c.fdc_ognname as 门店名称,
e.fdc_epname as 点餐员,
b.fdc_dishesname as 菜品名称,
sum(case when b.fdb_isnoweighing=0 then fdm_count else fdm_czcount end) as 销量,
sum(fdm_dishesamount) as 金额
from sh_shbill a
left join sh_shbilldetailed b on a.fdi_ognid=b.fdi_ognid and a.fdi_billid=b.fdi_billid
left join sys_organizations c on a.fdi_ognid=c.fdi_ognid
left join sys_dictionary d on c.fdi_dnregionid=d.fdi_dnid
left join sys_userinfo e on b.fdi_useepid=e.fdi_epid
where  a.fdi_ognid in ( select fdi_ognid  from  sys_organizations where fdi_brandid= 3)  
and  c.fdi_dnregionid in (select fdi_dnid from v_wl_local where fdi_fatherid=@location )
and a.fdd_paydate BETWEEN @start_day AND @end_day
and b.fdb_packageflag=0
and b.fdc_dishesname like '%储值%'
group by a.fdi_ognid, e.fdc_epname,b.fdi_dishesid,b.fdc_dishesname

**** 
set @start_day = '2021-03-21';
set @end_day = '2021-04-20';
-- set @region = '大连区域';
set @fdc_ognname='鱼谦大连星海店';
set @location  = (select fdi_dnid   from v_wl_local  where fdc_dnname =@region );
select 
d.fdc_dnname as 区域,
c.fdc_ognno as 门店编码,
c.fdc_ognname as 门店名称,
e.fdc_epname as 点餐员,
b.fdc_dishesname as 菜品名称,
sum(case when b.fdb_isnoweighing=0 then fdm_count else fdm_czcount end) as 销量,
sum(fdm_dishesamount) as 金额
from sh_shbill a
left join sh_shbilldetailed b on a.fdi_ognid=b.fdi_ognid and a.fdi_billid=b.fdi_billid
left join sys_organizations c on a.fdi_ognid=c.fdi_ognid
left join sys_dictionary d on c.fdi_dnregionid=d.fdi_dnid
left join sys_userinfo e on b.fdi_useepid=e.fdi_epid
where    a.fdi_ognid in ( select fdi_ognid  from  sys_organizations where fdi_brandid= 3)  
-- and  c.fdi_dnregionid in (select fdi_dnid from v_wl_local where fdi_fatherid=@location )
and c.fdc_ognname=@fdc_ognname 
and a.fdd_paydate BETWEEN @start_day AND @end_day
and b.fdb_packageflag=0
and b.fdc_dishesname like '%储值%'
group by a.fdi_ognid, e.fdc_epname,b.fdi_dishesid,b.fdc_dishesname

***
set @start_day = '2021-03-21';
set @end_day = '2021-04-20';
set @region = '华北大区';
set @location  = (select fdi_dnid   from v_wl_local  where fdc_dnname =@region );

-- select fdi_dishesid from  sys_dishes where fdi_brandid=3   and fdb_status=0  and  fdc_dishesno in ('62301073','62301074','62301075','62301076')
d.fdc_dnname as 区域,
c.fdc_ognno as 门店编码,
c.fdc_ognname as 门店名称,
e.fdc_epname as 点餐员,
b.fdi_dishesid as 菜品id,
b.fdc_dishesname as 菜品名称,
sum(case when b.fdb_isnoweighing=0 then fdm_count else fdm_czcount end) as 销量
-- sum(fdm_dishesamount) as 金额
from sh_shbill a
left join sh_shbilldetailed b on a.fdi_ognid=b.fdi_ognid and a.fdi_billid=b.fdi_billid
left join sys_organizations c on a.fdi_ognid=c.fdi_ognid
left join sys_dictionary d on c.fdi_dnregionid=d.fdi_dnid
left join sys_userinfo e on b.fdi_useepid=e.fdi_epid
where  a.fdi_ognid in ( select fdi_ognid  from  sys_organizations where fdi_brandid= 3)  
and  c.fdi_dnregionid in (select fdi_dnid from v_wl_local where fdi_fatherid=@location )
and b.fdi_dishesid in (  select fdi_dishesid from  sys_dishes where fdi_brandid=3   and fdb_status=0  
and  fdc_dishesno in (62401007,62401008,62401015,62401016,62401022,62401023,62401024,62401020,62401021,62301073,62301074,62301075,62301076))
and a.fdd_paydate BETWEEN @start_day AND @end_day
and b.fdb_packageflag=0
and  b.fdi_dishesid 
 -- and b.fdc_dishesname like '%储值%'
group by a.fdi_ognid, e.fdc_epname,b.fdi_dishesid,b.fdc_dishesname
order by a.fdi_ognid,e.fdc_epname,b.fdi_dishesid



 
  
#门店菜品销量统计 
set @start_day = '2021-04-01';
set @end_day = '2021-04-01';
select 
a.fdi_ognid as 门店id,
a.fdd_paydate as 日期,
b.fdi_dishesid as 菜品id,
b.fdc_dishesname as 菜品名称,
-- b.fdi_practiceid as 做法
sum(case when b.fdb_isnoweighing=0 then fdm_count else fdm_czcount end) as 销量,
sum(fdm_dishesamount) as 金额
from sh_shbill a
left join sh_shbilldetailed b on a.fdi_ognid=b.fdi_ognid and a.fdi_billid=b.fdi_billid
where a.fdd_paydate BETWEEN @start_day AND @end_day
and b.fdb_packageflag=0
group by a.fdi_ognid, a.fdd_paydate ,b.fdi_dishesid,b.fdc_dishesname

#做法分解
select fdi_billid,fdi_rcid,fdi_dishesid,fdc_dishesname,fdm_count,fdm_dishesamount,fdm_realprice,
fdm_practiceamount,fdi_practiceid,SUBSTRING_INDEX(fdi_practiceid,',',1) as practic_1,SUBSTRING_INDEX(fdi_practiceid,',',-1) as practic_2 ,
fdd_updatetime from wl_shbilldetailed_practiceid





#账单明细菜品做法统计
 select a.*,concat(b.fdc_practicename,'+',c.fdc_practicename) as practicname,left(b.fdc_practicename,2) as practicname_1 ,
 left(c.fdc_practicename,2) as practicname_2 
from wl_shbilldetailed_practiceid a LEFT join sys_practice b on a.practic_1=b.fdi_practiceid 
LEFT join sys_practice c on a.practic_2=c.fdi_practiceid 

#账单明细做法
create table  wl_shbilldetailed_practiceid
select fdi_ognid ,fdi_billid,
fdi_billdetailedid  ,
fdm_packageitemid ,
fdi_rcid ,
fdi_dishesid,
fdc_dishesname ,
if(RIGHT(fdc_dishesname,1)='味',
left(fdc_dishesname,char_length(fdc_dishesname)-2), fdc_dishesname) as fdc_dishname,
fdm_count  ,
fdm_dishesamount , 
fdi_useepid , fdm_orderprice ,
fdm_norealprice ,
fdm_realprice ,
fdm_practiceamount  ,
fdi_practiceid,
 cast(SUBSTRING_INDEX(fdi_practiceid,',',1) as decimal) as practic_1,
 cast(SUBSTRING_INDEX(fdi_practiceid,',',-1) AS DECIMAL) as practic_2 ,
fdb_freeflag, fdb_packageflag ,
fdd_updatetime, fdd_sendtime 
from  sh_shbilldetailed  
where fdi_practiceid<>'0' 
and fdd_sendtime between '2020-06-01' and '2020-11-01'




====================================================================
#
select fdi_ognid ,fdi_billid,
fdi_billdetailedid  ,
fdm_packageitemid as 套餐主项id,
fdi_rcid as 菜品二级类id ,
fdi_dishesid,fdc_dishesname ,fdm_count  as   数量 ,
fdm_dishesamount as 金额 , 
fdi_useepid as 点菜员ID, fdm_orderprice as 点餐员提成,
fdm_norealprice as 非实收的支付及抹零优惠金额 ,
fdm_realprice as 实收金额,  fdm_practiceamount as 做法加价 ,
fdb_freeflag as  赠送标识, fdb_packageflag as 套餐标识 ,
fdd_updatetime, fdd_sendtime 
from  wl_shbilldetailed 
order by fdd_sendtime desc 
limit 1000; 


# 统计门店日销售菜品合计

create table wl_shbill_day_dish_sum 
select  b.fdi_ognid,b.fdd_paydate,
a.fdi_dishesid,
a.fdc_dishesname,
sum(a.fdm_count) as count ,
sum( a.fdm_dishesamount ) as amount 
from   wl_shbill b  LEFT JOIN wl_shbilldetailed a  on a.fdi_billid=b.fdi_billid 
where b.fdd_paydate between '2021-01-01' and '2021-01-31'
group by  b.fdi_ognid,b.fdd_paydate,a.fdi_dishesid,a.fdc_dishesname

**

insert into  wl_shbill_day_dish_sum 
select  b.fdi_ognid,b.fdd_paydate,
a.fdi_dishesid,
a.fdc_dishesname,
sum(a.fdm_count) as count ,
sum( a.fdm_dishesamount ) as amount 
from   wl_shbill b  LEFT JOIN wl_shbilldetailed a  on a.fdi_billid=b.fdi_billid 
where b.fdd_paydate between '2021-02-01' and '2021-03-31'
group by  b.fdi_ognid,b.fdd_paydate,a.fdi_dishesid,a.fdc_dishesname





#门店查询
select b.fdc_brandname '品牌', 
       a.fdi_ognid '门店ID',
       a.fdc_ognno '平台门店ID',
       a.fdc_ognnewno  '门店财务编号',
       a.fdc_ognname '门店名称', 
       a.fdc_ognadd  '门店地址',
       a.fdc_ogncontract '联系人',
       a.fdc_ognmobile '手机',
       a.fdc_province '省份',
       a.fdc_city '城市', 
       a.fdi_ogntype '经营模式' , -- 2直营；3加盟
       a.fdb_state  '状态'-- 0正常；1停用；2删除
 from sys_organizations a join sys_brand b on a.fdi_brandid = b.fdi_brandid 

#查询账单表
SELECT
	fdi_ognid,
	fdi_billid,
	fdi_billdetailedid,
	fdm_packageitemid AS 套餐主项id,
	fdi_rcid AS 菜品二级类id,
	fdi_dishesid,
	fdc_dishesname,
	fdm_count AS 数量,
	fdi_dnid AS 单位id,
	fdm_pricea AS 单价,
	fdm_dishesamount AS 金额,
	fdi_menuid AS 菜谱id,
	fdi_practiceid AS 做法,
	fdi_useepid AS 点菜员ID,
	fdm_orderprice AS 点餐员提成,
	fdm_norealprice AS 非实收的支付及抹零优惠金额,
	fdm_realprice AS 实收金额,
	fdm_practiceamount AS 做法加价,
	fdb_freeflag AS 赠送标识,
	fdb_dandiscountflag AS 折扣标识,
	fdb_specialoffer AS 特价标识,
	fdb_packageflag AS 套餐标识,
	fdb_packagezfflag AS 套餐主辅标识,
	fdb_buyagainflag AS 再买优惠标识,
	fdb_fullcutflag AS 满减标识,
	-- fdd_updatetime, 
	fdd_sendtime 发送时间
FROM
	sh_shbilldetailed
WHERE
	fdd_sendtime BETWEEN '2021-04-01'
AND '2021-04-30'
ORDER BY
	fdd_sendtime DESC

#支付明细表

select 
fdi_ognid ,fdi_billid,fdi_billpayid ,fdd_paydate as 营业日期,
a.fdi_pmid as 付款方式, 
a.fdi_pmid as   支付ID,
b.fdc_pmname as 支付方式,
fdm_amount as 源币金额,
fdi_paymode as 计入实收,
fdc_memberno as 会员id,
fdc_memberphone as 会员手机号,
fdc_membername as  会员名称,
fdm_coupon_amount as 团购券金额,
fdm_storedsalepay as 会员实收金额,
fdm_freepay  as  折扣金额,
a.fdi_pmtype as 支付类型 , #"1现金类；2会员消费类；3移动支付；4团购支付类；6挂账消费类；7银联卡类；8代金券类；9其他类；
                           #10免单；11外卖；12银行卡类"
fdi_passages as 支付通道, #"0未知通道；1原生；2美团；3小程序；4ECO；5汇付"
fdi_payplatform as 支付平台 #支付平台 1 支付宝 2 微信 3 银联app 4 手机银行 5 支付宝澳门 6 澳门通钱包 7 广发手机银行 8 丰付宝钱包
from sh_shbillpay a join sys_payment b on a.fdi_pmid=b.fdi_pmid
where  
fdi_billid='3ee5251e-98c6-46be-9aa1-318477115eeb'
and 
fdd_paydate ='2021-04-13'
order by fdi_billid
limit 5000





--------------------------
#做法取第一个和最后一个 =2个口味
drop function f_wl_practicename;
create function f_wl_practicename(practice  varchar(16)) 
returns varchar(50)
-- 生成做法的名称，如多个做法， 取第一个和最后一个
begin 
    declare str1  varchar(10);
    declare str2  varchar(10);
    declare str3  varchar(20);
    declare str4  varchar(20);
    declare str0  varchar(50);
    declare  n  int;
    set n=cast((LENGTH(practice)-LENGTH(REPLACE(practice,",","")))/LENGTH(",") AS UNSIGNED);
 if n<1 then 
  set  str1=substring_index(practice ,',', 1) ;
  select fdc_practicename from  sys_practice  where str1=fdi_practiceid into str0;
 else    
  set  str1=substring_index(practice ,',', 1) ;
  set  str2=substring_index(practice ,',', -1) ;
  select fdc_practicename from  sys_practice  where str1=fdi_practiceid into str3;
  select fdc_practicename from  sys_practice  where str2=fdi_practiceid  into str4;
  set str0= CONCAT_ws("+",str3,str4);
 end if ;
RETURN  str0;
end

口味名称中去掉“味”  ， 方便统计

drop function f_wl_practicename;
create function f_wl_practicename(practice  varchar(16)) 
returns varchar(50)
-- 生成做法的名称，如多个做法， 取第一个和最后一个
begin 
    declare str1  varchar(10);
    declare str2  varchar(10);
    declare str3  varchar(30);
    declare str4  varchar(30);
    declare str0  varchar(50);
    declare  n  int;
    set n=cast((LENGTH(practice)-LENGTH(REPLACE(practice,",","")))/LENGTH(",") AS UNSIGNED);
 if n<1 then 
  set  str1=substring_index(practice ,',', 1) ;
  select fdc_practicename from  sys_practice  where str1=fdi_practiceid into str0;
   set  str0=if(RIGHT(str0,1)='味',left(str0,char_length(str0)-1), str0);
 else    
  set  str1=substring_index(practice ,',', 1) ;
  set  str2=substring_index(practice ,',', -1) ;
  select fdc_practicename from  sys_practice  where str1=fdi_practiceid into str3;
  set str3=if(RIGHT(str3,1)='味',left(str3,char_length(str3)-1), str3);
  select fdc_practicename from  sys_practice  where str2=fdi_practiceid  into str4;
  set str4=if(RIGHT(str4,1)='味',left(str4,char_length(str4)-1), str4);
  set str0= CONCAT_ws("+",str3,str4);
 end if ;
RETURN  str0;
end



select fdi_practiceid,f_wl_practicename(fdi_practiceid) ,
cast((LENGTH(fdi_practiceid)-LENGTH(REPLACE(fdi_practiceid,",","")))/LENGTH(",") AS UNSIGNED)
from wl_shbilldetailed_practiceid
where fdi_practiceid>0 limit 100

# 账单明细表出来， 处理烤鱼去掉单双味、 口味全称名、烤鱼+口味 生成菜品名
SELECT
	fdi_ognid,
	fdi_billid,
	fdi_billdetailedid,
	fdm_packageitemid AS 套餐主项id,
	fdi_rcid AS 菜品二级类id,
	fdi_dishesid,
	fdc_dishesname,
	fdm_count AS 数量,
	fdi_dnid AS 单位id,
	fdm_pricea AS 单价,
	fdm_dishesamount AS 金额,
	fdi_menuid AS 菜谱id,
	fdi_practiceid AS 做法,
	fdi_useepid AS 点菜员ID,
	fdm_orderprice AS 点餐员提成,
	fdm_norealprice AS 非实收的支付及抹零优惠金额,
	fdm_realprice AS 实收金额,
	fdm_practiceamount AS 做法加价,
	fdb_freeflag AS 赠送标识,
	fdb_dandiscountflag AS 折扣标识,
	fdb_specialoffer AS 特价标识,
	fdb_packageflag AS 套餐标识,
	fdb_packagezfflag AS 套餐主辅标识,
	fdb_buyagainflag AS 再买优惠标识,
	fdb_fullcutflag AS 满减标识,
	-- fdd_updatetime, 
	fdd_sendtime 发送时间,
 if(RIGHT(fdc_dishesname,1)='味',left(fdc_dishesname,char_length(fdc_dishesname)-2), fdc_dishesname) as fdc_dishname ,-- 烤鱼去掉单双味 , 
CONCAT( if(RIGHT(fdc_dishesname,1)='味',left(fdc_dishesname,char_length(fdc_dishesname)-2), fdc_dishesname),
'-',f_wl_practicename(fdi_practiceid)) as fdc_dishesname_all,  -- 烤鱼口味名
f_wl_practicename(fdi_practiceid) as practicname_all  -- 口味全称
FROM
	sh_shbilldetailed
WHERE
   fdi_ognid=249 and fdi_practiceid >0 and 
	fdd_sendtime BETWEEN  '2021-07-01' and  '2021-07-02' limit 100
	
	


#口味生成单独的表， 提供出来速度

create table  wl_shbilldetailed_practiceid
select fdi_ognid ,fdi_billid,
fdi_billdetailedid  ,
fdm_packageitemid ,
fdi_rcid ,
fdi_dishesid,
fdc_dishesname ,
if(RIGHT(fdc_dishesname,1)='味',
left(fdc_dishesname,char_length(fdc_dishesname)-2), fdc_dishesname) as fdc_dishname,
fdm_count  ,
fdm_dishesamount , 
fdi_useepid , fdm_orderprice ,
fdm_norealprice ,
fdm_realprice ,
fdm_practiceamount  ,
fdi_practiceid,
 cast(SUBSTRING_INDEX(fdi_practiceid,',',1) as decimal) as practic_1,
 cast(SUBSTRING_INDEX(fdi_practiceid,',',-1) AS DECIMAL) as practic_2 ,
fdb_freeflag, fdb_packageflag ,
fdd_updatetime, fdd_sendtime 
from  sh_shbilldetailed  
where fdi_practiceid<>'0' 
and fdd_sendtime between '2020-05-01' and '2021-01-01'


create  table    wl_shbilldetailed_practiceid
select fdi_ognid ,fdi_billid,
fdi_billdetailedid  ,
fdm_packageitemid ,
fdi_rcid ,
fdi_dishesid,
fdc_dishesname ,
if(RIGHT(fdc_dishesname,1)='味',
left(fdc_dishesname,char_length(fdc_dishesname)-2), fdc_dishesname) as fdc_dishname,
fdm_count  ,
fdm_dishesamount , 
fdi_useepid , fdm_orderprice ,
fdm_norealprice ,
fdm_realprice ,
fdm_practiceamount  ,
fdi_practiceid,
fdb_freeflag, fdb_packageflag ,
fdd_updatetime, fdd_sendtime 
from  sh_shbilldetailed  
where fdi_practiceid<>'0' 
and fdd_sendtime between '2020-04-01' and '2021-08-21'


#口味数量点多了， 需要单独处理
select fdi_ognid, fdi_billid,fdi_billdetailedid, fdi_practiceid  
from sh_shbilldetailed where  fdi_practiceid>'0' and  fdd_sendtime between '2020-08-01' and '2021-11-01'  and LENGTH(fdi_practiceid) >5
fdi_billdetailedid,fdi_practiceid 
29c6853e3b8443b7bed38fb8415dc768	9,10,36
4428da561e754445959fd0030d986e3d	9,10,36
d401cbab9c9a4e288c0902f8dd60d9c3	6,8,9,10,11,15,18,26,27,36
f9c77bc8010a4c8d95fa509ca50d10f0	6,8,9,10,11,15,18,26,27,36
29b95be3a219443bbdbdb51fdf8423de	6,8,10,27
8b25f19c8f4b4dbe8a485a1b7dfb5a55	6,8,10,27
02aafc8b-3fd5-4a68-b7c2-a3926d9fd5bc	9,10,36

update  sh_shbilldetailed  set fdi_practiceid='6,8'  where  fdd_sendtime between '2020-08-12' and '2020-09-06'  and  fdi_billdetailedid in (
'd401cbab9c9a4e288c0902f8dd60d9c3',
'f9c77bc8010a4c8d95fa509ca50d10f0',
'29b95be3a219443bbdbdb51fdf8423de',
'8b25f19c8f4b4dbe8a485a1b7dfb5a55')

update  sh_shbilldetailed  set fdi_practiceid='9,10'  where fdd_sendtime between '2020-08-12' and '2020-09-06'  and fdi_billdetailedid in (
'29c6853e3b8443b7bed38fb8415dc768',
'4428da561e754445959fd0030d986e3d',
'02aafc8b-3fd5-4a68-b7c2-a3926d9fd5bc')


update  sh_shbilldetailed  set fdi_practiceid='9,10'  where fdd_sendtime between '2021-06-12' and '2021-06-14' 
and fdi_billdetailedid ='02aafc8b-3fd5-4a68-b7c2-a3926d9fd5bc';


create table   wl_shbilldetailed_practiceid
select fdi_ognid ,fdi_billid,
fdi_billdetailedid  ,
fdm_packageitemid ,
fdi_rcid ,
fdi_dishesid,
fdc_dishesname ,
if(RIGHT(fdc_dishesname,1)='味',
left(fdc_dishesname,char_length(fdc_dishesname)-2), fdc_dishesname) as fdc_dishname,
fdm_count  ,
fdm_dishesamount , 
fdi_useepid , fdm_orderprice ,
fdm_norealprice ,
fdm_realprice ,
fdm_practiceamount  ,
fdi_practiceid,
 cast(SUBSTRING_INDEX(fdi_practiceid,',',1) as decimal) as practic_1,
 cast(SUBSTRING_INDEX(fdi_practiceid,',',-1) AS DECIMAL) as practic_2 ,
fdb_freeflag, fdb_packageflag ,
fdd_updatetime, fdd_sendtime 
from  sh_shbilldetailed  
where fdi_practiceid<>'0' 
and fdd_sendtime between '2020-04-01' and '2021-08-21'


insert into  wl_shbilldetailed_practiceid
select fdi_ognid ,fdi_billid,
fdi_billdetailedid  ,
fdm_packageitemid ,
fdi_rcid ,
fdi_dishesid,
fdc_dishesname ,
if(RIGHT(fdc_dishesname,1)='味',
left(fdc_dishesname,char_length(fdc_dishesname)-2), fdc_dishesname) as fdc_dishname,
fdm_count  ,
fdm_dishesamount , 
fdi_useepid , fdm_orderprice ,
fdm_norealprice ,
fdm_realprice ,
fdm_practiceamount  ,
fdi_practiceid,
 cast(SUBSTRING_INDEX(fdi_practiceid,',',1) as decimal) as practic_1,
 cast(SUBSTRING_INDEX(fdi_practiceid,',',-1) AS DECIMAL) as practic_2 ,
fdb_freeflag, fdb_packageflag ,
fdd_updatetime, fdd_sendtime 
from  sh_shbilldetailed  
where fdi_practiceid<>'0' 
and fdd_sendtime between '2020-05-01' and '2021-01-01'


做法数据生成，口味生成双记录， 便于统计， 口味数量*0.5
(select fdi_ognid ,fdi_billid,
fdi_billdetailedid  ,
fdc_dishesname ,
fdc_dishname ,
concat(fdc_dishname,'-',f_wl_practicename(fdi_practiceid)) as fdc_dishesname_all,
fdi_practiceid,
f_wl_practicename(fdi_practiceid) as practicname_all,
 cast(SUBSTRING_INDEX(fdi_practiceid,',',1) as decimal) as practic,
f_wl_practicename(SUBSTRING_INDEX(fdi_practiceid,',',1)) as fdc_practicname,
fdm_count,
fdm_practiceamount
from   wl_shbilldetailed_practiceid
where  fdd_sendtime between '2021-06-01' and '2021-06-02' limit 10 )
UNION ALL
(select fdi_ognid ,fdi_billid,
fdi_billdetailedid  ,
f_wl_practicename(fdi_practiceid) as practicname_all,
fdc_dishesname ,
fdc_dishname ,
concat(fdc_dishname,'-',f_wl_practicename(fdi_practiceid)) as fdc_dishesname_all,
fdi_practiceid,
 cast(SUBSTRING_INDEX(fdi_practiceid,',',-1) as decimal) as practic,
f_wl_practicename(SUBSTRING_INDEX(fdi_practiceid,',',-1)) as fdc_practicname,
fdm_count  ,
fdm_practiceamount
from   wl_shbilldetailed_practiceid
where  fdd_sendtime between '2021-06-01' and '2021-06-02' limit 10 )


(select fdi_ognid ,fdi_billid,
fdi_billdetailedid  ,
fdc_dishesname ,
fdc_dishname ,
concat(fdc_dishname,'-',f_wl_practicename(fdi_practiceid)) as fdc_dishesname_all,
fdi_practiceid,
concat(fdc_dishname,'-',f_wl_practicename(fdi_practiceid)) as fdc_dishesname_all,
f_wl_practicename(SUBSTRING_INDEX(fdi_practiceid,',',1)) as fdc_practicname,
fdm_count,
fdm_practiceamount
from   wl_shbilldetailed_practiceid
where  fdd_sendtime between '2020-04-01' and '2021-08-01'  )
union ALL
(select fdi_ognid ,fdi_billid,
fdi_billdetailedid  ,
fdc_dishesname ,
fdc_dishname ,
concat(fdc_dishname,'-',f_wl_practicename(fdi_practiceid)) as fdc_dishesname_all,
fdi_practiceid,
f_wl_practicename(fdi_practiceid) as practicname_all,
f_wl_practicename(SUBSTRING_INDEX(fdi_practiceid,',',-1)) as fdc_practicname,
fdm_count,
fdm_practiceamount
from   wl_shbilldetailed_practiceid
where  fdd_sendtime between '2020-04-01' and '2021-08-01'  )

口味数据错误（ 点的口味数量大于2） 需要处理

fdi_billdetailedid,fdi_practiceid 
266	b79885243a7b46249fdb9ca5698e85e7	d401cbab9c9a4e288c0902f8dd60d9c3	6,8,9,10,11,15,18,26,27,36
266	b7736abb1f43490b8e69df7042e1cc7f	f9c77bc8010a4c8d95fa509ca50d10f0	6,8,9,10,11,15,18,26,27,36
278	905ca2c7550b48d0b03333a5f7e8c029	29b95be3a219443bbdbdb51fdf8423de	6,8,10,27
278	905ca2c7550b48d0b03333a5f7e8c029	8b25f19c8f4b4dbe8a485a1b7dfb5a55	6,8,10,27
251	76db552d7fbf40a7956eb08cf2159e27	29c6853e3b8443b7bed38fb8415dc768	9,10,36
251	76db552d7fbf40a7956eb08cf2159e27	4428da561e754445959fd0030d986e3d	9,10,36
292	761017fe-11a1-458d-a421-855825f6d8b9	02aafc8b-3fd5-4a68-b7c2-a3926d9fd5bc	9,10,36


update  sh_shbilldetailed  set fdi_practiceid='6,8'  where
 fdi_ognid in (266,278) and  fdi_billdetailedid in (
'd401cbab9c9a4e288c0902f8dd60d9c3',
'f9c77bc8010a4c8d95fa509ca50d10f0',
'29b95be3a219443bbdbdb51fdf8423de',
'8b25f19c8f4b4dbe8a485a1b7dfb5a55');

update  sh_shbilldetailed  set fdi_practiceid='9,10'  where 
 fdi_ognid in (251,292)
and fdi_billdetailedid in (
'29c6853e3b8443b7bed38fb8415dc768',
'4428da561e754445959fd0030d986e3d',
'02aafc8b-3fd5-4a68-b7c2-a3926d9fd5bc')



#导入数据

SELECT
	fdi_ognid,
	fdi_billid,
	fdc_billno AS 账单号,
	fdd_paydate AS 营业日期,
	fdi_member AS 人数,
	fdi_tableid AS 桌台id,
	fdb_type AS 就餐类型,
	#堂食 1、外卖 2、外带 3、PARTY4、员工餐 5、试吃 6
	fdi_source AS 订单来源,
	#0 普通  1 扫付  2 微信
	fdi_tatype AS 外卖订单类型,
	# 外卖订单类型1-美团 2-百度 3-饿了么 4-微信外卖 5-到家 6-话务 7-澳觅 8-丰食 9-其他
	fdm_consume AS 合计收费,
	fdm_totalconsume AS 应收金额,
	fdm_realprice AS 订单实收金额,
	#fdm_grantinvoice  as 应开发票金额,
	fdi_channels AS 支付渠道,
	# 0.未知渠道 1. 收银点餐 2. 小程序自助结账  3 品智H5自助结账 4 外卖订单
	fdb_payflag AS 付款标识,
	fdi_payuserid AS 收银员id,
	fdd_paytime AS 结账时间
FROM
	sh_shbill where  fdd_paydate BETWEEN '2020-06-01' and '2020-12-31'

LEFT(fdc_practicname,LEN(fdc_practicname)-1)),


IF(ENDWITH(${自助数据集1_fdc[5f]practicname},“味"),
LEFT(${自助数据集1_fdc[5f]practicname},LEN(${自助数据集1_fdc[5f]practicname})-1),${自助数据集1_fdc[5f]practicname}))

create function f_wl_practicename(practice  varchar(16)) 
returns varchar(50)
-- 生成做法的名称，如多个做法， 取第一个和最后一个

begin 
    declare str1  varchar(10);
    declare str2  varchar(10);
    declare str3  varchar(30);
    declare str4  varchar(30);
    declare str0  varchar(50);
    declare  n  int;
    set n=cast((LENGTH(practice)-LENGTH(REPLACE(practice,",","")))/LENGTH(",") AS UNSIGNED);
 if n<1 then 
  set  str1=substring_index(practice ,',', 1) ;
  select fdc_practicename from  sys_practice  where str1=fdi_practiceid into str0;
   set  str0=if(RIGHT(str0,1)='味',left(str0,char_length(str0)-1), str0);
 else    
  set  str1=substring_index(practice ,',', 1) ;
  set  str2=substring_index(practice ,',', -1) ;
  select fdc_practicename from  sys_practice  where str1=fdi_practiceid into str3;
  set str3=if(RIGHT(str3,1)='味',left(str3,char_length(str3)-1), str3);
  select fdc_practicename from  sys_practice  where str2=fdi_practiceid  into str4;
  set str4=if(RIGHT(str4,1)='味',left(str4,char_length(str4)-1), str4);
  set str0= CONCAT_ws("+",str3,str4);
 end if ;
RETURN  str0;
end

