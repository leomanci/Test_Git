var isCHROME= /Chrome/.test(navigator.userAgent) && /Google Inc/.test(navigator.vendor);
var isSAFARI = /Safari/.test(navigator.userAgent) && /Apple Computer/.test(navigator.vendor);
var isMicrosoftIE=(window.ActiveXObject || "ActiveXObject" in window);
var isFIREFOX= !(window.mozInnerScreenX == null);
var isEDGE = /Edge/.test(navigator.userAgent);

function commonAlertMessage(primarymessage,secondarymessage) {
    var dialogBody = "<div class='dialogHeader'><div class='dialogIcon dialogIconAlert'>&nbsp;</div></div><div class='dialogFont'><div class='primary'>"+primarymessage+"<br /><br /></div><div class='secondary'>"+secondarymessage+"</div></div>";
    $("#dialog-confirm").html(dialogBody);

    // Define the Dialog and its properties.
    $("#dialog-confirm").dialog({
        resizable: false,
        modal: true,
        title: "Save",
        height: "auto",
        width: 413,
        buttons: {
            "NO": {
                click: function() {
                    $(this).dialog('close');

                },
                text: 'Close',
                'class': 'vabutton2'
            }

        },
        open: function(event, ui) {
            $('.ui-dialog :button').blur();
        }
    });
}
function getXMLStringFromXMLNode(node)
{
  try{
      if (typeof(XMLSerializer) !== 'undefined') {
      var serializer = new XMLSerializer();
      return serializer.serializeToString(node);
   } else if (node.xml) {
      return node.xml;
   }
   }
   catch(err){}
   return '';
}
function messageLogToIntercom(message){
 try{ message = $('<div/>').html(message).text();
 var logdata = {Log: message};
Intercom('trackEvent', 'debug-log', logdata ); 
 }
 catch(ee){

 }
  
}
function sendInfoToIntercom(eventType,eventLabel,metaData){
 try{  
 if(typeof metaData !== "undefined"){
Intercom(eventType, eventLabel, metaData ); 
}else{
Intercom(eventType, eventLabel); 
}
 }
 catch(ee){

 }
  
}
function getInnerXMLStringFromXMLNode(node)
{
var returnXMLstr='';
  if(node.childNodes.length>0)
  {
     $.each(node.childNodes,function(indx,childNode){
        returnXMLstr+=getXMLStringFromXMLNode(childNode);
     })
  }
       
   return returnXMLstr;
}
function upgradeNowMessage(primarymessage,secondarymessage,newPageUrl) {
    var dialogBody = "<div class='dialogHeader'><div class='dialogIcon dialogIconAlert'>&nbsp;</div></div><div class='dialogFont'><div class='primary'>"+primarymessage+"<br /></div><div class='secondary'>"+secondarymessage+"</div></div>";
    $("#dialog-confirm").html(dialogBody);

    // Define the Dialog and its properties.
    $("#dialog-confirm").dialog({
        resizable: false,
        modal: true,
        title: "Save",
        height: "auto",
        width: 413,
        buttons: {
            "YES": {
                click: function() {
                    $(this).dialog('close');
                    if(isNullOrEmpty(newPageUrl))
                    {
                    newPageUrl="http://visualantidote.com/fastforms#Subscribe";
                    }
                    window.open(newPageUrl, '_blank');
                },
                text: 'Upgrade Now!',
                'class': 'vabutton1'
            },
            "NO": {
                click: function() {
                    $(this).dialog('close');

                },
                text: 'No Thanks',
                'class': 'vabutton2'
            }
            

        },
        open: function(event, ui) {
            $('.ui-dialog :button').blur();
        }
    });
}
function validObjects()
{
  var data=[];
  data.push("Contact");
  data.push("Account");
  data.push("Lead");
  data.push("Case");
  return data;
}
function brTagSafe(htmlsrc)
{
 var cleanHtml= safeStringValue(htmlsrc);
 cleanHtml=cleanHtml.replace( /<br><br\/>/g, '<br/>' );
 cleanHtml=cleanHtml.replace( /<br>/g, '<br/>' );
 return cleanHtml;
}
function newlineToBr(str){
  try{
  str=str.replace(/(?:\r\n|\r|\n)/g, '<br />')
  }catch(err){}
  return str;
}
function isNullOrEmpty(strvalue)
{
  if(strvalue!==undefined && strvalue!==null && strvalue!='')
  {
    return false;
  }
  return true;
}
function safeStringValue(strvalue,defaultvalue)
{
  if(strvalue!==undefined && strvalue!==null && strvalue!='')
  {
    return strvalue;
  }
  return defaultvalue;
}
function safeInt(intValue,defaultValue){
    if(!isNaN(parseInt(intValue))){
     return parseInt(intValue);
    }
    return defaultValue;
   }
function safeHTMLValue(strvalue,defaultvalue,escapeHtml)
{
  if(strvalue!==undefined && strvalue!==null && strvalue!='')
  {
  if(escapeHtml)
  {

return  escapeHtmlString(unescapeHTMLString(strvalue));
    
  }
  else{
  return strvalue;    
  }
  }
  return defaultvalue;
}

function toggleDetailBlock(elemSource)
{
  $(elemSource).parents('.ff-detail-block-wrap').find('.ff-detail-block').slideToggle();
}
function isNotNullOrUndefined(objvalue)
{
  if(objvalue!==undefined && objvalue!==null  )
  {
    return true;
  }
  return false;
}
function formatAmountTo2Decimal(actualamount,defaultvalue)
{
   var amount=defaultvalue;
     try{
     amount=parseFloat(actualamount);

 if(isNaN(amount))
 {
   amount=0;
 }
 amount=amount.toFixed(2);
     }
     catch(err)
     {
     amount=parseFloat(defaultvalue);
     console.log(' Error formatting amount value');
     }
     return amount;
}
function safeStringValue(strvalue,defaultvalue)
{
var stringvalue=defaultvalue;
  if(strvalue!==undefined && strvalue!==null)
  {
    stringvalue=strvalue;
  }
  return stringvalue;
}
function escapeHTMLElementId(elementId)
{
var elemId=elementId;
  if(elementId!==undefined && elementId!=='' )
   {
  elemId= elementId.replace(/\./g,"\\.");
   }
   return elemId;
}
function getPrefixedOrgFieldName(prefixstr,fieldname)
{
   if(prefixstr!==undefined && prefixstr!=='' && fieldname!='' && fieldname.indexOf('__c')>0 && fieldname.indexOf(prefixstr)!=0 )
   {
   if(prefixstr.indexOf('__')>0){
   fieldname=prefixstr+fieldname;
   }else{
   fieldname=prefixstr+'__'+fieldname;
   }
   }
   return fieldname;
}
function isValid3Digits(elemSource){
 var isvalid=false;
  var $numeric = $(elemSource);
  var regex  =  /^\d{0,3}$/;
  if (regex.test($numeric.val())){
    $numeric.css("border-color","#aaa");
    $numeric.next( ".validation-message" ).remove();
 isvalid=true;
      } else {
    $numeric.css("border-color","#FF0000");
    if($numeric.next( ".validation-message" ).length<1)
    {
    var newDiv = $('<div />', {
        'class': 'validation-message' 
    });
      $numeric.after(newDiv);
      $numeric.next( ".validation-message" ).html('Please provide only numeric value of max 3 digits');
    }
  }
  return isvalid;
}
function msieversion()
   {
      var ua = window.navigator.userAgent;
     

      if ( ua.indexOf ( "MSIE " ) > 0 || ua.indexOf ( "Trident" )>0)      // If Internet Explorer, return version number
         return  1;
      else                 // If another browser, return 0
         return 0;

   }
function isValueNumeric(elemSource){
 var isnumeric=false;
  var $numeric = $(elemSource);
  var numericval=$numeric.val();
  var regex  =  /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
  if ( regex.test(numericval)){
    $numeric.css("border-color","#aaa");
 isnumeric=true;
      } else {
    $numeric.css("border-color","#FF0000");
    
  }
  return isnumeric;
}
function isValueNumericOrEmpty(elemSource){
 var isnumeric=false;
  var $numeric = $(elemSource);
  var numericval=$numeric.val();
  var regex  =  /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
  if (numericval=='' || regex.test(numericval)){
    $numeric.css("border-color","#aaa");
 isnumeric=true;
      } else {
    $numeric.css("border-color","#FF0000");
    
  }
  return isnumeric;
}
function isEmailValid(elemSource){
var isvalid=false;
  var $emailelem = $(elemSource);
  var regex  =  /^\w+@[a-zA-Z0-9_]+?\.[a-zA-Z]{2,3}$/;
  var emailtext=$emailelem.val();
  if (emailtext=='' || regex.test(emailtext)){
    $emailelem.css("border-color","#aaa");
    $emailelem.next( ".validation-message" ).remove();
 isvalid=true;
      } else {
    $emailelem.css("border-color","#FF0000");
    if($emailelem.next( ".validation-message" ).length<1)
    {
    var newDiv = $('<div />', {
        'class': 'validation-message' 
    });
      $emailelem.after(newDiv);
      $emailelem.next( ".validation-message" ).html('Please provide a valid email address');
    }
  }
  return isvalid;
}
function validatedHTML(html) {
    var d = document.createElement('div');
    if (html == '')
      html = '&nbsp;';
    d.innerHTML = html;
    return d.innerHTML;
}

function getFreemiumHTML(partialmessage,optionalMainCssClass,optionalSubCssClass){
var mainMsg='This feature is';
var cssClass='freemium-icon';//freemium-edit-block
var cssSubClass='-marginLT';
if(!isNullOrEmpty(optionalMainCssClass))
{
 cssClass= optionalMainCssClass+' '+cssClass;
}
if(!isNullOrEmpty(optionalSubCssClass))
{
 cssSubClass= cssSubClass+' '+optionalSubCssClass;
}
if(!isNullOrEmpty(partialmessage))
{
  mainMsg=partialmessage;
}
var htmlmsg='<span class="'+cssClass+' blue-tooltip" ><span class="blue-tooltip-text '+cssSubClass+'"><div class="freemium-tooltip-header">Premium Feature</div>'+mainMsg+' only available for paid subscriptions.<a class="upgrade-now" href="https://visualantidote.com/fastforms?orgid={!$Organization.Id}#Subscribe" target="_blank">Upgrade Now!</a></span></span>';
return htmlmsg;

}
function lengthSplitId(elemSourceId)
{
  var idItems=0;
                                    try{
                                    if(!isNullOrEmpty(elemSourceId) && typeof elemSourceId === 'string'  )
                                    {
                                       idItems=  elemSourceId.split('.').length;
                                       }
                                     }
                                     catch(err)
                                     {
                                        console.log(' Id check exception ');
                                     }
                                     return idItems;
}
function OpenInNewTab(urlstr)
{
event.stopPropagation();
  window.open(urlstr, '_blank');

}
function resetPrimaryForFreemium(selectElement)
                {
                   $(selectElement).find('>option').each(function(indx,optionelem){
                    if($(optionelem).val() != '' &&  $.inArray($(optionelem).val(), validObjects())<0) 
                      {
                        $(optionelem).addClass('free-icon');
                      }
                      else
                      {
                        $(optionelem).removeClass('free-icon');
                      }

                   }); 
                }
                function closeFreemiumNotification(elem,pageType)
        {
        
                $(elem).parent().parent().hide();
                /*if(pageType=='formeditor')
                {
                resetEditorFreemiumNotificationJS(false);
                }
                else if(pageType=='formmenu')
                 {
               resetDashboardFreemiumNotificationJS(false);
                }
                 */
        }
        function closeNotification(elemid)
    {
   
        $(elemid).parent().find('.msg-text-div').html('');
        $(elemid).parent().hide();
    }
    function escapeXML(unsafe) {
     if(!isNullOrEmpty(unsafe))
     {
      return unsafe.replace(/&/g, "&amp;")
         .replace(/</g, "&lt;")
         .replace(/>/g, "&gt;")
         .replace(/"/g, "&quot;")
         .replace(/'/g, "&#39;");
     }
     else
     {
     return '';
     }
   
 }
 function unscapeXML(unsafe) {
     if(!isNullOrEmpty(unsafe))
     {
      return unsafe.replace(/&amp;/g, "&")
         .replace(/&lt;/g, "<")
         .replace(/&gt;/g, ">")
         .replace(/&quot;/g, "\"")
         .replace(/&#39;/g, "'")
         .replace(/&#34;/g, "\"");
     }
     else
     {
     return '';
     }
   
 }
     function escapeHtmlString(unsafe) {
     if(!isNullOrEmpty(unsafe))
     {
      return unsafe.replace(/&/g, "&amp;")
         .replace(/</g, "&lt;")
         .replace(/>/g, "&gt;")
         .replace(/"/g, "&quot;")
         .replace(/'/g, "&apos;");
     }
     else
     {
     return '';
     }
   
 }
 function firstElementByTagName(xmlNodeElement, tagName, fetchElemHtml) {
    var firstElement;
    var elements = xmlNodeElement.getElementsByTagName(tagName);
    try {
        if (elements.length > 0) {

            if (fetchElemHtml) {
           firstElement= getXMLElemInnerContent(elements[0],'');
               
            }
            else {
                firstElement = elements[0];
            }
        }
    }
    catch (err) {

        if (fetchElemHtml) {
            firstElement = '';
        }
        else {

            firstElement = undefined;
        }
    }
    return firstElement;
}
function getXMLElemInnerContent(xmlElem,defaultvalue)
{
  var returnVal=defaultvalue;
  
  if(isSAFARI || isEDGE){
            returnVal = xmlElem.textContent;
            }
            else if(isMicrosoftIE)
            {
            returnVal = xmlElem.text;
            }
            else if(isCHROME)
            {
            returnVal = xmlElem.innerHTML;
            }
            else{
             returnVal = xmlElem.innerHTML;
            }

            return returnVal;
}
function firstBooleanElementByTagName(xmlNodeElement, tagName, defaultBool) {
    var firstElement = defaultBool;
    var elements = xmlNodeElement.getElementsByTagName(tagName);
    try {
        if (elements.length > 0) {
            var booleanvalue = getXMLElemInnerContent(elements[0],defaultBool);
            if (!isNullOrEmpty(booleanvalue) && (booleanvalue == true || booleanvalue + ''.toLowerCase() == 'true')) {
                firstElement = true;
            }
        }
        else {
            firstElement = defaultBool;
        }
    }
    catch (err) {

        firstElement = defaultBool;

    }
    return firstElement;
}
function subsstringWithReadmoreDots(text,size,dots){ 
if(!isNullOrEmpty(text) && text.length>size){
  text=text.substring(0,size);
  text=text+dots;
}
return text;
}
 function unescapeHTMLString(value){ 
  if(!isNullOrEmpty(value))
     {
     try{value=value.toString();
     }catch(err){}
     value=value.replace(/&amp;/g, "&");
      return value.replace(/&amp;/g, "&")
         .replace(/&lt;/g, "<")
         .replace(/&gt;/g, ">")
         .replace(/&quot;/g, "\"")
         .replace(/&apos;/g, "'")
         .replace(/&#039;/g, "'")
         .replace(/&#38;/g, "&")
         .replace(/&#39;/g, "'");
     }
     else
     {
     return '';
     }
}
function getXmlElementFromStr(xmlstring)
           {
           var xmlstr= safeStringForXML(xmlstring);
            if (msieversion()<1) {
                                                parser = new DOMParser();
                                                xmlDoc = parser.parseFromString(xmlstr, "text/xml");
                                            }
                                            else // Internet Explorer
                                            {
                                                xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
                                                xmlDoc.async = false;
                                                xmlDoc.loadXML(xmlstr);
                                            }
                                            return xmlDoc;
           }
function safeStringForXML(value){
var returnstr='';
try{
  if(!isNullOrEmpty(value))
     {
      returnstr= value.replace(/&/g, "&amp;");
     }
     else
     {
     returnstr= '';
     }
     }
     catch(err)
     {
     console.log('Safe  XML function error- '+err.message);
     }
     return returnstr;

}
 function decodeHTMLString(value){ 
  return $('<div/>').html(value).text(); 
}
function getXMLElemFirstNode(xmlElemParent,tagName)
{
var xmlElem;
if(xmlElemParent.getElementsByTagName(tagName).length>0)
{
 xmlElem= xmlElemParent.getElementsByTagName(tagName)[0];
}
return xmlElem;
}
function getInnerHTML(xmlElem,defaultValue)
{
var nodeValue=defaultValue;
if(xmlElem!==undefined)
{
 nodeValue= xmlElem.innerHTML;
}
return nodeValue;
}
function getSafeBoolean(booleanValue,defaultValue)
{
  var returnBool=defaultValue;
  try{
   
  if(booleanValue== "true" || booleanValue=='True' || booleanValue==true )
  {
  returnBool=true;
  }
  else if(booleanValue== "false" || booleanValue=='False' || booleanValue==false )
  {
  returnBool=false;
  }}
  catch(err){}
  return returnBool;
}
function xmlDocToString(xmlData) { 

    var xmlString;
    //IE
    if (window.ActiveXObject){
        xmlString = xmlData.xml;
    }
    // code for Mozilla, Firefox, Opera, etc.
    else{
        xmlString = (new XMLSerializer()).serializeToString(xmlData);
    }
    return xmlString;
} 
function getBrowserInfo(){
    var ua=navigator.userAgent,tem,M=ua.match(/(opera|chrome|safari|firefox|msie|trident(?=\/))\/?\s*(\d+)/i) || []; 
    if(/trident/i.test(M[1])){
        tem=/\brv[ :]+(\d+)/g.exec(ua) || []; 
        return {name:'IE',version:(tem[1]||'')};
        }   
    if(M[1]==='Chrome'){
        tem=ua.match(/\bOPR\/(\d+)/)
        if(tem!=null)   {return {name:'Opera', version:tem[1]};}
        }   
    M=M[2]? [M[1], M[2]]: [navigator.appName, navigator.appVersion, '-?'];
    if((tem=ua.match(/version\/(\d+)/i))!=null) {M.splice(1,1,tem[1]);}
    return {
      name: M[0],
      version: M[1]
    };
 }
 function showFFErrorMessage(message){
                  if(isNullOrEmpty(message))
                  {
                    message='Something went wrong please contact Fast Forms support team';
                  }
                  showFFNotification("errorActionBox", message);
       }
      function showFFSuccessMessage(message){
                  if(isNullOrEmpty(message))
                  {
                    message='Something went wrong please contact Fast Forms support team';
                  }
                  showFFNotification("successActionBox", message);
        }
        function hideFFNotification(elemid)
        {
                $('#' + elemid).find('.msg-text-div').html('');
                $('#' + elemid).fadeOut(250);
        }
        function showFFNotification(elemid, textmsg)
        {
                $('#' + elemid).fadeIn(250);
                $('#' + elemid).find('.msg-text-div').html(textmsg);
        }
        function hideFFNotificationElem(elem)
        {
        if(elem!==undefined){
                $(elem).find('.msg-text-div').html('');
                $(elem).fadeOut(250);
                }
        }
        function hideFFParentNotificationElem(elem)
        {
        var parentElem=$(elem).parent();
        if(parentElem!==undefined){
                $(parentElem).find('.msg-text-div').html('');
                $(parentElem).hide();
                }
        }
        function showFFNotificationElem(elem, textmsg)
        { if(elem!==undefined){
                $(elem).fadeIn(250);
                $(elem).find('.msg-text-div').html(textmsg);
                }
        }
        function getFormattedDateTime(ticks)
        {
var tickDate = new Date(ticks);//ticksToMicrotime - epochMicrotimeDiff);

//dd/MM/yyyy h:mm a
var yyyy=tickDate.getFullYear();
var yy=yyyy+''.substring(2);
var MM=tickDate.getMonth()+1;
var dd=tickDate.getDate();
var hh=tickDate.getHours(); 
var mm=tickDate.getMinutes();
var sss=tickDate.getSeconds();
var ampm='AM';
//var hours = (hh+24-2)%24; 
   //  hh=hours;
    if(hh==0){ //At 00 hours we need to show 12 am
    hh=12;
    }
    else if(hh>12)
    {
    hh=hh%12;
    ampm='PM';
    }

var formatForDateTime=window.UserContext['dateTimeFormat'];

var formmateddatetime=formatForDateTime.replace('yyyy',yyyy);
formmateddatetime=formmateddatetime.replace('HH','hh');
formmateddatetime=formmateddatetime.replace('H','h');
try{
formmateddatetime=formmateddatetime.replace('yy',yy);
formmateddatetime=formmateddatetime.replace('MM',formatWithZeroIfOneDigit(MM));
formmateddatetime=formmateddatetime.replace('M',formatWithZeroIfOneDigit(MM));
formmateddatetime=formmateddatetime.replace('dd',formatWithZeroIfOneDigit(dd));
formmateddatetime=formmateddatetime.replace('d',formatWithZeroIfOneDigit(dd));
formmateddatetime=formmateddatetime.replace('hh',formatWithZeroIfOneDigit(hh));
formmateddatetime=formmateddatetime.replace('h',formatWithZeroIfOneDigit(hh));
formmateddatetime=formmateddatetime.replace('mm',formatWithZeroIfOneDigit(mm));
formmateddatetime=formmateddatetime.replace('sss',sss);
formmateddatetime=formmateddatetime.replace('a',ampm);
formmateddatetime=formmateddatetime.replace('p',ampm);
}
catch(err){
    console.log(' Date format is not good'+err.message);
}

 return formmateddatetime;
        }
        function formatWithZeroIfOneDigit(integerNumber){
        return (integerNumber < 10? '0' : '')+integerNumber;
        }
        function firstCharCapitalCase(txt) {
    var txtstr = txt;
    if (!isNullOrEmpty(txt) && txt.length > 1) {
        txtstr = txt.slice(0, 1).toUpperCase()
        txtstr += txt.slice(1).toLowerCase();
    }
    return txtstr;
}
function getTrimmedSTR(strToTrim,maxLength,moreStr){
  var returnstr=strToTrim;
  if(!isNullOrEmpty(returnstr) && returnstr.length>maxLength){
    returnstr=returnstr.substring(0,maxLength)+moreStr;
  }
return returnstr;
}
function resetFastFormsHREFLinks(parentElem,ffnamespace){
if(isFFLightningEnabled()){
  $(parentElem).find('a.vfns-link').each(function(indx,aLink){
  var hreflink=$(aLink).attr('href');
  if(!isNullOrEmpty(hreflink)){

  if(hreflink.toLowerCase().indexOf('/apex/form')>=0 || hreflink.toLowerCase().indexOf('/apex/submission')>=0)
  {
  hreflink=hreflink.replace('/apex/','/apex/'+ffnamespace+'');
   $(aLink).attr('href',hreflink);
  } 
  }
  });
  }
}
function getQueryStringSafeURL(url){
  if(!isNullOrEmpty(url)){
      if(url.indexOf('?')>0){
      url = url.substring(0, url.indexOf('?'));
      }
  }
  return url;
}
function isFFLightningEnabled(){
var returnFlag=false;
if((typeof sforce != 'undefined') && sforce && (!!sforce.one)){
returnFlag=true;
}
return returnFlag;
}
function ffNavigateToUrl(navigationUrl,ffnamespace){
  if(isFFLightningEnabled()){
  navigationUrl=navigationUrl.replace('/apex/','/apex/'+ffnamespace);
    sforce.one.navigateToURL(navigationUrl);
  }
  else{

window.location.href=navigationUrl;
  }
}
function handleFFClick(elemSource,ev){
  if($(elemSource).parent().hasClass('dp-disabled')){
  ev.preventDefault();
  }
}
function generateFormFieldsSelectHtml(resultFFoptionsArr,mergeFields) {
  
    var sectionGrp = [];
    var sectionStart = false;
    var fieldsStart = 0;
    var fieldEnds = false;
    var genfieldsStart = 0;
    var genfieldEnds = false;
    var currentIndex = 0;
    var html = '';
    var childObjectPrefix = '';
    
var pageGrpStart = false;
    var sectionGrpStart = false;
    var fieldGrpStart = false;
    var genfieldGrpStart = false;
html += '<option class="fielditem" name="field-item" value="">--select an item--</option>';
if(mergeFields!=null && (mergeFields instanceof Array) && mergeFields.length>0){
html += '<optgroup class="FieldOption ff-merge-grp" label="Fast Forms Fields">';
$(mergeFields).each(function (index,ffOptionItem) {
  
  html += '<option class="fielditem ff-merge-field" name="field-item" value="' + ffOptionItem.FFValue + '">' + ffOptionItem.FFText + ' </option>';
});
html += '</optgroup>';
}
if(resultFFoptionsArr!=null && resultFFoptionsArr.length>0){
var totalItems = resultFFoptionsArr.length;
    $(resultFFoptionsArr).each(function (index,ffOptionItem) {

        var optionText = ffOptionItem.FFText;
        if(!isNullOrEmpty(optionText))
        {
        try{
       optionText= $('<div/>').html($('<div/>').html(optionText).text()).text()
       }catch(err){}
        }
        var optionValue = ffOptionItem.FFValue;
        if (optionText == '--select a page--') {
            pageGrpStart = true;
            html += '<optgroup class="PageOption" label="Pages">';
        }
        if (optionText == '--select a section--') {
            sectionGrpStart = true;
            if (pageGrpStart) {
                pageGrpStart = false;
                html += '</optgroup>';
            }
            html += '<optgroup class="SectionOption" label="Sections">';
        }
        if (optionText == '--select a field--' || optionText == '--select an item--') {
            if (sectionGrpStart) {
                sectionGrpStart = false;
                html += '</optgroup>';
            }
            fieldGrpStart = true;
            fieldsStart++;
        }
        if (optionText == '--select a general field--') {
            if (fieldGrpStart || sectionGrpStart) {
                fieldGrpStart = false;
                sectionGrpStart = false;
                html += '</optgroup>';
            }
            genfieldGrpStart = true;



        }
        if (fieldsStart > 0 && optionText.indexOf('Fields for') >= 0) {
            if (optionValue.length >= 1) {
               childObjectPrefix = 'FieldOption ' + optionValue;
             //  if(excludeSections){
              var sectionInfoArr= optionValue.split(' ');
               // && optionValue.split(' ').length>0 && optionValue.split(' ').length){
               if(sectionInfoArr.length==3 && sectionInfoArr[2]=='repeat'){
               childObjectPrefix += ' repeat-disabled';
               }
              // }
                //.substring(optionValue.length - 1);

            }

            if (fieldsStart > 0) {
                if (fieldEnds) {
                    // console.log('In fieldEnds - optionText :' + optionText);
                    html += '</optgroup>';
                    fieldEnds = false;
                }
                fieldsStart++;
            }
            html += '<optgroup class="' + childObjectPrefix + '" label="' + optionText + '">';

        }
        if (genfieldGrpStart && optionText.indexOf('--select a general field--') >= 0) {


            if (fieldsStart > 0) {
                if (fieldEnds) {
                    // console.log('IN fieldEnds - optionText :' + optionText);
                    html += '</optgroup>';
                    fieldEnds = false;
                }

                genfieldsStart++;
            }
            html += '<optgroup class="FieldOption" label="General Fields">';

        }
        if (pageGrpStart && !sectionGrpStart && optionValue != '' && fieldsStart == 0) {
            /*looping through section items */
            html += '<option class="pageitem" name="page-item" value="' + optionValue + '">' + optionText + ' </option>';
        }
        if (!pageGrpStart && sectionGrpStart && optionValue != '' && fieldsStart == 0) {
            /*looping through section items */
            html += '<option class="sectionitem" name="section-item" value="' + optionValue + '">' + optionText + ' </option>';
        }
        if (!pageGrpStart && !sectionGrpStart && fieldGrpStart && fieldsStart > 0 && optionValue != '' && optionText.indexOf('Fields for') < 0) {
            /*looping through field items */            
            fieldEnds = true;
           var elemType=getFieldTypeByElemId(optionValue);
            if(elemType!='undefined'){
            html += '<option class="fielditem" data-type="'+elemType+'" name="field-item" value="' + optionValue + '">' + optionText + ' </option>';
            }else{
            html += '<option class="fielditem" name="field-item" value="' + optionValue + '">' + optionText + ' </option>';
            }

        }
        if (!pageGrpStart && !sectionGrpStart && !fieldGrpStart && genfieldsStart > 0 && optionValue != '') {
            /*looping through field items */
            //  console.log('In gen  fields loop - optionText :' + optionText);
            fieldEnds = true;
            var elemType=getFieldTypeByElemId(optionValue);
            if(elemType!='undefined'){
            html += '<option class="fielditem" data-type="'+elemType+'" name="field-item" value="' + optionValue + '">' + optionText + ' </option>';
            }else{
            html += '<option class="fielditem" name="field-item" value="' + optionValue + '">' + optionText + ' </option>';
            }
        }
        
        if (index === totalItems - 1) {
            // this is the last one
            html += '</optgroup>';
        }
    });
    }
    return html;
}
function getFieldTypeByElemId(elemId){
var elemType='';
if(!isNullOrEmpty(elemId)){
elemId=elemId.replace("[[","").replace("]]","").replace(/\./g,"\\.");
  if($('#mainMultiPageWrapper').find('.fieldLi #'+elemId).length>0){
  elemType=$('#mainMultiPageWrapper').find('.fieldLi #'+elemId).attr('vatt');
  }
}
return elemType;
}
function isFieldExistOnForm(elemId){
var elemType='';
if(!isNullOrEmpty(elemId)){
elemId=elemId.replace("[[","").replace("]]","").replace(/\./g,"\\.");
  if($('#mainMultiPageWrapper').find('.fieldLi #'+elemId).length>0){
  return true;
  }

}
return false;
}
function parseStringToMergeFieldArr(stringWithMergeFields){
var mergeFieldsArr=[];
  if(!isNullOrEmpty(stringWithMergeFields)){
    var returnArr = stringWithMergeFields.match(/\[\[[A-Za-z0-9_.]*\]\]/g);
    if(returnArr!=null && returnArr.length>0){
    $.each(returnArr,function(indx,item){
    if(item!=''){
    item=item.replace('[[','').replace(']]','');
    mergeFieldsArr.push(item);
    }
    });
    }
  }
  return mergeFieldsArr;
}
function insertContentInCKEditor(elemSourceId, html) {

    var editor = CKEDITOR.instances[elemSourceId];
    editor.insertHtml(html);
    
}
function setContentInCKEditor(elemSourceId, html) {

    var editor = CKEDITOR.instances[elemSourceId];
    editor.setData(html);

}
function toggleAccordionContent(elemSource) {
    var targetclass = $(elemSource).attr('data-targetclass');
    var expand = false;
    var parentAccElem=$(elemSource).parents('.ff-accordion')[0];
    if ($(elemSource).parents('.accordion-wrapper').find('>.acc-content').hasClass('f-collapse')) {
        expand = true;
    }
    
    $(parentAccElem).find('>.accordion-wrapper>.acc-content').slideUp(300,'linear',function(){
$(this).addClass('f-collapse');
 });
    $(parentAccElem).find('>.accordion-wrapper>.accordion-header').removeClass('acc-expanded');
    if (!isNullOrEmpty(targetclass) && expand) {
         
         $(parentAccElem).find('>.accordion-wrapper>.' + targetclass).slideDown(300,'linear',function(){
$(this).removeClass('f-collapse');
$(elemSource).parent().addClass('acc-expanded');
if(accordionHeaderScrollToTop!==undefined && accordionHeaderScrollToTop){
try{scrollToElement($(elemSource).parent().parent().find('.accordion-header').first());}catch(err){}
}
 });
         
    } 
}
function initializeSelect2PlaceHolder(slectElem){
  if($(slectElem).find('option').length>0 && $(slectElem).find('option').first().val()==''){ 
  $(slectElem).select2({placeholderOption: 'first'});
  }else{
  $(slectElem).select2();
  }
}