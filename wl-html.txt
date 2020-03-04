# markdown  
## 语法
1. 标题
2. # 一级
3. ## 二级
4. ### 三级
5. 字体
6. **加粗**
7. *斜体*
8. ~~删除~~
9. 引用 
    > 引用
    >>引用2
            
10. 无序
     * abc
        + efg

11. 有序
    1. abc
    2. efg
       1. efg
       2. 
    
12. 分隔符
    ***
    ---
13. 单行
    
    ~单行程序块~

14. 程序块
    ~~~ 
    代码段
    ~~~

***
# json
~~~
1. 对象使用{}
   ｛ "lastname": "jon"  ｝
2. **键必须是字符串**
3. 键和值由：分割
4. 值可以是对象、数组、字符串、数字 或 true, flash,null 
5. 多个键逗号， 隔开
6. 数组 []
7. 可有层级
~~~
***
# yaml
1. ## 键值对  K: <**1个空格**> V
2. 空格表示层级
3. ## 值： 字符串不用引号
   ~~~
    " 转义特殊符号。 

    ' 不转义， 直接照样打印~~~

4. ## 对象  ： k 对象；  V 值
    ~~~
    friends：
        lastername: wl
        age: 22 
    ~~~

5.  ## 行内写法：
    firends： {lastername: wl, ege: 22}

6. ## 数组
   用 - 标识数组中的元素
    ~~~
     pets:
       - cat
       - dog 
       - pig
    ~~~
    行内写法：
    ~ pets： [cat,dog,pig]


***
# html #

1. doctype  对应关系
   + <!doctype html>
2. html标签 , 标签内部可以写属性  ---》 只能有一个
3. 注释  <!--    注释内容    --> 
4. 标签分类
    自闭合标签
    <meta charset="utf-8">
    <meta http-equiv="Refresh" Counter="3"> 自动刷新
    <meta>
     主动闭合
    <title>Title </title>   可显示
   <meta name='keywords" content="关键字搜索">
   <meta name="description" content="内容">  网站内容描述
5. head标签：
    -  <meta http-equiv="X-UA-Compatible" content="IE=IE9;IE=IE8;"/>
    -  title 标签
    -  link 设置图标
    -  style
    -  script
6.  body 标签
      &nbsp  -空格;  &gt>  -大于号 ;  &lt<  -小于号
       -  P 标签 <p>  段落
       -  br  标签 <br/> 换行-自闭合标签显示
	   -  hr  头行分隔符
       -  h  标签<h1>   n-字体（1，2..6) -标题
	 div
	 span
	 h 系列标签
***  
  标签总结
  所有标签分为：
     块级标签   H 标签  P标签(段落间有间距) ， div(白板)
     行内标签（内联标签） ：<span> 白板
   标签之间可以嵌套
   标签存在的意义， css操作， js操作
   ps：chrome 审查元素的使用。
		- 定位
        - 查看样式
7. input 系列 + form 标签
	input type='text'   - name 属性  value='wl’
	input type='password'   -  name 属性  value='wl’
	input  type='submit'   - value='提交’  提交按钮  ， 表单
	input  type=‘button’  - value=‘登陆’  按钮
	input type=‘radio’  -   单选框 value， checked=‘checked’ ， name 属性 （name相同则互斥）
	input type=‘checkbox' -复选框  value， checked=’checked' , name 属性（批量获取数据）
	
	input type=‘file'  - 依赖form表单的一个属性  enctype=‘multipart/form-data'
	input type='rest'  - 重置
	
	<textarea> 默认值</textarea>   -name 属性
	
	select  标签   - name , 内部option value， 提交到后台， size， multipe
8.  a标签
     - 跳转
	 - 锚点   href=’#某个标签额id‘， 标签的id不允许重复
9.  img
		src
		alt
		title
10.  列表
	ul
		li
	ol
		li
	dl	
		dt
		dd
11. 表格
		table
			thead
				tr
					th
			tbody
				tr
					td
		colspan = ’'
		rowspan = ''
12. lable
	 用于点击文件， 使得管理的标签获取光标
	 <label  for ='username'> 用户名：</label>
	 <input id='username' type='text' name='user" />
13. fieldset
     legend

***
# css

编写css样式：
1. 标签的style属性
2.  ID、 类名的第一个字符不能使用数字！
3. 不要在属性值与单位之间留有空格。
4. 指定特定的HTML元素使用class。 所有的 p 元素使用 class="center" 让该元素的文本居中: p.class="center" 让该元素的文本居中 

4. 写在head里面， style标签中的样式，
   <head> <link rel="stylesheet" type="text/css" href="mystyle.css"> </head>
	- id  选择器
			#id{
				backupground-color: #2459a2;
				height: 48px;
				}
	- class 选择器 
			.名称｛
					...
					}
					
			<标签 class=’名称'> </标签>
			
	- 标签选择器
			div｛
				...
				}
		
			所有div设置此样式
	- 层级选择器 （空格）
			.c1 .c2 div{
						....
						}
	- 组合选择器（逗号）
			.C1,.C3,div｛
						....
						}
	- 属性选择器
			对选择到的标签再通过属性再进行一次筛选
			.c1 [n='alex'] {width:100px;height:200px;}
			
	ps:
	   - 优先级  ， 标签上style优先，编写顺序， 就近原则。
	   CSS 优先级法则：
			 A 选择器都有一个权值，权值越大越优先；
			 B 当权值相等时，后出现的样式表设置要优于先出现的样式表设置；
			 C 创作者的规则高于浏览者：即网页编写者设置的CSS 样式的优先权高于浏览器所设置的样式；
			 D 继承的CSS 样式不如后来指定的CSS 样式；
			 E 在同一组属性设置中标有"!important"规则的优先级最大；
				  
	CSS 样式可以写到单独的文件中
	    <link rel="stylesheet"  href="commons.css“ />
		
	
	   
	备注 
	    /*       */
	
4.  边框
	- 宽度。样式、验收（board: 4px  botted red;)
	- board-left
	
5.  hight.    高度  百分比
	width      宽度  像素  百分比
	text-align:center 水平方向居中
	line-height.  垂直方向根据标签高度
	color   字体颜色
	font-size  字体大小
	font-weight  字体加粗
	
6.  背景
7.  float
		让标签浪起来，块级标签也可以堆叠
		老子管不住：
		  <div style="clear: both;"></div>
		  
8.  display：
		display: none;  -让标签消失
		display： inline；
		display： block；
		display： inline-block;
					具有inline， 默认自己占多少就占多少
					具有block； 可以设置无法设置的高度、 宽度、padding、margin
					
		******
		行内标签：  无法设置高度、宽度 、 padding、 margin
		块级标签：	设置高度、宽度、padding、margin
		
9.    padding  margin （0，auto）
		边距
		margin  （外边距）   0 auto；
		padding： （内边距） --> 自身发生变化
		
10     position：
		a.   fixed  固定在页面的某个位置。
		b.    relative + absolute
					< div  style='position : releative;'>
							<div style='position:absolute; top:0;left:0;'></div>
					</div>
					
			relative --单独没有意义
            absolute  --第一次定位。可以指定位置、滚轮滚动是， 不在了。
						
11. opacity: 0.5  透明度
12. z-index：  层级顺序
13. overflow:  hidden, auto  滚动条
14.  hover

15. background-image:url('image/4.gif'); #默认div大， 图片重复
	background-repeat:  repeat-y;
	background-position-x;
	background:
	background-position-y;


***js
JavaScript
	独立的语言， 浏览器具有js解释器
	
1	JavaScript 代码存在形式：
		- Head 中
			<script>
				// JavaScript 代码
					alter （123）；
			</script>
			
			<script  type="test/Javascript">
				//Javascript 代码
					alter（123）；
			</script>
			
		-  文件
			<script src='js 文件路径’></script>
		ps:  JS 代码需要放置到<body>标签内部的最下方。
		
2	存在于HTML中
		注释：
		    当前行： //
			多行注释：/*      */
			
3	基本数据类型
		数字 
			a=18；
		字符串
			a=”alix“
			a.charAt(索引位置）
			a.substring(起始位置、终止位置）
			a.lenght 获取当前字符串长度
		列表
			a = [11,22,33,44,55,55]
		字典
			a = {'k1':'1';'k2':'v2'}
			
		布尔类型
		    小写   false  true
		
4	条件语句
	for  循环
		1.  循环时， 循环的元素是索引
			a =[11,22,33,44]
			for  (var  item in a ){
			   console.log(item);
			   }
		2.  
		   for  (var i=0 ; i<10;i++){
		       js  语句
			   }
			不支持字典的循环
	条件语句：
		if  （条件){
		} else if (条件）｛
		｝else｛
		｝
		
		switch（name){
		    case：  ;
			case:   ;
			default:
			 
			}
		
		
		==  值相等
		===  值和类型都相等
		&&  and
		||  or
	
5	函数：
		function 函数名（形参）｛
		｝
		函数名（实参）
		
	
	 匿名函数
		function function（arg）｛
			return  arg+1
			
		｝
	自执行函数 (创建函数并自动执行）
		funcation  func（）｛
		
		｝
		func()
		
		｛function（arg）{
			console.log(arg);
			}}
	  
6	 序列化：
	  Json。stringify()  - 将对象转换车字符串
	  Json.parse()     -将字符串转换成对象类型
	  
7	  转义
	     客户端（cookie） -》  服务器
		 将数据经过转义后 保存到cookie
8	evel
	  
9	时间
	date 类
	
	  var d = new Date()
	   d.getXXX 获取
	   d.setXXX  设置
	  
10 作用域
     函数为作用域	    
	 函数的作用域在函数未使用之前， 就已经创建
	 函数的作用域存在作用域链，并且在被调用用之前创建
	 函数内局部不安了提前声明
	  
	
	定时器：
	  setInterval（’执行代码‘，时间间隔）
	  
	  其他：  alter（）
	          console.log()
	  
DOM:
	1. 找标签
		获取单个元素            document.getElmentByid('i1')
		获取多个元素（列表）    document.getElmentByTagName('div')
		获取多个原始（列表）	document.getElmentByClassName（'c1')
		
		1. 直接找：
			document.getElemntById    		根据id 获取第一个标签
			document.getElemntsByName		更加name属性获取标签集合
			document.getElemntsByClassName 		根据class属性获取标签集合
			document.getElemntsByTagName		根据标签名获取标签集合

            var obj =  document.getElementByid('i1')
			
			
		2. 间接找：
			tag =  document.getElementById('i1')
			
			 parentElement   			//父节点标签元素
			 children					//所有子标签
			 firstElementChild			//第一个子标签元素
			 lastElementChild			//最后一个子标签元素
			 nextElementSibling			//下一个兄弟标签元素
			 previousElementSibling     //上一个兄弟标签元素
			 
			 文件内容操作:
			    innerText  仅文本
				innerHTML   全内容
				value
				    input  value 获取当前标签中的值
					select  获取选中的value值（selectindex）
					textarea  value  获取当前标签中的值
			
				样式操作：
					className
					classList
						classList.add
						classList.remove
						
					obj.style.fontsize ='16px';
					obj.style.backgroupcolor='red';
					obj.style.color='red';
					
				属性操作：
					attributes
					getAttribute
					removeAttribute
					
				创建标签， 并添加到HTML中
					a.  字符串形式
					b.  对象形式
						document.createElement('div')
				提交表单
					任何标签通过DOM都可以提交表单
						document.getElementById('form'.submit()
				其他
					console.log()
					alter
					var v=confirm(信息）  v: true  false
					
					location.href
					localtion.href =''  # 重定向， 跳转
					loation.reload()    # 页面刷新
					localtion.href = location.href  ->  location.reload()
					
					var o1=setInterval(function(){),5000)
					
					clearInterval(o1);
					
					var o2 =setTimeout(funnction()(),50000)
					clearTimetout(o2);
					
					var obj=setInterval(funcation(){
					},5000)
					
					clearInterval(obj);
					cleartimeout（obj);
					
						
				
				  
			 
	2.  操作标签：
	
		a.  innertext
		
			获取标签中的文本内容
			标签.innerText  
			
			对标签内部文本进行重复复制
			
			标签.innerText =""
			
		b. classname:
			tag.className =>  直接整体做操作
			tag.ClassList.add ('样式名’）   添加指定样式
			Tag.classList.remove('样式名‘） 删除指定样式
			
	3.   事件
			    <div  onclick='func();'>点我</div>
				<script>
					function func(){
						}
				</script>
			
		 3.  checkBox
				获取值
				checkBox 对象.checked  - 
				设置值
				checkbox 对象.checked = true
		
	4.  事件
			onclick， onblur，onfocus
			  行为  样式  结构   相分离的页面
			  js     css	html
			  
			绑定使用两种方式：
			
				a.  直接标签绑定  onclick=‘xxx()'   onfocus
				b.  先获取DOM 对象， 然后进行绑定
					document.getElementById('xx').onclick
					document.GetElementByid('xx').onfocus
					
				this:  当前触发事件的标签。
				a.  第一种绑定方式
					<input  type='botton' onclick ='clickon(this)'>
					   function clickon(self){
					    // self  当前点击的标签
					   }
					   
				b.  第二中绑定方式
					<input id='i1' type='botton'>
					document.getElmentById('i1').onclick=function(){
					  //  this 代指当前点击标签
					 ｝
				作用域示例：
					var  myTrs = document.getElementByTagName('tr');
					var   len = myTrs.length;
					for (var i=0 ; i<len; i++) {
						myTrs[i].onmouseover = function(){
							this.style.backgroupcolor = 'red';
						};
					}


*** Jquery
  http://Jquery.cuishifeng.cn
  
  模块 《=》 类库
  DOM/BOM/javaScript 的类库
  
  <script src="jquery-1.12.4.js"></script)
  

一. 查找元素
	DOM  
		10 
	jQuery：
		选择器
		筛选
	版本：
	  1.X    1.12.4
	  2.X
	  3.X
	  
	  转换  
		jQuery 对象[0]  => DOM 对象
		Dom对象         => $(Dom对象）
		
		
	jQuery：
		选择器， 直接找到某个或某类标签
		1.  id：
			$('#id’)
		2.	class
			<div class='c1'></div>
			$('.c1')
		3. 标签
			<div class='c1'>
				<a>f</a>
				<a>g</a/>
			</div>
			<div class='c1'>
				<div class='c2'></div>
			<div>
		4. 组合
			$('a')
			$('.c2')
			$('aa,.c2,#i10)
		5. 层级
			$('#i10 a')  子子孙孙
			$('#i10>a')  儿子
			
		6.  基本
			:first
			:last
			:eq()
			
		7. 属性
			$('[alex]')    具有alex属性的所有标签
			$('[alex='123'])  alex属性等于123的标签
			
			<input  type = 'text' />
			<input  type = 'botton' />
			<input  type = 'file' />
			<intpu type = 'password' />
			$("input [type='text'])
			$(':text')
			
		示例
			多选  反选  全选
			-	选择权
			- 	
				$('#tb:checkbox').prop('checked');    获取值
				$('#tb.checkbox').prop('checked', true);  设置值
				
			-	jQuer 方法内置循环  $('#tb:checkbox').xxx
		
			-	$('#tb:checkbox').each(function(k){
						//k  当前索引
						// this DOM  当前循环的元素 $(this)
						}
					)
			- var  v= 条件 ？ 真值：假值
		
			筛选
			 $(this).next()  下一个
			 $(this).nextAll() 
			 $(this).nextuntil(’#i1‘） 
			 
			 $(this).prev()  上一个
             $(this).prevAll()  
			 $(this).prevuntil()

			 上一个
			 $(this).parent()  父
			 $(this).parents()  父
			 $(this).parentsuntil()  父
			 
			 $(this).children()  孩子
			 $('#i1').siblings() 兄弟
			 $(’#1').find('#i1') 子子孙孙中查找
			 $('#i1').find()
			 $('li:eq(1)')
			 $('li).eq()
			 first()
			 last()
			 hasclass(class)
			 
			 
			 $('#i1').addClas(..)
			 $('#i1').removeClass(..)
			 
			 $(this).next().removeClass('hide')
			 $(this).parent().siblings().find('.contnt').addClass('hide')
			 
			 $(this).next().removeClass('hide').parent().siblings().find('.content').addclass('hide')
		
	文本操作：
		$(..).text()   #获取文本内容
		$(..).text('<a>1</a>')  #设置文本内容
		
		$(..).html()
		$(..).html("<a>1</a>")
		
		$(..).val()		获取值 （ input  select  textarea）
		$(..).val(..)  设置值
	
	样式操作
		addClass
		removeClass
		taggleClass
		
	属性操作：
	    #  专门用于做自定义属性
		$(..).attr('n')
		$(..).attr('n','v')
		$(..).removeAttr('n')
		
		<input type='checkbox' id='i1' .?
		
		# 专门用于 checkbox  radio
		$(..).prop('checked')
		$(..).prop('checked', true)
		
			ps:  
				index  获取索引位置
				
			$(#a2').click(function(){
				var index=$('#t1').val();
				$('#ul  li').eq(index).remove()
			
	文档处理
		append
		prepend
		after
		before
		remove
		empty
		clone
		
	Css 处理
	
		$('t1').css('样式名称‘，’样式值‘)
		 点赞：
			$('t1').append()
			$('t1').remove()
			setInterval
			透明度  0 ~ 1
			position
			字体大小、位置。
			
		位置
			$(windows).scrollTop()   获取
			$(windows).scrolltop(0)   设置
			scrollLeft（[val]）
			
			offset().left    指定标签在html中的坐标
			offset().top     指定标签在回弹模量的坐标
			
			position()       指定标签相对父标签（relative)标签的坐标
			    <div style='relative'>
					<div id='i1' style='postition:absolute;'></div>
				</div>
			
			$('i1').height()					获取标签的高度 纯高度
			$（'i1').innerHeight()				获取边框+纯高度
			$('i1').outerHeight()				获取边框
			$('i1').outerHeight(true）			设置边框
			
		事件
			DOM   三种绑定方式
			jQuery：
				$('.c1').click()
				$('.c1'). .....
				
			$('.c1').bind('click',function(){
			})
			
			$('.c1').unbind('clock',function(){
			}}
			
			$('.c1').delegate('a',;click',function(){
			}）
			
			$('.c1').undelegate('a',click',function(){
			})
			
			$('.c1').on('click',function(){
			})
			
			$('.c1').off('click',function(){
			})
			
		阻止事件发生
			return false
		
		# 当页面框架加载完成之后， 自动执行
		$(function(){
		}
		
		jQuery 扩展：
		-	$.extend      $.方法
		-	$.fn.extend		$(..).方法
		
		(function(){
			var status =i;
			// 封装变量
			}) (jQuery)
			
			
			
		
		
			
			
			

	
		
			



				
			   
   

		
		

	
	

		
	
			
				



	 
	 
	
		
   

    




