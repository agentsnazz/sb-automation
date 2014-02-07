'==============================================================
'
'   Scriptname: tweeter.vbs
'
'   TWITTER STATUS UPDATE
'
'   With this script you can update a Twitter account, based on data in Starbound.log
'
'   USAGE:
'        
'
'
'==============================================================

OPTION EXPLICIT

' ---------------------------------------------------------------------
'   VARIABLES
'   Please modify the below variables to suit your needs.
' ---------------------------------------------------------------------

Dim strUsername, strPassword, strMessage, arrTriggers, DebugMode
strUsername = "your Twitter username here"
strPassword = "your Twitter password goes here"
strMessage = "This String Will Be Replaced By Text Pulled From Starbound.log"

DebugMode = true


'   Trigger Array - PreConfigured for StarFoundry
arrTriggers = Array(_
    "STARFOUNDRY_TWEETER"_ 'Trigger for StarFoundry object "monitor"
    "SOMEOTHERTRIGGER"_ 'Add your custom triggers here
    )

' --------------------------
'   EXECUTION
'   Do not modify any of the below unless you know what you're doing.
' --------------------------

'   Calling the function and store the result in a variable.
Dim strTwitterXMLResponse
strTwitterXMLResponse = SendToTwitter(strMessage, strUsername, strPassword)

'   Post back the result with a messagebox so you know something happened
If DebugMode Then MsgBox strTwitterXMLResponse, VbOkOnly, "TWITTER STATUS UPDATE"

Function SendToTwitter(strMessage, strUsername, strPassword)

     ' This is the function which does all the work.
     ' It uses XMLHTTP to post your message to Twitter..
     Dim objHTTP
     Set objHTTP = CreateObject("Microsoft.XMLHTTP")
     
          objHTTP.open "POST", "http://twitter.com/statuses/update.xml", false, strUsername, strPassword
          objHTTP.send "status=" & strMessage
          
          ' The function stores the Twitter response to the result of the function so you can use this later
          SendToTwitter = objHTTP.responseText
     
     Set objHTTP = nothing 'Release the object
     
End Function