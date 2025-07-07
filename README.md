### OPENEDGE:  progress webhandler gear

PASOE tool for more flexible, easier to maintain/deploy:   
one WebHandler for all business entity  
as 3 tier logic :  
1.  one common  PASOE WebHandler  ( pwh_gear.cls)
2.  one common ABL  handler ( pwh_oegear.p )
3.  many business handlers as  procedures or classes method   
    with  simple signature : (input oreq,output oresp,output ista)   


Progress WebHandler configuration  :  
Request sent to procedure/method  as query string in classic cgi style uri or in rest uri style :

* http://hostname:port/app/web/pwh_gear/procedurename?customer=12345&b1=order    
* http://hostname:port/app/web/pwh_gear/procedurename/customer/12345/order

app – *web application name*   
web – *PASOE transport*   
procedurename - *abl procedure* (input oreq,output oresp,output ista) 
-  oreq - as **OpenEdge.Core.String** ( query string - part uri after *procedurename* , parse query string is trivial task ) 
-  oresp - as **Progress.Lang.Object** - can be **JsonObject** or **String** (for xml response  or error description  response)
-  ista - as **integer** status (200 - ok , otherwise error brief description in oresp as **String**) 

For classes *procedurename* must be in format :  *a.b.c.d*  where 
- a.b.c - **ABL Class name**
- d - **method name** with same signature , if d='constructor' then call constructor with same params

  
  
Example configuration (done in OE 12.8 windows 11 as root web app):  
C:\OpenEdge\WRK\oepas1\webapps\ROOT\WEB-INF\adapters\web\ROOT\ROOT.handlers  
Example URL's :  
http://localhost:8810/web/pwh_gear/firsoft.oe-gear.mymethod?customer=12345&orders=  
http://localhost:8810/web/pwh_gear/aproc/customer/12345/orders  


