 
 /*------------------------------------------------------------------------
    File        : pwh_gear.cls
    Purpose     : 
    Syntax      : 
    Description : PASOE WebHandler gear 
    Author(s)   : firsoft (Gennadi Firsov) 
    Created     : Wed Jan 01 12:05:48 EET 2023
    
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING OpenEdge.Web.WebResponseWriter.
USING OpenEdge.Net.HTTP.StatusCodeEnum.
USING OpenEdge.Web.WebHandler.
USING Progress.Json.ObjectModel.*.
BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS pwh_gear INHERITS WebHandler: 

    
        
    /*------------------------------------------------------------------------------
            Purpose: Handler for unsupported methods. The request being serviced and
                     an optional status code is returned. A zero or null value means 
                     this method will deal with all errors.                                                               
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    METHOD OVERRIDE PROTECTED INTEGER HandleNotAllowedMethod( INPUT poRequest AS OpenEdge.Web.IWebRequest ):
    
        /* Throwing an error from this method results in a 500/Internal Server Error response. 
        The web handler will attempt to log this exception.
        
        See the HandleGet method's comments on choosing a value to return from this method. */
            
        UNDO, THROW NEW Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
    END METHOD.


    /*------------------------------------------------------------------------------
            Purpose: Handler for unknown methods. The request being serviced and an 
                     optional status code is returned. A zero or null value means 
                     this method will deal with all errors.                                                               
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    METHOD OVERRIDE PROTECTED INTEGER HandleNotImplemented( INPUT poRequest AS OpenEdge.Web.IWebRequest ):
    
        /* Throwing an error from this method results in a 500/Internal Server Error response. 
        The web handler will attempt to log this exception.
        
        See the HandleGet method's comments on choosing a value to return from this method. */  
        UNDO, THROW NEW Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
    END METHOD.
    
    
    /*------------------------------------------------------------------------------
            Purpose: Default handler for the HTTP GET method. The request being 
                     serviced and an optional status code is returned. A zero or 
                     null value means this method will deal with all errors.                                                               
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    METHOD OVERRIDE PROTECTED INTEGER HandleGet( INPUT poRequest AS OpenEdge.Web.IWebRequest ):
    
    
        DEFINE VARIABLE oResponse AS OpenEdge.Net.HTTP.IHttpResponse NO-UNDO.
        DEFINE VARIABLE oWriter   AS OpenEdge.Web.WebResponseWriter  NO-UNDO.
        DEFINE VARIABLE oBody     AS OpenEdge.Core.String            NO-UNDO.
        
        DEFINE VARIABLE cProgname AS CHAR                            NO-UNDO.
        DEFINE VARIABLE cQuery    AS CHAR                            NO-UNDO. // as query string
        DEFINE VARIABLE oQuery    AS OpenEdge.Core.String            NO-UNDO. 
        DEFINE VARIABLE cUri      AS CHAR                            NO-UNDO.
        DEFINE VARIABLE iSta      AS INT                             NO-UNDO INIT 200 .
        DEFINE VARIABLE oRespBody AS Progress.Lang.Object            NO-UNDO.
        def var oAcceptHdr as OpenEdge.Net.HTTP.HttpHeader .
        oAcceptHdr = poRequest:GetHeader("Accept").
            
        cQuery = STRING(poRequest:GetContextValue("QUERY_STRING")).  
        cUri = poRequest:PathInfo .
        cProgname = replace(cUri,'/pwh_gear/',''). 
        if cQuery = '' then do: // may be rest format then query string as the end of uri
           cProgname = entry(1,cProgname,'/').
           cQuery = replace(cUri,'/pwh_gear/' + cProgname ,'').
           if cQuery begins '/' then cQuery = substr(cQuery,2). 
        end.   
        if index(cProgname,'/') > 0 then iSta = 400.
        oQuery = NEW OpenEdge.Core.String(cQuery) .
        
        
        oRespBody = oQuery .
        run pwh_oegear (input cProgname,input oQuery,output oRespBody,output iSta).
        ASSIGN 
            oResponse            = NEW OpenEdge.Web.WebResponse()
            oResponse:StatusCode = INTEGER(StatusCodeEnum:OK)
            oResponse:StatusCode = iSta
            .

        ASSIGN 
            oBody = NEW OpenEdge.Core.String(
                             oRespBody:ToString() + '~r~n':u
                           ).
           if type-of(oRespBody,OpenEdge.Core.String) and iSta ne 200 then
              oResponse:ContentType   = 'text/plain':u .
            else  
            if  type-of(oRespBody,JsonObject) then
               oResponse:ContentType   = 'application/json':u .                          
            else
               oResponse:ContentType   = 'application/xml':u.
        ASSIGN 
            oResponse:Entity        = if ista ne 200 then oBody else oRespBody
            oResponse:ContentLength = oBody:Size
            .

        ASSIGN 
            oWriter = NEW WebResponseWriter(oResponse).
        oWriter:Open().
        
        oWriter:Close().
        
        RETURN 0.
        
        FINALLY:
             delete object oQuery no-error.
             delete object oRespBody no-error.
             delete object obody no-error.
             delete object oResponse no-error.
             delete object oWriter no-error.
        END FINALLY.
        
    END METHOD. 
    
    
    
    
END CLASS.
