function safePageLabel(pagerecordid)
{
var returnId=pagerecordid;
  if (!isNullOrEmpty(returnId))
  {
       returnId=returnId.replace('FFP-','');
      returnId = returnId.replace(/^0+/, '');
  }
    return 'pageFFLabel'+returnId;
}
function safeSectionLabel(sectionid)
{
var returnId=sectionid;
  if (!isNullOrEmpty(returnId))
  {
       
      returnId = returnId.replace(/sectionFFLabel/g, '');
      returnId = returnId.replace(/sectionLabel/g, '');
  }
    return 'sectionLabel'+returnId;
}
function getSafeApiName(formLiElem)
{
    var apiname=$(formLiElem).find('div.labelDiv label.ff-label').attr('data-apiname');
    if(isNullOrEmpty(apiname) || apiname.indexOf(' ')>0)
    {
     apiname=getSFieldName($(formLiElem).find('.fieldDiv').find('>select,>input,input.ff-input-type,>textarea').attr('id'));
    }
    return apiname;
}
function safeSectionCounter(sectionid)
{
var returnId=sectionid;
  if (!isNullOrEmpty(returnId))
  {
       
      returnId = returnId.replace(/sectionFFLabel/g, '');
      returnId = returnId.replace(/sectionLabel/g, '');
  }
    return returnId;
}


function firstCharCap(txt) {
    var txtstr = txt;
    if (!isNullOrEmpty(txt) && txt.length > 1) {
        txtstr = txt.slice(0, 1).toUpperCase()
        txtstr += txt.slice(1).toLowerCase();
    }
    return txtstr;
}
function refreshPagesOrder(){
 draftchanges(true);
 var multiPageOrderObjList=[];
        $('#mainMultiPageWrapper .fc-multi-page-item').each(function(indx,pageItem){
                    var pageid=$(pageItem).attr('data-pageid');
                    if(!isNullOrEmpty(pageid))
                    {
                var pageorder=0;
                  pageorder=indx;
                  pageorder++;
                  $(pageItem).find('.ff-page-header-box .page-tag-number').html(pageorder);
                   
                    var pageObj={'Id':pageid};
                    var pageorder_c=getPrefixedOrgFieldName(SFOrgPrefix,'Page_Order__c');
                    pageObj[pageorder_c]=pageorder;
                    multiPageOrderObjList.push(pageObj);
                    }
            });
            resetFooterNavigation();
            resetPageDeleteOption();
            remoteUpdateFormPagesOrderJs(multiPageOrderObjList);
  }
  function resetPageDeleteOption()
  {
   if($('#mainMultiPageWrapper .fc-multi-page-item').length<2)
   {
   if($('#mainMultiPageWrapper .fc-multi-page-item').hasClass('hide-visibility')){
   togglePageBlock($('#mainMultiPageWrapper .fc-multi-page-item .ff-page-header-box .expand-icon'));
   }
   $('#mainMultiPageWrapper .fc-multi-page-item .ff-page-header-box').fadeOut();
   $('#mainMultiPageWrapper .fc-multi-page-item').attr('data-ishidden',false);
   $('#mainMultiPageWrapper .fc-multi-page-item li.pageLi').fadeOut();
    
   }
   else{
    $('#mainMultiPageWrapper .fc-multi-page-item .ff-page-header-box').fadeIn();
    $('#mainMultiPageWrapper .fc-multi-page-item li.pageLi').fadeIn();
      $('#mainMultiPageWrapper .fc-multi-page-item').each(function(indx,pageItem){
       $(pageItem).find('.ff-page-header-box  .ff-page-edit-box .delete-icon').show();
      });

   }
  }
  function refreshPagesOrderCallBack(err, results,objevent)   {
  if(err)
  {
console.log('Error  Refreshed page orders-'+err.message);
draftchanges(false);
  }
  else{
      $(results).each(function(indx, pageitem){
     console.log(' Refreshed page orders-'+pageitem.Id);
      });
      draftchanges(false);
  }
   
}

function addFFPage(mainPageElemWrapper,pageItem) {
var pagename = pageItem["pTitle"];
            var pageorder = safeStringValue(pageItem["pOrder"],'');
            var pageid = safeStringValue(pageItem["pId"],'');
            var pageishidden = getSafeBoolean(pageItem["pHidden"],false);
            

    if ($(mainPageElemWrapper).find('.form-canvas-multi-page-inner').find('.fc-multi-page-item').length > 0) {

        $(mainPageElemWrapper).find('.form-canvas-multi-page-inner').append($('#pageAddNewTEMP').html());
    }
    var pageDiv = $('<div/>').addClass('fc-multi-page-item');
    pageDiv.append($('#pageHeaderTEMP').html());
    pageDiv.append($('#pageTitleTEMP').html());
    //pageDiv.find('.formSectionUl').append($('#pageNewSectionTEMP').html());
    var pagelabelid=safePageLabel(safeStringValue(pageItem["pFormPageId"],''));
    if (!isNullOrEmpty(pagelabelid)) {
        pageDiv.find('.ff-page-header').attr('id', pagelabelid);
    }

    pageDiv.append($('#pageFooterTEMP').html());
    pageDiv.append($('#pageNewSectionBoxTEMP').html());
    pageDiv.find('.ff-page-header-box .page-tag-number').html(pageorder);
            pageDiv.attr('data-pageid',pageid); 
            pageDiv.attr('data-ishidden',pageishidden);
            if(isNullOrEmpty(pagename))
            {
            pagename='New Page Title';
            }
             pageDiv.find('>ul.formPageUl>li .ff-page-header').html(pagename);
             addNewSectionItem(pageDiv.find('.add-newsection-box'),false);
    $(mainPageElemWrapper).find('.form-canvas-multi-page-inner').append(pageDiv);

}
function resetFooterNavigation()
{
var isSaveForLaterEnabled=false;
var totalPages=$('.form-canvas-multi-page-inner .fc-multi-page-item').length;
    $('.form-canvas-multi-page-inner .fc-multi-page-item').each(function(indx,pageElement){
    if(indx==0)
    {
    isSaveForLaterEnabled=getSafeBoolean($(pageElement).find('.Ulbtn .ff-btn-save').attr('data-saveenabled'),false);
    $(pageElement).find('.Ulbtn .ff-btn-prev').hide();
    if(totalPages>1)
    {
    $(pageElement).find('.Ulbtn .ff-btn-next').show();
    $(pageElement).find('.Ulbtn .ff-btn-submit').hide();
    }
    else{
    $(pageElement).find('.Ulbtn .ff-btn-next').hide();
    $(pageElement).find('.Ulbtn .ff-btn-submit').show();
    }
    }
    else if(indx==totalPages-1)
    {//last page-hide back button
    $(pageElement).find('.Ulbtn .ff-btn-next').hide();
     if(totalPages>1)
    {
    $(pageElement).find('.Ulbtn .ff-btn-prev').show();
    $(pageElement).find('.Ulbtn .ff-btn-submit').show();
    }
    else{
    $(pageElement).find('.Ulbtn .ff-btn-prev').hide();
    $(pageElement).find('.Ulbtn .ff-btn-submit').show();
    }
    }
    else{
     $(pageElement).find('.Ulbtn .ff-btn-submit').hide();
    $(pageElement).find('.Ulbtn .ff-btn-prev').show();
    $(pageElement).find('.Ulbtn .ff-btn-next').show();
    }
    if(isSaveForLaterEnabled){
    $(pageElement).find('.Ulbtn .ff-btn-save').show();
    }else{
    $(pageElement).find('.Ulbtn .ff-btn-save').hide();
    }
    
    });
}
function getFFPage(addSection) {

    var pageDiv = $('<div/>').addClass('fc-multi-page-item');
    pageDiv.append($('#pageHeaderTEMP').html());
    pageDiv.append($('#pageTitleTEMP').html());
    //pageDiv.find('.formSectionUl').append($('#pageNewSectionTEMP').html());


    pageDiv.append($('#pageFooterTEMP').html());
    pageDiv.append($('#pageNewSectionBoxTEMP').html());
    if(addSection)
    {
    addNewSectionItem(pageDiv.find('.add-newsection-box'),false);
    }
    return pageDiv;
}
function addLastNewPageElement() {
    if ($('#mainMultiPageWrapper').find('>.add-newpage-box').length < 1) {
        var addNewPageElem = $('<div/>').html($('#pageAddNewTEMP').html());
        addNewPageElem.find('.page-divider.item-last').remove();
        $('#mainMultiPageWrapper').append(addNewPageElem.html());
    }
}
function toggleNextElements(elemSource)
{
//toggleNextElement(elemSource,true);
}
function toggleNextElement(elemSource,checkEdition,isAutoSave)
{
var processAction=true;
if(checkEdition){
var editionFlagEnabled=getSafeBoolean($(elemSource).attr('data-featuredisabled'),false);
if(editionFlagEnabled)
{
var primaryMessage=safeStringValue($(elemSource).attr('data-upgradetitle'),'Premium feature');
var secMessage=safeStringValue($(elemSource).attr('data-upgrademsg'),'This feature is not available in your edition of Fast Forms');
 upgradeNowMessage(primaryMessage,secMessage,''); 
processAction=false;
   
}
 
}
if(processAction){
  if($(elemSource).prop('checked'))
{

    $(elemSource).closest('.toggle-div-parent').find('>.toggle-div-child').slideDown();
}
else{
 $(elemSource).closest('.toggle-div-parent').find('>.toggle-div-child').slideUp();   
}
onFormSettingsChange(elemSource,isAutoSave);
}
else{
  if($(elemSource).is(':checked')){
  $(elemSource).prop('checked',false);
  }
}

}
function formOptionsConfigXML() {
  
var formoptions='<formOptions>'
                              formoptions+='<submitInfo>';
                               
                              formoptions+='<btnMessage>'+safeStringValue($("#txtareaThankyoumsg").val(),"Thank you for your submission!")+'</btnMessage>';
                            formoptions+='<btnText>'+safeStringValue($("#txtbxSubmitButtonLabel").val(),"Send")+'</btnText>';
                            formoptions+='<btnUrl>'+safeStringValue($("#txtbxRedirectUrl").val(),"")+'</btnUrl>'; 
                              if($('a[href$="#formconfirmationRadio2"]').parent().hasClass('active'))
                              {
                                formoptions+='<redirectEnabled>true</redirectEnabled>';
                              }
                              else
                              {
                                formoptions+='<redirectEnabled>false</redirectEnabled>';
                              }
                              formoptions+='</submitInfo>';
                              formoptions+='<multiPageInfo>';
                              if($('#mainMultiPageWrapper').find('.form-canvas-multi-page-inner').find('.fc-multi-page-item').length > 1)
                              {
                                formoptions+='<multiPageEnabled>true</multiPageEnabled>';
                              }
                              else{
                                formoptions+='<multiPageEnabled>false</multiPageEnabled>';
                              }
                              formoptions+='<breadcrumbEnabled>'+getFFCheckBoxElemValue($("#chkFormNavigationBar"),false)+'</breadcrumbEnabled>';
                              formoptions+='<breadcrumbPrefixEnabled>'+getFFCheckBoxElemValue($("#chkPrefixNumber"),false)+'</breadcrumbPrefixEnabled>';
                              formoptions+='<breadcrumbPrefix>'+safeStringValue($("#inputPrefixNumber").val(),"Back")+'</breadcrumbPrefix>';
                              formoptions+='<breadcrumbNumbered>'+getFFCheckBoxElemValue($("#chkPagenumberInNavigation"),false)+'</breadcrumbNumbered>';
                              var validationtype=safeStringValue($('#selFormValidationType').select2("val"),"");
                              if(validationtype=='page')
                              {
                              formoptions+='<pageValidationType>'+validationtype+'</pageValidationType>';
                              }
                              else
                              {
                               formoptions+='<pageValidationType>form</pageValidationType>';
                              }
                              formoptions+='<isFooterCustomized>'+getFFCheckBoxElemValue($("#chkCustomizeFooterNavigation"),false)+'</isFooterCustomized>';
                              formoptions+='<prevBtnText>'+safeStringValue($("#inputBtnPrev").val(),"Back")+'</prevBtnText>';
                              formoptions+='<nextBtnText>'+safeStringValue($("#inputBtnNext").val(),"Next")+'</nextBtnText>';
                              formoptions+='</multiPageInfo>';
                              formoptions+='<saveForLaterInfo>';
                              formoptions+='<saveForLaterEnabled>'+getFFCheckBoxElemValue($("#chkCustomizeSaveForLater"),false)+'</saveForLaterEnabled>';
                              formoptions+='<saveBtnText>'+safeStringValue($("#inputBtnSFLSave").val(),"Save")+'</saveBtnText>';
                              formoptions+='<discardBtnText>'+safeStringValue($("#inputBtnSFLDiscard").val(),"Discard")+'</discardBtnText>';
                              formoptions+='</saveForLaterInfo>';
                              formoptions+='</formOptions>';
                              return formoptions;

}
function populateSubmitOptions(formOptionsElem,onlyFormCanvasElements) {

$('#selFormValidationType').select2();
    var btnMessage =firstElementByTagName(formOptionsElem, "btnMessage", true);// getXMLElemFirstNode(submitOptions, "btnMessage");
    var btnText = firstElementByTagName(formOptionsElem, "btnText", true);
    var btnUrl = firstElementByTagName(formOptionsElem, "btnUrl", true);
    var redirectEnabled = firstBooleanElementByTagName(formOptionsElem, "redirectEnabled", false);
   var breadcrumbEnabled =firstBooleanElementByTagName(formOptionsElem, "breadcrumbEnabled",false);
var breadcrumbPrefix =firstElementByTagName(formOptionsElem, "breadcrumbPrefix",true);
var breadcrumbPrefixEnabled =firstBooleanElementByTagName(formOptionsElem, "breadcrumbPrefixEnabled",false);
var breadcrumbNumbered =firstBooleanElementByTagName(formOptionsElem, "breadcrumbNumbered",false);

var pageValidationType =firstElementByTagName(formOptionsElem, "pageValidationType",true);
var isFooterCustomized = firstBooleanElementByTagName(formOptionsElem, "isFooterCustomized", false);
var prevBtnText =firstElementByTagName(formOptionsElem, "prevBtnText",true);
var nextBtnText =firstElementByTagName(formOptionsElem, "nextBtnText",true);
     
var isSaveForLaterEnabled = firstBooleanElementByTagName(formOptionsElem, "saveForLaterEnabled", false);
var saveBtnText =safeStringValue(firstElementByTagName(formOptionsElem, "saveBtnText",true),'Save');
var discardBtnText =safeStringValue(firstElementByTagName(formOptionsElem, "discardBtnText",true),'Discard');

     
    try {
      
        if(!onlyFormCanvasElements)
        {
         
        $("#txtbxSubmitButtonLabel").val(btnText);
        $("#txtareaThankyoumsg").val(btnMessage);
        $("#txtbxRedirectUrl").val(btnUrl);
        $('#inputPrefixNumber').val(breadcrumbPrefix);
        $('#inputBtnPrev').val(prevBtnText);
        $('#inputBtnNext').val(nextBtnText);
        $('#inputBtnSFLDiscard').val(discardBtnText);
        $('#inputBtnSFLSave').val(saveBtnText);

            if (redirectEnabled) {
                $('a[href$="#formconfirmationRadio1"]').parent().removeClass('active');
                $('a[href$="#formconfirmationRadio2"]').parent().addClass('active')
                $('#formconfirmationRadio1').removeClass('active in');
                $('#formconfirmationRadio2').addClass('active in');
            }

            setFFCheckBoxElem($('#chkFormNavigationBar'),breadcrumbEnabled);
            setFFCheckBoxElem($('#chkPagenumberInNavigation'),breadcrumbNumbered );
            setFFCheckBoxElem($('#chkPrefixNumber'),breadcrumbPrefixEnabled );
            setFFCheckBoxElem($('#chkCustomizeFooterNavigation'),isFooterCustomized);
            setFFCheckBoxElem($('#chkCustomizeSaveForLater'),isSaveForLaterEnabled);
            if(!isNullOrEmpty(pageValidationType))
            {
             $('#selFormValidationType').select2('val',pageValidationType);
            }
            $('.form-row-group .toggle-trigger').each(function(indx,chkBoxElem){
        toggleNextElement(chkBoxElem,false,false);
        });
        }
         
        
        resetFooterNavigationBtns(btnText,prevBtnText,nextBtnText,saveBtnText,isSaveForLaterEnabled);
    }
    catch (err) {
        console.log(' Error in populating footerHtml ' + err);
    }
} 
function resetFooterNavigationBtns(submitBtnText,prevBtnText,nextBtnText,saveText,isSaveForLaterEnabled)
{
    $('#mainMultiPageWrapper').find('.form-canvas-multi-page-inner .fc-multi-page-item').each(function(indx,pageElem){
     $(pageElem).find('.Ulbtn').find('.ff-btn-prev').val(prevBtnText);
     $(pageElem).find('.Ulbtn').find('.ff-btn-next').val(nextBtnText);
     $(pageElem).find('.Ulbtn').find('.ff-btn-submit').val(submitBtnText);      
     $(pageElem).find('.Ulbtn').find('.ff-btn-save').val(saveText);
     $(pageElem).find('.Ulbtn').find('.ff-btn-save').attr('data-saveenabled',isSaveForLaterEnabled);
      
    });
}
function createJSONPageObj(pageid,formpageid,pageTitle, pageOrder, pageFieldsXml,pagehtml,pagehidden) {
    var dataobj = { 'pId':pageid,'pFormPageId':formpageid, 'pTitle': pageTitle, 'pOrder': pageOrder, 'pXML': pageFieldsXml,'pHTML': pagehtml,'pHidden': pagehidden };


    return dataobj;
}
function createJSONFormPageObj(pageid,pageTitle, pageOrder, pageFieldsXml,pagehtml,pageFieldsObjectXml,pagehidden) {
 var pagexml_c=getPrefixedOrgFieldName(SFOrgPrefix,'Fields_xml__c');
 var pagefieldsobjectxml_c=getPrefixedOrgFieldName(SFOrgPrefix,'FieldsObjectXml__c');
var formhtml_c=getPrefixedOrgFieldName(SFOrgPrefix,'Html__c'); 
var pageorder_c=getPrefixedOrgFieldName(SFOrgPrefix,'Page_Order__c');
var pagetitle_c=getPrefixedOrgFieldName(SFOrgPrefix,'Page_Title__c');
var ishidden=getPrefixedOrgFieldName(SFOrgPrefix,'Is_Hidden__c');

    var dataobj = { 'Id':pageid};
    dataobj[pagetitle_c]=pageTitle;
    dataobj[pageorder_c]=pageOrder;
    dataobj[pagexml_c]=pageFieldsXml;
    dataobj[pagefieldsobjectxml_c]=pageFieldsObjectXml;
    dataobj[formhtml_c]=pagehtml;
    dataobj[ishidden]=pagehidden; 
    return dataobj;
}
 
 
function updateElemProps(elemSource, classnm, elemid, text) {
    $(elemSource).attr('class', classnm);
    $(elemSource).attr('id', elemid);
    $(elemSource).html(text);
    return $(elemSource)

}
function isStringTrue(stringBooleanFlag, defaultBool) {
    var returnflag = defaultBool;
    if (!isNullOrEmpty(stringBooleanFlag) && (stringBooleanFlag == true || stringBooleanFlag + ''.toLowerCase() == 'true')) {
        returnflag = true;
    }
    return returnflag;
}
function updateElementProp(elemSource, attrName, attrValue, includeIfBlankValue) {
    if (elemSource !== undefined) {
        if (!isNullOrEmpty(attrValue)) {
            $(elemSource).attr(attrName, attrValue);
        }
        else if (includeIfBlankValue) {
            $(elemSource).attr(attrName, '');
        }
    }

}

function initializeESignatureElements() {
    $('#mainMultiPageWrapper .formFieldUl li.fieldLi[data-otype="OESignature"]').each(function (inx, fieldLi) {
        if ($(fieldLi).hasClass('generalSortableForFields')) {
            resetESignatureElement(fieldLi, false);
        }
    });
}
function htmlUnescape(value) {
    return String(value)
        .replace(/&quot;/g, '"')
        .replace(/&#39;/g, "'")
        .replace(/&lt;/g, '<')
        .replace(/&gt;/g, '>')
        .replace(/&amp;/g, '&');
}
function objectInfoDisplay() {
$('.formFieldUl li .labelDiv').each(function (i, labelDiv) {
if($(labelDiv).find('.obj-info').length>0)
{
    var listname=$(labelDiv).find('.obj-info').attr('data-listname');
    var labeltext=$('#'+listname).parents('.list-toggle-div-wrap').find('.objName').text();
    var labeltext='';
   if(listname=='sortableForRelFields1'){
    labeltext=$("#priName").text();
    }
    else{
   labeltext= $('#'+listname).parents('.list-toggle-div-wrap').find('.objName').text();
    }
    if(!isNullOrEmpty(labeltext))
    {
    $(labelDiv).find('.obj-info').html('From: '+labeltext);
    }
     
}
});
}
function addObjectInfoOnLabel(labelElemDiv,sortableclass,colorcode)
{
   $(labelElemDiv).find('.obj-info').remove();
   if(!isNullOrEmpty(colorcode)){
   colorcode=colorcode.trim();
   }
    $(labelElemDiv).append($('<div/>',{'class':'obj-info','data-listname':sortableclass,'data-colorcode':colorcode}));
    $(labelElemDiv).find('.obj-info').hide();
    
    var labeltext='';
   if(sortableclass=='sortableForRelFields1'){
    labeltext=$("#priName").text();
    }
    else{
   labeltext= $('#'+sortableclass).parents('.list-toggle-div-wrap').find('.objName').text();
    }
    if(!isNullOrEmpty(labeltext))
    {
    $(labelElemDiv).find('.obj-info').html('From: '+labeltext);
    }
}
function resetFlexInputElements() {

    $('.formFieldUl li .fieldDiv>input[type="textbox"]').each(function (i, inputElement) {

        var attrDataFlexControl = $(inputElement).attr('data-flexcontrol');
        if (typeof attrDataFlexControl !== typeof undefined && attrDataFlexControl !== false && attrDataFlexControl != '') {
            switch (attrDataFlexControl) {
                case "integer-starrating":
                    var noofitems = $(inputElement).attr('data-flex-max');
                    var minlabel = $(inputElement).attr('data-flex-minlabel');
                    var maxlabel = $(inputElement).attr('data-flex-maxlabel');

                    setRatingInput($(inputElement), noofitems, minlabel, '', maxlabel, attrDataFlexControl);

                    break;
                case "integer-npsrating":
                    var minlabel = $(inputElement).attr('data-flex-minlabel');
                    var maxlabel = $(inputElement).attr('data-flex-maxlabel');
                    var middlelabel = $(inputElement).attr('data-flex-middlelabel');
                    setRatingInput($(inputElement), '', minlabel, middlelabel, maxlabel, attrDataFlexControl);

                    break;
                default:
                    setRatingInput($(inputElement), '', '', '', '', attrDataFlexControl);
                    break;
            }
        }
        $( inputElement).parents('.fieldDiv').find('.ff-currency').remove();
        $( inputElement).parents('.fieldDiv').find('.ff-percent').remove();
        var vatttype = $(inputElement).attr('vatt');
        if(!isNullOrEmpty(vatttype) && vatttype.indexOf('CURRENCY')>=0)
        {
        var currencylabel=$(inputElement).attr('data-currencylabel');
        if(isNullOrEmpty(currencylabel))
        {
        currencylabel='$';
        }
          $( inputElement).parents('.fieldDiv').prepend( "<div class='ff-currency'>"+currencylabel+"</div>" );
        
        }
        else if(!isNullOrEmpty(vatttype) && vatttype.indexOf('PERCENT')>=0)
        {
          var percentlabel=$(inputElement).attr('data-percentlabel');
        if(isNullOrEmpty(percentlabel))
        {
        percentlabel='%';
        }
          $( inputElement).parents('.fieldDiv').append( "<div class='ff-percent'>"+percentlabel+"</div>" );
        
        }
    });

}

/* MakeMulti page form sortable*/
function makeMultiPageFormSortable(fmEditEnabled, onlyProfEnterprise, onlyEnterpriseEdit) {
    console.log('in   makeMultiPageFormSortable ');
    $(".formFieldUl").sortable({
        items: "> li:not(.sectionLi)",
         
        connectWith: ".list-toggle-div .dropfields,.formFieldUl",
        dropOnEmpty: true,
        zIndex: 9999,
        cancel: 'select,option,textarea,input,.isFieldEdit,.editDelDiv',
        revert: 300,

        receive: function (ev, ui) {
            goToNextTourStop();
            var isSectionRepeatItem=false;
            var isAllowed=true;
            if (ui.item.hasClass("ui-restricted")){
            isAllowed=false;
            ui.item.removeClass("ui-restricted");
            ui.sender.sortable("cancel");
            }
            if(isAllowed && $(ui.sender).parents('.list-toggle-div-wrap').length>0){
            if($(ui.sender).parents('.list-toggle-div-wrap').hasClass('repeat')){
            isSectionRepeatItem=true;
            }
            }
            var isParentCanvas = false;
            if (ui.sender.hasClass('formFieldUl')) {
                isParentCanvas = true;
            }
            console.log('Recieving li item on sortable recieve event');
            var validField = true;
            if (ui.item.hasClass("Ulbtn") || ui.item.hasClass("lbl") || ui.item.hasClass("sectionHeader")) {
                alert('Oops! Fields can only be added to sections. Please drop your field into an section or create a new section.');
                ui.sender.sortable("cancel");
                validField = false;
            }
            if (fmEditEnabled) {
                if (ui.sender.parents('.list-toggle-div-wrap').length > 0 && ui.sender.attr('id') != 'sortableForRelFields1' && ui.sender.attr('id') != 'generalSortableForFields') {
                    console.log(' Sender List id- ' + ui.sender.attr('id'));
                    upgradeNowMessage('Multi-object forms are only available for paid subscriptions..', '', '');
                    ui.sender.sortable("cancel");
                    validField = false;
                }
                else if (ui.sender.parents('.list-toggle-div-wrap').length > 0 && ui.sender.attr('id') == 'sortableForRelFields1') {
                    var objname = ui.sender.parents('.list-toggle-div-wrap').find('span.objName').text();
                    var vatt = ui.item.find('>div:first-child > label').attr('vatt');
                    if ($.inArray(objname, validObjects()) < 0) {
                        upgradeNowMessage("Only Case, Account, Contact and Lead fields are available in Fast Forms free edition.", "", "");
                        ui.sender.sortable("cancel");
                        validField = false;
                    }
                    else if (!isNullOrEmpty(vatt) && vatt == 'REFERENCE') {
                        upgradeNowMessage("Reference fields are only available for paid subscriptions.", "", "");
                        ui.sender.sortable("cancel");
                        validField = false;
                    }


                }
            }
            if(isAllowed){
            //Run this code whenever an item is dragged and dropped into this list 
            if (validField) {
            if(isSectionRepeatItem){
            $(ev.target).parents('.formSectionUl').addClass('section-repeat');
            $(ev.target).parents('.formSectionUl').attr('data-sortableclass',ui.sender.attr("id"));
            $(ev.target).parents('.formSectionUl').attr('data-childclass',ui.sender.parents('.list-toggle-div-wrap').attr('data-childclass'));
            }
                console.log(' Drag and drop Item lentgh -'+ui.item.length);
                var isGen = false;
                ui.item.removeAttr('style');
                if (ui.item.length > 0) {


                    var itemid = ui.item.attr('id');
                    //var str ='';  
                    var ispaymentfield = false;
                    var isESignaturefield = false;
                   itemid= safeLegacyPAYPALPAYMENT(itemid);
                    if (itemid !== undefined && itemid.indexOf('FASTFORMSPAYMENT') > 0) {
                        ispaymentfield = true;
                    }
                    else if (itemid !== undefined && itemid.indexOf('ESIGNATURE') > 0) {
                        isESignaturefield = true;
                    }
                    if (ispaymentfield) {
                        ui.item.find('.payment-item-header').hide();

                        $(ui.item.find('.payment-item-row')).each(function (i, ppitemrow) {

                            if (!$(ppitemrow).hasClass('pp-default-hide')) {
                                $(ppitemrow).find('.PPGeneralFieldDiv').show();
                                $(ppitemrow).show();
                            }
                            // $(ppitemrow).find('.PPGeneralFieldDiv').css('width','40%');

                        });
                        ui.item.find('.alert-payment-setup').show();

                    }
                    else if (isESignaturefield) {
                        ui.item.find('.ffd-esignature').html($('#DocSignHTMLTemp').html());
                        isGen = true;
                    }
                    else {
                        ui.item.find('div').show();
                       // ui.item.find('div:first').css('width', '40%');
                         
                       
                    }

                    ui.item.removeClass('tooltip');
                    $(".formUlLabel").children().removeClass('ui-state-default');
                    ui.item.find('.deleteField').show();
                    var dropLiId = ui.item.attr('id');
                    ui.item.removeClass('ui-state-default');

                    // str = str.substring(0, str.indexOf("."));
                    ui.item.removeAttr('style');
                    if (ui.sender.hasClass('formUlLabel') && ui.item.find('.fieldDiv').find('>select,>:input').length > 0) {
                        if (ui.item.find('.fieldDiv').find('>select').length > 0) {
                            var controlType = ui.item.find('.fieldDiv').find('>select').attr('data-flexcontrol');
                            if (controlType !== undefined && controlType != '') {
                                if (controlType.indexOf('picklist-radiobutton') >= 0) {
                                    var alignment = controlType.replace('picklist-radiobutton', '');
                                    reinitializeSelectToRadioElement(controlType, ui.item.find('.fieldDiv'), false, false, 'ff-ext-radio', alignment);
                                }
                                else if (controlType.indexOf('multipicklist-checkbox') >= 0) {
                                    var alignment = controlType.replace('multipicklist-checkbox', '');
                                    reinitializeSelectToRadioElement(controlType, ui.item.find('.fieldDiv'), false, false, 'ff-ext-radio', alignment);
                                }
                                else if (controlType = 'picklist-combobox') {
                                    destroySelect2(ui.item.find('.fieldDiv'));
                                    ui.item.find('.fieldDiv').find('>select').select2();
                                }
                                else {

                                }
                            }
                        }
                        else if (ui.item.find('.fieldDiv').find('>:input[type="textbox"]').length > 0) {

                            var controlType = ui.item.find('.fieldDiv').find('>:input[type="textbox"]:first').attr('data-flexcontrol');
                            var attrDataFlexControl = ui.item.find('.fieldDiv').find('>:input[type="textbox"]:first').attr('data-flexcontrol');
                            if (typeof attrDataFlexControl !== typeof undefined && attrDataFlexControl !== false && attrDataFlexControl != '') {
                                switch (attrDataFlexControl) {
                                    case "integer-starrating":
                                        reinitializeRatingElement(ui.item.find('.fieldDiv'));
                                        break;
                                    case "integer-npsrating":
                                        reinitializeRatingElement(ui.item.find('.fieldDiv'));
                                        break;
                                    default:
                                        setRatingInput(ui.item.find('.fieldDiv'), '', '', '', '', attrDataFlexControl);
                                        break;
                                }
                            }
                        }
                    }
                    ui.item.unbind();
                  
                    var sortableFieldClassName = '';
                    if (ui.sender.attr("id") == 'sortableForRelFields1') {
                        sortableFieldClassName = 'sortableForRelFields1';
                         
                        addObjectInfoOnLabel(ui.item.find('>div.labelDiv'),sortableFieldClassName,'');
                        
                    }
                    else if (ui.sender.attr("id") == 'generalSortableForFields') {
                        sortableFieldClassName = 'generalSortableForFields';
                        ui.item.addClass(sortableFieldClassName);
                    }
                    else if (!isNullOrEmpty(ui.sender.attr("id")) && ui.sender.attr("id").indexOf('sortableForRelFields') >= 0 && ui.sender.hasClass('dropfields')) {
                        var ListMainVarRel = ui.sender.parents('.list-toggle-div-wrap');
                        
                        var mainFieldElement = ui.item.find('.fieldDiv').find('>select,>input,input.ff-input-type,input[type=hidden],>textarea');
                        var elemId=$(mainFieldElement).attr('id');
                        $(mainFieldElement).each(function (indx, inputElem) {
                                if ($(inputElem).attr('type') != 'hidden') { 
                                    elemId=$(inputElem).attr('id');
                               }
                            });
                        
                        sortableFieldClassName = $(ListMainVarRel).find('ul.dropfields').attr('id');
                        var colorBar = safeStringValue($(ListMainVarRel).attr('data-childclass'), '');
                        ui.item.find('.labelDiv').removeAttr('style');
                        ui.item.removeAttr('style');
                         
                        //var lblName = ui.item.find('.labelDiv label.ff-label').addClass('grayLabel');// $(litem).find('label').attr('id').replace('lbl', '');
                        var finalElemId = elemId;

                        var elemIdWODot = elemId.replace(/\./g, '');
                        if (colorBar != undefined && colorBar != '') {
                        addObjectInfoOnLabel(ui.item.find('>div.labelDiv'),sortableFieldClassName,colorBar);

                            ui.item.addClass(colorBar);
                            if (colorBar != '') {

                                finalElemId = elemId.substring(0, elemId.lastIndexOf('.'));

                                finalElemId = finalElemId + '.' + colorBar + '.' + elemId.substring(elemId.lastIndexOf('.') + 1);
                            }



                            if (ui.item.find('.labelDiv .ff-label').length > 0) {
                                ui.item.find('.labelDiv .ff-label').attr('ondblclick', "editFFLabel(this);");
                            }
                            elemIdWODot=finalElemId.replace(/\./g,'');
                            ui.item.attr('id', 'lblli'+elemIdWODot);
                            if(!isParentCanvas){
                            $(mainFieldElement).each(function (indx, inputElem) {
                                if ($(inputElem).attr('type') == 'hidden') {
                                    $(inputElem).attr('id', finalElemId + 'hidden');
                                    $(inputElem).attr('name', finalElemId + 'hidden');
                                }
                                else {
                                    $(inputElem).attr('id', finalElemId);
                                    $(inputElem).attr('name', finalElemId);
                                }
                            });
                            }
                            ui.item.find('.editImg').attr('onclick', "openEditDialog(this,true);");



                        } else {
                            RemoveAllClassColorCodes(ui.item);
                            addObjectInfoOnLabel(ui.item.find('>div.labelDiv'),sortableFieldClassName,'');
                            var midName = '';
                            var str =elemId;
                            var idArr = str.split('\.');
                            if (idArr.length > 2) {
                                midName = idArr[1];
                            }
                            $("#sortableForRelFields1").find('li').each(function () {
                                if (isNullOrEmpty($(ListMainVarRel).attr('data-ischild'))) {
                                    if (($(this).attr("title") == "REFERENCE" || $(this).attr("title").match(/\(Lookup\)$/g) != null) && $(this).find('div.labelDiv').attr('lblname') == $(ListMainVarRel).find('.objName').text().substring(0, $(ListMainVarRel).find('.objName').text().indexOf('(') - 1)) {
                                        midName = $(this).find('>div:first-child label').attr('id').replace('lbl', '');
                                    }
                                }
                            });

                            var priObj = str.substring(0, str.indexOf('.') + 1);
                            var fldObj = str.substring(str.lastIndexOf('.'));
                            var inputIdStr = priObj + midName + fldObj;
                            if(!isParentCanvas)
                            {
                            $(mainFieldElement).each(function (indx, inputElem) {
                                if ($(inputElem).attr('type') == 'hidden') {

                                    $(inputElem).attr('id', inputIdStr + 'hidden');
                                    $(inputElem).attr('name', inputIdStr + 'hidden');
                                }
                                else {
                                    $(inputElem).attr('id', inputIdStr);
                                    $(inputElem).attr('name', inputIdStr);
                                }
                            });
                            }

                        }
                        //ui.item.find('.labelDiv').after('<span class="listName" style="display:none">' + sortableFieldClassName + ' ' + colorBar + '</span>');
                       // ui.item.find('.labelDiv label').first().after('<br/><span class="addObjName"><i>From : ' + addObjName + '</i></span>');
                        ui.item.attr('id', 'lblli' + elemIdWODot);
                        ui.item.addClass(sortableFieldClassName);
                        if (getSafeBoolean($(mainFieldElement).attr('data-isdefaultreq'), false)) {
                        $(mainFieldElement).attr('data-isrequired',true);
                            ui.item.find('.deleteField').remove();
                            ui.item.find('.labelDiv .ff-required-mark').remove();
                            ui.item.find('.labelDiv .ff-label').after($('<span/>',{'class':'ff-required-mark','html':'*'}));
                        }
                        if (ui.item.find('.labelDiv .ff-label').length > 0) {
                            ui.item.find('.labelDiv .ff-label').attr('ondblclick', "editFFLabel(this);");
                        }


                    }
                    var isPaymentField = false;
                    if (dropLiId == "lblliGENERALTEXT") {
                        var i = Math.floor((Math.random() * 1000) + 1);
                        dropLiId = dropLiId + i;
                        ui.item.attr('id', dropLiId);
                        ui.item.find('.labelDiv label').attr('id', 'lblGENERALTEXT' + i);
                        isGen = true;
                    }

                    if (dropLiId == "lblliIMAGE") {
                        var i = Math.floor((Math.random() * 1000) + 1);
                        dropLiId = dropLiId + i;
                        ui.item.attr('id', dropLiId);
                        ui.item.find('label').attr('id', 'lblIMAGE' + i);
                        ui.item.find('label').hide();
                        isGen = true;
                        ui.item.find('div:first').css('width', '100%');
                        ui.item.addClass('fieldLiImage');
                    }
                   dropLiId= safeLegacyPAYPALPAYMENT(dropLiId);
                    if (dropLiId == "lblliFASTFORMSPAYMENT") {

                        if (!onlyEnterpriseEdit) {
                            upgradeNowMessage('Payment fields are only available in the Enterprise edition of Fast Forms.', '', '');
                            deletePaymentFieldByParentFieldLi(ui.item,true);
                        }

                        if (onlyEnterpriseEdit) {
                            var i = Math.floor((Math.random() * 1000) + 1);
                            dropLiId = dropLiId + i;
                            ui.item.attr('id', dropLiId);
                            var originaldivId = ui.item.find('.field-div-payment').attr('id');
                            ui.item.find('.field-div-payment').attr('id', originaldivId + i);

                            $(ui.item.find('.payment-item-row')).each(function (index, ppitemrow) {

                                if ($(ppitemrow).hasClass('pp-expiry')) {

                                    var ppexpirylblid = $(ppitemrow).find('.PPGeneralLabelDiv label').attr('id');
                                    ppexpirylblid.replace(i, '');
                                    $(ppitemrow).find('.PPGeneralLabelDiv label').attr('id', ppexpirylblid + i);
                                    $($(ppitemrow).find('select')).each(function (index, ppitemrowselect) {
                                        var orginalselElemId = $(ppitemrowselect).attr('data-pp-name');
                                        $(ppitemrowselect).attr('id', orginalselElemId + i);
                                        $(ppitemrowselect).attr('name', orginalselElemId + i);
                                    });
                                }
                                else {
                                    var orginalElemId = $(ppitemrow).find('.PPGeneralFieldDiv input,.PPGeneralFieldDiv label.ff-label').attr('data-pp-name');
                                    orginalElemId = orginalElemId;
                                    $(ppitemrow).find('.PPGeneralFieldDiv input,.PPGeneralFieldDiv label.ff-label').attr('id', orginalElemId + i);
                                    $(ppitemrow).find('.PPGeneralFieldDiv input,.PPGeneralFieldDiv label.ff-label').attr('name', orginalElemId + i);
                                    $(ppitemrow).find('.PPGeneralLabelDiv label').attr('id', 'lbl' + orginalElemId + i);
                                }

                            });
                            isPaymentField = true;
                            isGen = true;
                        }
                    }

                    if (dropLiId == "lblliCAPTCHA") {
                        var i = Math.floor((Math.random() * 1000) + 1);
                        dropLiId = dropLiId + i;
                        ui.item.attr('id', dropLiId);
                        ui.item.find('.labelDiv label').attr('id', 'lblCAPTCHA' + i);
                        ui.item.find('.fieldDiv .ff-type-captcha').attr('id', 'Captcha' + i);
                        isGen = true;
                    }

                    if (dropLiId == "lblliFILEUPLOADAREA") {

                        if (!onlyProfEnterprise) {
                            upgradeNowMessage('File uploads are only available in Professional or Enterprise editions of Fast Forms.', '', '');
                            deleteFieldByParentFieldLi(ui.item,true);
                        }


                        if (onlyProfEnterprise) {
                            var i = Math.floor((Math.random() * 1000) + 1);
                            dropLiId = dropLiId + i;
                            ui.item.attr('id', dropLiId);


                            var fileIndxId = i;
                            var fieldElemDiv = ui.item.find('.fieldDiv');
                            ui.item.find('.labelDiv label.ff-label').attr('id', 'lblFileUpload' + fileIndxId);
                            fieldElemDiv.find('.ff-fileupload-drop-area').attr('id', 'FileUploadArea' + fileIndxId);  
                            fieldElemDiv.find('.ff-fileupload-drop-area label').attr('id', 'lblFileUpload' + fileIndxId + '_Select');
                            fieldElemDiv.find('.ff-fileupload-drop-area label').attr('name', 'FileUpload' + fileIndxId+ '_Select');
                             fieldElemDiv.find('.ff-fileupload-drop-area label').attr('for', 'FileUpload' + fileIndxId);
                            fieldElemDiv.find('.ff-fileupload-drop-area input').attr('id', 'FileUpload' + fileIndxId);
                            fieldElemDiv.find('.ff-fileupload-drop-area input').attr('name', 'FileUpload' + fileIndxId);
                            isGen = true;
                        }
                    }

                    if (/RecordTypeId/i.test(dropLiId)) {
                        ui.item.find('label').addClass('grayLabel');
                    }

                    var editDelDivHtml = '<div class="editDelDiv">';

                    if (ui.item.find('.deleteField').length == 0 && ui.item.find('.editImg').length == 0) {

                        if (isGen) {
                            if (isPaymentField) {
                                editDelDivHtml += '<img class="editImg" src="' + imgUrl + '" onclick="openEditPaymentDialog(this);" />';
                                editDelDivHtml += '<img id="' + dropLiId + '" src="' + deleteImgUrl + '" class="deleteField" onclick="deletePaymentField(this,true);"/>';
                            }
                            else if (isESignaturefield) {
                                editDelDivHtml += '<img class="editImg" src="' + imgUrl + '" onclick="openEditSignatureDialog(this);" />';
                                editDelDivHtml += '<img id="' + dropLiId + '" src="' + deleteImgUrl + '" class="deleteField" onclick="deleteSignatureField(this,true);"/>';
                            }
                            else {
                                editDelDivHtml += '<img class="editImg" src="' + imgUrl + '" onclick="openEditDialog(this,true);" />';
                                editDelDivHtml += '<img id="' + dropLiId + '" src="' + deleteImgUrl + '" class="deleteField" onclick="deleteField(this,true);"/>';
                            }
                        } else {
                            editDelDivHtml += '<img class="editImg" src="' + imgUrl + '" onclick="openEditDialog(this,true);" />';
                            editDelDivHtml += '<img id="' + ui.item.attr('id') + '" src="' + deleteImgUrl + '" class="deleteField" onclick="deleteField(this,true);"/>';
                        }
                    }
                    editDelDivHtml += '</div >';
                    if (isPaymentField) {
                    ui.item.find('.editDelDiv').remove();
                        ui.item.find('.field-div-payment').append(editDelDivHtml);
                    }
                    else if (isESignaturefield) {
                        if (!onlyEnterpriseEdit) {
                            upgradeNowMessage('Signature fields are only available in the Enterprise edition of Fast Forms.', '', '');
                            deleteFieldByParentFieldLi(ui.item,true);
                        }
                        if (onlyEnterpriseEdit) {
                            if (!isParentCanvas) {
                                var signatureIndex = Math.floor((Math.random() * 1000) + 1);
                                dropLiId = dropLiId + signatureIndex;
                                ui.item.attr('id', dropLiId);
                                var eSignatureId = dropLiId.replace('lblli', '');
                                ui.item.append(editDelDivHtml);
                                ui.item.find('.labelDiv').hide();
                                ui.item.find('.eSignatureFieldDiv').attr('id', 'field' + eSignatureId);
                                ui.item.find('.eSignatureFieldDiv .ffd-esignature-input').attr('id', 'input' + eSignatureId);
                                ui.item.find('.eSignatureFieldDiv').show();
                                ui.item.find('.eSignatureFieldDiv .ffd-esignature').show();
                                ui.item.find('.eSignatureFieldDiv .main-docsign-wrapper').attr('id', 'elem' + eSignatureId);
                                assignSignatureElementIds(ui.item, signatureIndex);

                                setDefaultSignatureElementValues(ui.item.find('.eSignatureFieldDiv .ffd-esignature-input'));
                                resetPDFRequiredOption(false);
                            }
                            resetESignatureElement(ui.item, false);
                        }
                    }
                    else {

                        if (ui.item.find('.labelDiv .ff-label').length > 0) {
                            ui.item.find('.labelDiv .ff-label').attr('ondblclick', "editFFLabel(this);");
                        }
                         if(!isParentCanvas)
                        {
                        ui.item.append(editDelDivHtml);
                        }
                    }
                    if(ui.item.find('.fieldDiv').find('>select,>input,input.ff-input-type,>textarea').length>0)
                    {
                    setCurrencyOrPercentLabels(ui.item.find('.fieldDiv').find('>select,>input,input.ff-input-type,>textarea'));
                    }
                    if(!isParentCanvas)
                    {
                    addRequiredOnLabel(ui.item);
                    }
                    if (isFirstTimeFormEdit == "true") {
                        $(".dragDropInfoDiv").hide();
                        $(".arrowUpper").hide();
                        $(".addNewSection").css('margin-top', '0%');
                    }

                    if (ui.item.parent().attr('id') == 'labelformUlForAddNewSection') {
                       
                        var bottomMostSection = $("#parentUlForm [id^='labelformUl']:not(#labelformUlForAddNewSection)").last();
                        $(bottomMostSection).append($("#labelformUlForAddNewSection").html());
                        $("#labelformUlForAddNewSection").html('');
                    }


                }
                //resetSavedButton();

                $(this).parent().find('.ui-sortable-placeholder').removeClass('addNewSectionIcon');
                $(this).parent().find('.ui-sortable-placeholder').css("visibility", "hidden");
                $(this).parent().find('.ui-sortable-placeholder').remove('plusIcon');
                setHover();
                mixpanel.track('Field added by drag', { "Field ID": dropLiId });
                var metadata = {
                    field_name: dropLiId
                };
                Intercom('trackEvent', 'added-field', metadata);
            }
            }/*isAllowed ends */
        },
        activate: function (event, ui) {
            console.log(' makeMultiFormSortable- ' + ui.item.attr('class'));
            ui.item.css('height', 'auto');

            //ui.item.addClass('grabCursor');
            //ui.item.removeAttr('style');
           // ui.item.show();
        },
        deactivate: function (event, ui) {
            resetSavedButton();
            $('#addSectionPlus').hide();

            ui.item.removeClass('grabCursor');
        },
        over: function (event, ui) {
        var isFieldGood=false;
        var isParentCanvas=false;
        if(ui.sender.hasClass('formFieldUl')){
        isParentCanvas=true;
        }
        //formSectionUl
        if(isParentCanvas){
        /*Source is Form Canvas*/
              if($(event.target).parents('.formSectionUl').attr('id')==ui.sender.parents('.formSectionUl').attr('id')){
              /*Same Section*/
              isFieldGood=true;
              }else if( ui.sender.parents('.formSectionUl').hasClass('section-repeat')){

              isFieldGood=false;
              }else if($(event.target).parents('.formSectionUl').hasClass('section-repeat')){
              isFieldGood=false;
              }else {
               
               isFieldGood=true;
              
              }
              if (!isFieldGood && $.inArray(safeStringValue($(ui.item).attr('data-otype'),''), availableGenFieldsInRepSecArr) < 0) {
              ui.helper.addClass('ui-restricted');
              ui.item.addClass('ui-restricted');
              }else{
              ui.helper.removeClass('ui-restricted');
              ui.item.removeClass('ui-restricted');
              }
         
        }else{
        /*if Source is available field list*/
            var senderUlId=ui.sender.attr('id');
            console.log('senderUlId '+senderUlId);
            if($(event.target).parents('.formSectionUl').find('li.fieldLi:not(.ui-sortable-placeholder)').length==0){
            if($('.formSectionUl.section-repeat[data-sortableclass="'+senderUlId+'"]').length>0){
            isFieldGood=false;
            console.log('Section repeat already exist');
            }else{
            isFieldGood=true;
            }
            }else{
            var targetSortableClass=$(event.target).parents('.formSectionUl').attr('data-sortableclass');
            if(targetSortableClass!==undefined && $(event.target).parents('.formSectionUl').hasClass('section-repeat') &&  ui.sender.parents('.list-toggle-div-wrap').hasClass('repeat') && ui.sender.attr('id')==targetSortableClass){
            isFieldGood=true;
            }else if(!$(event.target).parents('.formSectionUl').hasClass('section-repeat') &&  !(ui.sender.parents('.list-toggle-div-wrap').hasClass('repeat'))){
            isFieldGood=true;
            }else{
              
             if($(event.target).parents('.formSectionUl').find('li.fieldLi:not(.ui-sortable-placeholder)').length==0){
              isFieldGood=true;
             }else{
             isFieldGood=false;
             }
            }
            }
            if (!isFieldGood && $(event.target).parents('.formSectionUl').length>0 && $.inArray(safeStringValue($(ui.item).attr('data-otype'),''), availableGenFieldsInRepSecArr) < 0) {
            ui.helper.addClass('ui-restricted');
            ui.item.addClass('ui-restricted');
            }else{
            ui.helper.removeClass('ui-restricted');
            ui.item.removeClass('ui-restricted');
            }        
        }
        $(this).parent().find('.ui-sortable-placeholder').css("visibility", "visible");
        if (ui.helper.hasClass('ui-restricted')) {
        $(this).parent().find('.ui-sortable-placeholder').addClass('restricted-placeholder');
        }else{
         $(this).parent().find('.ui-sortable-placeholder').removeClass('restricted-placeholder');
        }
            

        }

    });
}
/**/
function setCurrencyOrPercentLabels(inputElement)
{
    var vatttype = $(inputElement).attr('vatt');
        if(!isNullOrEmpty(vatttype) && vatttype.indexOf('CURRENCY')>=0)
        {
        var currencylabel=$(inputElement).attr('data-currencylabel');
        if(isNullOrEmpty(currencylabel))
        {
        currencylabel='$';
        }
          $( inputElement).parents('.fieldDiv').prepend( "<div class='ff-currency'>"+currencylabel+"</>" );
        
        }
        else if(!isNullOrEmpty(vatttype) && vatttype.indexOf('PERCENT')>=0)
        {
          var percentlabel=$(inputElement).attr('data-percentlabel');
        if(isNullOrEmpty(percentlabel))
        {
        percentlabel='%';
        }
          $( inputElement).parents('.fieldDiv').append( "<div class='ff-percent'>"+percentlabel+"</>" );
        
        }
}
 
function resetMultiPageSortable(fmEditEnabled, onlyProfEnterprise, onlyEnterpriseEdit) {
    console.log('reset resetMultiPageSortable');
    var blockSort = false;
    $(".list-toggle-div .dropfields").sortable({
        connectWith: ".formFieldUl",
        dropOnEmpty: true,
        revert: 300,

        appendTo: document.body,
        helper: "clone",
        receive: function (event, ui) {
            var liId = ui.item.attr('id');
            if (getSafeBoolean($('#' + liId + ' .fieldDiv').find('>select,>input,input.ff-input-type,>textarea').attr('data-isdefaultreq'),false)) {
                /// deletefield method added to fix the issue drag and drop issue from main form to fields list [it was adding the dragged item to first list fields]- balinder

                $(this).sortable('cancel');
                $(ui.sender).sortable('cancel');
                showError("<div class='primary'>The field you are attempting to remove is a required field.</div> <br/> <br /><div class='secondary'>Required fields cannot be removed from your form.</div>");

            } else {
            console.log(' Item is removed from canvas');
                deleteFieldByParentFieldLi(ui.item,true);
            }


        },

        activate: function (event, ui) {
            ui.item.css('height', 'auto');
            ui.item.addClass('grabCursor');
        },
        deactivate: function (event, ui) {
            ui.item.removeClass('grabCursor');
        }
    });

    /* General Fields Sortable */
    var dropCount = 0;
    $('#generalSortableForFields.dropfields').sortable({
        connectWith: ".formFieldUl",
        helper: 'clone',        
        appendTo: document.body,
        stop: function (event, ui) {
            var $uiItem = $(ui.item);

            if ($uiItem.parent().is('#generalSortableForFields.dropfields')) $uiItem.remove();
            $('#generalFieldBox li').unbind('dblclick');
            $('#generalFieldBox li').dblclick(function () {

                resetSavedButton();
                var isPaymentField = false;
                var isESignaturefield = false;
                var litem = $(this).clone();
                litem = itemAdd(litem);

                var dropLiId = litem.attr('id');
          dropLiId= safeLegacyPAYPALPAYMENT(dropLiId);
                /*following line will append html item to the last section on form canvas */
               // litem.appendTo($("#parentUlForm li:nth-last-child(2) .mainTable tr td ul.formUlLabel"));
                var randomId = Math.floor((Math.random() * 1000) + 1);
                if (dropLiId == "lblliCAPTCHA") {

                    dropLiId = dropLiId + randomId;
                    litem.attr('id', dropLiId);
                    litem.find('label').attr('id', 'lblCAPTCHA' + randomId);
                    litem.find('.labelDiv label').attr('id', 'lblCAPTCHA' + randomId);
                    litem.find('.fieldDiv .ff-type-captcha').attr('id', 'Captcha' + randomId);
                    litem.find('.deleteField').attr('id', 'lblliCAPTCHA' + randomId);
                    litem.find('.fieldDiv').removeAttr('style');

                }
                else if (dropLiId == "lblliGENERALTEXT") {

                    dropLiId = dropLiId + randomId;
                    litem.attr('id', dropLiId);
                    litem.find('.labelDiv label').attr('id', 'lblGENERALTEXT' + randomId);
                    litem.find('.deleteField').attr('id', 'lblliGENERALTEXT' + randomId);

                }
                else if (dropLiId == "lblliIMAGE") {

                    dropLiId = dropLiId + randomId;
                    litem.attr('id', dropLiId);
                    litem.find('label').attr('id', 'lblIMAGE' + randomId);
                    litem.find('.deleteField').attr('id', 'lblliIMAGE' + randomId);
                    litem.find('label').hide();
                    litem.addClass('fieldLiImage');
                }
                else if (dropLiId !== undefined && dropLiId.indexOf('ESIGNATURE') > 0) {
                if (!onlyEnterpriseEdit) {
                 upgradeNowMessage('E-Signature fields are only available in the Enterprise edition of Fast Forms.', '', '');
                        deleteSignatureField(litem,true);
                       
                    }
                    else {
                    isESignaturefield = true;
                    signatureIndex = randomId;
                    dropLiId = dropLiId + signatureIndex;
                    litem.attr('id', dropLiId);
                    var eSignatureId = dropLiId.replace('lblli', '');

                    //litem.removeClass('grabCursor');
                    litem.addClass('generalSortableForFields');
                    litem.find('.ffd-esignature').html($('#DocSignHTMLTemp').html());
                    litem.find('.labelDiv').hide();
                    litem.find('.eSignatureFieldDiv').attr('id', 'field' + eSignatureId);
                    litem.find('.eSignatureFieldDiv .ffd-esignature-input').attr('id', 'input' + eSignatureId);
                    litem.find('.eSignatureFieldDiv').show();
                    litem.find('.eSignatureFieldDiv .ffd-esignature').show();
                    litem.find('.eSignatureFieldDiv .main-docsign-wrapper').attr('id', 'elem' + eSignatureId);
                    assignSignatureElementIds(litem, signatureIndex);

                    setDefaultSignatureElementValues(litem.find('.eSignatureFieldDiv .ffd-esignature-input'));
                    resetPDFRequiredOption(false);
                    resetESignatureElement(litem, false);
                    }
                }
                else if (dropLiId == "lblliFASTFORMSPAYMENT") {
                    if (!onlyEnterpriseEdit) {
                        upgradeNowMessage('Payment fields are only available in the Enterprise edition of Fast Forms.', '', '');
                        deletePaymentFieldByParentFieldLi(litem,true);
                    }
                    else {

                        isPaymentField = true;
                        var i = randomId;
                        dropLiId = dropLiId + i;
                        litem.attr('id', dropLiId);
                        var originaldivId = litem.find('.field-div-payment').attr('id');
                        litem.find('.field-div-payment').attr('id', originaldivId + i);
                        $(litem.find('.payment-item-row')).each(function (index, ppitemrow) {
                            if ($(ppitemrow).hasClass('pp-expiry')) {

                                var ppexpirylblid = $(ppitemrow).find('.PPGeneralLabelDiv label').attr('id');
                                ppexpirylblid.replace(i, '');
                                $(ppitemrow).find('.PPGeneralLabelDiv label').attr('id', ppexpirylblid + i);
                                $($(ppitemrow).find('select')).each(function (index, ppitemrowselect) {
                                    var orginalselElemId = $(ppitemrowselect).attr('data-pp-name');
                                    $(ppitemrowselect).attr('id', orginalselElemId + i);
                                    $(ppitemrowselect).attr('name', orginalselElemId + i);
                                });
                            }
                            else {
                                var orginalElemId = $(ppitemrow).find('.PPGeneralFieldDiv input,.PPGeneralFieldDiv label.ff-label').attr('data-pp-name');
                                orginalElemId = orginalElemId;
                                $(ppitemrow).find('.PPGeneralFieldDiv input,.PPGeneralFieldDiv label.ff-label').attr('id', orginalElemId + i);
                                $(ppitemrow).find('.PPGeneralFieldDiv input,.PPGeneralFieldDiv label.ff-label').attr('name', orginalElemId + i);
                                $(ppitemrow).find('.PPGeneralLabelDiv label').attr('id', 'lbl' + orginalElemId + i);
                            }

                        });
                        litem.find('.deleteField').attr('id', 'lblliFASTFORMSPAYMENT' + i);
                    }
                }


                if (dropLiId == "lblliFILEUPLOADAREA") {
                    var i = randomId;
                    dropLiId = dropLiId + i;
                    litem.attr('id', dropLiId);
                    if (!onlyProfEnterprise) {
                        upgradeNowMessage('File uploads are only available in Professional or Enterprise editions of Fast Forms.', '', '');
                        deleteFieldByParentFieldLi(litem,true);
                    } else {
                    var fileIndxId=randomId;
                     var fieldElemDiv=litem.find('.fieldDiv');
                        litem.find('.labelDiv label.ff-label').attr('id', 'lblFileUpload' + fileIndxId);;
                        fieldElemDiv.find('.ff-fileupload-drop-area label').attr('id', 'lblFileUpload' + fileIndxId+'_Select');
                        fieldElemDiv.find('.ff-fileupload-drop-area').attr('id', 'FileUploadArea' + fileIndxId);   
                                fieldElemDiv.find('.ff-fileupload-drop-area label').attr('name', 'FileUpload' + fileIndxId+ '_Select');
                             fieldElemDiv.find('.ff-fileupload-drop-area label').attr('for', 'FileUpload' + fileIndxId);
                                fieldElemDiv.find('.ff-fileupload-drop-area input').attr('id', 'FileUpload' + fileIndxId);
                                fieldElemDiv.find('.ff-fileupload-drop-area input').attr('name', 'FileUpload' + fileIndxId);
                    }

                }
                litem.addClass('generalSortableForFields');
                //litem.css('height','auto');
                litem.removeAttr('style');
                if (isPaymentField) {
                    litem.find('.editImg').attr('onclick', "openEditPaymentDialog(this);");

                }
                else if (isESignaturefield) {
                    litem.find('.editImg').attr('onclick', "openEditSignatureDialog(this);");
                    litem.find('.deleteField').attr('onclick', "deleteSignatureField(this,true);");

                }
                else {

                  
                    if(litem.find('.labelDiv .ff-label').length>0)
                            {
                              litem.find('.labelDiv .ff-label').attr('ondblclick', "editFFLabel(this);");
                            }
                    litem.find('.editImg').attr('onclick', "openEditDialog(this,true);");

                }
                 
                 addRequiredOnLabel(litem);
                 
                 
                setHover();
                mixpanel.track('Field added by double-click', { "Field ID": dropLiId });
                var metadata = {
                    field_name: dropLiId
                };
                Intercom('trackEvent', 'added-field', metadata);
                var lastFieldUlLiItem=$("#mainMultiPageWrapper .form-canvas-multi-page-inner .formSectionUl:last-child .formFieldUl").last();
                 if($(lastFieldUlLiItem).parents('.formSectionUl').hasClass('section-repeat') && $.inArray(safeStringValue($(litem).attr('data-otype'),''), availableGenFieldsInRepSecArr) < 0){
                 addNewSectionItem($(lastFieldUlLiItem).parents('.fc-multi-page-item').find('>.add-newsection-box>a'),false);
                  $("#mainMultiPageWrapper .form-canvas-multi-page-inner .formSectionUl:last-child .formFieldUl").last().append(litem); 
                 }else{
                   $(lastFieldUlLiItem).append(litem); 
                 } 
            });
            $("#generalSortableForFields > li").each(function () {
                if ($(this).html() == $(this).next().html()) {
                    $(this).remove();
                }
                else {
                    $(this).show();
                }
            });
            

        }
    });

    $('#generalSortableForFields.dropfields').bind('sortstart', function (event, ui) {
        var $uiItem = $(ui.item);
        $uiItem.clone().hide().insertBefore($uiItem);
    });
    $(".formFieldUl").bind('sortreceive', function () {
        blockSort = false;
    });
    var blockSortRequired = false;
   /* $("#sortableForRelFields1").bind('sortstop', function (e) {
        if (blockSort) {
            var selfId = $(this).attr('Id');
            if (selfId == 'sortableForRelFields1') {
                e.preventDefault();
            }
        }
        blockSort = true;
    });*/
    //Keep the editor hidden until the user selects an object in the 'Select Object' list
    if ($('[id$="mergeTypeSelect"]').val() != '')
        $('[id$="pb2"]').show();
    else
        $('[id$="pb2"]').hide();
 
    makeAllLiHeightEqual();
    /*addNewSectionLi();*/
    makeMultiPageFormSortable(fmEditEnabled, onlyProfEnterprise, onlyEnterpriseEdit);

    if (RunOnces == 0) {

        if (isSecNameElemExistsByIndex(0)) {
            console.log('First Related object added Secondary objects count-' + $(".ObjectName span.secName").length);
            setTitleSortable();

        }
        else {
            console.log('No Related object added');
            setTitleSortable();
        }

    }


    console.log(' RunOnces-' + RunOnces);
    //fieldsToggleBind  ();
    RunOnces++;

     
    var isAlreadyAdd = false;
    $('#generalFieldBox li').unbind('dblclick');
    $('#generalFieldBox li').dblclick(function () {
        resetSavedButton();
        var itemAllowedToAdd=true;
        var isPayAllowed=true;
        var isFileAllowed=true;
        var isSignAllowed=true;
        var litem = $(this).clone();

        litem = itemAdd(litem);
        isAlreadyAdd = true;
        var isPaymentField = false;
        var isESignaturefield = false;
        var randomId = Math.floor((Math.random() * 1000) + 1);
        /*following line will append html item to the last section on form canvas */
       
        var dropLiId = litem.attr('id');
    dropLiId= safeLegacyPAYPALPAYMENT(dropLiId);
        if (dropLiId == "lblliCAPTCHA") {

                    dropLiId = dropLiId + randomId;
                    litem.attr('id', dropLiId);
                    litem.find('label').attr('id', 'lblCAPTCHA' + randomId);
                    litem.find('.labelDiv label').attr('id', 'lblCAPTCHA' + randomId);
                    litem.find('.fieldDiv .ff-type-captcha').attr('id', 'Captcha' + randomId);
                    litem.find('.deleteField').attr('id', 'lblliCAPTCHA' + randomId);
                    litem.find('.fieldDiv').removeAttr('style');
        }
        else if (dropLiId == "lblliGENERALTEXT") {
                dropLiId = dropLiId + randomId;
                    litem.attr('id', dropLiId);
                    litem.find('.labelDiv label').attr('id', 'lblGENERALTEXT' + randomId);
                    litem.find('.deleteField').attr('id', 'lblliGENERALTEXT' + randomId);

        }
        else if (dropLiId == "lblliIMAGE") {

                    dropLiId = dropLiId + randomId;
                    litem.attr('id', dropLiId);
                    litem.find('label').attr('id', 'lblIMAGE' + randomId);
                    litem.find('.deleteField').attr('id', 'lblliIMAGE' + randomId);
                    litem.find('label').hide();
                    litem.addClass('fieldLiImage');
        }
        else if (dropLiId !== undefined && dropLiId.indexOf('ESIGNATURE') > 0) {
           if (!onlyEnterpriseEdit) { upgradeNowMessage('E-Signature fields are only available in the Enterprise edition of Fast Forms.', '', '');
                        
                        itemAllowedToAdd=false;
                    }
                    else {
            isESignaturefield = true;

            dropLiId = dropLiId + randomId;
            litem.attr('id', dropLiId);
            var eSignatureId = dropLiId.replace('lblli', '');
            var signatureIndex = randomId;
            //litem.removeClass('grabCursor');
            litem.addClass('generalSortableForFields');
            litem.find('.ffd-esignature').html($('#DocSignHTMLTemp').html());
            litem.find('.labelDiv').hide();
            litem.find('.eSignatureFieldDiv').attr('id', 'field' + eSignatureId);
            litem.find('.eSignatureFieldDiv .ffd-esignature-input').attr('id', 'input' + eSignatureId);
            litem.find('.eSignatureFieldDiv').show();
            litem.find('.eSignatureFieldDiv .ffd-esignature').show();
            litem.find('.eSignatureFieldDiv .main-docsign-wrapper').attr('id', eSignatureId);
            assignSignatureElementIds(litem, signatureIndex);

            setDefaultSignatureElementValues(litem.find('.eSignatureFieldDiv .ffd-esignature-input'));
            resetPDFRequiredOption(false);
            resetESignatureElement(litem, false);
            }
        }
        else if (dropLiId == "lblliFASTFORMSPAYMENT") {
             if (!onlyEnterpriseEdit) {
                        upgradeNowMessage('Payment fields are only available in the Enterprise edition of Fast Forms.', '', '');
                        
                        itemAllowedToAdd=false;
                    }
                    else {
            isPaymentField = true;

            var i = Math.floor((Math.random() * 1000) + 1);
            dropLiId = dropLiId + i;
            litem.attr('id', dropLiId);
            var originaldivId = litem.find('.field-div-payment').attr('id');
            litem.find('.field-div-payment').attr('id', originaldivId + i);
            $(litem.find('.payment-item-row')).each(function (index, ppitemrow) {

                if ($(ppitemrow).hasClass('pp-expiry')) {

                    var ppexpirylblid = $(ppitemrow).find('.PPGeneralLabelDiv label').attr('id');
                    ppexpirylblid.replace(i, '');
                    $(ppitemrow).find('.PPGeneralLabelDiv label').attr('id', ppexpirylblid + i);
                    $($(ppitemrow).find('select')).each(function (index, ppitemrowselect) {
                        var orginalselElemId = $(ppitemrowselect).attr('data-pp-name');
                        $(ppitemrowselect).attr('id', orginalselElemId + i);
                        $(ppitemrowselect).attr('name', orginalselElemId + i);
                    });
                }
                else {
                    var orginalElemId = $(ppitemrow).find('.PPGeneralFieldDiv input,.PPGeneralFieldDiv label.ff-label').attr('data-pp-name');
                    orginalElemId = orginalElemId;
                    $(ppitemrow).find('.PPGeneralFieldDiv input,.PPGeneralFieldDiv label.ff-label').attr('id', orginalElemId + i);
                    $(ppitemrow).find('.PPGeneralFieldDiv input,.PPGeneralFieldDiv label.ff-label').attr('name', orginalElemId + i);
                    $(ppitemrow).find('.PPGeneralLabelDiv label').attr('id', 'lbl' + orginalElemId + i);
                }
            });
            litem.find('.deleteField').attr('id', 'lblliFASTFORMSPAYMENT' + i);
            }

        }
        else if (dropLiId == "lblliFILEUPLOADAREA") {
                    var i = randomId;
                    dropLiId = dropLiId + i;
                    litem.attr('id', dropLiId);
                    if (!onlyProfEnterprise) {
                        upgradeNowMessage('File uploads are only available in Professional or Enterprise editions of Fast Forms.', '', '');
                        deleteFieldByParentFieldLi(litem,true);
                        itemAllowedToAdd=false;
                    } else {
                    var fileIndxId=randomId;
                     var fieldElemDiv=litem.find('.fieldDiv');
                        litem.find('.labelDiv label.ff-label').attr('id', 'lblFileUpload' + fileIndxId);;
                        fieldElemDiv.find('.ff-fileupload-drop-area label').attr('id', 'lblFileUpload' + fileIndxId+'_Select');
                        fieldElemDiv.find('.ff-fileupload-drop-area').attr('id', 'FileUploadArea' + fileIndxId);  
                                //fieldElemDiv.find('.ff-fileupload-drop-area label').attr('name', 'FileUpload' + fileIndxId);
                                fieldElemDiv.find('.ff-fileupload-drop-area label').attr('name', 'FileUpload' + fileIndxId+ '_Select');
                             fieldElemDiv.find('.ff-fileupload-drop-area label').attr('for', 'FileUpload' + fileIndxId);
                                fieldElemDiv.find('.ff-fileupload-drop-area input').attr('id', 'FileUpload' + fileIndxId);
                                fieldElemDiv.find('.ff-fileupload-drop-area input').attr('name', 'FileUpload' + fileIndxId);
                    }

                }
        //litem.css('height','auto');
        litem.addClass('generalSortableForFields');
        litem.addClass('grabCursor');
        if (isPaymentField) {

            litem.find('.editImg').attr('onclick', "openEditPaymentDialog(this);");
        } else if (isESignaturefield) {
            litem.find('.editImg').attr('onclick', "openEditSignatureDialog(this);");
            litem.find('.deleteField').attr('onclick', "deleteSignatureField(this,true);");

        }
        else {

            // litem.attr('ondblclick' , "editFFLabel('"+ litem.attr('id')+"');");                
           if(litem.find('.labelDiv .ff-label').length>0)
                            {
                              litem.find('.labelDiv .ff-label').attr('ondblclick', "editFFLabel(this);");
                            }
            litem.find('.editImg').attr('onclick', "openEditDialog(this,true);");
        }
        addRequiredOnLabel(litem);
         if(itemAllowedToAdd){
         
         //$("#mainMultiPageWrapper .form-canvas-multi-page-inner .formSectionUl:last-child .formFieldUl").last().append(litem); 
         var lastFieldUlLiItem=$("#mainMultiPageWrapper .form-canvas-multi-page-inner .formSectionUl:last-child .formFieldUl").last();
         if($(lastFieldUlLiItem).parents('.formSectionUl').hasClass('section-repeat') && $.inArray(safeStringValue($(litem).attr('data-otype'),''), availableGenFieldsInRepSecArr) < 0){
         addNewSectionItem($(lastFieldUlLiItem).parents('.fc-multi-page-item').find('>.add-newsection-box>a'),false);
          $("#mainMultiPageWrapper .form-canvas-multi-page-inner .formSectionUl:last-child .formFieldUl").last().append(litem); 
         }else{
           $(lastFieldUlLiItem).append(litem); 
         }
        setHover();
        }
    });
    activeClick();
    var sectionLabel = $('.sectionLi').find('label.ff-section-header');
    if (sectionLabel !== undefined) {
        $(sectionLabel).unbind('dblclick');
        $(sectionLabel).dblclick(function () {
             

            editFFSection(this);

        });
    }

}
function nextSectionItemCounter(){
                 var  numberofsections=0;
                 var sectionIdArray=[];
                 $("#multiPageUlForm label.ff-section-header").each(function(indx,sectionLabel) {
        var sectionId=$(sectionLabel).attr('id');
        if(!isNullOrEmpty(sectionId))
        {
        sectionId=sectionId.replace(/sectionFFLabel/g,'');
        sectionId=sectionId.replace(/sectionLabel/g,'');
        if(!isNullOrEmpty(sectionId)){
         sectionIdArray.push(parseInt(sectionId));
        }
        }
        numberofsections++;
        console.log(' numberofsections '+numberofsections);
});
                //if there were multiple sections created previously,
                //this ID might already be in use
                //let's continue to add until we get another one
                 while( jQuery.inArray( numberofsections, sectionIdArray )>=0 ){
                        numberofsections++;
                 }
                
                 return numberofsections;
}
function nextPageItemCounter(){
                 var  numberofpages=0;
                 var pageIdArray=[];
                 $("#multiPageUlForm label.ff-page-header").each(function(indx,pageLabel) {
        var pageLabelId=$(pageLabel).attr('id');
        if(!isNullOrEmpty(pageLabelId))
        {
        pageLabelId=pageLabelId.replace('pageFFLabel','');
        if(!isNullOrEmpty(pageLabelId)){
         pageIdArray.push(pageLabelId);
        }
        }
        numberofpages++;
        console.log(' numberofsections '+numberofpages);
});
                //if there were multiple sections created previously,
                //this ID might already be in use
                //let's continue to add until we get another one
                 while( jQuery.inArray( pageIdArray, sectionIdArray )>=0 ){
                        numberofpages+=1;
                 }
                
                 return numberofpages;
}
function addNewSectionItem(elemSource,isAutoSave){
                        
                          
                        var idCounter=nextSectionItemCounter();          
                        var liId = idCounter+ 'sortableForLabelli';
                         
                         var pageMainElem=$(elemSource).parents('.fc-multi-page-item');

                        var ulHtml = $('<div/>').html($('#pageNewSectionTEMP').html());
                        ulHtml.find('>ul.formSectionUl').attr('id','labelSectionformUl'+idCounter);
                        ulHtml.find('>ul>li.sectionLi').attr('id','sortableForSectionLabelli'+idCounter);
                        ulHtml.find('>ul>li>label.ff-section-header').attr('id','sectionLabel'+idCounter);

                       $(pageMainElem).find('.formSectionUlWrap').append(ulHtml.html());
                        makeSectionsSortable(); 
                        resetMultiPageSortableCall();           
                        if(isAutoSave)
                            {
                             isChangesMadeInForm = true;
                             autosaveTriggered();
                             }
}
function addNewRepeatableSectionItem(elemSource,isAutoSave){
                        
                          
                        var idCounter=nextSectionItemCounter();          
                        var liId = idCounter+ 'sortableForLabelli';
                         
                         var pageMainElem=$(elemSource).parents('.fc-multi-page-item');

                        var ulHtml = $('<div/>').html($('#pageNewSectionTEMP').html());
                        ulHtml.addClass('section-repeat');
                        ulHtml.find('>ul.formSectionUl').attr('id','labelSectionformUl'+idCounter);
                        ulHtml.find('>ul>li.sectionLi').attr('id','sortableForSectionLabelli'+idCounter);
                        ulHtml.find('>ul>li>label.ff-section-header').attr('id','sectionLabel'+idCounter);

                       $(pageMainElem).find('.formSectionUlWrap').append(ulHtml.html());
                        makeSectionsSortable(); 
                        resetMultiPageSortableCall();           
                        if(isAutoSave)
                            {
                             isChangesMadeInForm = true;
                             autosaveTriggered();
                             }
}

function makeSectionsSortable() {
    $(".formSectionUlWrap").sortable({
        dropOnEmpty: true,
        revert: 300,
        zIndex: 9999,
        placeholder: "sortable-section-placeholder",
        connectWith: ".formSectionUlWrap",
        items: 'ul.formSectionUl',
        cancel: "select,option,textarea,input,.isFieldEdit,.editDelDiv,.editImg, .deleteField",
        update: function (event, ui) {
        isChangesMadeInForm = true;

        },
        activate: function (event, ui) {
            ui.item.css('height', 'auto');
            ui.item.addClass('grabCursor');
            ui.item.show();
        },
        deactivate: function (event, ui) {
            ui.item.removeClass('grabCursor');
        }

    });


}
function makePagesSortable() {
    $(".form-canvas-multi-page-inner").sortable({
        dropOnEmpty: true,
        revert: 300,
        zIndex: 9999,
        placeholder: "sortable-page-placeholder",
        connectWith: ".form-canvas-multi-page-inner",
        items: 'div.fc-multi-page-item',

        cancel: ".ui-page-state-disabled",
         receive: function(ev, ui) {
        if(!(ui.item.hasClass("hide-visibility")))
          {ui.sender.sortable("cancel");}
    },
        stop: function(ev, ui) {
            if (!(ui.item.hasClass('hide-visibility'))) {
                $(this).sortable('cancel');
            }
            else{
            refreshAddNewPagesLink();
            }
        },
        activate: function (event, ui) {
            ui.item.css('height', 'auto');
            ui.item.addClass('grabCursor');
            ui.item.show();
        },
        deactivate: function (event, ui) {
            ui.item.removeClass('grabCursor');
        }

    });
    $('.form-canvas-multi-page-inner').bind('sortstart', function(event, ui) {


     var prevElemSame=isPlaceholderElemIsSame($('.sortable-page-placeholder').prev(),ui.item)
     var nextElemSame=isPlaceholderElemIsSame($('.sortable-page-placeholder').next(),ui.item);
     
        if(prevElemSame && $('.sortable-page-placeholder').prev().hasClass('fc-multi-page-item'))
        {
         $('.sortable-page-placeholder').html('<span class="vert-line-prev">move here</span>');
        }
        else if(nextElemSame && $('.sortable-page-placeholder').next().hasClass('fc-multi-page-item')){
         $('.sortable-page-placeholder').html('<span class="vert-line-next">move here</span>');
        }
         
        
    });


}
function isPlaceholderElemIsSame(sourceElem,uiItem)
{
var returnFlag=false;
if(sourceElem.length>0 && uiItem.length>0  && sourceElem[0]==uiItem[0])
   {
returnFlag=true;
   }
   return returnFlag;
}
function toggleSortableOption(disbleDragNDrop){
    
    $(".formFieldUl").sortable("option", "disabled", disbleDragNDrop);
    $(".formSectionUlWrap").sortable("option", "disabled", disbleDragNDrop);
    $("#multiPageUlForm").sortable("option", "disabled", disbleDragNDrop);
    
}

function addRequiredOnLabel(elemSourceFieldLi){
                
                                if($(elemSourceFieldLi).hasClass('lbl') == false){
                                        var lblLiId =  $(elemSourceFieldLi).attr('id');
                                        
                                        var isRequired =false;
                                        if($(elemSourceFieldLi).find('.labelDiv>label.ff-label').attr('id')!==undefined)
                                        {
                                          
                                         
                                        var defreq= getSafeBoolean($(elemSourceFieldLi).find('.fieldDiv').find('>select,>input,input.ff-input-type,>textarea').attr('data-isdefualtreq'), false);
                                        var userreq= getSafeBoolean($(elemSourceFieldLi).find('.fieldDiv').find('>select,>input,input.ff-input-type,>textarea').attr('data-isuserreq'), false);
                                        isRequired=defreq;
                                            if(userreq)
                                            {
                                            isRequired=defreq;
                                            }
                                        }
                                        var isPaymentField=false;
                                        if(lblLiId.indexOf('FASTFORMSPAYMENT')>0)
                                        {
                                        isPaymentField=true;
                                        }
                                        var isSignatureField=false;
                                        if(lblLiId.indexOf('ESIGNATURE')>0)
                                        {

                                        isSignatureField=true;
                                        }
                                        //Required Label Add onload                       
                                             if(!isPaymentField && !isSignatureField)
                                                { 
                                                   
                                                  $(elemSourceFieldLi).find('.labelDiv .ff-required-mark').remove();
                                                }
                                                                                            

                                         if(lblLiId.indexOf('lblliCAPTCHA')>= 0){
                                                $(elemSourceFieldLi).find('.labelDiv>label.ff-label').after('<span class="ff-required-mark"  >*</span>');
                                        }
                                        else if(lblLiId.indexOf('lblliFileUploadArea')>= 0){
                                        var fieldUploadDiv=  $(elemSourceFieldLi).find('.fieldDiv .ff-fileupload-drop-area');
                                         if($(fieldUploadDiv).attr('data-isrequired') || $(fieldUploadDiv).attr('data-isrequired')=='true'){
                                                $(elemSourceFieldLi).find('.labelDiv>label.ff-label').after('<span class="ff-required-mark"  >*</span>');
                                        }                      
                                        else if($(fieldUploadDiv).attr('data-isrequired') == false || $(fieldUploadDiv).attr('data-isrequired') == "false"){
                                                $(elemSourceFieldLi).find('.labelDiv .ff-required-mark').remove();
                                        }
                                        } 
                                        else if(isRequired == "true" || isRequired == true) {
                                                $(elemSourceFieldLi).find('.labelDiv>label.ff-label').after('<span class="ff-required-mark"  >*</span>');
                                        }
                                            if(isPaymentField)
                                            {
                                                var ispaymentreq=false;
                                                if($(elemSourceFieldLi).find('.field-div-payment').attr('data-paymentrequired'))
                                                {
                                                        ispaymentreq=true;
                                                }
                                                $($(elemSourceFieldLi).find('.payment-item-row')).each(function(i, ppitemrow) {
                                                $(ppitemrow).find('label.ff-required-mark').remove();
                                                        var isdatarequired=$(ppitemrow).find('.PPGeneralFieldDiv input,.PPGeneralFieldDiv select').attr('data-isrequired');
                                                        if(isdatarequired!==undefined && ispaymentreq &&  (isdatarequired == "true" || isdatarequired == true ))
                                                        {
                                                            if($(ppitemrow).find('span.requiredSpan').length<1)
                                                            {
                                                                $(ppitemrow).find('label.ff-label').after('<span class="ff-required-mark"  >*</span>');
                                                             }
                                                        }
                                                        
                                                });  
                                         }             
                                }
                                   
                }

function updateDefaultConfig(elemFieldLi,isAutoSave) {
    /**/
    var fieldLabelHtml = $('#defaultLabel').val();
    $("#tempBlockQuotesHide").html(fieldLabelHtml);
    $("blockquote").contents().unwrap();
    fieldLabelHtml = $("#tempBlockQuotesHide").html();
    var liId = $(elemFieldLi).attr('id');
    $("#labelDiv").html(fieldLabelHtml);
    if ($("#labelDiv").has("h1,h2,h3").length) {
        if ($("#labelDiv").find("h1,h2,h3").attr('align') != undefined)
            $(elemFieldLi).css("text-align", $("#labelDiv").find("h1,h2,h3").attr('align'));
        else if ($("#labelDiv").find("h1,h2,h3").css('text-align') != "undefined")
            $(elemFieldLi).css("text-align", $("#labelDiv").find("h1,h2,h3").css('text-align'));
    } else {
        $(elemFieldLi).css("text-align", '');
    }
    /*lblliIMAGE check added to fix #190 issue on Sep 17 2015*/
    if (!(/lblliIMAGE/i.test(liId)) && (fieldLabelHtml == "" || fieldLabelHtml == "<br>" || fieldLabelHtml == "Please enter a label.")) {

        isFFValid = false; 
    } else if (/lblUPLOAD/i.test(liId)) {
        if ($('#selectedfiletypes').val() == '' || $("#limitValue").val() == '') {
            isFFValid = false; 
        }
    } else {
         
         
        if ($("#hiddenLiId").val() != "")   {
            if (/lblliFILEUPLOADAREA/i.test(liId)) {
                
                var fieldElemDiv = $(elemFieldLi).find('.fieldDiv');
                var labelElemDiv = $(elemFieldLi).find('.labelDiv');
          
             $(labelElemDiv).find('.ff-required-mark').remove();
             if ($('#requiredChk').prop("checked"))
                {  
                 $(labelElemDiv).find('.ff-label').after($('<span/>',{'class':'ff-required-mark','html':'*'}));
                 }
                fieldElemDiv.find('.ff-fileupload-drop-area').attr('data-requiredmessage', $("#errMsgForRequiredField").val());
                fieldElemDiv.find('.ff-fileupload-drop-area').attr('data-isrequired', $('#requiredChk').prop("checked")); 
                fieldElemDiv.find('.ff-fileupload-drop-area').attr('data-maxfiles', $("#limitValue").val());
                fieldElemDiv.find('.ff-fileupload-drop-area').attr('data-allowedfiletypes', $("#selectedfiletypes").val());
                fieldElemDiv.find('.ff-fileupload-drop-area').attr('data-uploadtochatter', $('#chkUploadToChatter').prop("checked"));
                fieldElemDiv.find('.ff-fileupload-drop-area').attr('data-attachto', safeStringValue($('#ddlObjListForAttachment').val(),1));
                var filename=$('#ffFileName').val();
                                if(!isNullOrEmpty(filename)){
                                filename=filename.replace(/'/g,"&#39;");
                                filename=filename.replace(/"/g,"&quot;");
                               fieldElemDiv.find('.ff-fileupload-drop-area').attr('data-filename', filename); 
                                }

            } else if (/lblliIMAGE/i.test(liId)) {
                
                var imgAlignment = $("#ddlImageAlignment").val();
                var labelElemDiv = $(elemFieldLi).find('.labelDiv');
                if (!isNullOrEmpty(imgAlignment)) {
                    labelElemDiv.find('.imageGeneralFieldDiv').attr('style', 'text-align:' + imgAlignment);
                }
                labelElemDiv.find('.ffse-img-upload-placeholder-editor img').attr('width', $("#imgWidthValue").val());
                labelElemDiv.find('.ffse-img-upload-placeholder-editor img').attr('height', $("#imgHeightValue").val()); 
                labelElemDiv.find('.ffse-img-upload-placeholder-editor img').attr('alt', $("#imgAltTag").val()); 
            }
            else if ($(elemFieldLi).find('.fieldDiv').find('>select,>input,input.ff-input-type,>textarea').length>0)
            {
            
            $(elemFieldLi).find('.labelDiv .ff-label').html(fieldLabelHtml);
             
            var defaultValue, upsertValue;
            if ($('#defaultValue').attr('type') == 'checkbox') {
                defaultValue = $('#defaultValue').prop('checked');
            } else if ($('#defaultValue').attr('multiple') == 'multiple' && $('#defaultValue').val() != '' && $('#defaultValue').val() != null) {
                defaultValue = $('#defaultValue').val();
            } else {
                defaultValue = $('#defaultValue').val();
            }
            if ($('#upsertField').attr('type') == 'checkbox') {
                upsertValue = $('#upsertField').prop('checked');
            } else {
                upsertValue = $('#upsertField').val();
            }
           var mainFieldElement= $(elemFieldLi).find('.fieldDiv').find('>select,>input,input.ff-input-type,>textarea');//.attr('data-isuserreq'), false);
            var labelElemDiv = $(elemFieldLi).find('.labelDiv');
          
             $(labelElemDiv).find('.ff-required-mark').remove();
             
            $(mainFieldElement).each(function (indx, inputElem) {
                if ($(inputElem).attr('type')== 'hidden') {
                   // $(inputElem).attr('id', finalElemId + 'hidden');
                   // $(inputElem).attr('name', finalElemId + 'hidden');
                }
                else{
                $(labelElemDiv).find('.ff-required-mark').remove();
                $(inputElem).attr('placeholder',$('#placeholderText').val());
                $(inputElem).attr('data-requiredmessage', $('#errMsgForRequiredField').val());
                $(inputElem).attr('data-isdefaultreq', $('#requiredChk').prop("disabled"));
                $(inputElem).attr('data-isuserreq', $('#requiredChk').prop("checked"));
                if ($('#requiredChk').prop("checked"))
                { $(inputElem).attr('data-isrequired', true);
                 $(labelElemDiv).find('.ff-label').after($('<span/>',{'class':'ff-required-mark','html':'*'}));
                 }
                else {
                 $(inputElem).attr('data-isrequired', false); }
                $(inputElem).attr('data-isupsert', upsertValue);
                $(inputElem).attr('data-ishidden', $('#hideField').prop("checked"));
                $(inputElem).attr('data-isreadonly', $('#readOnlyField').prop("checked"));
                 }
            });


            if ($(elemFieldLi).find('.fieldDiv > input[type="checkbox"]').length > 0) {
                if (defaultValue == 'true' || defaultValue) {
                    $(elemFieldLi).find('.fieldDiv > input[type="checkbox"]').attr('checked', 'checked');
                }
                else { $(elemFieldLi).find('.fieldDiv > input[type="checkbox"]').removeAttr('checked'); }
            }
            else if ($(elemFieldLi).find('.fieldDiv > select').length > 0) {
            var selectElement= $(elemFieldLi).find('.fieldDiv > select');
                if(defaultValue instanceof Array && defaultValue.length>0)
                {
                    $.each( defaultValue, function( key, value ) {
                        $(selectElement).find('option[value="'+value+'"]').attr('selected','selected');
                    });
                }
                else
                {
                    $(selectElement).find('option[value="'+defaultValue+'"]').attr('selected','selected');
                }
        } else if ($(elemFieldLi).find('.fieldDiv > textarea').length > 0) {
            $(elemFieldLi).find('.fieldDiv > textarea').text(defaultValue);
        } else if ($(elemFieldLi).find('.fieldDiv .lookupInput > input[type="hidden"]').length > 0) {
            $(elemFieldLi).find('.fieldDiv .lookupInput > input[type="hidden"]').attr('value', $('#defaultValueHidden').val());
            $(elemFieldLi).find('.fieldDiv .lookupInput > input[type="textbox"]').attr('value', defaultValue);
            } else {
            if ($(elemFieldLi).find('.fieldDiv > input[type="hidden"]').length > 0) {
                $(elemFieldLi).find('.fieldDiv > input[type="hidden"]').attr('value', $('#defaultValueHidden').val());

                $(elemFieldLi).find('.fieldDiv > input[type="textbox"]').attr('value', defaultValue);
            }
            }
             
        }
           
           
        }

        if(isAutoSave){
         isChangesMadeInForm=true;
         }
    } 
}
function togglePageBlock(elemSource){
    togglePageBlockElement(elemSource,false);
}
function expandFirstPage()
{
   
      $('#mainMultiPageWrapper').find('.fc-multi-page-item').each(function(indx,pageElementMain){
      if(indx==0)
      {
       $(pageElementMain).find('.Ulbtn').slideDown('300');
       $(pageElementMain).find('.formPageUl').slideDown('300');
       $(pageElementMain).removeClass('hide-visibility');
       if(!$(pageElementMain).hasClass('ui-page-state-disabled')){
       $(pageElementMain).addClass('ui-page-state-disabled');
       }
      }
      else{
      $(pageElementMain).find('.Ulbtn').slideUp('300');
       $(pageElementMain).find('.formPageUl').slideUp('300');
       $(pageElementMain).addClass('hide-visibility');
       $(pageElementMain).removeClass('ui-page-state-disabled');
        var pagetitle=  $(pageElementMain).find('.ff-page-header').html();
       if(!isNullOrEmpty(pagetitle))
       {
       
      $(pageElementMain).find('.ff-page-info .ff-page-title').html(pagetitle);
       
      }

      }
      });

}
function togglePageBlockElement(elemSource,firstChild)
{
 var collapsePageDiv=false;
    if(!firstChild && !$(elemSource).parents('.fc-multi-page-item').hasClass('hide-visibility'))
    {
    collapsePageDiv=true;
    }

    if(firstChild)
    {
    $('#mainMultiPageWrapper').find('.fc-multi-page-item:first-child').removeClass('hide-visibility');
    $('#mainMultiPageWrapper').find('.fc-multi-page-item:first-child').addClass('ui-page-state-disabled');
    $('#mainMultiPageWrapper').find('.fc-multi-page-item:first-child').find('.Ulbtn').slideDown('300');
    $('#mainMultiPageWrapper').find('.fc-multi-page-item:first-child').find('.formPageUl').slideDown('300');
    }
    else
    {
     if(collapsePageDiv)
      {
        
       $(elemSource).parents('.fc-multi-page-item').find('.Ulbtn').slideUp('300');
       $(elemSource).parents('.fc-multi-page-item').find('.formPageUl').slideUp('300');
       $(elemSource).parents('.fc-multi-page-item').addClass('hide-visibility');
       $(elemSource).parents('.fc-multi-page-item').removeClass('ui-page-state-disabled');
       var pagetitle=  $(elemSource).parents('.fc-multi-page-item').find('.ff-page-header').html();
       if(!isNullOrEmpty(pagetitle))
       {
       
      $(elemSource).parents('.fc-multi-page-item').find('.ff-page-info .ff-page-title').html(pagetitle);
       
      }
      }
      else
      {
       $(elemSource).parents('.fc-multi-page-item').removeClass('hide-visibility');
       $(elemSource).parents('.fc-multi-page-item').addClass('ui-page-state-disabled');
       $(elemSource).parents('.fc-multi-page-item').find('.Ulbtn').slideDown('300');
       $(elemSource).parents('.fc-multi-page-item').find('.formPageUl').slideDown('300');
        
        
      }
    }

}
function refreshAddNewPagesLink()
{
   var pageDiv= $('<div/>').html($('#pageAddNewTEMP').html());
    $('#mainMultiPageWrapper').find('.form-canvas-multi-page-inner .add-newpage-box').remove();
    var totalPages=$('#mainMultiPageWrapper').find('.form-canvas-multi-page-inner .fc-multi-page-item').length;
    $('#mainMultiPageWrapper').find('.form-canvas-multi-page-inner .fc-multi-page-item').each(function(indx,pageElem){
      if(indx<(totalPages-1))
      {
         $(pageElem).after(pageDiv.html());
      }
    });
    refreshPagesOrder();   
}
