
/*------------------------------------------------------------------------
    File        : pwh_oegear.p
    Purpose     : 

    Syntax      :

    Description : common ABL  handler for PASOE WebHandler

    Author(s)   : firsoft ( Gennadi Firsov ) 
    Created     : Fri Feb 1 16:30:35 EET 2023
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */
def input param cprog as char no-undo.
def input param oreq as Progress.Lang.Object no-undo.
def output param oresp as Progress.Lang.Object no-undo. 
def output param ista as int no-undo.
def var cmethod as char no-undo.
def var oo  AS Progress.Lang.Object NO-UNDO.
 
ista=405.
if index(cprog,'.') = 0 then do: // simple procedure
  run value(cprog) (input oreq,output oresp,output ista).
  return.    
end.    
else do:
  cmethod = entry(num-entries(cprog,'.'),cprog,'.').  
  cprog = replace(cprog,'.' + cmethod,'').
  if cmethod = 'constructor' then 
     oo = dynamic-new cprog (input oreq,output oresp,output ista).
  else do:   
    oo = dynamic-new cprog ().
    dynamic-invoke(oo,cmethod,input oreq,output oresp,output ista).
  end.  
  return.  
end.    
    
/* ***************************  Main Block  *************************** */
 CATCH oneError AS Progress.Lang.SysError:
    delete object oresp no-error.
    oresp = NEW OpenEdge.Core.String(oneError:GetMessage(1)).
    ista = 405.
  END CATCH.
          
  CATCH twoError AS Progress.Lang.AppError :
    delete object oresp no-error.
    oresp = NEW OpenEdge.Core.String(oneError:GetMessage(1)).
    ista = 405.
  END CATCH.

 FINALLY:
      delete object oo no-error.          
 END FINALLY. 
 
