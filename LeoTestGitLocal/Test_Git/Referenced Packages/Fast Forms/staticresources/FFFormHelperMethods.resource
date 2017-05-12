// JavaScript source code
function getFFPageXML(formPageUlElem, pageOrder) {
    var pageLabel = $(formPageUlElem).find(">li.pageLi .ff-page-header");
    var returnXML = '';
    returnXML += '<ffPage>';

    returnXML += '<name>' + safeHTMLValue($(pageLabel).html(), "", true) + '</name>';
    returnXML += '<pageOrder>' + pageOrder + '</pageOrder>';
    returnXML += '<isHidden>' + getSafeBoolean($(formPageUlElem).attr('data-ishidden'), false) + '</isHidden>';
    returnXML += '<pageId>' + safeStringValue($(pageLabel).attr("id"), "") + '</pageId>';
    var sectionElementXML = '';
    $(formPageUlElem).find(">li.formSectionUlWrap  .formSectionUl").each(function (sectionIndx, formSectionUlElem) {
        sectionElementXML += getFFOSectionXML(formSectionUlElem, sectionIndx);
    });
    returnXML += '<sectionList>';
    if (!isNullOrEmpty(sectionElementXML)) {
        returnXML += sectionElementXML;
    }
    returnXML += '</sectionList>';
    returnXML += '</ffPage>';
    return returnXML;
}
function getFFOSectionXML(formSectionUlElem, sectionOrder) {
 
    var sectionLabel = $(formSectionUlElem).find(">li.sectionLi .ff-section-header");
    var returnXML = '';
    returnXML += '<OSection>';
    returnXML += '<name>' + safeHTMLValue($(sectionLabel).html(), "", true) + '</name>';
    returnXML += '<sectionOrder>' + sectionOrder + '</sectionOrder>';
    returnXML += '<isHidden>' + getSafeBoolean($(formSectionUlElem).attr('data-ishidden'), false) + '</isHidden>';   
    var isSectionRepeat=getSafeBoolean($(formSectionUlElem).hasClass('section-repeat'), false);
    returnXML += '<repeat>' + isSectionRepeat + '</repeat>';
    if(isSectionRepeat){    
     returnXML += '<addLink>' + safeStringValue($(formSectionUlElem).attr('data-add-link'),"") + '</addLink>';
     returnXML += '<removeLink>' + safeStringValue($(formSectionUlElem).attr('data-remove-link'),"") + '</removeLink>';
     returnXML += '<minCount>' + safeStringValue($(formSectionUlElem).attr('data-min-count'),"") + '</minCount>';
     returnXML += '<maxCount>' + safeStringValue($(formSectionUlElem).attr('data-max-count'),"") + '</maxCount>';
     }
    returnXML += '<sectionId>' + safeStringValue($(sectionLabel).attr("id"), "") + '</sectionId>';
    //OLookup,OMultiPicklist,OSinglePicklist,OCurrency,ONumeric,OSField,OGeneralText,OCaptcha,OFileUpload,OImage,OPayPalPayment,OESignature 
    var fieldElementXML = '';
    $(formSectionUlElem).find(">li.formFieldUlWrap  .formFieldUl>.fieldLi").each(function (indx, fieldLiElement) {
        var elemType = safeStringValue($(fieldLiElement).attr('data-otype'), '');
        switch (elemType) {
            case 'OLookup':
                fieldElementXML += getFFOLookupXML(fieldLiElement);
                break;
            case 'OMultiPicklist':
                fieldElementXML += getFFOMultiPicklistXML(fieldLiElement);
                break;
            case 'OSinglePicklist':
                fieldElementXML += getFFOSinglePicklistXML(fieldLiElement);
                break;
            case 'OCurrency':
                fieldElementXML += getFFOCurrencyXML(fieldLiElement);
                break;
            case 'ONumeric':
                fieldElementXML += getFFONumericXML(fieldLiElement);
                break;
            case 'OSField':
                fieldElementXML += getFFOSFieldXML(fieldLiElement);
                break;
            case 'OGeneralText':
                fieldElementXML += getFFOGeneralTextXML(fieldLiElement);
                break;
            case 'OCaptcha':
                fieldElementXML += getFFOCaptchaXML(fieldLiElement);
                break;
            case 'OFileUpload':
                fieldElementXML += getFFOFileUploadXML(fieldLiElement);
                break;
            case 'OImage':
                fieldElementXML += getFFOImageXML(fieldLiElement);
                break;
            case 'OPayPalPayment':
            case 'OiATSPayment':
            case 'OStripePayment':
            case 'OAuthorizeNetPayment':
                fieldElementXML += getFFPaymentXML(fieldLiElement,elemType);
                break;
            case 'OESignature':
                fieldElementXML += getFFOESignatureXML(fieldLiElement);
                break;

            default:
        }
    });
    returnXML += '<fieldList>';
    if (!isNullOrEmpty(fieldElementXML)) {
        returnXML += fieldElementXML;
    }
    returnXML += '</fieldList>';
    returnXML += '</OSection>';
    return returnXML;
}
function getFFOSFieldXML(fieldLiElement) {
    var labelElem = $(fieldLiElement).find('.labelDiv label.ff-label');
    var inputElem = $(fieldLiElement).find('.fieldDiv input,textarea');
    var elementId = $(inputElem).attr('id');
    var colorCode = safeStringValue($(fieldLiElement).find('.labelDiv .obj-info').attr('data-colorcode'), "");
    var listname = safeStringValue($(fieldLiElement).find('.labelDiv .obj-info').attr('data-listname'), "");
    var objectType = '';
    var objectName = '';
    var dataObj = getObjectConfigFromElemId(elementId, colorCode);
    if (dataObj != null) {
        objectType = dataObj["objectType"] + "";
        objectName = dataObj["objectName"] + "";
    }
    var defaultvalue = '';
    var returnXML = '';
    var ctrltype = 'textbox';
    if($(inputElem).length>0)
    {
    if ($(inputElem)[0].type == 'checkbox')
    {
        defaultvalue = false;
        ctrltype = 'checkbox';
        if ($(inputElem).prop( "checked" ))
        {
            defaultvalue = true;
        }
    } else if ($(inputElem)[0].type == 'textarea') {
        ctrltype = 'textarea';
        defaultvalue = $(inputElem).val();
    }
    else {
        defaultvalue = $(inputElem).val();
    }
    }
    returnXML += '<OField  type="OSField">';
    returnXML += '<sortableObject>' + listname + '</sortableObject>';
    returnXML += '<objectName>' + objectName + '</objectName>';
    returnXML += '<objectType>' + objectType + '</objectType>';

    returnXML += '<controlType>' + ctrltype + '</controlType>';
    returnXML += '<label>' + safeHTMLValue($(labelElem).html(), "", true) + '</label>';
    returnXML += '<elemId>' + elementId + '</elemId>';
    returnXML += '<name>'+getSafeApiName(fieldLiElement)+'</name>';
    returnXML += '<type>' + safeStringValue($(inputElem).attr("vatt"), "") + '</type>';
    returnXML += '<hiddenField>' + getSafeBoolean($(inputElem).attr('data-ishidden'), false) + '</hiddenField>';
    returnXML += '<required>' + getSafeBoolean($(inputElem).attr('data-isrequired'), false) + '</required>';
    returnXML += '<placeholder>' + safeStringValue($(inputElem).attr('placeholder'), "") + '</placeholder>';
    returnXML += '<colorCode>' + colorCode + '</colorCode>';
    returnXML += '<readOnly>' + getSafeBoolean($(inputElem).attr('data-isreadonly'), false) + '</readOnly>';
    returnXML += '<upsert>' + getSafeBoolean($(inputElem).attr('data-isupsert'), false) + '</upsert>';
    returnXML += '<defaultValue>'+defaultvalue+'</defaultValue>';
    returnXML += '<maxLength>' + safeStringValue($(inputElem).attr('maxLength'), "") + '</maxLength>';
    returnXML += '<maxLengthMessage>' + safeStringValue($(inputElem).attr('data-maxlengthmessage'), "") + '</maxLengthMessage>';
    returnXML += '<isDefaultReq>' + getSafeBoolean($(inputElem).attr('data-isdefaultreq'), false) + '</isDefaultReq>';
    returnXML += '<isUserReq>' + getSafeBoolean($(inputElem).attr('data-isuserreq'), false) + '</isUserReq>';
    returnXML += '<requiredMessage>' + safeStringValue($(inputElem).attr('data-requiredmessage'), "") + '</requiredMessage>';
    returnXML += '<vatt>' + safeStringValue($(inputElem).attr("vatt"), "") + '</vatt>';
    returnXML += '<flexControlEnabled>false</flexControlEnabled>';
    returnXML += '<formatMessage/>';
    returnXML += '</OField>';
    return returnXML;
}
function getFFOCurrencyXML(fieldLiElement) {
    var labelElem = $(fieldLiElement).find('.labelDiv label.ff-label');
    var inputElem = $(fieldLiElement).find('.fieldDiv input[type="textbox"]');
    var elementId = $(inputElem).attr('id');
    var colorCode = safeStringValue($(fieldLiElement).find('.labelDiv .obj-info').attr('data-colorcode'), "");
    var listname = safeStringValue($(fieldLiElement).find('.labelDiv .obj-info').attr('data-listname'), "");
    var objectType = '';
    var objectName = '';
    var defaultvalue = $(inputElem).val();
    var dataObj = getObjectConfigFromElemId(elementId, colorCode);
    if (dataObj != null) {
        objectType = dataObj["objectType"] + "";
        objectName = dataObj["objectName"] + "";
    }
    var returnXML = '';
    returnXML += '<OField  type="OCurrency">';
    returnXML += '<sortableObject>' + listname + '</sortableObject>';
    returnXML += '<objectName>' + objectName + '</objectName>';
    returnXML += '<objectType>' + objectType + '</objectType>';
    returnXML += '<controlType>textbox</controlType>';
    returnXML += '<label>' + safeHTMLValue($(labelElem).html(), "", true) + '</label>';
    returnXML += '<elemId>' + elementId + '</elemId>';
    returnXML += '<name>'+getSafeApiName(fieldLiElement)+'</name>';
    returnXML += '<type>CURRENCY</type>';
    returnXML += '<hiddenField>' + getSafeBoolean($(inputElem).attr('data-ishidden'), false) + '</hiddenField>';
    returnXML += '<required>' + getSafeBoolean($(inputElem).attr('data-isrequired'), false) + '</required>';
    returnXML += '<placeholder>' + safeStringValue($(inputElem).attr('placeholder'), "") + '</placeholder>';
    returnXML += '<colorCode>' + colorCode + '</colorCode>';
    returnXML += '<readOnly>' + getSafeBoolean($(inputElem).attr('data-isreadonly'), false) + '</readOnly>';
    returnXML += '<upsert>' + getSafeBoolean($(inputElem).attr('data-isupsert'), false) + '</upsert>';
    returnXML += '<defaultValue>'+defaultvalue+'</defaultValue>';
    returnXML += '<maxLength>' + safeStringValue($(inputElem).attr('maxLength'), "") + '</maxLength>';
    returnXML += '<maxLengthMessage>' + safeStringValue($(inputElem).attr('data-maxlengthmessage'), "") + '</maxLengthMessage>';
    returnXML += '<isDefaultReq>' + getSafeBoolean($(inputElem).attr('data-isdefaultreq'), false) + '</isDefaultReq>';
    returnXML += '<isUserReq>' + getSafeBoolean($(inputElem).attr('data-isuserreq'), false) + '</isUserReq>';
    returnXML += '<requiredMessage>' + safeStringValue($(inputElem).attr('data-requiredmessage'), "") + '</requiredMessage>';
    returnXML += '<vatt>' + safeStringValue($(inputElem).attr("vatt"), "") + '</vatt>';
    returnXML += '<flexControlEnabled>false</flexControlEnabled>';
    returnXML += '<formatMessage/>';
    returnXML += '<currencyLabel>' + safeStringValue($(fieldLiElement).find('.fieldDiv .ff-currency').html(), "", true) + '</currencyLabel>';
    returnXML += '</OField>';
    return returnXML;
}
function getFFONumericXML(fieldLiElement) {
    var labelElem = $(fieldLiElement).find('.labelDiv label.ff-label');
    var inputElem = $(fieldLiElement).find('.fieldDiv input[type="textbox"]');
    var elementId = $(inputElem).attr('id');
    var colorCode = safeStringValue($(fieldLiElement).find('.labelDiv .obj-info').attr('data-colorcode'), "");
    var listname = safeStringValue($(fieldLiElement).find('.labelDiv .obj-info').attr('data-listname'), "");
     var defaultvalue = $(inputElem).val();
    var objectType = '';
    var objectName = '';
    var dataObj = getObjectConfigFromElemId(elementId, colorCode);
    if (dataObj != null) {
        objectType = dataObj["objectType"] + "";
        objectName = dataObj["objectName"] + "";
    }
    var returnXML = '';
    returnXML += '<OField  type="ONumeric">';
    returnXML += '<sortableObject>' + listname + '</sortableObject>';
    returnXML += '<objectName>' + objectName + '</objectName>';
    returnXML += '<objectType>' + objectType + '</objectType>';
    returnXML += '<controlType>textbox</controlType>';
    returnXML += '<label>' + safeHTMLValue($(labelElem).html(), "", true) + '</label>';
    returnXML += '<elemId>' + elementId + '</elemId>';
    returnXML += '<name>'+getSafeApiName(fieldLiElement)+'</name>';
    returnXML += '<type>NUMERIC</type>';
    returnXML += '<hiddenField>' + getSafeBoolean($(inputElem).attr('data-ishidden'), false) + '</hiddenField>';
    returnXML += '<required>' + getSafeBoolean($(inputElem).attr('data-isrequired'), false) + '</required>';
    returnXML += '<placeholder>' + safeStringValue($(inputElem).attr('placeholder'), "") + '</placeholder>';
    returnXML += '<colorCode>' + colorCode + '</colorCode>';
    returnXML += '<readOnly>' + getSafeBoolean($(inputElem).attr('data-isreadonly'), false) + '</readOnly>';
    returnXML += '<upsert>' + getSafeBoolean($(inputElem).attr('data-isupsert'), false) + '</upsert>';
    returnXML += '<defaultValue>'+defaultvalue+'</defaultValue>';
    returnXML += '<maxLength>' + safeStringValue($(inputElem).attr('maxLength'), "") + '</maxLength>';
    returnXML += '<maxLengthMessage>' + safeStringValue($(inputElem).attr('data-maxlengthmessage'), "") + '</maxLengthMessage>';
    returnXML += '<isDefaultReq>' + getSafeBoolean($(inputElem).attr('data-isdefaultreq'), false) + '</isDefaultReq>';
    returnXML += '<isUserReq>' + getSafeBoolean($(inputElem).attr('data-isuserreq'), false) + '</isUserReq>';
    returnXML += '<requiredMessage>' + safeStringValue($(inputElem).attr('data-requiredmessage'), "") + '</requiredMessage>';
    returnXML += '<vatt>' + safeStringValue($(inputElem).attr("vatt"), "") + '</vatt>';
    returnXML += '<flexControlEnabled>true</flexControlEnabled>';
    returnXML += '<formatMessage/>';
    var flexctrltype = safeStringValue($(inputElem).attr('data-flexcontrol'), "");
    returnXML += '<flexControlType>' + flexctrltype + '</flexControlType>';
    var flexXML = getFFNumFlexXML(inputElem);
    if (!isNullOrEmpty(flexctrltype) && flexctrltype.toLowerCase() != 'integer-default' && !isNullOrEmpty(flexXML)) {
        returnXML += '<flexControlXML>' + flexXML + '</flexControlXML>';
    }

    returnXML += '</OField>';
    return returnXML;
}
function getFFNumFlexXML(inputElem) {
    var returnXML = '';

    returnXML += '<data_flex_min>' + safeHTMLValue($(inputElem).attr('data-flex-min'), "",true) + '</data_flex_min>';
    returnXML += '<data_flex_middle>' + safeHTMLValue($(inputElem).attr('data-flex-middle'), "",true) + '</data_flex_middle>';
    returnXML += '<data_flex_max>' + safeHTMLValue($(inputElem).attr('data-flex-max'), "",true) + '</data_flex_max>';
    returnXML += '<data_flex_minlabel>' + safeHTMLValue($(inputElem).attr('data-flex-minlabel'), "",true) + '</data_flex_minlabel>';
    returnXML += '<data_flex_middlelabel>' + safeHTMLValue($(inputElem).attr('data-flex-middlelabel'), "",true) + '</data_flex_middlelabel>';
    returnXML += '<data_flex_maxlabel>' + safeHTMLValue($(inputElem).attr('data-flex-maxlabel'), "",true) + '</data_flex_maxlabel>';

    return returnXML;
}
function getObjectConfigFromElemId(elementId, colorCode) {
    var dataObj ;
    if (!isNullOrEmpty(elementId)) {
        var idToArray = elementId.split('\.');

        if (idToArray.length == 2) {
             
           dataObj= createJSONObjInfo("PRIMARY",idToArray[0]+'');
        }
        else if (idToArray.length > 2) {
            if (isNullOrEmpty(colorCode)) {
                
                dataObj= createJSONObjInfo("LOOKUP",idToArray[1].replace("Id", ""));
            }
            else {
                 dataObj= createJSONObjInfo("DETAIL",idToArray[1].replace("Id", ""));
            }
        }
    }
    return dataObj;
}
function getFFOLookupXML(fieldLiElement) {
    var labelElem = $(fieldLiElement).find('.labelDiv label.ff-label');
    var inputHiddenElem = $(fieldLiElement).find('.fieldDiv input[type="hidden"]');
    var inputElem = $(fieldLiElement).find('.fieldDiv input[type="textbox"]');
    var elementId = $(inputElem).attr('id');
    var colorCode = safeStringValue($(fieldLiElement).find('.labelDiv .obj-info').attr('data-colorcode'), "");
    var listname = safeStringValue($(fieldLiElement).find('.labelDiv .obj-info').attr('data-listname'), "");
    var objectType = '';
    var objectName = '';
    var dataObj = getObjectConfigFromElemId(elementId, colorCode);
    if (dataObj != null) {
        objectType = dataObj["objectType"] + "";
        objectName = dataObj["objectName"] + "";
    }
    var returnXML = '';
    returnXML += '<OField  type="OLookup">';
    returnXML += '<sortableObject>' + listname + '</sortableObject>';
    returnXML += '<objectName>' + objectName + '</objectName>';
    returnXML += '<objectType>' + objectType + '</objectType>';
    returnXML += '<controlType>lookupinput</controlType>';
    returnXML += '<label>' + safeHTMLValue($(labelElem).html(), "", true) + '</label>';
    returnXML += '<elemId>' + elementId + '</elemId>';
    returnXML += '<name>'+getSafeApiName(fieldLiElement)+'</name>';
    returnXML += '<type>LOOKUP</type>';
    returnXML += '<hiddenField>' + getSafeBoolean($(inputElem).attr('data-ishidden'), false) + '</hiddenField>';
    returnXML += '<required>' + getSafeBoolean($(inputElem).attr('data-isrequired'), false) + '</required>';
    returnXML += '<placeholder>' + safeStringValue($(inputElem).attr('placeholder'), "") + '</placeholder>';
    returnXML += '<colorCode>' + colorCode + '</colorCode>';
    returnXML += '<readOnly>' + getSafeBoolean($(inputElem).attr('data-isreadonly'), false) + '</readOnly>';
    returnXML += '<upsert>' + getSafeBoolean($(inputElem).attr('data-isupsert'), false) + '</upsert>';
    returnXML += '<defaultValue>' + $(inputElem).val() + '</defaultValue>';
    returnXML += '<maxLength>' + safeStringValue($(inputElem).attr('maxLength'), "") + '</maxLength>';
    returnXML += '<maxLengthMessage>' + safeStringValue($(inputElem).attr('data-maxlengthmessage'), "") + '</maxLengthMessage>';
    returnXML += '<isDefaultReq>' + getSafeBoolean($(inputElem).attr('data-isdefaultreq'), false) + '</isDefaultReq>';
    returnXML += '<isUserReq>' + getSafeBoolean($(inputElem).attr('data-isuserreq'), false) + '</isUserReq>';
    returnXML += '<requiredMessage>' + safeStringValue($(inputElem).attr('data-requiredmessage'), "") + '</requiredMessage>';
    returnXML += '<vatt>REFERENCE</vatt>';
    returnXML += '<flexControlEnabled>false</flexControlEnabled>';
    returnXML += '<formatMessage/>';
    if (safeStringValue($(inputHiddenElem).attr('data-lookup-value'), "") == 'list') {
        returnXML += '<listViewType>list</listViewType>';
    }
    else {
        returnXML += '<listViewType></listViewType>';
    }
    returnXML += '<listViewId>' + safeStringValue($(inputHiddenElem).attr('data-lookup-value'), "") + '</listViewId>';
    returnXML += '<listViewObject>' + safeStringValue($(inputElem).attr('data-lobj'), "") + '</listViewObject>';
    returnXML += '<defaultValueId>' + $(inputHiddenElem).val() + '</defaultValueId>';
    returnXML += '<vaObj>' + safeStringValue($(inputElem).attr('data-lobj'), "") + '</vaObj>';
    returnXML += '<rtypeObj>' + safeStringValue($(inputElem).attr('data-robj'), "") + '</rtypeObj>';
    returnXML += '</OField>';



    return returnXML;
}
function getFFOSinglePicklistXML(fieldLiElement) {
    var labelElem = $(fieldLiElement).find('.labelDiv label.ff-label');
    var inputElem = $(fieldLiElement).find('.fieldDiv select');
    var elementId = $(inputElem).attr('id');
    var colorCode = safeStringValue($(fieldLiElement).find('.labelDiv .obj-info').attr('data-colorcode'), "");
    var listname = safeStringValue($(fieldLiElement).find('.labelDiv .obj-info').attr('data-listname'), "");
    var objectType = '';
    var objectName = '';
    var dataObj = getObjectConfigFromElemId(elementId, colorCode);
    if (dataObj != null) {
        objectType = dataObj["objectType"] + "";
        objectName = dataObj["objectName"] + "";
    }
    var selectedValue = $(inputElem).val();
    var defaultValue = '';
    if (!isNullOrEmpty(selectedValue)) {

        defaultValue = selectedValue;

    }
    defaultValue=escapeHtmlString(defaultValue);
    var returnXML = '';
    returnXML += '<OField  type="OSinglePicklist">';
    returnXML += '<sortableObject>' + listname + '</sortableObject>';
    returnXML += '<objectName>' + objectName + '</objectName>';
    returnXML += '<objectType>' + objectType + '</objectType>';
    returnXML += '<controlType>select-one</controlType>';
    returnXML += '<label>' + safeHTMLValue($(labelElem).html(), "", true) + '</label>';
    returnXML += '<elemId>' + elementId + '</elemId>';
    returnXML += '<dtCustom>' + getSafeBoolean($(inputElem).attr('data-customset'),false) + '</dtCustom>';
    returnXML += '<name>'+getSafeApiName(fieldLiElement)+'</name>';
    returnXML += '<type>PICKLIST</type>';
    returnXML += '<hiddenField>' + getSafeBoolean($(inputElem).attr('data-ishidden'), false) + '</hiddenField>';
    returnXML += '<required>' + getSafeBoolean($(inputElem).attr('data-isrequired'), false) + '</required>';
    returnXML += '<colorCode>' + colorCode + '</colorCode>';
    returnXML += '<readOnly>' + getSafeBoolean($(inputElem).attr('data-isreadonly'), false) + '</readOnly>';
    returnXML += '<upsert>' + getSafeBoolean($(inputElem).attr('data-isupsert'), false) + '</upsert>';
    returnXML += '<defaultValue>' + defaultValue + '</defaultValue>';
    returnXML += '<maxLength>' + safeStringValue($(inputElem).attr('maxLength'), "") + '</maxLength>';
    returnXML += '<maxLengthMessage>' + safeStringValue($(inputElem).attr('data-maxlengthmessage'), "") + '</maxLengthMessage>';
    returnXML += '<isDefaultReq>' + getSafeBoolean($(inputElem).attr('data-isdefaultreq'), false) + '</isDefaultReq>';
    returnXML += '<isUserReq>' + getSafeBoolean($(inputElem).attr('data-isuserreq'), false) + '</isUserReq>';
    returnXML += '<requiredMessage>' + safeStringValue($(inputElem).attr('data-requiredmessage'), "") + '</requiredMessage>';
    returnXML += '<vatt>PICKLIST</vatt>';
    returnXML += '<flexControlEnabled>true</flexControlEnabled>';
    returnXML += '<formatMessage/>';
    var picklistvalues=getFFPicklistValues(inputElem);
    returnXML += '<picklistValues>' +picklistvalues  +'</picklistValues>';
    returnXML += '<flexControlType>' + safeStringValue($(inputElem).attr('data-flexcontrol'), "") + '</flexControlType>';

    returnXML += '</OField>';
    return returnXML;
}
function getFFOMultiPicklistXML(fieldLiElement) {
    var labelElem = $(fieldLiElement).find('.labelDiv label.ff-label');

    var inputElem = $(fieldLiElement).find('.fieldDiv select');
    var elementId = $(inputElem).attr('id');
    var colorCode = safeStringValue($(fieldLiElement).find('.labelDiv .obj-info').attr('data-colorcode'), "");
    var listname = safeStringValue($(fieldLiElement).find('.labelDiv .obj-info').attr('data-listname'), "");
    var objectType = '';
    var objectName = '';
    var dataObj = getObjectConfigFromElemId(elementId, colorCode);
    if (dataObj != null) {
        objectType = dataObj["objectType"] + "";
        objectName = dataObj["objectName"] + "";
    }
    var selectedValue = $(inputElem).val();
    var defaultValue = '';
    if (selectedValue != null && selectedValue !== undefined) {
        if (selectedValue instanceof Array) {
            defaultValue = selectedValue.join(';');
        }
        else {

            defaultValue = selectedValue;
        }
    }
    defaultValue=escapeHtmlString(defaultValue);
    var returnXML = '';
    returnXML += '<OField  type="OMultiPicklist">';
    returnXML += '<sortableObject>' + listname + '</sortableObject>';
    returnXML += '<objectName>' + objectName + '</objectName>';
    returnXML += '<objectType>' + objectType + '</objectType>';
    returnXML += '<controlType>select-multi</controlType>';
    returnXML += '<label>' + safeHTMLValue($(labelElem).html(), "", true) + '</label>';
    returnXML += '<elemId>' + elementId + '</elemId>';
    returnXML += '<dtCustom>' + getSafeBoolean($(inputElem).attr('data-customset'),false) + '</dtCustom>';
    returnXML += '<name>'+getSafeApiName(fieldLiElement)+'</name>';
    returnXML += '<type>MULTIPICKLIST</type>';
    returnXML += '<hiddenField>' + getSafeBoolean($(inputElem).attr('data-ishidden'), false) + '</hiddenField>';
    returnXML += '<required>' + getSafeBoolean($(inputElem).attr('data-isrequired'), false) + '</required>';
    returnXML += '<colorCode>' + colorCode + '</colorCode>';
    returnXML += '<readOnly>' + getSafeBoolean($(inputElem).attr('data-isreadonly'), false) + '</readOnly>';
    returnXML += '<upsert>' + getSafeBoolean($(inputElem).attr('data-isupsert'), false) + '</upsert>';
    returnXML += '<defaultValue>' + defaultValue + '</defaultValue>';
    returnXML += '<maxLength>' + safeStringValue($(inputElem).attr('maxLength'), "") + '</maxLength>';
    returnXML += '<maxLengthMessage>' + safeStringValue($(inputElem).attr('data-maxlengthmessage'), "") + '</maxLengthMessage>';
    returnXML += '<isDefaultReq>' + getSafeBoolean($(inputElem).attr('data-isdefaultreq'), false) + '</isDefaultReq>';
    returnXML += '<isUserReq>' + getSafeBoolean($(inputElem).attr('data-isuserreq'), false) + '</isUserReq>';
    returnXML += '<requiredMessage>' + safeStringValue($(inputElem).attr('data-requiredmessage'), "") + '</requiredMessage>';
    returnXML += '<vatt>MULTIPICKLIST</vatt>';
    returnXML += '<flexControlEnabled>true</flexControlEnabled>';
    returnXML += '<formatMessage/>';
    var picklistvalues=getFFPicklistValues(inputElem);
    returnXML += '<picklistValues>' +picklistvalues  +'</picklistValues>';
    returnXML += '<flexControlType>' + safeStringValue($(inputElem).attr('data-flexcontrol'), "") + '</flexControlType>';

    returnXML += '</OField>';
    return returnXML;
}

function getFFPicklistValues(selectElement) {
     

    var picklistValuesXML = '';
    var customDataSet=   getSafeBoolean($(selectElement).attr('data-customset'),false);
     if(customDataSet && $(selectElement).parent().find('.selectDataSet select').length>0){
    selectElement=$(selectElement).parent().find('.selectDataSet select');
    } 
    $.each($(selectElement).find('option'), function (index, optionElem) {
       
    var optionValue=   escapeHtmlString($(optionElem).val());
    var optionText=   escapeHtmlString($(optionElem).text());
    var isCustom=   getSafeBoolean($(optionElem).attr('data-iscustom'),false);
    var isDisabled=   getSafeBoolean($(optionElem).attr('data-disabled'),false);
   var isSelected=false;
   if ($(optionElem).is(':selected')) {
   isSelected=true;
   }
   var customAttr='';
   if(isDisabled){customAttr='ignore="true" ';
   }
   if(isCustom){customAttr+='custom="true" ';
   }     
            picklistValuesXML += '<picklistValue '+customAttr+'value="' + optionValue + '" selected="'+isSelected+'">' + optionText + '</picklistValue>';
   
     });
     

    return picklistValuesXML;
}
//var generalFields = ['generaltext', 'esignature', 'payment', 'fileupload', 'image', 'captcha'];
function getFFOGeneralTextXML(fieldLiElement) {
    var labelElement = $(fieldLiElement).find('.labelDiv label.ff-label');

    var returnXML = '';
    returnXML += '<OField  type="OGeneralText">';
    returnXML += '<sortableObject/>';
    returnXML += '<objectName>General</objectName>';
    returnXML += '<objectType>GENERAL</objectType>';
    returnXML += '<controlType>GENERALTEXT</controlType>';
    returnXML += '<label>' + safeHTMLValue($(labelElement).html(), "", true) + '</label>';
    returnXML += '<elemId>' + safeStringValue($(labelElement).attr("id"), "").replace(/lbl/g,"") + '</elemId>';
    returnXML += '<name>' + safeStringValue($(labelElement).attr("id"), "").replace(/lbl/g,"")  + '</name>';
    returnXML += '<type>STRING</type>';
    returnXML += '<hiddenField>' + getSafeBoolean($(labelElement).attr('data-ishidden'), false) + '</hiddenField>';
    returnXML += '<required/>';
    returnXML += '</OField>';
    return returnXML;
}
function getFFOESignatureXML(fieldLiElement) {
    var inputSignatureElement = $(fieldLiElement).find('.eSignatureFieldDiv input.ffd-esignature-input');
    var signatureElemId = safeStringValue($(inputSignatureElement).attr("id"), "");
    signatureElemId = signatureElemId.replace('input', '');
    var returnXML = '';
    returnXML += '<OField  type="OESignature">';
    returnXML += '<sortableObject/>';
    returnXML += '<objectName>General</objectName>';
    returnXML += '<objectType>GENERAL</objectType>';
    returnXML += '<controlType>ESIGNATURE</controlType>';
    returnXML += '<elemId>' + signatureElemId + '</elemId>';
    returnXML += '<name>' + signatureElemId + '</name>';
    returnXML += '<type>ESIGNATURE</type>';
    returnXML += '<hiddenField>false</hiddenField>';
    returnXML += '<required>true</required>';
    returnXML += '<signType>' + safeStringValue($(inputSignatureElement).attr("data-signtype"), "") + '</signType>';
    returnXML += '<signOptions>' + safeStringValue($(inputSignatureElement).attr("data-signoptions"), "") + '</signOptions>';
    returnXML += '<signLabel>' + safeStringValue($(inputSignatureElement).attr("data-signlabel"), "") + '</signLabel>';
    returnXML += '<signDate>' + safeStringValue($(inputSignatureElement).attr("data-signdate"), "") + '</signDate>';
    returnXML += '<isDateHidden>' + safeStringValue($(inputSignatureElement).attr("data-signdatehide"), "false") + '</isDateHidden>';
    returnXML += '<signAgreeText>' + safeStringValue($(inputSignatureElement).attr("data-signagree"), "") + '</signAgreeText>';
    returnXML += '<isAgreeHidden>' + safeStringValue($(inputSignatureElement).attr("data-signagreehide"), "true") + '</isAgreeHidden>';
    returnXML += '<emailEnabled>' + safeStringValue($(inputSignatureElement).attr("data-emailenabled"), "false") + '</emailEnabled>';
    returnXML += '<emailLabel>' + safeStringValue($(inputSignatureElement).attr("data-emaillabel"), "Email" ) + '</emailLabel>';

    returnXML += '</OField>';
    return returnXML;
}
 
function getFFPaymentXML(fieldLiElement,paymentType) {
var oDataType=$(fieldLiElement).attr("data-otype");
    var fieldDivPayment = $(fieldLiElement).find('.field-div-payment');
    var paymentElemId = safeStringValue($(fieldDivPayment).attr("id"), "");
   var  paymentElemIndex = paymentElemId.replace('FASTFORMSPAYMENT', ''); 
   paymentElemIndex=paymentElemIndex.replace('divLabel','');   
    var returnXML = '';
    returnXML += '<OField  type="'+oDataType+'">';
    returnXML += '<sortableObject/>';
    returnXML += '<objectName>General</objectName>';
    returnXML += '<objectType>GENERAL</objectType>';
    returnXML += '<controlType>PAYMENT</controlType>';
    returnXML += '<label/>';
     switch (paymentType) {
    case 'OPayPalPayment':
    returnXML += '<elemId>PAYPALPAYMENT' + paymentElemIndex + '</elemId>';
    returnXML += '<type>PAYPALPAYMENT</type>';
    break;
            case 'OiATSPayment':
            returnXML += '<elemId>IATSPAYMENT' + paymentElemIndex + '</elemId>';
    returnXML += '<type>IATSPAYMENT</type>';
            break;
            case 'OStripePayment':
            returnXML += '<elemId>STRIPEPAYMENT' + paymentElemIndex + '</elemId>';
    returnXML += '<type>STRIPEPAYMENT</type>';
            break;
            case 'OAuthorizeNetPayment':
            returnXML += '<elemId>AUTHORIZENETPAYMENT' + paymentElemIndex + '</elemId>';
    returnXML += '<type>AUTHORIZENETPAYMENT</type>';
            break;
            default:
            returnXML += '<elemId>PAYPALPAYMENT' + paymentElemIndex + '</elemId>';
    returnXML += '<type>PAYPALPAYMENT</type>';
            break;
            }
    
    returnXML += '<hiddenField>' + safeStringValue($(fieldDivPayment).attr("data-ishidden"), "false") + '</hiddenField>';
    returnXML += '<required>' + getSafeBoolean($(fieldDivPayment).attr('data-paymentrequired'), false) + '</required>';
    returnXML += '<paymentFieldId>' + safeStringValue($(fieldDivPayment).attr("data-paymentfield-record-id"), "") + '</paymentFieldId>';
    returnXML += '<testMode>' + getSafeBoolean($(fieldDivPayment).attr('data-test-mode'), false) + '</testMode>';
    returnXML += '</OField>';
    return returnXML;
}

function getFFOFileUploadXML(fieldLiElement) {
    var labelElement = $(fieldLiElement).find('.labelDiv label.ff-label');
    var fielUploadDivElem = $(fieldLiElement).find('.fieldDiv .ff-fileupload-drop-area');

    var returnXML = '';
    returnXML += '<OField  type="OFileUpload">';
    returnXML += '<sortableObject/>';
    returnXML += '<objectName>General</objectName>';
    returnXML += '<objectType>GENERAL</objectType>';
    returnXML += '<controlType>FILEUPLOAD</controlType>';
    returnXML += '<label>' + safeHTMLValue($(labelElement).html(), "", true) + '</label>';
    returnXML += '<elemId>' + safeStringValue($(fielUploadDivElem).attr("id"), "") + '</elemId>';
    returnXML += '<name/>';
    returnXML += '<type>FILE</type>';
    returnXML += '<hiddenField>' + getSafeBoolean($(fielUploadDivElem).attr('data-ishidden'), false) + '</hiddenField>';
    returnXML += '<required>' + getSafeBoolean($(fielUploadDivElem).attr('data-isrequired'), false) + '</required>';
    returnXML += '<uploadToChatter>' + getSafeBoolean($(fielUploadDivElem).attr('data-uploadtochatter'), false) + '</uploadToChatter>';
    returnXML += '<allowedFileTypes>' + safeStringValue($(fielUploadDivElem).attr('data-allowedfiletypes'), "") + '</allowedFileTypes>';
    returnXML += '<maxFiles>' + safeStringValue($(fielUploadDivElem).attr('data-maxfiles'), "3") + '</maxFiles>';
    returnXML += '<attachTo>' + safeStringValue($(fielUploadDivElem).attr('data-attachto'), 1) + '</attachTo>';
    returnXML += '<requiredMessage>' + safeStringValue($(fielUploadDivElem).attr('data-requiredmessage'), "required") + '</requiredMessage>';
    returnXML += '<fileName>' + escapeXML(unscapeXML($(fielUploadDivElem).attr('data-filename'))) + '</fileName>';
    returnXML += '</OField>';
    return returnXML;
}

function getFFOImageXML(fieldLiElement) {
    var imageFieldDiv = $(fieldLiElement).find('.imageGeneralFieldDiv');

    var imgAlignment = '';
    var styleValue = $(imageFieldDiv).attr('style');
    if (!isNullOrEmpty(styleValue)) {
        if (styleValue.toLowerCase().indexOf('right') > 0) {
            imgAlignment = 'right';
        }
        else if (styleValue.toLowerCase().indexOf('left') > 0) {
            imgAlignment = 'left';
        }
        else if (styleValue.toLowerCase().indexOf('center') > 0) {
            imgAlignment = 'center';
        }
    }
    var returnXML = '';
    returnXML += '<OField  type="OImage">';
    returnXML += '<sortableObject/>';
    returnXML += '<objectName>General</objectName>';
    returnXML += '<objectType>GENERAL</objectType>';
    returnXML += '<controlType>IMAGE</controlType>';
    returnXML += '<label/>';
    var elemid=safeStringValue($(imageFieldDiv).find('.ffse-img-upload-placeholder-editor>img').attr('id'), "");
    if(isNullOrEmpty(elemid)){
    var lblliid=$(fieldLiElement).attr('id');
    elemid=lblliid.replace('lblli','img');
    }
    returnXML += '<elemId>' + elemid + '</elemId>';
    returnXML += '<name/>';
    returnXML += '<type>IMAGE</type>';
    returnXML += '<hiddenField>' + getSafeBoolean($(fieldLiElement).find('.ff-image-label').attr('data-ishidden'), false) + '</hiddenField>';
    returnXML += '<required/>';
    returnXML += '<imgSrc>' + safeStringValue($(imageFieldDiv).find('.ffse-img-upload-placeholder-editor>img').attr('src'), "") + '</imgSrc>';
    returnXML += '<imgWidth>' + safeStringValue($(imageFieldDiv).find('.ffse-img-upload-placeholder-editor>img').attr('width'), "") + '</imgWidth>';
    returnXML += '<imgHeight>' + safeStringValue($(imageFieldDiv).find('.ffse-img-upload-placeholder-editor>img').attr('height'), "") + '</imgHeight>';
    returnXML += '<alt>' + safeStringValue($(imageFieldDiv).find('.ffse-img-upload-placeholder-editor>img').attr('alt'), "") + '</alt>';
    returnXML += '<alignment>' + imgAlignment + '</alignment>';
    returnXML += '</OField>';
    return returnXML;
}

function getFFOCaptchaXML(fieldLiElement) {
    var inputElem = $(fieldLiElement).find('.fieldDiv input.ff-type-captcha');
    var labelElement = $(fieldLiElement).find('.labelDiv label.ff-label');
    var returnXML = '';
    returnXML += '<OField  type="OCaptcha">';
    returnXML += '<sortableObject/>';
    returnXML += '<objectName>General</objectName>';
    returnXML += '<objectType>GENERAL</objectType>';
    returnXML += '<controlType>CAPTCHA</controlType>';
    returnXML += '<label>' + safeHTMLValue($(labelElement).html(), "", true) + '</label>';
    returnXML += '<elemId>' + safeStringValue($(inputElem).attr('id'), "") + '</elemId>';
    returnXML += '<name>Captcha</name>';
    returnXML += '<type>CAPTCHA</type>';
    returnXML += '<hiddenField>' + getSafeBoolean($(inputElem).attr('data-ishidden'), false) + '</hiddenField>';
    returnXML += '<required>true</required>';
    returnXML += '</OField>';
    return returnXML;
}

function createJSONObjInfo(objecttype,objectname) {
    var dataobj = { "objectType": objecttype, "objectName": objectname  };


    return dataobj;
}
 

function generateFormHTML(pageElemDiv, pageItemXML) {
     
     

    var pagename = safeStringValue($(pageElemDiv).find('>ul.formPageUl>li .ff-page-header').html(), "",true);//pageItem["pTitle"];
    var pageorder = safeStringValue($(pageElemDiv).find('.ff-page-header-box .page-tag-number').text(), "");  //pageItem["pOrder"];
    var pageid = safeStringValue($(pageElemDiv).attr("data-pageid"), "");
    var pagelabelid = safeStringValue($(pageElemDiv).find('>ul.formPageUl>li .ff-page-header').attr('id'), "");
    var pageishidden = getSafeBoolean($(pageElemDiv).attr("data-ishidden"), false);
 
     
    var pageInfoJSONarr = [];
    pageInfoJSONarr.push(createJSONPageObj(pageid,pagelabelid, pagename, pageorder, pageItemXML,'',pageishidden));

    var renderHTML= getRenderedFormHTML( pageInfoJSONarr[0]);
    ////console.log(' Render html'+renderHTML);
     return renderHTML;
}
    function getRenderedFormHTML(pageItem) {
   /* var safeXML=pageItem["pXML"].replace(/&/g, "&amp;");
        if (window.DOMParser) {
            parser = new DOMParser();
            xmlDoc = parser.parseFromString(safeXML, "text/xml");
        }
        else // Internet Explorer
        {
            xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
            xmlDoc.async = false;
            xmlDoc.loadXML(safeXML);
        }*/
        var returnHTML = '';
        var xmlDocElement=getXmlElementFromStr(pageItem["pXML"]);
        var pageElements = xmlDocElement.getElementsByTagName("ffPage");
       var formHtml=$('<div/>'); 
    $.each(pageElements, function (pageIndx, pageElement) {

        
        if (pageElement.childNodes.length > 0) {


            var pageishidden =getSafeBoolean(pageItem["pHidden"],false);//firstBooleanElementByTagName(pageElement, "isHidden", false);
             var pageorder = safeStringValue(pageItem["pOrder"],'');//firstElementByTagName(pageElement, "pageOrder", true);
             var pagetitle =safeStringValue(pageItem["pTitle"],'');//firstElementByTagName(pageElement, "name", true);
             var pagenameHTML=unescapeHTMLString(pagetitle);
          var pageId =safeStringValue(pageItem["pFormPageId"],'');
          if(isNullOrEmpty(pageId))
          {
          pageId='';
          }
          else{
          pageId=pageId.replaceAll('pageFFLabel','ffPage');
          }
                var pageElemDiv = $('<div/>', { 'id':pageId, 'class': 'ff-page-row page-'+pageorder });
                $(pageElemDiv).attr('data-pagetitle',pagetitle);
                 
            if (pageishidden) {
                 $(pageElemDiv).attr('page-ishidden',true);
            }
            /*Page title item row starts*/
            var ffPageItemRow = $('<div/>', { 'class': 'ff-page-header-row' });
                  var pagelabelElemDiv = $('<div/>', { 'class': 'ff-col-1 ff-page-col' });
                     var pagelabelElem = $('<label />', {   'class': 'ff-page-header',   'html': pagenameHTML });
                    pagelabelElemDiv.append(pagelabelElem);
                    ffPageItemRow.append($('<div/>', { 'class': 'ff-item-row' }).append(pagelabelElemDiv));
                    if($('#mainMultiPageWrapper').find('.form-canvas-multi-page-inner .fc-multi-page-item').length>1)
                    {
                    pageElemDiv.append(ffPageItemRow);
                    }
                    /*Page  title item row ends*/

            var sectionlistElem = firstElementByTagName(pageElement, "sectionList", false);
            $.each(sectionlistElem.getElementsByTagName("OSection"), function (sectionIndex, sectionElement) {
               // var sectionElemDiv = $('<div/>').addClass('ff-group-row group-' + sectionIndex);
                
                 

                var sectionname = firstElementByTagName(sectionElement, "name", true);
                var sectionorder = firstElementByTagName(sectionElement, "sectionOrder", true);
                var sectionid = firstElementByTagName(sectionElement, "sectionId", true);
               var sectionnameHTML=unescapeHTMLString(sectionname);
                var sectionishidden = firstBooleanElementByTagName(sectionElement, "isHidden", false); 
                var sectionCounter = safeSectionCounter(sectionid);
                var sectionElemDiv = $('<div/>', { 'class': 'ff-group-row group-' + sectionIndex, 'id': 'ffSection'+sectionCounter });
                if (sectionishidden) {
                    $(sectionElemDiv).hide();
                }
                var isSectionRepeat = firstBooleanElementByTagName(sectionElement, "repeat", false); 
                if(isSectionRepeat){  
                    $(sectionElemDiv).attr('data-repeat',true); 
                     $(sectionElemDiv).attr('data-addlink',firstElementByTagName(sectionElement, "addLink",true));
                     $(sectionElemDiv).attr('data-removelink',firstElementByTagName(sectionElement, "removeLink",true));
                     $(sectionElemDiv).attr('data-min',firstElementByTagName(sectionElement, "minCount",true));
                     $(sectionElemDiv).attr('data-max',firstElementByTagName(sectionElement, "maxCount",true));
                    }
                var ffSectionItemRowDiv = $('<div/>', { 'class': 'ff-item-row' });
                 var fieldlistElem = firstElementByTagName(sectionElement, "fieldList", false);
                 var labelElemDiv = $('<div/>', { 'class': 'ff-col-1 ff-section-col' });
                     var sectionlabelElem = $('<label />', {   'class': 'ff-section-header', id: 'sectionLabel'+sectionCounter, 'html': sectionnameHTML });
                    labelElemDiv.append(sectionlabelElem);
                    ffSectionItemRowDiv.append(labelElemDiv);
                    

                 var fieldlistElem = firstElementByTagName(sectionElement, "fieldList", false);
                $.each(fieldlistElem.getElementsByTagName("OField"), function (fieldIndex, fieldElement) {

                    var fieldAttrType = '';
                    if (!isNullOrEmpty(fieldElement.getAttribute('type'))) {
                        fieldAttrType = fieldElement.getAttribute('type');
                    }

                    var ffItemRowDiv = $('<div/>', { 'class': 'ff-item-row' });
                    var elemId = firstElementByTagName(fieldElement, "elemId", true);
                    var elemIdWOdot = elemId.replace(/\./g, '');

                    var labelElemDiv = $('<div/>', { 'class': 'ff-col-1 ff-label-col' });
                    var fieldElemDiv = $('<div/>', { 'class': 'ff-col-2 ff-field-col' });
                    
                     
                     
                    var controltype = firstElementByTagName(fieldElement, "controlType", true);
                    var labeltext = firstElementByTagName(fieldElement, "label", true);
                    var labelHTML=unescapeHTMLString(labeltext);
                    var fieldtype = firstElementByTagName(fieldElement, "type", true);
                    var isfieldhidden = firstBooleanElementByTagName(fieldElement, "hiddenField", false);
                    var labelclass = 'ff-label';
                    if (isfieldhidden) {
                         
                        $(ffItemRowDiv).hide();
                    }

                
                   



                    var addSField = false;
                    var generalFields = ['generaltext', 'esignature', 'payment', 'fileupload', 'image', 'captcha'];

                    /*field parsing starts*/
                    if (controltype.toLowerCase() != '' && $.inArray(controltype.toLowerCase(), generalFields) < 0) {
                        
                        /*Salesforce object fields*/

                        var vatttype = firstElementByTagName(fieldElement, "vatt", true);
                        var vattUpperCase=safeStringValue(vatttype.toUpperCase(),'');
                        var colorcode = firstElementByTagName(fieldElement, "colorCode", true);
                        
                        var sortableobject = firstElementByTagName(fieldElement, "sortableObject", true);
                        
                         
                        var labelElem = $('<label />', { 'vatt': vatttype,'for':elemId, 'class': labelclass, id: 'lbl' + elemIdWOdot, 'html': labelHTML });

                        labelElemDiv.html(labelElem);


                        var fieldrequiredmessage = firstElementByTagName(fieldElement, "requiredMessage", true);
                        if (isNullOrEmpty(fieldrequiredmessage)) {
                            fieldrequiredmessage = 'required';
                        }
                        var isrequiredEmpty=firstElementByTagName(fieldElement, "required", true);
                        if(isNullOrEmpty(isrequiredEmpty))
                        {
                         isrequiredEmpty=true;
                        }
                        var isdatarequired= firstBooleanElementByTagName(fieldElement, "required", false);
                        var isfieldupsert = firstBooleanElementByTagName(fieldElement, "upsert", false);
                        var isfieldreadonly = firstBooleanElementByTagName(fieldElement, "readOnly", false);

                        var isdefaultreq = firstBooleanElementByTagName(fieldElement, "isDefaultReq", false);
                        var isuserreq = firstBooleanElementByTagName(fieldElement, "isUserReq", false);



                        switch (controltype.toLowerCase()) {
                            /// create LOOKUP elements
                            case 'lookupinput':
                                 labelElemDiv.find('.ff-label').attr('for','input'+elemId);
                                var listviewid = firstElementByTagName(fieldElement, "listViewId", true);
                                var listviewobject = firstElementByTagName(fieldElement, "listViewObject", true);
                                var defaultvalueid = firstElementByTagName(fieldElement, "defaultValueId", true);
                                var defaultvalue = firstElementByTagName(fieldElement, "defaultValue", true);
                                var placeholdertext = firstElementByTagName(fieldElement, "placeholder", true);
                                var vaobj = firstElementByTagName(fieldElement, "vaObj", true);
                                var rtypeobj = firstElementByTagName(fieldElement, "rtypeObj", true);
                                var spanLookupElem = $('<span />', { 'class': 'lookupInput' });
                                var inputHiddenElem = $('<input />', { 'type': 'hidden', 'id': elemId + '', 'vatt': 'REFERENCE' });
                                var inputElem = $('<input />', { 'type': 'textbox', 'id': 'input'+elemId  ,'placeholder':placeholdertext, 'name': 'input'+elemId, 'class': 'ff-input-type ff-type-text','readonly':'readonly', 'vatt': 'REFERENCE', value: defaultvalue, 'data-lobj': vaobj, 'data-robj': rtypeobj });
                                updateElementProp(inputHiddenElem, 'data-vaobj', listviewobject, false);
                                updateElementProp(inputHiddenElem, 'data-lookup-value', listviewid, false);
                                if (!isNullOrEmpty(listviewid)) {
                                    updateElementProp(inputHiddenElem, 'data-lookup-value-type', 'list', true);
                                }
                                if(isfieldreadonly)
                                {
                                updateElementProp(inputHiddenElem, 'readonly','readonly', false);
                                }
                                updateElementProp(inputHiddenElem, 'value', defaultvalueid, false);
                                var aLookupElem = $('<a />', { 'class':'lookup-link','title':'Lookup', 'onclick': 'openLookupPopup(this);', 'id': 'alink'+elemId + '' });
                                
                                
                                fieldElemDiv.html(inputHiddenElem);
                                fieldElemDiv.append(inputElem);
                                 if(!isfieldreadonly)
                                {
                                
                                fieldElemDiv.append(aLookupElem); 
                                }
                                addSField = true;
                                break;
                                /// create TEXTBOX elements
                            case 'textbox':
                               
                               var placeholdertext = firstElementByTagName(fieldElement, "placeholder", true);
                                var fieldmaxlength = firstElementByTagName(fieldElement, "maxLength", true);
                                var fieldmaxlengthmessage = firstElementByTagName(fieldElement, "maxLengthMessage", true);

                                var inputElem = $('<input />', { 'type': 'textbox', 'id': elemId + '','placeholder':placeholdertext, 'name': elemId + '', 'vatt': vatttype, 'class': 'ff-input-type ff-type-text', 'data-maxlengthmessage': fieldmaxlengthmessage, 'maxlength': fieldmaxlength });

                                var inputdefaultvalue = firstElementByTagName(fieldElement, "defaultValue", true);
                                inputElem.val(inputdefaultvalue);
                                inputElem.attr('value',inputdefaultvalue);

                                if (fieldtype == 'CURRENCY') {
                                    inputElem.attr('data-formatmessage', 'Please enter a valid currency value');
                                    var currencylbl = firstElementByTagName(fieldElement, "currencyLabel", true);
                                    //inputElem.attr('data-currencylabel', currencylbl);
                                    fieldElemDiv.html( "<span class='ff-currency-lbl'>"+currencylbl+"</span>" );
                                    fieldElemDiv.append(inputElem);
                                }
                                else if (vatttype.indexOf('PERCENT') >= 0) {

                                    inputElem.attr('data-formatmessage', 'Please enter a valid percentage');

                                    //inputElem.attr('data-percentlabel', '%');
                                    fieldElemDiv.html( inputElem );
                                    fieldElemDiv.append("<span class='ff-percent-lbl'>%</span>" );
                                }
                                else if (fieldtype == 'NUMERIC') {

                                    var dataflexmin = firstElementByTagName(fieldElement, "data_flex_min", true);
                                    var dataflexmax = firstElementByTagName(fieldElement, "data_flex_max", true);
                                    var dataflexminlabel = firstElementByTagName(fieldElement, "data_flex_minlabel", true);
                                    var dataflexmaxlabel = firstElementByTagName(fieldElement, "data_flex_maxlabel", true);

                                    var flexcontroltype = firstElementByTagName(fieldElement, "flexControlType", true);
                                    inputElem.attr('data-flexcontrol', flexcontroltype);
                                    if (flexcontroltype == 'integer-npsrating') {
                                        var dataflexmiddle = firstElementByTagName(fieldElement, "data_flex_middle", true);
                                        var dataflexmiddlelabel = firstElementByTagName(fieldElement, "data_flex_middlelabel", true);
                                        inputElem.attr('data-flex-min', dataflexmin);
                                        inputElem.attr('data-flex-max', dataflexmax);
                                        inputElem.attr('data-flex-middle', dataflexmiddle);
                                        inputElem.attr('data-flex-minlabel', dataflexminlabel);
                                        inputElem.attr('data-flex-maxlabel', dataflexmaxlabel);
                                        inputElem.attr('data-flex-middlelabel', dataflexmiddlelabel);
                                    }
                                    else if (flexcontroltype == 'integer-starrating') {
                                        inputElem.attr('data-flex-min', dataflexmin);
                                        inputElem.attr('data-flex-max', dataflexmax);
                                        inputElem.attr('data-flex-minlabel', dataflexminlabel);
                                        inputElem.attr('data-flex-maxlabel', dataflexmaxlabel);
                                    }
                                    fieldElemDiv.html(inputElem);
                                }
                                else{
                                fieldElemDiv.html(inputElem);
                                }
                                
                                addSField = true;
                                break;
                                /// create TEXTAREA elements
                            case 'textarea':
                                var placeholdertext = firstElementByTagName(fieldElement, "placeholder", true);
                                var fieldmaxlength = firstElementByTagName(fieldElement, "maxLength", true);
                                var fieldmaxlengthmessage = firstElementByTagName(fieldElement, "maxLengthMessage", true);

                                var inputElem = $('<textarea />', { 'id': elemId + '','placeholder':placeholdertext, 'name': elemId + '', 'vatt': vatttype, 'class': 'ff-textarea', 'data-maxlengthmessage': fieldmaxlengthmessage, 'maxlength': fieldmaxlength });
                                var inputdefaultvalue = firstElementByTagName(fieldElement, "defaultValue", true);
                                inputElem.val(inputdefaultvalue);
                                inputElem.text(inputdefaultvalue);
                                inputElem.attr('value',inputdefaultvalue);
                                fieldElemDiv.html(inputElem);
                                addSField = true;
                                break;

                                /// create BOOLEAN elements
                            case 'checkbox':
                                var inputElem = $('<input />', { 'type': 'checkbox', 'id': elemId + '', 'name': elemId + '', 'vatt': vatttype, 'class': 'ff-checkbox' });
                                //var labelForElem = $('<label />', { 'for': elemId + '', 'vatt': vatttype, 'class': 'css-label' });
                                var inputdefaultvalue = firstBooleanElementByTagName(fieldElement, "defaultValue", false);
                                if (inputdefaultvalue) {
                                    inputElem.prop('checked', true);
                                    inputElem.attr("checked", true);
                                }
                                else {
                                    inputElem.prop('checked', false);
                                    inputElem.removeAttr("checked");
                                }

                                fieldElemDiv.html(inputElem);
                               // fieldElemDiv.append(labelForElem);
                                addSField = true;
                                break;

                                /// create SINGLEPICKLIST elements
                            case 'select-one':
                                var selectcontroltype = firstElementByTagName(fieldElement, "flexControlType", true);
                                var selectElem = $('<select />', { 'name': elemId, 'id': elemId + '', 'vatt': vatttype, 'class': 'ff-select-type ff-singlepicklist', 'data-flexcontrol': selectcontroltype });

                                var picklistValuesElem = firstElementByTagName(fieldElement, "picklistValues", false);

                                $.each(picklistValuesElem.getElementsByTagName("picklistValue"), function (index, picklistValueElem) {
                                    var optionValue = picklistValueElem.getAttribute('value');
                                    optionValue= unescapeHTMLString(optionValue);
                                    var optiontext=unescapeHTMLString($(picklistValueElem).text());
                                    var isDisabled=   getSafeBoolean(picklistValueElem.getAttribute('ignore'),false);
                                     var isSelected=   getSafeBoolean(picklistValueElem.getAttribute('selected'),false);
                                     if(!isDisabled){
                                    if (isSelected) {
                                        $("<option />", { value: optionValue, text: optiontext, 'selected': 'true' }).appendTo(selectElem);
                                    }
                                    else {
                                        $("<option />", { value: optionValue, text: optiontext }).appendTo(selectElem);
                                    }
                                    }

                                });
                                fieldElemDiv.html(selectElem);
                                addSField = true;
                                break;

                                /// create SINGLEPICKLIST elements
                            case 'select-multi':
                                var selectcontroltype = firstElementByTagName(fieldElement, "flexControlType", true);
                                var selectElem = $('<select  />', { 'name': elemId, 'id': elemId + '', 'vatt': vatttype, 'class': 'ff-select-type ff-multipicklist', 'data-flexcontrol': selectcontroltype, 'multiple': 'multiple' });

                                var picklistValuesElem = firstElementByTagName(fieldElement, "picklistValues", false);

                                $.each(picklistValuesElem.getElementsByTagName("picklistValue"), function (index, picklistValueElem) {
                                    var optionValue = picklistValueElem.getAttribute('value');
                                   optionValue= unescapeHTMLString(optionValue);
                                   var optiontext=unescapeHTMLString($(picklistValueElem).text());
                                      var isDisabled=   getSafeBoolean(picklistValueElem.getAttribute('ignore'),false);
                                     var isSelected=   getSafeBoolean(picklistValueElem.getAttribute('selected'),false);
                                     if(!isDisabled){
                                    if (isSelected) {
                                        $("<option />", { value: optionValue, text: optiontext, 'selected': 'true' }).appendTo(selectElem);
                                    }
                                    else {
                                        $("<option />", { value: optionValue, text: optiontext }).appendTo(selectElem);
                                    }
                                    }

                                });
                                fieldElemDiv.html(selectElem);
                                addSField = true;
                                break;
                            default:
                        }
                        if (addSField) {
                            //fieldrequiredmessage, isfieldupsert, isfieldreadonly, isfieldhidden, isdefaultreq, isuserreq 
                            fieldElemDiv.find('select,input,textarea').not(':input[type=hidden]').attr('data-requiredmessage', fieldrequiredmessage);
                            fieldElemDiv.find('select,input,textarea').not(':input[type=hidden]').removeAttr('data-isdefaultreq');
                            fieldElemDiv.find('select,input,textarea').not(':input[type=hidden]').removeAttr('data-isuserreq');

                            if(isrequiredEmpty)
                            {
                            if (isdefaultreq || isuserreq) {
                                fieldElemDiv.find('select,input,textarea').not(':input[type=hidden]').attr('data-isrequired', true);
                                labelElemDiv.append($('<span/>', { 'class': 'requiredSpan ff-required-mark', 'html': '*' }));
                            }
                            }else if(isdatarequired){
                             fieldElemDiv.find('select,input,textarea').not(':input[type=hidden]').attr('data-isrequired', true);
                                labelElemDiv.append($('<span/>', { 'class': 'requiredSpan ff-required-mark', 'html': '*' }));
                            }

                             
                            fieldElemDiv.find('select,input,textarea').not(':input[type=hidden]').attr('data-isupsert', isfieldupsert);
                            fieldElemDiv.find('select,input,textarea').not(':input[type=hidden]').attr('data-ishidden', isfieldhidden);
                            if(controltype.toLowerCase()!='lookupinput') {
                            if(isfieldreadonly)
                            {
                                 if(fieldElemDiv.find('select').length>0)
                                 {
                                 fieldElemDiv.find('select').attr('disabled', true);
                                 }
                                 else if(vattUpperCase=='DATE' || vattUpperCase=='DATETIME')
                                 {
                                 fieldElemDiv.find('input').attr('disabled', true);
                                 }
                                 else{
                                fieldElemDiv.find('select,input,textarea').not(':input[type=hidden]').attr('readonly', true);
                                }
                            }
                            else{
                                fieldElemDiv.find('select,input,textarea').not(':input[type=hidden]').removeAttr('readonly');
                            }
                            }

                            ffItemRowDiv.html(labelElemDiv);
                            ffItemRowDiv.append(fieldElemDiv);
                             
                            sectionElemDiv.append(ffItemRowDiv);
                        }
                    }
                    else if (controltype.toLowerCase() != '')
                    {
                        var addGenField = false; 
                        var isPaymentField=false;
                        var onlyLabelDiv = false;
                         
                        var testModeBlock = $('<input />', { 'class': 'payment-test-mode', html: 'Test Mode' });
                        var istestmode = false;

                         
                        /*general fields*/
                        switch (controltype.toLowerCase()) {
                            /// create GENERALTEXT elements
                            case 'generaltext':
                                ffItemRowDiv.addClass('fw-row');                                  
                                var labelElem = $('<label />', { 'id': elemId, 'lblname': 'text',  'class': 'ff-label ff-general-text-label', 'html': labelHTML ,'data-ishidden': isfieldhidden});
                                
                                
                                labelElemDiv.html(labelElem);
                                
                                onlyLabelDiv = true;
                                addGenField = true;

                                break;

                                /// create ESIGNATURE elements
                            case 'esignature':
                                 
                                var signtype = firstElementByTagName(fieldElement, "signType", true);
                                var signoptions = firstElementByTagName(fieldElement, "signOptions", true);
                                var signlabel = firstElementByTagName(fieldElement, "signLabel", true);
                                var signdate = firstElementByTagName(fieldElement, "signDate", true);
                                var signdatehide = firstElementByTagName(fieldElement, "isDateHidden", true);
                                var signagree = firstElementByTagName(fieldElement, "signAgreeText", true);
                                var signagreehide = firstElementByTagName(fieldElement, "isAgreeHidden", true);
                                var emailverifenabled=firstBooleanElementByTagName(fieldElement, "emailEnabled", false);
                                var emaillabel = firstElementByTagName(fieldElement, "emailLabel", true);
                                 

                                var inputElem = $('<input />', { 'id': 'input' + elemId, 'type': 'hidden', 'lblname': 'Signature', 'class': 'ffd-esignature-input', 'data-signtype': signtype, 'data-signoptions': signoptions, 'data-signlabel': signlabel, 'data-signdate': signdate, 'data-signdatehide': signdatehide, 'data-signagree': signagree, 'data-signagreehide': signagreehide,'data-emailenabled':emailverifenabled,'data-emaillabel':emaillabel });

                                fieldElemDiv.html(inputElem);
                                var signatureComponentItem = $('#DocSignHTMLTemp').clone().html();
                                var signatureIndex = elemId.replace('ESIGNATURE', '');
                                //fieldElemDiv.html(inputElem);
                                fieldElemDiv.append(signatureComponentItem);
                               
                                fieldElemDiv.find('.ffd-esignature-input').attr('id', 'input' + elemId);
                                fieldElemDiv.find('.ffd-esignature').show();
                                fieldElemDiv.find('.main-docsign-wrapper').attr('id', 'elem' + elemId);
                                fieldElemDiv.find('.ff-label').removeAttr('ondblclick');

                                fieldElemDiv.find('.main-docsign-wrapper .ff-typed .docsignWrapper .ffdate').attr('vatt','DATE');
                                

                                assignSignatureElementIds(fieldElemDiv, signatureIndex);
                                 /*WCAG changes*/
                                fieldElemDiv.find('.ff-chkagree label.ff-label').attr('for',fieldElemDiv.find('.ff-chkagree input').attr('id'));
                               // fieldElemDiv.find('.ff-signwrapper').each(function(indx,signWrapElem){
                                    fieldElemDiv.find('.ff-sign-block').each(function(indx,signBlockElem){
                                   var inputId=  $(signBlockElem).find('.ff-col-2 input.ff-type-text').attr('id');
                                   $(signBlockElem).find('.ff-col-1 label.ff-label').attr('for',inputId);
                                    });
                               // });
                                /**/
                                ffItemRowDiv.attr('class','ff-esignature-wrapper');
                                ffItemRowDiv.html(fieldElemDiv.html());
                                sectionElemDiv.append(ffItemRowDiv);
                                break;

                                /// create PAYMENT elements
                            case 'payment':

                                ffItemRowDiv.attr('class', 'ff-payment-wrapper');
                                
                               var tempPaymentIndex=elemId.substring(elemId.indexOf('PAYMENT')+7);
                               var paymentTypePrefixToReplace=getOPaymentTypeVal(fieldAttrType,'PayPal','PayPal','IATS','Stripe','AuthorizeNet');
                               var paymentTypePrefix=getOPaymentTypeVal(fieldAttrType,'FF','FF','FF','FF','FF');
                                 ffItemRowDiv.attr('id', 'lblFFPAYMENT' + tempPaymentIndex);
                                 istestmode = firstBooleanElementByTagName(fieldElement, "testMode", false);
                                  
                                if (istestmode) {
                                    ffItemRowDiv.addClass('ff-test-mode')
                                   
                                }
                                var paymentItem=$('<div/>').html($('#mainMultiPageWrapper').find('#lblliFASTFORMSPAYMENT'+tempPaymentIndex).html());
                          
                                 var paymentItemDiv= paymentItem.find('.field-div-payment');
                                $($(paymentItemDiv).find('.payment-item-row')).each(function (i, ppitemrow) {

                                    if ($(ppitemrow).find('.ff-line-seperator').length > 0) {
                                        if ($(ppitemrow).css('display') != 'none') {
                                            var paymentItemRowDiv = $('<div/>', { 'class': 'ff-item-row payment-seperator-item' });
                                           
                                            paymentItemRowDiv.append($(ppitemrow).html());
                                            ffItemRowDiv.append(paymentItemRowDiv);
                                        }
                                    }
                                    else {
                                        var paymentItemRowDiv = $('<div/>', { 'class': 'ff-item-row payment-field-item' });
                                        var labelHtmlDiv = $('<div/>', { 'class': 'ff-col-1 ff-label-col' });
                                        var fieldHtmlDiv = $('<div/>', { 'class': 'ff-col-2 ff-field-col' });
                                        $(ppitemrow).find('.PPGeneralLabelDiv').find('label.ff-label').removeAttr('data-label-prop');
                                        $(ppitemrow).find('.PPGeneralLabelDiv').find('label.ff-label').removeAttr('ondblclick');
                                        var lblid=$(ppitemrow).find('.PPGeneralLabelDiv').find('label.ff-label').attr('id');
                                        lblid=lblid.replace('FFPayment',paymentTypePrefix);
                                        lblid=lblid.replace(paymentTypePrefixToReplace,paymentTypePrefix);
                                        $(ppitemrow).find('.PPGeneralLabelDiv').find('label.ff-label').attr('id',lblid);
                                        $(ppitemrow).find('.PPGeneralLabelDiv').find('label.ff-label').attr('for',lblid.replace('lbl',''));

                                        labelHtmlDiv.html($(ppitemrow).find('.PPGeneralLabelDiv').html());
                                        var fieldHtml = '';
                                        if($(ppitemrow).find('.PPGeneralFieldDiv input,.PPGeneralFieldDiv label').length>0){
                                        var inputElem=$(ppitemrow).find('.PPGeneralFieldDiv input,.PPGeneralFieldDiv label');
                                        var lid=$(inputElem).attr('id');
                                            console.log(' FFpayment replacement'+lid);
                                            lid=lid.replace('FFPayment',paymentTypePrefix);
                                            lid=lid.replace(paymentTypePrefixToReplace,paymentTypePrefix);
                                            console.log(' FFpayment replacement after'+lid);
                                            $(inputElem).attr('id',lid);
                                            $(inputElem).attr('name',lid);
                                            if($(inputElem).attr('data-pp-name')){
                                            $(inputElem).attr('data-pp-name',lid);
                                            }
                                            }
                                            

                                        if ($(ppitemrow).hasClass('pp-expiry')) {
                                            $(ppitemrow).find('.PPGeneralFieldDiv select').each(function (index, selectElem) {
                                            var lid=$(selectElem).attr('id');
                                            console.log(' FFpayment replacement'+lid);
                                            lid=lid.replace('FFPayment',paymentTypePrefix);
                                            lid=lid.replace(paymentTypePrefixToReplace,paymentTypePrefix);
                                            console.log(' FFpayment replacement after'+lid);
                                            $(selectElem).attr('id',lid);
                                            $(selectElem).attr('name',lid);
                                            if($(selectElem).attr('data-pp-name')){
                                            $(selectElem).attr('data-pp-name',lid);
                                            }
                                                $(selectElem).find('option').each(function (indx, optionelem) {
                                                    if (indx == 0) {
                                                        $(optionelem).attr('value', '');
                                                    }
                                                });
                                            });
                                        }
                                        
                                        fieldHtmlDiv.html($(ppitemrow).find('.PPGeneralFieldDiv').html());

                                        if ($(ppitemrow).css('display') == 'none') {
                                             
                                            paymentItemRowDiv.hide();
                                        }
                                        paymentItemRowDiv.append(labelHtmlDiv);
                                        paymentItemRowDiv.append(fieldHtmlDiv);
                                        ffItemRowDiv.append(paymentItemRowDiv);
                                    }

                                }); 
                                 
                                addGenField = true;
                                isPaymentField = true;
                                break;

                                /// create FILEUPLOAD elements
                            case 'fileupload':
                                var fileIndxId = elemId.replace('FileUploadArea', '');
                                var isrequired = firstBooleanElementByTagName(fieldElement, "required", false);
                                var uploadtochatter = firstBooleanElementByTagName(fieldElement, "uploadToChatter", false);
                                var fieldrequiredmessage = firstElementByTagName(fieldElement, "requiredMessage", true);
                                var allowedfiletypes = firstElementByTagName(fieldElement, "allowedFileTypes", true);
                                var maxfiles = firstElementByTagName(fieldElement, "maxFiles", true); 
                                var attachto = firstElementByTagName(fieldElement, "attachTo", true); 
                                ffItemRowDiv.attr('title', 'File Upload');
                                //labelElemDiv.attr('id', 'divLabel' + elemId);
                                var labelElem = $('<label />', { 'id': 'lblFileUpload' + fileIndxId+'','for':'FileUpload' + fileIndxId, 'lblname': 'File Upload', 'class': 'ff-label ff-fileupload-label', html: labelHTML });
                                labelElemDiv.html(labelElem);

                                var fielUploadItem = $('#generalFieldBox #lblliFILEUPLOADAREA .fieldDiv').clone().html();

                                 if (isrequired)
                                {  
                                 $(labelElemDiv).find('.ff-label').after($('<span/>',{'class':'ff-required-mark','html':'*'}));
                                 }
                                fieldElemDiv.append(fielUploadItem);
                                fieldElemDiv.find('.ff-fileupload-drop-area').attr('data-requiredmessage', fieldrequiredmessage);
                                fieldElemDiv.find('.ff-fileupload-drop-area').attr('data-isrequired', isrequired);
                                fieldElemDiv.find('.ff-fileupload-drop-area').attr('data-ishidden', isfieldhidden);
                                fieldElemDiv.find('.ff-fileupload-drop-area').attr('data-maxfiles', maxfiles);
                                fieldElemDiv.find('.ff-fileupload-drop-area').attr('data-allowedfiletypes', allowedfiletypes);
                                fieldElemDiv.find('.ff-fileupload-drop-area').attr('data-attachto', attachto);
                                
                                fieldElemDiv.find('.ff-fileupload-drop-area').attr('data-uploadtochatter', uploadtochatter);
                                fieldElemDiv.find('.ff-fileupload-drop-area').attr('id', 'FileUploadArea' + fileIndxId);
                                fieldElemDiv.find('.ff-fileupload-drop-area').attr('name', 'FileUploadArea' + fileIndxId);
                                fieldElemDiv.find('.ff-fileupload-drop-area label').attr('id', 'lblFileUpload' + fileIndxId + '_Select');
                                 
                                fieldElemDiv.find('.ff-fileupload-drop-area label').attr('name', 'FileUpload' + fileIndxId+ '_Select');
                                fieldElemDiv.find('.ff-fileupload-drop-area label').attr('for', 'FileUpload' + fileIndxId);
                                fieldElemDiv.find('.ff-fileupload-drop-area input').attr('id', 'FileUpload' + fileIndxId);
                                fieldElemDiv.find('.ff-fileupload-drop-area input').attr('name', 'FileUpload' + fileIndxId);
                                
                                addGenField = true;
                                break;

                                /// create IMAGE elements
                            case 'image':
                                 
                                labelElemDiv.attr('class', 'ff-col-1 ff-image');
                                var labelElem = $('<label />', { 'id': 'lbl' + elemId,'for':elemId, 'lblname': 'Image', 'class': 'ff-label ff-image-label', 'data-ishidden': isfieldhidden });
                                labelElemDiv.html();

                                var imageComponentItem = $('#generalFieldBox .imageGeneralFieldDiv').clone().html();
                                $ImageComponentWrapper = $('<div />', { 'class': 'imageGeneralFieldDiv', 'id': 'imageField' + elemId });
                                $ImageComponentWrapper.append(imageComponentItem);
                                var imgSrc = firstElementByTagName(fieldElement, "imgSrc", true);
                                labelElemDiv.append($ImageComponentWrapper);
                                if (!isNullOrEmpty(imgSrc)) {
                                    imgSrc = unescapeHTMLString(imgSrc);
                                    var imgwidth = firstElementByTagName(fieldElement, "imgWidth", true);
                                    var imgHeight = firstElementByTagName(fieldElement, "imgHeight", true);
                                    var imgAlignment = firstElementByTagName(fieldElement, "alignment", true);
                                     var imgAltTag = firstElementByTagName(fieldElement, "alt", true);
                                    
                                    labelElemDiv.find('.ffse-img-upload-placeholder-editor').show();

                                    var imagElem = $('<img />', { 'id': elemId ,'src':imgSrc});
                                    if (!isNullOrEmpty(imgwidth))
                                    {
                                        imagElem.attr('width', imgwidth);
                                    }
                                    if (!isNullOrEmpty(imgHeight)) {
                                        imagElem.attr('width', imgHeight);
                                    }
                                    if (!isNullOrEmpty(imgAlignment)) {
                                        labelElemDiv.css('text-align', imgAlignment);
                                    }
                                    if (!isNullOrEmpty(imgAltTag)) {
                                        imagElem.attr('alt', imgAltTag);
                                    }

                                    labelElemDiv.html(imagElem);
                                     
                                    addGenField = true;
                                    onlyLabelDiv = true;
                                }
                                 
                                
                                break;

                                /// create CAPTCHA elements
                            case 'captcha':
                                ffItemRowDiv.attr('title', 'Captcha');
                                
                                var labelElem = $('<label />', { 'id': 'lbl'+elemId,'for':elemId, 'lblname': 'Captcha', 'class': 'ff-label ff-captcha-label', 'html': labelHTML });
                                labelElemDiv.html(labelElem);
                                 labelElemDiv.append($('<span/>', { 'class': 'requiredSpan ff-required-mark', 'html': '*' }));
                                //var imgElem = $('<img/>', { 'src': 'https://fastforms.visualantidote.com/Images/captcha.png' });
                                var isreq = firstBooleanElementByTagName(fieldElement, "required", true);
                                var ishidden = firstBooleanElementByTagName(fieldElement, "hiddenField", false);

                                 
                                var inputElem = $('<div />', {  'id': elemId + '', 'name': 'Captcha', 'vatt': fieldtype,   'data-requiredmessage': 'Please enter the text shown in the image above',   'data-isrequired': isreq, 'data-ishidden': isfieldhidden });
                               // fieldElemDiv.html(imgElem);
                                //fieldElemDiv.append('<br/>');
                                fieldElemDiv.addClass('ff-captcha');
                                fieldElemDiv.append(inputElem);
                                
                                addGenField = true;
                                break;

                            default:
                        }
                        if (addGenField) {
                            if (!isPaymentField) {
                                ffItemRowDiv.html(labelElemDiv);
                                if (!onlyLabelDiv) {
                                    ffItemRowDiv.append(fieldElemDiv);
                                }
                                 
                            }
                            if (ffItemRowDiv.hasClass('ff-test-mode'))
                            {
                                sectionElemDiv.append(testModeBlock);
                            }
                            sectionElemDiv.append(ffItemRowDiv);
                        }
                    }
                     /*field parsing ends*/

                });
                if(isSectionRepeat){
               var sectionRepeatWrapper=$('<div/>',{'class':'ff-sec-repeat-wrapper'});
               sectionRepeatWrapper.html(sectionElemDiv.html());
               sectionElemDiv.html(sectionRepeatWrapper);
                }
                sectionElemDiv.prepend(ffSectionItemRowDiv);
                pageElemDiv.append(sectionElemDiv);

            });
            var pageHTML=$('<div/>').append(pageElemDiv);
             formHtml.append(pageHTML.html());
        }
    });

    var formHTMLMain=$('<div/>');
    formHTMLMain.html(formHtml.html());
    return formHTMLMain.html();
}
function getSFieldName(elementId)
{
    var fieldName='';
    if(!isNullOrEmpty(elementId) && elementId.indexOf('.')>0)
    {
     fieldName=elementId.substring(elementId.lastIndexOf('.')+1);
    }
return fieldName;
}
 function getFieldsObjectXML(fieldsXml) {

    var data = safeStringForXML(fieldsXml);
    var $xmlDoc = ($.parseXML('<root>' + data + '</root>'));

    var fieldsObjectXml = '';
    //Reference fields XML
    fieldsObjectXml += '<object>';
    fieldsObjectXml += '<objectOrder>1</objectOrder>';
    fieldsObjectXml += '<name>' + $('#priName').attr('class') + '</name>';
    fieldsObjectXml += '<objectType>Primary</objectType>';
    fieldsObjectXml += '<relationshipType></relationshipType>';
    fieldsObjectXml += '<relatedField></relatedField>';
    //Add fieldsXml String
    fieldsObjectXml += '<fields>';

    $($xmlDoc.getElementsByTagName("OField")).each(function (indx,fieldElement) {
        //check if the object name matches so we know where to put the field
        //we also check if there is no object name - this denotes a general field e.g. file upload
        //which should be included with the primary object anyway            
        var fieldAttrType = '';
                    if (!isNullOrEmpty(fieldElement.getAttribute('type'))) {
                        fieldAttrType = fieldElement.getAttribute('type').toLowerCase();
                    }
        if ($(fieldElement).find('sortableObject').text().trim() == "sortableForRelFields1") {
            fieldsObjectXml += '<field>';
            fieldsObjectXml += '<name>' + getSFieldName($(fieldElement).find("elemId").text() )+ '</name>';
            fieldsObjectXml += '<type>' + $(fieldElement).find("vatt").text() + '</type>';
            fieldsObjectXml += '<hiddenField>' + $(fieldElement).find("hiddenField").text() + '</hiddenField>';

            fieldsObjectXml += '<readOnly>' + $(fieldElement).find("readOnly").text() + '</readOnly>';
            fieldsObjectXml += '<upsert>' + $(fieldElement).find("upsert").text() + '</upsert>';
            if ($(fieldElement).find("listViewId").length > 0) {
                fieldsObjectXml += '<listViewId>' + $(fieldElement).find("listViewId").text() + '</listViewId>';
            }
            if ($(fieldElement).find("listViewObject").length > 0) {
                fieldsObjectXml += '<listViewObject>' + $(fieldElement).find("listViewObject").text() + '</listViewObject>';
            }
            if(fieldAttrType=='olookup'){
            fieldsObjectXml += '<defaultValue>' + $(fieldElement).find("defaultValueId").text() + '</defaultValue>';
            }else{
            fieldsObjectXml += '<defaultValue>' + $(fieldElement).find("defaultValue").text() + '</defaultValue>';
            }
            fieldsObjectXml += '<maxLength>' + $(fieldElement).find("maxLength").text() + '</maxLength>';
            fieldsObjectXml += '<required>' + $(fieldElement).find("required").text() + '</required>';
            fieldsObjectXml += '<requiredMessage>' + $(fieldElement).find("requiredMessage").text() + '</requiredMessage>';
            fieldsObjectXml += '<picklistValues>';
            $(fieldElement).find('picklistValues').find("picklistValue").each(function (i,picklistElem) {
                            fieldsObjectXml += '<picklistValue><value>' + $(picklistElem).attr('value') + '</value></picklistValue>';
                        });
            fieldsObjectXml += '</picklistValues>';
            fieldsObjectXml += '</field>';
        }
        if ($(fieldElement).find('sortableObject').text() == '') {
            if ($(fieldElement).find('type').text() == "CAPTCHA") {
                fieldsObjectXml += '<field>';
                fieldsObjectXml += '<name>' + $(fieldElement).find("elemId").text() + '</name>';
                fieldsObjectXml += '<type>CAPTCHA</type>';
                fieldsObjectXml += '<required>' + $(fieldElement).find("required").text() + '</required>';
                fieldsObjectXml += '<requiredMessage>' + $(fieldElement).find("requiredMessage").text() + '</requiredMessage>';
                fieldsObjectXml += '</field>';
            }
            else if ($(fieldElement).find('controlType').text() == "PAYMENT" ) {
            var paymentFieldName=$(fieldElement).find("elemId").text();
            var tempPaymentIndex='';
            try{
                              tempPaymentIndex=paymentFieldName.substring(paymentFieldName.indexOf('PAYMENT')+7);
                             }catch(err){
                              tempPaymentIndex=tempPaymentIndex.replace('PAYPALPAYMENT','');
                              tempPaymentIndex=tempPaymentIndex.replace('IATSPAYMENT','');
                              tempPaymentIndex=tempPaymentIndex.replace('AUTHORIZENETPAYMENT','');
                              tempPaymentIndex=tempPaymentIndex.replace('STRIPEPAYMENT','');
                              tempPaymentIndex=tempPaymentIndex.replace('FASTFORMSPAYMENT','');
                             }
                fieldsObjectXml += '<field>';
                fieldsObjectXml += '<name>FFPAYMENT' + tempPaymentIndex + '</name>';
                fieldsObjectXml += '<type>PAYMENT</type>';
                fieldsObjectXml += '<required>' + $(fieldElement).find("required").text() + '</required>';
                fieldsObjectXml += '<requiredMessage>' + $(fieldElement).find("requiredMessage").text() + '</requiredMessage>';
                fieldsObjectXml += '</field>';
            }
            else if ($(fieldElement).find('type').text() == "ESIGNATURE") {
                fieldsObjectXml += '<field>';
                fieldsObjectXml += '<name>' + $(fieldElement).find("elemId").text() + '</name>';
                fieldsObjectXml += '<type>ESIGNATURE</type>';
                fieldsObjectXml += '<emailVerificationEnabled>' + getSafeBoolean($(fieldElement).find("emailEnabled").text(),false )+ '</emailVerificationEnabled>';
                 fieldsObjectXml+='<signatureEmailFrom>'+FFUserEmail+'</signatureEmailFrom>';
                fieldsObjectXml += '<required>' + $(fieldElement).find("required").text() + '</required>';
                fieldsObjectXml += '<requiredMessage>' + $(fieldElement).find("requiredMessage").text() + '</requiredMessage>';
                fieldsObjectXml += '</field>';
            }
            else if ($(fieldElement).find('type').text() == 'FILE') {
                var elemId = firstElementByTagName(fieldElement, "elemId", true);
                var isrequired = firstBooleanElementByTagName(fieldElement, "required", false);
                var uploadtochatter = firstBooleanElementByTagName(fieldElement, "uploadToChatter", false);
                var fieldrequiredmessage = firstElementByTagName(fieldElement, "requiredMessage", true);
                var allowedfiletypes = firstElementByTagName(fieldElement, "allowedFileTypes", true);
                var attachto = firstElementByTagName(fieldElement, "attachTo", true);
                var maxfiles = firstElementByTagName(fieldElement, "maxFiles", true);
                var fileName = firstElementByTagName(fieldElement, "fileName", true);
                var fieluploadname=elemId.replace('Area','');
                fieldsObjectXml += '<field>';
                fieldsObjectXml += '<name>' + fieluploadname + '</name>';
                fieldsObjectXml += '<type>FILEUPLOAD</type>';
                fieldsObjectXml += '<allowedFileTypes>' + allowedfiletypes + '</allowedFileTypes>';
                fieldsObjectXml += '<attachTo>' + attachto + '</attachTo>';                
                fieldsObjectXml += '<uploadToChatter>' + uploadtochatter + '</uploadToChatter>';
                fieldsObjectXml += '<maxFiles>' + maxfiles + '</maxFiles>';
                fieldsObjectXml += '<required>' + isrequired + '</required>';
                fieldsObjectXml += '<requiredMessage>' + fieldrequiredmessage + '</requiredMessage>';
                fieldsObjectXml += '<fileName>' + fileName + '</fileName>';
                fieldsObjectXml += '</field>';
            }

        }
    });
    fieldsObjectXml += '</fields>';
    fieldsObjectXml += '</object>';

 $('.available-fields-block-wrapper .list-toggle-div-wrap').each(function (indx, wrapperDiv) {
        var relindx = indx;
        relindx++;
        var secondaryObjectId = selectRelObjIdByIndex(relindx);
        var ListRelVarElem = $('#' + $(wrapperDiv).attr('id'));
        var sortableFieldClassName = safeStringValue($(ListRelVarElem).find('ul.dropfields').attr('id'), '');
        fieldsObjectXml += '<object>';
        fieldsObjectXml += '<objectOrder>'+$(wrapperDiv).find(".obj-tab-number").text()+'</objectOrder>';
        //data-reftorectrim
       // fieldsObjectXml += '<name>' + secondaryObjectId.substring(secondaryObjectId.indexOf('(') + 1, secondaryObjectId.indexOf(')')) + '</name>';
        fieldsObjectXml += '<objectType>Secondary</objectType>';
        
        
        var childObjectClass = '';
        if ($(wrapperDiv).attr('data-childclass') != undefined && $(wrapperDiv).attr('data-childclass') != "") {
            childObjectClass = safeStringValue($(wrapperDiv).attr('data-childclass'), '');
            childObjectClass=childObjectClass.trim();
        }

        //if ($(ListRelVarElem).find('.objName').text().indexOf('-') > 0) {
        //    fieldsObjectXml += '<relationshipType>Master</relationshipType>';
        //} else {
            //if(getImg != undefined){
            if (childObjectClass != '') {
            var childObjName=getSafeRelObjAttribute(indx,'data-objname','');
            fieldsObjectXml += '<name>'+childObjName+'</name>';
                fieldsObjectXml += '<relationshipType>Detail</relationshipType>';
                var childObjFieldName=getSafeRelObjAttribute(indx,'data-refidname','');
                fieldsObjectXml += '<relatedField>' + childObjFieldName + '</relatedField>';
                if($(wrapperDiv).hasClass('repeat')){
                    fieldsObjectXml += '<repeat>true</repeat>';
                }else{
                    fieldsObjectXml += '<repeat>false</repeat>';
                }
            } else {
             var lookupObjName=getSafeRelObjAttribute(indx,'data-reftorectrim','');
            fieldsObjectXml += '<name>'+lookupObjName+'</name>';
                fieldsObjectXml += '<relationshipType>Lookup</relationshipType>';
                var lookupObjFieldName=getSafeRelObjAttribute(indx,'data-objname','');
                fieldsObjectXml += '<relatedField>' + lookupObjFieldName + '</relatedField>';
                
            }
        //}



        //Add fieldsXml String
        fieldsObjectXml += '<fields>';
        $($xmlDoc.getElementsByTagName("OField")).each(function (indx, fieldElement) {
var fieldAttrType = '';
                    if (!isNullOrEmpty(fieldElement.getAttribute('type'))) {
                        fieldAttrType = fieldElement.getAttribute('type').toLowerCase();
                    }
            if (!isNullOrEmpty($(fieldElement).find('sortableObject').text().trim()) && $(fieldElement).find('sortableObject').text().trim() == sortableFieldClassName) {

                var colorcode = $(fieldElement).find("colorCode").text();
                if (childObjectClass != '') {
                        if(!isNullOrEmpty(colorcode)){
                           colorcode=colorcode.trim();
                           }
                    if (childObjectClass == colorcode) {
                        fieldsObjectXml += '<field>';
                        //var fieldname = $(fieldElement).find("elemId").text().replace('.' + colorcode + '.', '.');
                        fieldsObjectXml += '<name>' + getSFieldName($(fieldElement).find("elemId").text() ) + '</name>';
                        fieldsObjectXml += '<type>' + $(fieldElement).find("vatt").text() + '</type>';
                        fieldsObjectXml += '<hiddenField>' + $(fieldElement).find("hiddenField").text() + '</hiddenField>';
                        fieldsObjectXml += '<readOnly>' + $(fieldElement).find("readOnly").text() + '</readOnly>';
                        fieldsObjectXml += '<upsert>' + $(fieldElement).find("upsert").text() + '</upsert>';
                        if ($(fieldElement).find("listViewId").length > 0) {
                            fieldsObjectXml += '<listViewId>' + $(fieldElement).find("listViewId").text() + '</listViewId>';
                        }
                        if ($(fieldElement).find("listViewObject").length > 0) {
                            fieldsObjectXml += '<listViewObject>' + $(fieldElement).find("listViewObject").text() + '</listViewObject>';
                        }
                         if(fieldAttrType=='olookup'){
                            fieldsObjectXml += '<defaultValue>' + $(fieldElement).find("defaultValueId").text() + '</defaultValue>';
                            }else{
                            fieldsObjectXml += '<defaultValue>' + $(fieldElement).find("defaultValue").text() + '</defaultValue>';
                            }
                         
                        fieldsObjectXml += '<maxLength>' + $(fieldElement).find("maxLength").text() + '</maxLength>';
                        fieldsObjectXml += '<required>' + $(fieldElement).find("required").text() + '</required>';
                        fieldsObjectXml += '<requiredMessage>' + $(fieldElement).find("requiredMessage").text() + '</requiredMessage>';
                        fieldsObjectXml += '<picklistValues>';
                        $(fieldElement).find('picklistValues').find("picklistValue").each(function (i,picklistElem) {
                            fieldsObjectXml += '<picklistValue><value>' + $(picklistElem).attr('value') + '</value></picklistValue>';
                        });
                        fieldsObjectXml += '</picklistValues>';
                        fieldsObjectXml += '</field>';
                    }
                } else {
                    fieldsObjectXml += '<field>';
                    fieldsObjectXml += '<name>' + getSFieldName($(fieldElement).find("elemId").text() ) + '</name>';
                    fieldsObjectXml += '<type>' + $(fieldElement).find("vatt").text() + '</type>';
                    fieldsObjectXml += '<hiddenField>' + $(fieldElement).find("hiddenField").text() + '</hiddenField>';
                    fieldsObjectXml += '<readOnly>' + $(fieldElement).find("readOnly").text() + '</readOnly>';
                    fieldsObjectXml += '<upsert>' + $(fieldElement).find("upsert").text() + '</upsert>';
                    if ($(fieldElement).find("listViewId").length > 0) {
                        fieldsObjectXml += '<listViewId>' + $(fieldElement).find("listViewId").text() + '</listViewId>';
                    }
                    if ($(fieldElement).find("listViewObject").length > 0) {
                        fieldsObjectXml += '<listViewObject>' + $(fieldElement).find("listViewObject").text() + '</listViewObject>';
                    }
                     if(fieldAttrType=='olookup'){
                        fieldsObjectXml += '<defaultValue>' + $(fieldElement).find("defaultValueId").text() + '</defaultValue>';
                        }else{
                        fieldsObjectXml += '<defaultValue>' + $(fieldElement).find("defaultValue").text() + '</defaultValue>';
                        }
                    
                    fieldsObjectXml += '<maxLength>' + $(fieldElement).find("maxLength").text() + '</maxLength>';
                    fieldsObjectXml += '<required>' + $(fieldElement).find("required").text() + '</required>';
                    fieldsObjectXml += '<requiredMessage>' + $(fieldElement).find("requiredMessage").text() + '</requiredMessage>';
                    fieldsObjectXml += '<picklistValues>';
                    $(fieldElement).find('picklistValues').find("picklistValue").each(function (i,picklistElem) {
                            fieldsObjectXml += '<picklistValue><value>' + $(picklistElem).attr('value') + '</value></picklistValue>';
                        });
                    fieldsObjectXml += '</picklistValues>';
                    fieldsObjectXml += '</field>';
                }
            }
        });

        fieldsObjectXml += '</fields>';
        fieldsObjectXml += '</object>';

    });
   
    return fieldsObjectXml;
}