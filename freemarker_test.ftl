<!--assign-->
<#assign seasons = ["winter", "spring", "summer", "autumn"]>
<#assign test = test + 1>  
<#assign
  seasons = ["winter", "spring", "summer", "autumn"]
  test = test + 1
>
<#import "/mylib.ftl" as my>
<#assign bgColor="red" in my>  
<#macro myMacro>foo</#macro>
<#assign x>
  <#list 1..3 as n>
    ${n} <@myMacro />
  </#list>
</#assign>
Number of words: ${x?word_list?size}
${x}
<#assign x>Hello ${user}!</#assign> <#-- BAD PRACTICE! -->
<#assign x="Hello ${user}!">

<!--attempt-->
Primary content
<#attempt>
  Optional content: ${thisMayFails}
<#recover>
  Ops! The optional content is not available.
</#attempt>
Primary content continued

<!--switch, case and default-->
<#switch being.size>
  <#case "small">
     This will be processed if it is small
     <#break>
  <#case "medium">
     This will be processed if it is medium
     <#break>
  <#case "large">
     This will be processed if it is large
     <#break>
  <#default>
     This will be processed if it is neither
</#switch>

<#switch x>
  <#case x = 1>
    1
  <#case x = 2>
    2
  <#default>
    d
</#switch>


<!--compress-->
<#assign x = "    moo  \n\n   ">
(<#compress>
  1 2  3   4    5
  ${moo}
  test only

  I said, test only

</#compress>)


<!--if, elseif and  else--->
<#if x == 1>
  x is 1
</#if>  

<#if x == 1>
  x is 1
<#else>
  x is not 1
</#if>  

<#if x == 1>
  x is 1
<#elseif x == 2>
  x is 2
<#elseif x == 3>
  x is 3
</#if>  

<#if x == 1>
  x is 1
<#elseif x == 2>
  x is 2
<#elseif x == 3>
  x is 3
<#elseif x == 4>
  x is 4
<#else>
  x is not 1 nor 2 nor 3 nor 4
</#if>  

<#if x == 1>
  x is 1
  <#if y == 1>
    and y is 1 too
  <#else>
    but y is not
  </#if>
<#else>
  x is not 1
  <#if y < 0>
    and y is less than 0
  </#if>
</#if>


<!--escape, noescape-->
<#escape x as x?html>
  First name: ${firstName}
  Last name: ${lastName}
  Maiden name: ${maidenName}
</#escape>

  First name: ${firstName?html}
  Last name: ${lastName?html}
  Maiden name: ${maidenName?html}

<#assign x = "<test>">
<#macro m1>
  m1: ${x}
</#macro>
<#escape x as x?html>
  <#macro m2>m2: ${x}</#macro>
  ${x}
  <@m1/>
</#escape>
${x}
<@m2/>

<#escape x as x?html>
  From: ${mailMessage.From}
  Subject: ${mailMessage.Subject}
  <#noescape>Message: ${mailMessage.htmlFormattedBody}</#noescape>
</#escape>

From: ${mailMessage.From?html}
  Subject: ${mailMessage.Subject?html}
  Message: ${mailMessage.htmlFormattedBody}

	

<#escape x as x?html>
  Customer Name: ${customerName}
  Items to ship:
  <#escape x as itemCodeToNameMap[x]>
    ${itemCode1}
    ${itemCode2}
    ${itemCode3}
    ${itemCode4}
  </#escape>
</#escape>  

  Customer Name: ${customerName?html}
  Items to ship:
    ${itemCodeToNameMap[itemCode1]?html}
    ${itemCodeToNameMap[itemCode2]?html}
    ${itemCodeToNameMap[itemCode3]?html}
    ${itemCodeToNameMap[itemCode4]?html}  


<!--visit, recurse, fallback-->
<#-- Assume that nodeWithNameX?node_name is "x" -->
<#visit nodeWithNameX>
Done.
<#macro x>
   Now I'm handling a node that has the name "x".
   Just to show how to access this node: this node has ${.node?children?size} children.
</#macro>  

<#import "n1.ftl" as n1>
<#import "n2.ftl" as n2>

<#-- This will call n2.x (because there is no n1.x): -->
<#visit nodeWithNameX using [n1, n2]>

<#-- This will call the x of the current namespace: -->
<#visit nodeWithNameX>

<#macro x>
  Simply x
</#macro>  

<#macro y>
  n1.y
</#macro>

<#macro x>
  n2.x
  <#-- This will call n1.y, becuase it inherits the "using [n1, n2]" from the pending visit call: -->
  <#visit nodeWithNameY>
  <#-- This will call n2.y: -->
  <#visit nodeWithNameY using .namespace>
</#macro>

<#macro y>
  n2.y
</#macro>

<#-- Assume that nodeWithNameX?node_name is "x" -->
<#visit nodeWithNameX>

<#-- Assume that nodeWithNameY?node_type is "foo" -->
<#visit nodeWithNameY>

<#macro x>
Handling node x
</#macro>

<#macro @foo>
There was no specific handler for node ${node?node_name}
</#macro>  

<#recurse someNode using someLib>

<#list someNode?children as child><#visit child using someLib></#list>

<#list .node?children as child><#visit child></#list> 

	

<#import "/lib/docbook.ftl" as docbook>

<#--
  We use the docbook library, but we override some handlers
  in this namespace.
-->
<#visit document using [.namespace, docbook]>

<#--
  Override the "programlisting" handler, but only in the case if
  its "role" attribute is "java"
-->
<#macro programlisting>
  <#if .node.@role[0]!"" == "java">
    <#-- Do something special here... -->
    ...
  <#else>
    <#-- Just use the original (overidden) handler -->
    <#fallback>
  </#if>
</#macro>

<!--function, return-->
<#function avg x y>
  <#return (x + y) / 2>
</#function>
${avg(10, 20)}

<#function avg nums...>
  <#local sum = 0>
  <#list nums as num>
    <#local sum = sum + num>
  </#list>
  <#if nums?size != 0>
    <#return sum / nums?size>
  </#if>
</#function>
${avg(10, 20)}
${avg(10, 20, 30, 40)}
${avg()!"N/A"}


<!--flush-->
<#flush>


<!--ftl-->
<#ftl param1=value1 param2=value2 ... paramN=valueN>


<!--global-->
<#global name=value>

<#global name1=value1 name2=value2 ... nameN=valueN>

<#global name>
  capture this
</#global>


<!--import-->
<#import "/libs/mylib.ftl" as my>

<@my.copyright date="1999-2002"/>  


<!--include-->
<#assign me = "Juila Smith">
<h1>Some test</h1>
<p>Yeah.
<hr>
<#include "/common/copyright.ftl">  

<#include "/common/navbar.html" parse=false encoding="Shift_JIS">  

<#include "*/footer.ftl">


<!--list-->
<#assign seq = ["winter", "spring", "summer", "autumn"]>
<#list seq as x>
  ${x_index + 1}. ${x}<#if x_has_next>,</#if>
</#list>

<#assign x=3>
<#list 1..x as i>
  ${i}
</#list>  

<#list seq as x>
  ${x}
  <#if x = "spring"><#break></#if>
</#list>  


<!--local-->
<#local name=value>

<#local name1=value1 name2=value2 nameN=valueN>

<#local name>
  capture this
</#local>


<!--t, lt, rt, nt-->
<#t>

<#lt>

<#rt>

<#nt>


<!--macro, nested, return-->
<#-- call the macro; the macro variable is already created: -->
<@test/>
<#-- create the macro variable: -->
<#macro test>
  Test text
</#macro>  

<#macro test>
  Test text
</#macro>
<#-- call the macro: -->
<@test/>  

	

<#macro test foo bar baaz>
  Test text, and the params: ${foo}, ${bar}, ${baaz}
</#macro>
<#-- call the macro: -->
<@test foo="a" bar="b" baaz=5*5-2/>

	

<#macro test foo bar="Bar" baaz=-1>
  Test text, and the params: ${foo}, ${bar}, ${baaz}
</#macro>
<@test foo="a" bar="b" baaz=5*5-2/>
<@test foo="a" bar="b"/>
<@test foo="a" baaz=5*5-2/>
<@test foo="a"/>

<#macro list title items>
  <p>${title?cap_first}:
  <ul>
    <#list items as x>
      <li>${x?cap_first}
    </#list>
  </ul>
</#macro>
<@list items=["mouse", "elephant", "python"] title="Animals"/>

<#macro img src extra...>
  <img src="/context${src?html}" 
  <#list extra?keys as attr>
    ${attr}="${extra[attr]?html}"
  </#list>
  >
</#macro>
<@img src="/images/test.png" width=100 height=50 alt="Test"/>

<#macro do_twice>
  1. <#nested>
  2. <#nested>
</#macro>
<@do_twice>something</@do_twice>

<#macro do_thrice>
  <#nested 1>
  <#nested 2>
  <#nested 3>
</#macro>
<@do_thrice ; x>
  ${x} Anything.
</@do_thrice>

<#macro repeat count>
  <#list 1..count as x>
    <#nested x, x/2, x==count>
  </#list>
</#macro>
<@repeat count=4 ; c, halfc, last>
  ${c}. ${halfc}<#if last> Last!</#if>
</@repeat>

<#macro test>
  Test text
  <#return>
  Will not be printed.
</#macro>
<@test/>


<!--setting-->
${1.2}
<#setting locale="en_US">
${1.2}


<!--stop-->
<#stop>
<#stop reason>


<!--user-defined directives-->
<@html_escape>
  a < b
  Romeo & Juliet
</@html_escape>

<@list items=["mouse", "elephant", "python"] title="Animals"/>
<#macro list title items>
  <p>${title?cap_first}:
  <ul>
    <#list items as x>
      <li>${x?cap_first}
    </#list>
  </ul>
</#macro>  

<@myRepeatMacro count=4 ; x, last>
  ${x}. Something... <#if last> This was the last!</#if>
</@myRepeatMacro> 

<@myRepeatMacro count=4 ; x>
  ${x}. Something...
</@myRepeatMacro> 


<@myRepeatMacro count=4>
  Something...
</@myRepeatMacro>


<!--end of directives-->



<!--start of built-ins-->

<!--built-ins for strings - see http://freemarker.sourceforge.net/docs/ref_builtins_string.html -->
<!--substring-->
- ${'abc'?substring(0)}
- ${'abc'?substring(1)}
- ${'abc'?substring(2)}
- ${'abc'?substring(3)}

- ${'abc'?substring(0, 0)}
- ${'abc'?substring(0, 1)}
- ${'abc'?substring(0, 2)}
- ${'abc'?substring(0, 3)}

- ${'abc'?substring(0, 1)}
- ${'abc'?substring(1, 2)}
- ${'abc'?substring(2, 3)}


<!--cap_first-->
${"  green mouse"?cap_first}
${"GreEN mouse"?cap_first}
${"- green mouse"?cap_first}


<!--uncap_first-->
${"  green mouse"?uncap_first}
${"GreEN mouse"?uncap_first}
${"- green mouse"?uncap_first}


<!--capitalize-->

${"  green  mouse"?capitalize}
${"GreEN mouse"?capitalize}  


<!--chop_linebreak-->
${"GreEN 
mouse"?chop_linebreak}  


<!--date, time, datetime-->
<#assign test1 = "10/25/1995"?date("MM/dd/yyyy")>
<#assign test2 = "15:05:30"?time("HH:mm:ss")>
<#assign test3 = "1995-10-25 03:05 PM"?datetime("yyyy-MM-dd hh:mm a")>
${test1}
${test2}
${test3}

<#assign test1 = "Oct 25, 1995"?date>
<#assign test2 = "3:05:30 PM"?time>
<#assign test3 = "Oct 25, 1995 03:05:00 PM"?datetime>
${test1}
${test2}
${test3}


<!--ends_with-->
"redhead"?ends_with("head")


<!--html-->
<input type=text name=user value="${user?html}"> 


<!--groups, matches-->

<#if "fxo"?matches("f.?o")>Matches.<#else>Does not match.</#if>

<#assign res = "foo bar fyo"?matches("f.?o")>
<#if res>Matches.<#else>Does not match.</#if>
Matching sub-strings:
<#list res as m>
- ${m}
</#list>

<#assign res = "aa/rx; ab/r;"?matches("(\\w[^/]+)/([^;]+);")>
<#list res as m>
- ${m} is ${m?groups[1]} per ${m?groups[2]}
</#list>


<!--index_of-->
"abcabc"?index_of("bc")

"abcabc"?index_of("bc", 2)


<!--j_string-->

<#assign beanName = 'The "foo" bean.'>
String BEAN_NAME = "${beanName?j_string}";


<!--js_string-->

<#assign user = "Big Joe's \"right hand\"">
<script>
  alert("Welcome ${user?js_string}!");
</script>


<!--json_string-->

"abcabc"?json_string


<!--last_index_of-->

"abcabc"?last_index_of("ab")

"abcabc"?last_index_of("ab", 2)


<!--length-->

"abcabc"?length


<!--lower_case-->

"GrEeN MoUsE"?lower_case


<!--left_pad-->

[${""?left_pad(5)}]
[${"a"?left_pad(5)}]
[${"ab"?left_pad(5)}]
[${"abc"?left_pad(5)}]
[${"abcd"?left_pad(5)}]
[${"abcde"?left_pad(5)}]
[${"abcdef"?left_pad(5)}]
[${"abcdefg"?left_pad(5)}]
[${"abcdefgh"?left_pad(5)}]

[${""?left_pad(5, "-")}]
[${"a"?left_pad(5, "-")}]
[${"ab"?left_pad(5, "-")}]
[${"abc"?left_pad(5, "-")}]
[${"abcd"?left_pad(5, "-")}]
[${"abcde"?left_pad(5, "-")}]

[${""?left_pad(8, ".oO")}]
[${"a"?left_pad(8, ".oO")}]
[${"ab"?left_pad(8, ".oO")}]
[${"abc"?left_pad(8, ".oO")}]
[${"abcd"?left_pad(8, ".oO")}]


<!--right_pad-->

[${""?right_pad(5)}]
[${"a"?right_pad(5)}]
[${"ab"?right_pad(5)}]
[${"abc"?right_pad(5)}]
[${"abcd"?right_pad(5)}]
[${"abcde"?right_pad(5)}]
[${"abcdef"?right_pad(5)}]
[${"abcdefg"?right_pad(5)}]
[${"abcdefgh"?right_pad(5)}]

[${""?right_pad(8, ".oO")}]
[${"a"?right_pad(8, ".oO")}]
[${"ab"?right_pad(8, ".oO")}]
[${"abc"?right_pad(8, ".oO")}]
[${"abcd"?right_pad(8, ".oO")}]


<!--contains-->

<#if "piceous"?contains("ice")>It contains "ice"</#if>


<!--number-->
"1.23E6"?number


<!--replace-->

${"this is a car acarus"?replace("car", "bulldozer")}

${"aaaaa"?replace("aaa", "X")}

"foo"?replace("","|")


<!--url-->

<#assign x = 'a/b c'>
${x?url}

<a href="foo.cgi?x=${x?url}&y=${y?url}">Click here...</a>

<#--
  This will use the charset specified by the programmers
  before the template execution has started.
-->
<a href="foo.cgi?x=${x?url}">foo</a>

<#-- Use UTF-8 charset for URL escaping from now: -->
<#setting url_escaping_charset="UTF-8">

<#-- This will surely use UTF-8 charset -->
<a href="bar.cgi?x=${x?url}">bar</a>

<a href="foo.cgi?x=${x?url('ISO-8895-2')}">foo</a>


<!--split-->

<#list "someMOOtestMOOtext"?split("MOO") as x>
- ${x}
</#list>

<#list "some,,test,text,"?split(",") as x>
- "${x}"
</#list>


<!--starts_with-->

"redhead"?starts_with("red")

"red"?starts_with("red")


<!--string-->

"red"?string


<!--trim-->

(${"  green mouse  "?trim})


<!--upper_case-->

"GrEeN MoUsE"?upper_case


<!--word_list-->

<#assign words = "   a bcd, .   1-2-3"?word_list>
<#list words as word>[${word}]</#list>


<!--xhtml, xml-->

string?xhtml
string?xml


<!--Common flags ('irmscf')-->

<#assign s = 'foo bAr baar'>
${s?replace('ba', 'XY')}
i: ${s?replace('ba', 'XY', 'i')}
if: ${s?replace('ba', 'XY', 'if')}
r: ${s?replace('ba*', 'XY', 'r')}
ri: ${s?replace('ba*', 'XY', 'ri')}
rif: ${s?replace('ba*', 'XY', 'rif')}

<!--built-ins for numbers - see http://freemarker.sourceforge.net/docs/ref_builtins_number.html -->
<!--c-->

${x?c}


<!--string (when used with a numerical value)-->

<#assign x=42>
${x}
${x?string}  <#-- the same as ${x} -->
${x?string.number}
${x?string.currency}
${x?string.percent}
${x?string.computer}

<#setting number_format="currency">
<#assign x=42>
${x}
${x?string}  <#-- the same as ${x} -->
${x?string.number}
${x?string.currency}
${x?string.percent}

<#assign x = 1.234>
${x?string("0")}
${x?string("0.#")}
${x?string("0.##")}
${x?string("0.###")}
${x?string("0.####")}

${1?string("000.00")}
${12.1?string("000.00")}
${123.456?string("000.00")}

${1.2?string("0")}
${1.8?string("0")}
${1.5?string("0")} <-- 1.5, rounded towards even neighbor
${2.5?string("0")} <-- 2.5, rounded towards even neighbor

${12345?string("0.##E0")}

<#setting number_format="0.##">
${1.234}

<#setting locale="en_US">
US people write:        ${12345678?string(",##0.00")}
<#setting locale="hu">
Hungarian people write: ${12345678?string(",##0.00")}


<!--round, floor, ceiling-->

<#assign testlist=[
  0, 1, -1, 0.5, 1.5, -0.5,
  -1.5, 0.25, -0.25, 1.75, -1.75]>
<#list testlist as result>
    ${result} ?floor=${result?floor} ?ceiling=${result?ceiling} ?round=${result?round}
</#list>


<!--Built-ins for dates-->

<!--string (when used with a date value)-->

${openingTime?string.short}
${openingTime?string.medium}
${openingTime?string.long}
${openingTime?string.full}

${nextDiscountDay?string.short}
${nextDiscountDay?string.medium}
${nextDiscountDay?string.long}
${nextDiscountDay?string.full}

${lastUpdated?string.short}
${lastUpdated?string.medium}
${lastUpdated?string.long}
${lastUpdated?string.full}

${lastUpdated?string.short_long} <#-- short date, long time -->
${lastUpdated?string.medium_short} <#-- medium date, short time -->

${lastUpdated?string("yyyy-MM-dd HH:mm:ss zzzz")}
${lastUpdated?string("EEE, MMM d, ''yy")}
${lastUpdated?string("EEEE, MMMM dd, yyyy, hh:mm:ss a '('zzz')'")}


<!--date, time, datetime (when used with a date value)-->

<#assign x = openingTime> <#-- no problem can occur here -->
${openingTime?time} <#-- without ?time it would fail -->
<#-- For the sake of better understanding, consider this: -->
<#assign openingTime = openingTime?time>
${openingTime} <#-- this will work now -->

Last updated: ${lastUpdated} <#-- assume that lastUpdated is a date-time value -->
Last updated date: ${lastUpdated?date}
Last updated time: ${lastUpdated?time}


<!--iso...-->

<#assign aDateTime = .now>
<#assign aDate = aDateTime?date>
<#assign aTime = aDateTime?time>

Basic formats:
${aDate?iso_utc}
${aTime?iso_utc}
${aDateTime?iso_utc}

Different accuracies:
${aTime?iso_utc_ms}
${aDateTime?iso_utc_m}

Local time zone:
${aDateTime?iso_local}

<#assign aDateTime = .now>
${aDateTime?iso("UTC")}
${aDateTime?iso("GMT-02:30")}
${aDateTime?iso("Europe/Rome")}

The usual variations are supported:
${aDateTime?iso_m("GMT+02")}
${aDateTime?iso_m_nz("GMT+02")}
${aDateTime?iso_nz("GMT+02")}


<!--Built-ins for booleans - see http://freemarker.sourceforge.net/docs/ref_builtins_boolean.html-->

foo?string
foo?string("yes", "no")


<!--Built-ins for sequences - see http://freemarker.sourceforge.net/docs/ref_builtins_sequence.html -->

<!--first, last-->

<#assign x = ["red", 16, "blue", "cyan"]>
${x?first}
${x?last}


<!--seq_contains-->

<#assign x = ["red", 16, "blue", "cyan"]>
"blue": ${x?seq_contains("blue")?string("yes", "no")}
"yellow": ${x?seq_contains("yellow")?string("yes", "no")}
16: ${x?seq_contains(16)?string("yes", "no")}
"16": ${x?seq_contains("16")?string("yes", "no")}


<!--seq_index_of-->

<#assign colors = ["red", "green", "blue"]>
${colors?seq_index_of("blue")}
${colors?seq_index_of("red")}
${colors?seq_index_of("purple")}

<#assign names = ["Joe", "Fred", "Joe", "Susan"]>
No 2nd param: ${names?seq_index_of("Joe")}
-2: ${names?seq_index_of("Joe", -2)}
-1: ${names?seq_index_of("Joe", -1)}
 0: ${names?seq_index_of("Joe", 0)}
 1: ${names?seq_index_of("Joe", 1)}
 2: ${names?seq_index_of("Joe", 2)}
 3: ${names?seq_index_of("Joe", 3)}
 4: ${names?seq_index_of("Joe", 4)}
 
 
 <!--seq_last_index_of-->
 
 <#assign names = ["Joe", "Fred", "Joe", "Susan"]>
No 2nd param: ${names?seq_last_index_of("Joe")}
-2: ${names?seq_last_index_of("Joe", -2)}
-1: ${names?seq_last_index_of("Joe", -1)}
 0: ${names?seq_last_index_of("Joe", 0)}
 1: ${names?seq_last_index_of("Joe", 1)}
 2: ${names?seq_last_index_of("Joe", 2)}
 3: ${names?seq_last_index_of("Joe", 3)}
 4: ${names?seq_last_index_of("Joe", 4)}


<!--reverse-->

${x?reverse}


<!--size-->

${x?size}


<!--sort-->

<#assign ls = ["whale", "Barbara", "zeppelin", "aardvark", "beetroot"]?sort>
<#list ls as i>${i} </#list>


<!--sort_by-->

<#assign ls = [
  {"name":"whale", "weight":2000},
  {"name":"Barbara", "weight":53},
  {"name":"zeppelin", "weight":-200},
  {"name":"aardvark", "weight":30},
  {"name":"beetroot", "weight":0.3}
]>
Order by name:
<#list ls?sort_by("name") as i>
- ${i.name}: ${i.weight}
</#list>

Order by weight:
<#list ls?sort_by("weight") as i>
- ${i.name}: ${i.weight}
</#list>

<#assign members = [
    {"name": {"first": "Joe", "last": "Smith"}, "age": 40},
    {"name": {"first": "Fred", "last": "Crooger"}, "age": 35},
    {"name": {"first": "Amanda", "last": "Fox"}, "age": 25}]>
Sorted by name.last: 
<#list members?sort_by(['name', 'last']) as m>
- ${m.name.last}, ${m.name.first}: ${m.age} years old
</#list>


<!--chunk-->

<#assign seq = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j']>

<#list seq?chunk(4) as row>
  <#list row as cell>${cell} </#list>
</#list>

<#list seq?chunk(4, '-') as row>
  <#list row as cell>${cell} </#list>
</#list>


<!--Built-ins for hashes - see http://freemarker.sourceforge.net/docs/ref_builtins_hash.html-->

<!--keys-->
<#assign h = {"name":"mouse", "price":50}>
<#assign keys = h?keys>
<#list keys as key>${key} = ${h[key]}; </#list>


<!--values-->
<#assign h = {"name":"mouse", "price":50}>
<#assign values = h?values>
<#list values as value>${value} = ${h[value]}; </#list>


<!--Built-ins for nodes (for XML) - see http://freemarker.sourceforge.net/docs/ref_builtins_node.html-->
<!--children, parent, root, ancestors, node_name, node_type and node_namespace-->

node?children
node?parent
node?root
node?ancestors
node?node_name
node?node_type
node?node_namespace


<!--Seldom used and expert built-ins - see http://freemarker.sourceforge.net/docs/ref_builtins_expert.html-->

<!--byte, double, float, int, long, short-->
somenumber?byte
somenumber?double
somenumber?float
somenumber?int
somenumber?long
somenumber?short


<!--number_to_date, number_to_time, number_to_datetime-->

${1305575275540?number_to_datetime}
${1305575275540?number_to_date}
${1305575275540?number_to_time}


<!--eval-->

"1+2"?eval


<!--has_content-->

product.color?has_content
(product.color)?has_content


<!--interpret-->

<#assign x=["a", "b", "c"]>
<#assign templateSource = r"<#list x as y>${y}</#list>">
<#-- Note: That r was needed so that the ${y} is not interpreted above -->
<#assign inlineTemplate = templateSource?interpret>
<@inlineTemplate />

<#assign inlineTemplate = [templateSource, "myInlineTemplate"]?interpret>


<!--is_...-->

myobject?is_string
myobject?is_number
myobject?is_boolean
myobject?is_date
myobject?is_method
myobject?is_transform
myobject?is_macro
myobject?is_hash
myobject?is_hash_ex
myobject?is_sequence
myobject?is_collection
myobject?is_enumerable
myobject?is_indexable
myobject?is_directive
myobject?is_node


<!--namespace-->

myobject?namespace


<!--new-->

<#-- Creates an user-defined directive be calling the parameterless constructor of the class -->
<#assign word_wrapp = "com.acmee.freemarker.WordWrapperDirective"?new()>
<#-- Creates an user-defined directive be calling the constructor with one numerical argument -->
<#assign word_wrapp_narrow = "com.acmee.freemarker.WordWrapperDirective"?new(40)>


<!--Special Variable Reference - see http://freemarker.sourceforge.net/docs/ref_specvar.html-->

.data_model
.error
.globals
.lang
.locale
.locals
.main
.namespace
.node
.now
.template_name
.url_escaping_charset
.vars
.version


<!--Reserved names in FTL-->

<!--true, false, gt, gte, lt, lte, as, in, using-->
