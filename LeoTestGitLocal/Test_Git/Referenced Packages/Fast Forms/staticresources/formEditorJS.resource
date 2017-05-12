/*Methods from FormEditor Page*/
/*Refresh child records start*/
function refreshChildRecordsFieldLi() {
    $('.list-toggle-div-wrap').each(function (indx, wrapperDiv) {

        if ($(wrapperDiv).attr('data-childclass') != undefined && $(wrapperDiv).attr('data-childclass') != "") {
            var sortableClassName = '';
            var clsName = safeStringValue($(wrapperDiv).attr('data-childclass'), '');
            var relListId = $(wrapperDiv).attr('id');
            var classnameindx = "";
            if (!isNullOrEmpty(relListId)) {
                classnameindx = relListId.replace('ListMainRel', '');
                if (!isNullOrEmpty(classnameindx)) {

                    sortableClassName = 'sortableForRelFields' + classnameindx;
                }
            }
            if (!isNullOrEmpty(sortableClassName)) {
                $("#mainMultiPageWrapper .formFieldUl li." + sortableClassName).each(function () {

                    var listnm = $(this).find('.obj-info').attr('data-listname');
                    var colorcode = $(this).find('.obj-info').attr('data-colorcode');

                    if (!isNullOrEmpty(colorcode)) {
                        $(this).find('.obj-info').attr('data-listname', sortableClassName);
                        RemoveAllClassColorCodes(this);
                        var previousClass = colorcode;
                        $(this).removeClass(previousClass);
                        $(this).addClass(clsName);
                        var elemId = $(this).find(".fieldDiv").find('>select,>input,input.ff-input-type,>textarea').attr('id');
                        console.log(' previousClass:' + previousClass + ' clsName:' + clsName);

                        var newelemId = elemId.replace('.' + previousClass, '.' + clsName);
                        var finalElemId = newelemId;
                        var newelemIdWODot = newelemId.replace(/\./g, '');


                        $(this).find('.obj-info').attr('data-colorcode', clsName);
                        var newElemIdWOCodenDot = replaceAllColorCodeFromId(newelemId);
                        newElemIdWOCodenDot = newElemIdWOCodenDot.replace(/\./g, '');
                        $(this).find(".labelDiv label.ff-label").attr('id', 'lbl' + newElemIdWOCodenDot);
                        var mainFieldElement = $(this).find(".fieldDiv").find('>select,>input,input.ff-input-type,input[type=hidden],>textarea');

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


                        $(this).attr('id', 'lblli' + newelemIdWODot);


                    }

                });
            }

        }
    });

    $('.form-information .secName-wrap').each(function (indx, objItem) {
        if ($(objItem).hasClass('object-detail')) {
            var relIndex = indx + 2;
            if ($(objItem).hasClass('is-repeat')) {
                var ulItem = $('<ul/>');
                if ($("#mainMultiPageWrapper .formFieldUl li.sortableForRelFields" + relIndex).first().length > 0 && !$("#mainMultiPageWrapper .formFieldUl li.sortableForRelFields" + relIndex).first().parents('.formSectionUl').hasClass('section-repeat')) {
                    var parentULElem = $("#mainMultiPageWrapper .formFieldUl li.sortableForRelFields" + relIndex).first().parent();
                    $("#mainMultiPageWrapper .formFieldUl li.sortableForRelFields" + relIndex).each(function (id, liItem) {
                        $(ulItem).append($(liItem).clone());
                        $(this).remove();
                    });

                    var lastFieldUlLiItem = $("#mainMultiPageWrapper .form-canvas-multi-page-inner .formSectionUl:last-child .formFieldUl").last();
                    if ($("#mainMultiPageWrapper .form-canvas-multi-page-inner .formSectionUl:last-child .formFieldUl").last().find('>li.fieldLi').length > 0) {
                        addNewSectionItem($(lastFieldUlLiItem).parents('.fc-multi-page-item').find('>.add-newsection-box>a'), false);
                    }

                    var sectionUlElem = $('#mainMultiPageWrapper .form-canvas-multi-page-inner .formSectionUl').last();
                    var childIndx = $(objItem).attr('data-relobj');
                    $(sectionUlElem).attr('data-childclass', colorTagArray[childIndx]);
                    $(sectionUlElem).attr('data-sortableclass', 'sortableForRelFields' + relIndex);
                    $(sectionUlElem).addClass('section-repeat')
                    $(sectionUlElem).find('.formFieldUl').append($(ulItem).html());
                }
            } else {
                if ($("#mainMultiPageWrapper .formFieldUl li.sortableForRelFields" + relIndex).first().length > 0) {
                    var formSectionUlElem = $("#mainMultiPageWrapper .formFieldUl li.sortableForRelFields" + relIndex).first().parents('.formSectionUl');
                    $(formSectionUlElem).removeClass('section-repeat');
                    $(formSectionUlElem).removeAttr('data-childclass');
                    $(formSectionUlElem).removeAttr('data-sortableclass');
                }
            }
            isChangesMadeInForm = true;
        }
    });
    $("#mainMultiPageWrapper .formFieldUl li.fieldLi:not(.generalSortableForFields)").each(function (index, fieldLiElem) {

        for (indx = $('.list-toggle-div-wrap').length + 1; indx < 25; indx++) {
            var sortableClassName = 'sortableForRelFields' + indx;
            if ($(fieldLiElem).hasClass(sortableClassName)) {
                /*to remove extra li items  which are not belong to any related object anymore */
                $(fieldLiElem).remove();
            }
        }
    });
    $("#mainMultiPageWrapper .formFieldUl li.fieldLi:not(.generalSortableForFields)").each(function (index, fieldLiElem) {
        var fieldLiClass = $(fieldLiElem).attr("class");

        var liIsChildObject = false;
        if (!isNullOrEmpty($(fieldLiElem).find('.obj-info').attr('data-colorcode'))) {
            liIsChildObject = true;
        }
        var listid = $(fieldLiElem).find('.obj-info').attr('data-listname');

        if (!isNullOrEmpty(listid)) {
            if (liIsChildObject) {
                var datachildclass = $('#' + listid).parents('.list-toggle-div-wrap').attr('data-childclass');
                var elemid = $(fieldLiElem).find('.fieldDiv').find('>select,>input,input.ff-input-type,input[type=hidden],>textarea').attr('id');
                if (!isNullOrEmpty(datachildclass) && $(fieldLiElem).hasClass(datachildclass) && !isNullOrEmpty(elemid) && elemid.split('.').length == 3 && elemid.split('.')[1] != $('#' + listid).parents('.list-toggle-div-wrap').find('.objName').attr('id')) {
                    /*to remove li items  which are not belong to any related child object */
                    $(fieldLiElem).remove();
                }
            }
            else if (!liIsChildObject) {

                var elementName = $(fieldLiElem).attr("title");
                var lookupobjid = $('#' + listid).parents('.list-toggle-div-wrap').find('.objName').attr('id');
                if (!isNullOrEmpty(elementName) && $('#' + listid).parents('.list-toggle-div-wrap').find('.objName').text() == elementName.replace('(Lookup)', "(" + lookupobjid + ")")) {
                    /*to remove li items  which are not belong to any related lookup object */
                    $(fieldLiElem).remove();
                }

            }
        }
    });

    $('.availableHeaderDiv').removeClass('activeTab');
    $('.genlist-toggle-div-wrap').show();
    refreshRelatedObjectInfo('.select-secondary-element-wrapper');

}
/*Refresh child records end*/
function refreshRelatedObjectInfo(parentMainWrapper) {

    var selectHTML = getRelatedObjSelectOptionHTML();
    $(parentMainWrapper).find('.secondary-object-block').each(function (indx, selectParentDiv) {
        restructureRelatedObjSelectElement($(selectParentDiv).find('select.select-secondary-element'), selectHTML);
        $(selectParentDiv).find('.select2-container.select-secondary-element a.select2-choice').removeClass('ff-repeat');
        var dataRelIndex = $(selectParentDiv).find('select.select-secondary-element').attr('data-detail-index');
        if (!isNullOrEmpty(dataRelIndex) && $('.form-information').find('.object-detail.relobj-' + dataRelIndex).hasClass('is-repeat')) {
            $(selectParentDiv).find('input.chkbx-repeating').prop('checked', true);
        }
    });

    setColorTag();
}

function disableSelectLookupOption() {
    var lookupSelected = [];
    $('.select-secondary-element-wrapper .secondary-object-block select').each(function (indx, selectElement) {
        if ($(selectElement).find('option:selected').attr('name') == 'lookup') {
            // lookupSelected.push({"order":indx,"svalue":$(selectElement).val()});
            lookupSelected.push($(selectElement).val());
        }
    });
    $('.select-secondary-element-wrapper .secondary-object-block select option').each(function (indx, optionelem) {
        var optgrpclass = $(optionelem).parent().attr('class');
        if (!isNullOrEmpty(optgrpclass) && optgrpclass == 'LookupOption') {
            $(optionelem).removeAttr('disabled', 'disabled');
            $(optionelem).removeClass('display-none');
        }
    });

    $('.select-secondary-element-wrapper .secondary-object-block select').each(function (selindx, selectElement) {
        $(selectElement).find('optgroup').each(function (index, optgroup) {
            var optgrpclass = $(optgroup).attr('class');
            if (!isNullOrEmpty(optgrpclass) && optgrpclass == 'LookupOption') {
                $(optgroup).find('option').each(function (indx, optionelem) {

                    if (!$(optionelem).is(':selected') && $.inArray($(optionelem).val(), lookupSelected) >= 0) {


                        $(optionelem).attr('disabled', 'disabled');
                        $(optionelem).addClass('display-none');

                    }
                    else {

                    }
                });
            }
        });

    });
}
function createRelJSONObj(relatedObjectName) {
    var data = { "object": relatedObjectName };
    return data;
}

function selectSecNameIdByIndex(senderCount) {
    var idstr = "";

    $(".ObjectName span.secName").each(function (index) {
        if (index == senderCount) {

            idstr = $(this).attr('id');
        }

    });
    return idstr;
}
function selectSecNameTextByIndex(senderCount) {
    var idstr = "";

    $(".ObjectName span.secName").each(function (index) {
        if (index == senderCount) {

            idstr = $(this).text();
        }

    });
    return idstr;
}
function selectRelObjIdByIndex(senderCount) {
    var idstr = "";

    $(".ObjectName span.secName").each(function (index) {
        if ((index + 1) == senderCount) {

            idstr = $(this).attr('id');
        }

    });
    return idstr;
}
function getSafeRelObjAttribute(senderCount, attrName, defaultValue) {
    var returnvalue = defaultValue;
    try {
        var index = senderCount;

        if ($($(".ObjectName span.secName")[index]).length > 0) {
            returnvalue = $($(".ObjectName span.secName")[index]).attr(attrName);
        }
    }
    catch (err) {
        console.log('Attribute value not found');
    }
    return returnvalue;
}
function selectRelObjTextByIndex(senderCount) {
    var idstr = "";

    $(".ObjectName span.secName").each(function (index) {
        if ((index + 1) == senderCount) {

            idstr = $(this).text();
        }

    });
    return idstr;
}
function selectSecNameHtmlByIndex(senderCount) {
    var idstr = "";

    $(".ObjectName span.secName").each(function (index) {
        if (index == senderCount) {

            idstr = $(this).html();
        }

    });
    return idstr;
}
function selectRelObjDataAttrByIndex(senderCount, attrName) {
    var idstr = "";

    $(".ObjectName span.secName").each(function (index) {
        if ((index + 1) == senderCount) {

            idstr = $(this).attr(attrName);
        }

    });
    return idstr;
}
function isSecNameElemExistsByIndex(senderCount) {
    var isexists = false;

    if ($(".ObjectName span.secName").length > senderCount) {
        isexists = true;
    }


    return isexists;
}
function RemoveAllClassColorCodes(elem) {
    $(elem).removeClass('A');
    $(elem).removeClass('B');
    $(elem).removeClass('C');
    $(elem).removeClass('D');
    $(elem).removeClass('E');
    $(elem).removeClass('F');
    $(elem).removeClass('G');
    $(elem).removeClass('H');
    $(elem).removeClass('I');
    $(elem).removeClass('J');
    $(elem).removeClass('K');
    $(elem).removeClass('L');
    $(elem).removeClass('M');
    $(elem).removeClass('N');
}
function replaceAllColorCodeFromId(elemId) {
    // replcae child class characters from id
    var returnId = elemId;
    if (!isNullOrEmpty(returnId)) {

        returnId = returnId.replace('.A.', '.');
        returnId = returnId.replace('.B.', '.');
        returnId = returnId.replace('.C.', '.');
        returnId = returnId.replace('.D.', '.');
        returnId = returnId.replace('.E.', '.');
        returnId = returnId.replace('.F.', '.');
        returnId = returnId.replace('.G.', '.');
        returnId = returnId.replace('.H.', '.');
        returnId = returnId.replace('.I.', '.');
        returnId = returnId.replace('.J.', '.');
        returnId = returnId.replace('.K.', '.');
        returnId = returnId.replace('.L.', '.');
        returnId = returnId.replace('.M.', '.');
        returnId = returnId.replace('.N.', '.');
    }
    return returnId;
}
function removeColorCodes(elemtext) {
    var elemtxt = elemtext;
    if (!isNullOrEmpty(elemtext)) {
        elemtxt = elemtxt.replace(' A', ' ');
        elemtxt = elemtxt.replace(' B', ' ');
        elemtxt = elemtxt.replace(' C', ' ');
        elemtxt = elemtxt.replace(' D', ' ');
        elemtxt = elemtxt.replace(' E', ' ');
        elemtxt = elemtxt.replace(' F', ' ');
        elemtxt = elemtxt.replace(' G', ' ');
        elemtxt = elemtxt.replace(' H', ' ');
        elemtxt = elemtxt.replace(' I', ' ');
        elemtxt = elemtxt.replace(' J', ' ');
        elemtxt = elemtxt.replace(' K', ' ');
        elemtxt = elemtxt.replace(' L', ' ');
        elemtxt = elemtxt.replace(' M', ' ');
        elemtxt = elemtxt.replace(' N', ' ');
    }
    return elemtxt;
}
function isIdHasChildColorCode(elemtext) {
    console.log('listname-- ' + elemtext);
    var returnflag = false;
    if (!isNullOrEmpty(elemtext) && colorTagArray.indexOf(elemtext + '') >= 0) {
        returnflag = true;
    }
    return returnflag;
}
function resetSavedButton() {
    isChangesMadeInForm = true;
}
function isNumber(n) {
    return (parseFloat(n) == n);
}
function fancydropdowntoggle(dv) {
    $('#limitValue').focus();
    var myRegExp = /\.[0-9a-z]+$/i;
    if ($('#customfltype').val() == "") {
        $(dv).next().toggle();
        $(dv).next().next().toggle();
    } else {
        if (myRegExp.test($('#customfltype').val())) {
            $(dv).next().toggle();
            $(dv).next().next().toggle();
            //isChangesMadeInForm = true;    
        } else {
            $('.ExCol').attr('src', ffcommonResuorceUrl + '/iconimages/SelectArrowDown.png');
            $("#customfltype").next().remove();
            $("#selectedfiletypes").val('');
            $("#customfltype").after('<span style="color:red;">Please provide comma-separated extensions (e.g. .doc, .txt)</span>');
            $("#customfltype").css('border', '1px solid red');
            $("#customfltype").focus();
        }
    }

    if ($('.fancydropdown').css('display') != 'none') {
        $('.fancyheader').addClass('addFancy');
        $('.fancydropdown').addClass('addFancyTop');
        $('.fancydropdownbottom').addClass('addFancyBottom');
        $('.ExCol').attr('src', ffcommonResuorceUrl + '/iconimages/SelectArrowUp.png');
    } else {
        $('.fancyheader').removeClass('addFancy');
        $('#trForFileField td').removeAttr('style');
        $('.fancyheader').attr('title', $("#selectedfiletypes").val());
        $('.ExCol').attr('src', ffcommonResuorceUrl + '/iconimages/SelectArrowDown.png');
    }


    //Dropdown
    $(".flChk").click(function () {
        var ck = '';
        var totCheck = 0;
        var getCheck = 0;
        $(".flChk").each(function () {
            totCheck += 1;
            if ($(this).is(":checked")) {
                ck += $(this).val() + ",";
            } else {
                getCheck += 1;
            }
        });
        if ($('#customfltype').val() == "") {
            $("#selectedfiletypes").val(ck.slice(0, -1));
            $('.fancyheader span').text(ck.slice(0, -1))
        } else {
            ck += $("#customfltype").val();
            $("#selectedfiletypes").val(ck);
            $('.fancyheader span').text(ck)
        }
        if (totCheck == getCheck) {
            $('.fancyheader span').text("All");
            $("#customfltype").val('');
        }
        addLabel($(this));
        resetSavedButton();

    });
    $("#customfltype").bind("change", function () {

        $("#selectedfiletypes").val($(this).val());
        $("#customfltype").css('border', 'none');
        $("#customfltype").next().remove();
        var ck = '';
        var isGet = false;
        $(".flChk").each(function () {
            if ($(this).is(":checked")) {
                ck += $(this).val() + ",";
                isGet = true;
            }
        });
        if ($('.fancyheader span').text() == "") {
            $('.fancyheader span').text("All");
        }
        var myRegExp = /\.[0-9a-z]+$/i;
        if ($('#customfltype').val() == "") {
            $("#selectedfiletypes").val(ck.slice(0, -1));
        } else {
            if (myRegExp.test($('#customfltype').val())) {
                ck += $("#customfltype").val() + ',';
                $("#selectedfiletypes").val(ck.slice(0, -1));
                $('.fancyheader span').text($("#selectedfiletypes").val());
                isFFValid = true;

                addLabel($(this));

            } else {
                $("#selectedfiletypes").val('');
                $("#customfltype").after('<span style="color:red;">Please provide comma-separated extensions (e.g. .doc, .txt)</span>');
                $("#customfltype").css('border', '1px solid red');
                $("#customfltype").focus();
                isFFValid = false;

            }
        }
    });

}

function resetFloat() {
    resetScroll();

}

function scrollAvailableDiv() {
    var margintop = 140;
    if (msieversion() > 0 && !$("#mainDiv").hasClass('msIE')) {
        $("#mainDiv").addClass('msIE');
    }
    $(window).scroll(function () {

        var legendOffset = $('.form-editor-title-box').offset().top + $('.form-editor-title-box').height();///$('#headerPanel').offset().top+$('#headerPanel').height()+100;
        var headerLegendOffset = $('#sfff-form-editor').offset().top;
        var scroll = $(this).scrollTop();
        var formCanvasBottom = $('#sfff-form-editor .main-content-holder').offset().top + $('.main-content-holder').height();
        var availableFieldBottom = $('#availableFieldBox').offset().top + $('#availableFieldBox').height() - 1;

        if (scroll <= legendOffset || legendOffset == 0) {

            if ($('#sfff-form-editor .main-content-holder').hasClass('floating-sidebar')) {
                $('#availableFieldBox').css({
                    'position': 'relative',
                    'top': 'auto',
                    'margin-top': 0
                });
                $('.form-floating-actions').hide();
                $('#sfff-form-editor .main-content-holder').removeClass('floating-sidebar');
            }

        }

        else {
            if (scroll > headerLegendOffset) {



                $('#availableFieldBox').css({
                    'position': 'fixed',
                    'top': 0,
                    'margin-top': 1
                });
            }
            else {
                $('#availableFieldBox').css({
                    'position': 'relative',
                    'top': 'auto',
                    'margin-top': 0
                });
            }

            if (!$('#sfff-form-editor .main-content-holder').hasClass('floating-sidebar')) {


                $('#sfff-form-editor .main-content-holder').addClass('floating-sidebar');
                $('.form-floating-actions').show();
            }

        }
    });
}
function setElementIdWithIndx(elemSource, elemIndx, prefix) {
    if (!isNullOrEmpty($(elemSource).attr('id'))) {
        $(elemSource).attr('id', prefix + $(elemSource).attr('id') + elemIndx);
    }
}
function setElementNameWithIndx(elemSource, elemIndx, prefix) {
    if (!isNullOrEmpty($(elemSource).attr('name'))) {
        $(elemSource).attr('name', prefix + $(elemSource).attr('name') + elemIndx);
    }
}
function assignSignatureElementIds(parentElement, signatureIndex) {
    setElementIdWithIndx($(parentElement).find('.main-docsign-wrapper .ff-chkagree input'), signatureIndex, '');
    setElementIdWithIndx($(parentElement).find('.main-docsign-wrapper .ff-email-verification .ff-col-2 .ff-type-text'), signatureIndex, '');
    $(parentElement).find('.ff-signwrapper').each(function (ind, signElement) {
        var signoptclass = 'signT';
        if ($(signElement).hasClass('ff-drawn')) {
            signoptclass = 'signD';
        }

        setElementIdWithIndx($(signElement).find('.docsignWrapper .ffsignature'), signatureIndex, signoptclass);
        setElementIdWithIndx($(signElement).find('.docsignWrapper .ffdate'), signatureIndex, signoptclass);
        setElementIdWithIndx($(signElement).find('.docsignWrapper .outputSignedName'), signatureIndex, signoptclass);
        setElementIdWithIndx($(signElement).find('.docsignWrapper .outputSignedDate'), signatureIndex, signoptclass);
        setElementNameWithIndx($(signElement).find('.docsignWrapper .outputSignedName'), signatureIndex, signoptclass);
        setElementNameWithIndx($(signElement).find('.docsignWrapper .outputSignedDate'), signatureIndex, signoptclass);

    });
}
function setDefaultSignatureElementValues(inputSignatureElement) {
    // var inputSignatureElement=ui.item.find('.eSignatureFieldDiv .ffd-esignature-input');
    setInputAttributeName(inputSignatureElement, 'data-signtype', 'full');
    setInputAttributeName(inputSignatureElement, 'data-signoptions', 'typed');
    setInputAttributeName(inputSignatureElement, 'data-signlabel', 'Full Name');
    setInputAttributeName(inputSignatureElement, 'data-signdate', 'Date');
    setInputAttributeName(inputSignatureElement, 'data-signdatehide', 'false');
    setInputAttributeName(inputSignatureElement, 'data-signagreehide', 'true');
    setInputAttributeName(inputSignatureElement, 'data-signagree', 'I agree to terms and services');
    setInputAttributeName(inputSignatureElement, 'data-emailenabled', 'false');
    setInputAttributeName(inputSignatureElement, 'data-emaillabel', 'Email');
}
function getAttributeNameIfExists(elemSource, attrName, defaultvalue) {
    var stringReturn = defaultvalue;
    if (!isNullOrEmpty($(elemSource).attr(attrName))) {
        stringReturn = $(elemSource).attr(attrName);
    }
    return stringReturn;
}
function setInputAttributeName(elemSource, attrName, elemvalue) {
    $(elemSource).attr(attrName, elemvalue);
}
function resetESignatureElement(elemSource, isAutoSave) {
    var inputSignatureElement = $(elemSource).find('.eSignatureFieldDiv .ffd-esignature-input');
    var signType = getAttributeNameIfExists(inputSignatureElement, 'data-signtype', 'full');

    var signOptions = getAttributeNameIfExists(inputSignatureElement, 'data-signoptions', 'typed');
    var signLabel = getAttributeNameIfExists(inputSignatureElement, 'data-signlabel', 'Full Name');
    var signDate = getAttributeNameIfExists(inputSignatureElement, 'data-signdate', 'Date');
    var signDateHide = getAttributeNameIfExists(inputSignatureElement, 'data-signdatehide', 'false');
    var signAgreeHide = getAttributeNameIfExists(inputSignatureElement, 'data-signagreehide', 'true');
    var signAgree = getAttributeNameIfExists(inputSignatureElement, 'data-signagree', 'I agree to terms and services');
    var signEmailLabel = getAttributeNameIfExists(inputSignatureElement, 'data-emaillabel', 'Email');
    var signEmailEnabled = getAttributeNameIfExists(inputSignatureElement, 'data-emailenabled', 'false');
    var options = {
        name: '.ffsignature',
        penColour: '#052942',
        drawOnly: false,
        typed: '.typedSignName',
        output: '.outputSignedName',
        drawIt: '.ffdrawIt a',
        sig: 'docsignWrapper',
        clear: '.ffclearButton a',
        canvas: '.signPadName',
        onBeforeValidate: 'validateDocSign',
        errorMessage: 'please provide a signature',
        errorMessageDraw: 'please sign in this block',
        errorClass: 'ff-error',
        validateFields: false
    };
    var optionsDate = {
        name: '.ffdate',
        penColour: '#052942',
        drawOnly: false,
        typed: '.typedSignDate',
        output: '.outputSignedDate',
        drawIt: '.ffdrawIt a',
        sig: 'docsignWrapper',
        clear: '.ffclearButton a',
        canvas: '.signPadDate',
        onBeforeValidate: 'validateDocSign',
        errorMessage: 'please provide a date',
        errorMessageDraw: 'please provide a date',
        errorClass: 'ff-error',
        validateFields: false
    };
    if (signType == 'initials') {

        $(elemSource).find('.ff-signwrapper.ff-typed .doc-sign-name .ffsignature').attr('maxlength', 6);
        $(elemSource).find('.ff-signwrapper.ff-typed .doc-sign-name .docsignWrapper .signPadName').attr('width', '120');
        $(elemSource).find('.ff-signwrapper.ff-drawn .doc-sign-name .docsignWrapper .signPadName').attr('width', '120');
    }
    else {
        $(elemSource).find('.ff-signwrapper.ff-typed .doc-sign-name .ffsignature').removeAttr('maxlength');
        $(elemSource).find('.ff-signwrapper.ff-typed .doc-sign-name .docsignWrapper .signPadName').attr('width', '232');
        $(elemSource).find('.ff-signwrapper.ff-drawn .doc-sign-name .docsignWrapper .signPadName').attr('width', '232');
    }

    var signInstance = $(elemSource).find('.ff-signwrapper.ff-typed .doc-sign-name').signaturePad(options);

    var signInstanceDate = $(elemSource).find('.ff-signwrapper.ff-typed .doc-sign-date').signaturePad(optionsDate);
    options['drawOnly'] = true;
    var signInstance = $(elemSource).find('.ff-signwrapper.ff-drawn .doc-sign-name').signaturePad(options);

    optionsDate['drawOnly'] = true;
    var signInstanceDate = $(elemSource).find('.ff-signwrapper.ff-drawn .doc-sign-date').signaturePad(optionsDate);
    /*Updating properties*/


    $(elemSource).find('.ff-chkagree > label').html(signAgree);
    $(elemSource).find('.ff-email-verification  label.ff-label').html(signEmailLabel);
    $(elemSource).find('.ff-signwrapper').each(function (ind, signElement) {
        $(signElement).find('.doc-sign-name .ffsign-label>label').html(signLabel);
        $(signElement).find('.doc-sign-date .ffsign-label>label').html(signDate);

        if (signDateHide == true || signDateHide == 'true') {
            $(signElement).find('.doc-sign-date input[type="hidden"]').attr('data-required', false);
            $(signElement).find('.doc-sign-date').slideUp();
        }
        else {
            $(signElement).find('.doc-sign-date input[type="hidden"]').attr('data-required', true);
            $(signElement).find('.doc-sign-date').slideDown();
        }
    });
    $(elemSource).find('.main-docsign-wrapper').removeClass('ffs-typed');
    $(elemSource).find('.main-docsign-wrapper').removeClass('ffs-both');
    $(elemSource).find('.main-docsign-wrapper').removeClass('ffs-drawn');
    $(elemSource).find('.main-docsign-wrapper').addClass('ffs-' + signOptions);
    $(elemSource).find('.main-docsign-wrapper').removeClass('ffs-full');
    $(elemSource).find('.main-docsign-wrapper').removeClass('ffs-initials');
    $(elemSource).find('.main-docsign-wrapper').addClass('ffs-' + signType);


    if (signOptions == 'drawn') {
        switchSignTab($(elemSource).find('.main-docsign-wrapper').find('li.ffdrawIt>a'));
    }
    else {
        switchSignTab($(elemSource).find('.main-docsign-wrapper').find('li.fftypeIt>a'));
    }
    if (signAgreeHide == true || signAgreeHide == 'true') {
        $(elemSource).find('.ff-chkagree > input').attr('data-isrequired', false);
        $(elemSource).find('.ff-chkagree').slideUp();
        $(elemSource).find('.ff-chkagree').hide();

    }
    else {
        $(elemSource).find('.ff-chkagree').slideDown();
        $(elemSource).find('.ff-chkagree > input').attr('data-isrequired', true);
    }
    $(elemSource).find('.ff-email-verification .ff-required-mark').remove();
    if (signEmailEnabled == true || signEmailEnabled == 'true') {
        $(elemSource).find('.ff-email-verification > input').attr('data-isrequired', true);
        $(elemSource).find('.ff-email-verification').slideDown();
        $(elemSource).find('.ff-email-verification .ffsign-label').append('<span class="ff-required-mark">*</span>');
    }
    else {
        $(elemSource).find('.ff-email-verification').slideUp();
        $(elemSource).find('.ff-email-verification').hide();
        $(elemSource).find('.ff-email-verification > input').attr('data-isrequired', false);
    }
    $(elemSource).find('input.hasDate').datetimepicker({
        showTimepicker: false,
        addSliderAccess: true,
        sliderAccessArgs: {
            touchonly: false
        },
        changeMonth: true,
        changeYear: true,
        yearRange: "-100:+10",
        onSelect: function (dateText) {
            $(elemSource).find('.ff-signwrapper.ff-typed .typedSignDate').text(dateText);
        },
        constrainInput: false
    });
    $(elemSource).find('input.hasDate').attr('maxlength', 10);
    $(elemSource).find('input.hasDate').attr('vatt', 'DATE');
    if (isAutoSave) {
        isChangesMadeInForm = true;
        autosaveTriggered();
    }
}
function clearDrawnElements(elemSource) {

    $(elemSource).parents('.main-docsign-wrapper').find('.ff-signwrapper.ff-drawn .doc-sign-name').signaturePad().clearCanvas();
    $(elemSource).parents('.main-docsign-wrapper').find('.ff-signwrapper.ff-drawn .doc-sign-date').signaturePad().clearCanvas();
}
function switchSignTab(elemSource) {
    $(elemSource).parents('.main-docsign-wrapper').find('.ff-sign-ul li a').removeClass('current');
    $(elemSource).addClass('current');
    $(elemSource).parents('.main-docsign-wrapper').find('.ff-signwrapper').addClass('display-none');
    if ($(elemSource).attr('data-signed') == 'drawn') {
        $(elemSource).parents('.main-docsign-wrapper').find('.ff-signwrapper.ff-drawn').removeClass('display-none');
        $(elemSource).parents('.main-docsign-wrapper').find('.ff-sign-div .ffclearButton').css('visibility', 'visible');
    }
    else {
        $(elemSource).parents('.main-docsign-wrapper').find('.ff-signwrapper.ff-typed').removeClass('display-none');
        $(elemSource).parents('.main-docsign-wrapper').find('.ff-sign-div .ffclearButton').css('visibility', 'hidden');
    }
}

function bindLabelDoubleClick(parentElementSource) {
    var labelElement = (parentElementSource).find('label.ff-label:first');

    $(labelElement).bind("dblclick", (function () {
        var $input = $('<input />', { 'class': 'ff-label ff-label-input' });
        $input.val($(this).text());

        $(labelElement).html('');
        $(labelElement).append($input);

    }));
    $(labelElement).find('input').on("blur", (function () {
        $(labelElement).text($(this).val());

    }));

}
function editFFLabel(elemSource) {


    try {
        mixpanel.track('Field label changed using double-click', { "Field ID": $(elemSource).attr('id') });
        var metadata = {
            field_name: ''
        };
        sendInfoToIntercom('trackEvent', 'changed-label', metadata);
    }
    catch (err) {
        console.log('Warning:' + err.message);
    }
    var elem = $(elemSource);
    var parentClass = $(elemSource).attr('class');
    if ($(elem).find('.ff-label-input').length < 1) {

        var $input = $('<textarea />', { 'class': 'ff-label ff-label-input', 'onblur': 'backToFFLabel(this,false);', 'data-parentclass': 'ff-label', 'data-parentclassnames': parentClass });
        var labelVal = $(elem).html();
        if ($(elem).text() == String.fromCharCode(160))
            labelVal = '';
        $input.val(labelVal);

        $(elem).attr('data-text', $(elem).text());
        $(elem).html('');

        $(elem).append($input);
        $(elem).find('.ff-label-input').focus();
        //$(elem).find('.ff-label-input').autogrow({onInitialize: true});
    }
}

function editFFPage(elemSource) {
    var elemLabel = $(elemSource);//.find('label.ff-section-header');
    var elemid = $(elemLabel).attr('id');
    mixpanel.track('Page label changed using double-click', { "Page ID": elemid });

    var elem = $(elemLabel);
    if ($(elem).find('.ff-label-input').length < 1) {

        var $input = $('<textarea />', { 'class': 'ff-page-header ff-label-input', 'onblur': 'backToFFLabel(this,false);', 'data-parentclass': 'ff-page-header' });
        $input.val($(elem).html());

        $(elem).attr('data-text', $(elem).text());
        $(elem).html('');

        $(elem).append($input);
        $(elem).find('.ff-label-input').focus();
        //$(elem).find('.ff-label-input').autogrow({onInitialize: true});
    }
}
function editFFSection(elemSource) {
    var elemLabel = $(elemSource);//.find('label.ff-section-header');
    var elemid = $(elemLabel).attr('id');
    mixpanel.track('Section label changed using double-click', { "Section ID": elemid });

    var elem = $(elemLabel);
    if ($(elem).find('.ff-label-input').length < 1) {

        var $input = $('<textarea />', { 'class': 'ff-section-header ff-label-input', 'onblur': 'backToFFLabel(this,false);', 'data-parentclass': 'ff-section-header' });
        $input.val($(elem).html());

        $(elem).attr('data-text', $(elem).text());
        $(elem).html('');

        $(elem).append($input);
        $(elem).find('.ff-label-input').focus();
        // $(elem).find('.ff-label-input').autogrow({onInitialize: true});
    }
}
function editPaymentFFLabel(elem) {
    mixpanel.track('Field label changed', { "Field ID": $(elem).attr('id') });

    if ($(elem).find('.ff-label-input').length < 1) {
        var $input = $('<textarea />', { 'class': 'ff-label ff-label-input', 'onblur': 'backToFFLabel(this,true);', 'data-parentclass': 'ff-label' });
        $input.val($(elem).html());

        $(elem).attr('data-text', $(elem).text());
        $(elem).html('');

        $(elem).append($input);
        $(elem).find('.ff-label-input').focus();
        // autosize($(elem).find('.ff-label-input'));
        //$(elem).find('.ff-label-input').autogrow({onInitialize: true});
    }
}
function editESignLabel(elem, isSignOrDate) {
    var mainSignatureParent = $(elem).parents('.main-docsign-wrapper');

    try {
        mixpanel.track('ESignature Field label changed using double-click', { "Signature Field ID": $(mainSignatureParent).attr('id') });
        var metadata = {
            field_name: ''
        };
        sendInfoToIntercom('trackEvent', 'changed-label', metadata);
    }
    catch (err) {
        console.log('Warning:' + err.message);
    }

    if ($(elem).find('.ff-label-input').length < 1 && $(elem).parents('.fieldLi').find('.ExpandDivESignature').length < 1) {

        var $input = $('<textarea />', { 'class': 'ff-label ff-label-input', 'onblur': 'backToESignLabel(this,' + isSignOrDate + ');', 'data-parentclass': 'ff-label' });
        var labelVal = $(elem).html();
        if ($(elem).text() == String.fromCharCode(160))
        { labelVal = ''; }
        $input.val(labelVal);

        $(elem).attr('data-text', $(elem).text());
        $(elem).html('');

        $(elem).append($input);
        $(elem).find('.ff-label-input').focus();
    }
}
function backToESignLabel(elem, isSignOrDate) {
    var labelElement;
    var parentElementBlock = $(elem).parents('.ff-signwrapper-outer');
    if (isSignOrDate) {
        parentElementBlock = $(elem).parents('.ff-sign-block');
    }
    var parentClass = $(elem).attr('data-parentclass');
    if (!isNullOrEmpty($(elem).attr('data-parentclass'))) {
        labelElement = $(elem).parents('label.' + parentClass + '');
    }
    var newvalue = $(labelElement).find('.ff-label-input').val();
    $(labelElement).find('.ff-label-input').remove();
    newvalue = validatedHTML(newvalue);
    $(labelElement).html(newvalue);
    if (isSignOrDate) {
        if ($(parentElementBlock).hasClass('doc-sign-name')) {
            $(parentElementBlock).parents('.eSignatureFieldDiv').find('>input.ffd-esignature-input').attr('data-signlabel', newvalue);
        }
        else if ($(parentElementBlock).hasClass('doc-sign-date')) {
            $(parentElementBlock).parents('.eSignatureFieldDiv').find('>input.ffd-esignature-input').attr('data-signdate', newvalue);

        }
    }
    else {
        if ($(elem).parents('.ff-email-verification').length > 0) {
            $(parentElementBlock).parents('.eSignatureFieldDiv').find('>input.ffd-esignature-input').attr('data-emaillabel', newvalue);
        }
        else {
            $(parentElementBlock).parents('.eSignatureFieldDiv').find('>input.ffd-esignature-input').attr('data-signagree', newvalue);
        }
    }
    resetESignatureElement($(parentElementBlock).parents('.fieldLi'), true);
}
function backToFFLabel(elem, isPaymentFieldLabel) {
    var labelElement;
    var parentClass = $(elem).attr('data-parentclass');
    if (!isNullOrEmpty($(elem).attr('data-parentclass'))) {
        labelElement = $(elem).parents('label.' + parentClass + '');
    }
    var newvalue = $(labelElement).find('textarea.ff-label-input').val();
    $(labelElement).find('textarea.ff-label-input').remove();
    // newvalue=validatedHTML(newvalue);
    if (parentClass.indexOf('ff-page-header') >= 0) {
        $(labelElement).parents('.fc-multi-page-item').find('.ff-page-info .ff-page-title').html(newvalue);
    }
    $(labelElement).html(newvalue);
    if (isPaymentFieldLabel) {

        updatePaymentFieldLabels(labelElement);
    }
    else {
        isChangesMadeInForm = true;
        autosaveTriggered();
    }
}

function setHover() {
    $('.fc-multi-page-item  ul.formFieldUl li').hover(
                 function () {
                     $(this).find('.obj-info').show();

                 },
                 function () {
                     $(this).find('.obj-info').hide();
                 }
    );
}

/*Methods from Form Editor page ends*/
function resetFlexInputForFormElements() {

    $('.fieldDiv>input[type="textbox"]').each(function (i, inputElement) {

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
    });

}
function initializeSignatureElements() {
    $('#parentUlForm li ul li[id^="lblliESIGNATURE"]').each(function (inx, fieldLi) {
        if ($(fieldLi).hasClass('generalSortableForFields')) {
            resetESignatureElement(fieldLi, false);
        }
    });
}
function getSignatureConfigXML(inputSignatureElement) {
    var returnXML = "";

    returnXML += "<type>" + $(inputSignatureElement).attr('data-signtype') + "</type>";
    returnXML += "<option>" + $(inputSignatureElement).attr('data-signoptions') + "</option>";
    returnXML += "<label>" + $(inputSignatureElement).attr('data-signlabel') + "</label>";
    returnXML += "<date>" + $(inputSignatureElement).attr('data-signdate') + "</date>";
    returnXML += "<agree>" + $(inputSignatureElement).attr('data-signagree') + "</agree>";
    returnXML += "<datehide>" + $(inputSignatureElement).attr('data-signdatehide') + "</datehide>";
    returnXML += "<agreehide>" + $(inputSignatureElement).attr('data-signagreehide') + "</agreehide>";
    return returnXML;
}
function populateFooterFromFormHTML(sendBtnElem, footnote) {
    try {
        $("#btnTxt").val($(sendBtnElem).val());
        $("#txtbxSubmitButtonLabel").val($(sendBtnElem).val());
        $("#BtnMessage").val($(sendBtnElem).attr('btnmessage'));
        $("#txtareaThankyoumsg").val($(sendBtnElem).attr('btnmessage'));
        $("#btnFootnote").val('' + footnote);
        $("#btnUrl").val($(sendBtnElem).attr('btnurl'));
        $("#txtbxRedirectUrl").val($(sendBtnElem).attr('btnurl'));

        if ($("#txtbxRedirectUrl").val() != "") {
            $('a[href$="#formconfirmationRadio1"]').parent().removeClass('active');
            $('a[href$="#formconfirmationRadio2"]').parent().addClass('active')
            $('#formconfirmationRadio1').removeClass('active in');
            $('#formconfirmationRadio2').addClass('active in');
        }

        footerBtnHTMLPopulated = true;
    }
    catch (err) {
        console.log(' Error in populating footerHtml ' + err);
    }
}
function createHtml() {

    $('.list-toggle-div-wrap ul.dropfields').each(function (indx, sortableUL) {
        $(sortableUL).find('li').each(function () {
            $(this).find('div.fieldDiv').each(function (index) {
                if ($(this).text().indexOf('<') >= 0) {
                    $(this).html($(this).text());
                }

            });
        });
    });
}
function hideAllAvailableFieldLists() {
    $('.availableHeaderDiv').removeClass('activeTab');
    $('.list-toggle-div').slideUp(100);
    $('.list-toggle-div-wrap').hide();
}

function getColorCode(liElement) {
    var childElemClass = '';
    if ($(liElement).hasClass('A')) {
        childElemClass = 'A';
    }
    else if ($(liElement).hasClass('B')) {
        childElemClass = 'B';
    }
    else if ($(liElement).hasClass('C')) {
        childElemClass = 'C';
    }
    else if ($(liElement).hasClass('D')) {
        childElemClass = 'D';
    }
    else if ($(liElement).hasClass('E')) {
        childElemClass = 'E';
    }
    else if ($(liElement).hasClass('F')) {
        childElemClass = 'F';
    }
    else if ($(liElement).hasClass('G')) {
        childElemClass = 'G';
    }
    else if ($(liElement).hasClass('H')) {
        childElemClass = 'H';
    }
    else if ($(liElement).hasClass('I')) {
        childElemClass = 'I';
    }
    else if ($(liElement).hasClass('J')) {
        childElemClass = 'J';
    }
    else if ($(liElement).hasClass('K')) {
        childElemClass = 'K';
    }
    else if ($(liElement).hasClass('L')) {
        childElemClass = 'L';
    }
    else if ($(liElement).hasClass('M')) {
        childElemClass = 'M';
    }
    else if ($(liElement).hasClass('N')) {
        childElemClass = 'N';
    }

    return childElemClass;
}
function getFormattedElemId(liElement) {
    var childElemClass = getColorCode(liElement);
    var elementName = '';

    var originalFieldDiv = $(liElement).find('.fieldDiv').html();

    var finalElemId;
    if ($(liElement).hasClass('generalSortableForFields')) {
        var dataOType = $(liElement).attr('data-otype');
        var lblLi = $(liElement).attr('id');
        if (!isNullOrEmpty(dataOType) && dataOType.indexOf('Payment') > 0) {
            lblLi = lblLi.replace('FASTFORMSPAYMENT', 'FFPAYMENT');
        }

        finalElemId = lblLi.replace('lblli', '');

    } else if ($(originalFieldDiv).length > 0) {

        if ($(originalFieldDiv).first().hasClass('lookupInput'))
            elementName = $(originalFieldDiv).find('input').last().attr('name');
        else
            elementName = $(originalFieldDiv).not('label,span,div').last().attr('name');

        finalElemId = elementName;
        if (childElemClass != '') {
            console.log(' finalElemId 1 ' + finalElemId);
            finalElemId = elementName.substring(0, elementName.lastIndexOf('.'));

            finalElemId = finalElemId + '.' + childElemClass + '.' + elementName.substring(elementName.lastIndexOf('.') + 1);


        }
    }
    else {
        finalElemId = $(liElement).find('.labelDiv>label.ff-label').attr('id');
        finalElemId = finalElemId.replace('lbl', '');
    }

    return finalElemId;
}
function getElementObjectType(liElement) {
    var objectType = '';

    if ($(liElement).hasClass('sortableForRelFields1')) {
        objectType = 'PRIMARY';
    }
    else {

        objectType = 'LOOKUP';

        $.each(colorTagArray, function (indx, tagValue) {
            if ($(liElement).hasClass(tagValue + '')) {
                objectType = 'DETAIL';
            }
        });
    }

    return objectType;
}
function createJSONSectionObj(sectionlabelid, sectionclass) {
    var dataobj = { "id": sectionlabelid, "class": sectionclass };


    return dataobj;
}



function fetchHiddenObjectValues() {
    var hiddenObjects = '';
    var seperator = "";
    $('.select-secondary-element-wrapper').find('.secondary-object-block').each(function (indx, selectParentElem) {
        var selectedValue = $(selectParentElem).find('select.select-secondary-element').val();
        if (!isNullOrEmpty(selectedValue)) {
            var objtype = $(selectParentElem).find('select.select-secondary-element').children().children(':selected').attr('name');
            console.log(' selectedValue  ' + selectedValue + '  objtype-' + objtype);
            hiddenObjects += seperator + selectedValue + '##' + objtype;
            seperator = ",";
        }

    });
    return hiddenObjects;
}



function IsSelectVisible(selectlevelID) {

    var returnflag = true;
    if ($('#' + selectlevelID + ' .scroll-parent').css('display') == 'none') {
        returnflag = false;
    }
    return returnflag;
}
function isSelectedItemIsvalid(selectlevelID) {

    var returnflag = true;
    if ($('#' + selectlevelID + ' .scroll-parent .select2-container a.select2-choice .select2-chosen').text() == '----Select Object----') {
        returnflag = false;
    }
    return returnflag;
}
function vaildateLookupEdit(liElementId) {
    var infoIsValid = true;
    var firstLabel = $('#' + liElementId).find('>div:first > label:first');
    if (!isNullOrEmpty($(firstLabel).attr('vatt')) && $(firstLabel).attr('vatt') == 'REFERENCE') {
        if (!$('#' + liElementId).find('#trForHideField input[type="checkbox"]').is(':checked') && !$('#' + liElementId).find('#trForReadOnlyField input[type="checkbox"]').is(':checked') && $('#' + liElementId).find('#trForLookupView').is(':visible')) {
            var selectedOptionElem = $('#' + liElementId).find('#trForLookupView select.lookup-select option:selected');
            if (!isNotNullOrUndefined(selectedOptionElem) || isNullOrEmpty($(selectedOptionElem).attr('value')) || $(selectedOptionElem).val() == '000000000000000AAA') {
                infoIsValid = false;
                var validationMsg = 'Please select a view';
                if ($(selectedOptionElem).val() == '000000000000000AAA') {
                    validationMsg = 'List View is null';
                }
                var lookupViewTr = $('#' + liElementId).find('#trForLookupView');

                $(lookupViewTr).find('select.lookup-select').select2('focus');
                if ($(lookupViewTr).find('.formatEditCol2 .edit-validation-err').length < 1) {
                    $(lookupViewTr).find('.formatEditCol2 a.lookup-edit-link').after('<span class="edit-validation-err">' + validationMsg + '<span>');
                }
                else {
                    $(lookupViewTr).find('.formatEditCol2 .edit-validation-err').text(validationMsg);
                }


            }


        }
    }
    return infoIsValid;
}
/*form editor old functions ends*/

function generateLookupListViewHtml(resultSelectOptions) {
    var returnHtml = '<option>-select a view-</option>';

    if (resultSelectOptions != null && resultSelectOptions.length > 0) {
        if (resultSelectOptions.length > 1 || resultSelectOptions[0].FFValue != '000000000000000AAA') {
            $.each(resultSelectOptions, function (index, item) {
                returnHtml += '<option   value="' + item.FFValue + '">' + item.FFText + ' </option>';
            });
        }

    }
    return returnHtml;
}
function lookupListViewChange(elemSource) {
    var parentFieldLi = $(elemSource).parents('.fieldLi');
    var hiddenElem = $(parentFieldLi).find('.fieldDiv .lookupInput input[type=hidden]');
    var textboxElem = $(parentFieldLi).find('.fieldDiv .lookupInput input[type=textbox]');
    var refObjectname = '';
    refObjectname = $(parentFieldLi).find('div:first label:first').attr('vaobj');
    if (!isNullOrEmpty(refObjectname)) {
        $(hiddenElem).attr('data-vaobj', refObjectname);
    }
    var selectedValue = $(elemSource).select2('val');
    if (!isNullOrEmpty(selectedValue) && selectedValue != '-select a view-') {
        $(hiddenElem).attr('data-lookup-value-type', 'list');

        $(hiddenElem).attr('data-lookup-value', selectedValue);
        $(parentFieldLi).find('.ExpandDiv  a.lookup-edit-link').show();
        $(parentFieldLi).find('.ExpandDiv .edit-validation-err').remove();
    }
    else {
        $(hiddenElem).attr('data-lookup-value-type', '');
        $(hiddenElem).attr('data-lookup-value', '');
        $(parentFieldLi).find('.ExpandDiv  a.lookup-edit-link').hide();
    }

}
function populateLookupSelect(parentFieldLiElement, result) {
    var lookupHtml = generateLookupListViewHtml(result);
    $(parentFieldLiElement).find('select.lookup-select').html(lookupHtml);
    $(parentFieldLiElement).find('select.lookup-select').select2();

    var hiddenElem = $(parentFieldLiElement).find('.ExpandDiv .lookupInput input[type=hidden]');
    var lookupType = $(hiddenElem).attr('data-lookup-value-type');
    var lookupSelectedValue = $(hiddenElem).attr('data-lookup-value');
    if (!isNullOrEmpty(lookupType) && !isNullOrEmpty(lookupSelectedValue)) {
        $(parentFieldLiElement).find('select.lookup-select').select2('val', lookupSelectedValue);
        $(parentFieldLiElement).find('.ExpandDiv a.lookup-edit-link').show();
    }
    else {
        $(parentFieldLiElement).find('.ExpandDiv a.lookup-edit-link').hide();
    }

}
function openLookupEditPage(elemSource) {
    var liId = $(elemSource).parents('.fieldLi').attr('id');
    var filterPageUrl = 'https://' + sfdcHostName + '.salesforce.com/ui/list/FilterEditPage';
    var returnUrl = 'https://' + sfdcHostName + '.salesforce.com/apex/FastFormListViewRet?itemid=' + liId;
    /*  path for editor page  /ui/list/FilterEditPage?id=00Bo0000003iSba&retURL=returnurl  */
    var selectedvalue = $(elemSource).parent().find('select.lookup-select').select2('val');
    if (!isNullOrEmpty(selectedvalue)) {
        filterPageUrl += "?id=" + selectedvalue;
        var strWindowFeatures = "location=no,height=570,width=520,scrollbars=yes,status=no";
        var URL = filterPageUrl + "&retURL=" + returnUrl;
        var win = window.open(URL, "_blank", strWindowFeatures);




    }
}
function CallBackFromFilterPage(fieldliiElement) {
    var refObjectname = '';
    refObjectname = $('#' + fieldliiElement).find('div:first label:first').attr('vaobj');
    if (!isNullOrEmpty(refObjectname)) {
        remoteGetSObjectListViewJS(refObjectname, $('#' + fieldliiElement));
    }
}
function hideWarning(elemid) {
    $(elemid).parents('.vff-alert').hide();
}
function doSearch(thisElem) {
    var txtToSearch = $(thisElem).parent().find('input[type="textbox"]').val();
    doFieldSearch(txtToSearch);
}
function doDynamicSearch(thisElem) {
    var txtToSearch = $(thisElem).val();
    if (!isNullOrEmpty(txtToSearch) && txtToSearch.length > 1) {
        doFieldSearch(txtToSearch);
    }
    else {
        resetSearch();
    }
}
function doFieldSearch(textToSearch) {
    $('#availableFieldBox .availableHeaderDiv').find('.result-text').remove();
    //var textToSearch=$(thisElem).parent().find('input[type="textbox"]').val();
    if (!isNullOrEmpty(textToSearch)) {
        $('#availableFieldBox').find('.list-toggle-div .fieldLi').each(function (indx, elemLi) {
            var titlestr = $(elemLi).attr('title');
            if (!isNullOrEmpty(titlestr) && titlestr.toLowerCase().indexOf(textToSearch.toLowerCase()) >= 0) {
                $(elemLi).removeClass('display-none');
            }
            else {
                $(elemLi).addClass('display-none');
            }
        });
        $('#availableFieldBox').find('.list-toggle-div').each(function (indx, divElem) {
            var parentDiv = $(divElem).parent();

            if (!isNullOrEmpty($(divElem).find('.fieldLi:not(.display-none):not([style])').length)) {
                $(parentDiv).addClass('search-enable');
                var objnamehtml = $(parentDiv).find('.objName').html();
                $(parentDiv).find('.availableHeaderDiv').append('<span class="result-text">' + $(divElem).find(".fieldLi:not(.display-none):not([style])").length + ' Results</span>');
            }
            else {
                $(parentDiv).addClass('search-enable');
                $(parentDiv).find('.availableHeaderDiv').append('<span class="result-text">0 Result</span>');
            }
        });
    }
    else {
        $('#availableFieldBox').find('.list-toggle-div .fieldLi').removeClass('display-none');
    }
}
function clearSearch(thisElem) {
    $(thisElem).parent().find('input[type="textbox"]').val('');
    resetSearch();
}
function resetSearch() {

    $('#availableFieldBox').find('.list-toggle-div .fieldLi').removeClass('display-none');
    $('#availableFieldBox .availableHeaderDiv').find('.result-text').remove();
    $('#availableFieldBox').find('.list-toggle-div-wrap').removeClass('search-enable');
    if ($('#availableFieldBox').find('.availableHeaderDiv.activeTab').length > 0) {
        var fieldListElem = $('#availableFieldBox').find('.availableHeaderDiv.activeTab').parent().find('.list-toggle-div');
        if (msieversion() <= 0) {
            $(fieldListElem).jScrollPane({ mouseWheelSpeed: 100 });
        }
    }
}
function toggleSearchBox(elemSource) {
    if ($(elemSource).parents('.availablefields-wrapper').hasClass('hideSearch')) {
        $(elemSource).parents('.availablefields-wrapper').removeClass('hideSearch')
    }
    else {
        $(elemSource).parents('.availablefields-wrapper').addClass('hideSearch');
    }
}
function flexControlDisplayName(flextypecode, defaulttype) {
    var returnStr = defaulttype;
    switch (flextypecode) {
        case 'integer-npsrating':
            returnStr = 'NPS Rating';
            break;
        case 'integer-starrating':
            returnStr = 'Star Rating';
            break;
        case 'picklist-combobox':
            returnStr = 'Searchable Picklist';
            break;
        case 'picklist-radiobutton-vertical':
            returnStr = 'Radio Button List (Vertical)';
            break;
        case 'picklist-radiobutton-horizontal':
            returnStr = 'Radio Button List (Horizontal)';
            break;
        case 'multipicklist-multi-tags':
            returnStr = 'Multi-Select Tag List';
            break;
        case 'multipicklist-multi-tags-check':
            returnStr = 'Multi-Select Checkbox Tag List';
            break;
        case 'multipicklist-checkbox-horizontal':
            returnStr = 'Checkbox List (Vertical)';
            break;
        case 'multipicklist-checkbox-vertical':
            returnStr = 'Checkbox List (Vertical)';
            break;
        default:
            break;
    }
    return returnStr;
}

/*Picklist management methods start*/
function setupPicklistManagementElement(elemSource, picklistValuesJsonArr) {
    setHiddenSelectDataSet(elemSource);
    var picklistBoxElement = $('#trForformFieldsPicklistdOptions .picklist-box');
    var ulElem = $('<ul/>', { 'class': 'sortable-picklist' });

    $.each(picklistValuesJsonArr, function (indx, jsonItem) {

        var pval = safeStringValue(jsonItem.pval, '');
        if (!isNullOrEmpty(pval)) {
            var pItemElem = $('<span/>', { 'class': 'pitem', 'onclick': 'toggleItemSelection(this,true);' });
            var spanValueElem = $('<span/>', { 'class': 'pick-t', 'html': jsonItem.ptxt, 'data-txt': jsonItem.ptxt, 'data-val': pval });
            var delElem = $('<span/>', { 'class': 'del-icon', 'onclick': 'removeCustomLi(this);' });
            var chkElem = $('<span/>', { 'class': 'chk-icon' });
            var dragElem = $('<span/>', { 'class': 'drag-ic' });
            var selected = jsonItem.psel;
            var isCustom = getSafeBoolean(jsonItem.pcustom, false);
            var liElem = $('<li/>', { 'class': 'pick-item ' });
            if (!getSafeBoolean(jsonItem.pdisabled, false)) {
                $(liElem).addClass('selected');
            }
            if (isCustom) {

                $(liElem).addClass('custom-li');
                $(spanValueElem).append($('<span/>').html(' (custom)'));
            }

            $(liElem).html(dragElem);
            $(pItemElem).append(chkElem);
            $(pItemElem).append(spanValueElem);
            $(liElem).append(pItemElem);
            if (isCustom) { $(liElem).append(delElem); }
            $(ulElem).append(liElem);
        }
    });
    $(picklistBoxElement).html(ulElem);
    $(picklistBoxElement).find('ul').sortable({
        axis: 'y',
        handle: '.drag-ic',
        update: function (event, ui) {
            changePicklistItem(ui.item);
        }
    });
    //   setHoverEventsForMultiPick($(elemSource).parents('.picklist-options-toggle').parent().find('.picklist-options-wrapper .picklist-footer-2'));
}
function filterPicklistItems(elemSource) {
    var txtToSearch = $(elemSource).val();

    doPicklistItemSearch(elemSource, txtToSearch);

}
function doPicklistItemSearch(elemSource, txtToSearch) {
    if (!isNullOrEmpty(txtToSearch) && txtToSearch.length > 0) {
        $(elemSource).parents('.picklist-box-wrapper').find('ul.sortable-picklist>li').each(function (indx, elemLi) {
            var datatext = $(elemLi).find('.pick-t').attr('data-txt');
            if (!isNullOrEmpty(datatext) && datatext.toLowerCase().indexOf(txtToSearch.toLowerCase()) >= 0) {
                $(elemLi).removeClass('display-none');
            }
            else {
                $(elemLi).addClass('display-none');
            }
        });
    }
    else {
        $(elemSource).parents('.picklist-box-wrapper').find('ul.sortable-picklist>li').each(function (indx, elemLi) {
            $(elemLi).removeClass('display-none');
        });
    }
}
function resetPicklistSearch(elemSource) {

}
function sortPicklistItems(elemSource) {
    var sortOrderAsc = true;
    var elementText = $(elemSource).text();
    if (!isNullOrEmpty(elementText) && elementText.toLowerCase() == 'sort z-a') {
        sortOrderAsc = false;
        $(elemSource).text('Sort A-Z');
    }
    else {
        $(elemSource).text('Sort Z-A');
    }
    var ulSortableElem = $(elemSource).parents('.picklist-box-wrapper').find('ul.sortable-picklist');
    $(ulSortableElem).html($(ulSortableElem).find('li').sort(function (a, b) {
        if (sortOrderAsc) { return $(a).find('.pick-t').attr('data-txt').toUpperCase().localeCompare($(b).find('.pick-t').attr('data-txt').toUpperCase()); }
        else { return $(b).find('.pick-t').attr('data-txt').toUpperCase().localeCompare($(a).find('.pick-t').attr('data-txt').toUpperCase()); }
    })
                    );
    changePicklistItem(elemSource);
}
function resetPicklistItems(elemSource) {
    var expandDivElem = $(elemSource).parents('.ExpandDiv');
    var fieldLiElem = $(expandDivElem).parent();
    var defaultSelectElement = $('#tblForRequirdBlock').find('#defaultValue');
    if ($(fieldLiElem).find('.fieldDiv .selectDataSet select').length > 0) {
        defaultSelectElement = $(elemSource).parents('.fieldLi').find('.fieldDiv .selectDataSet select');
    }
    var selectOptions = [];

    $(defaultSelectElement).find('option').each(function (indx, optionElem) {
        if (!isNullOrEmpty($(optionElem).attr('value'))) {


            var isCustom = getSafeBoolean($(optionElem).attr('data-iscustom'), false);
            if (!isCustom) {
                var optionItem = { 'pval': $(optionElem).attr('value'), 'ptxt': $(optionElem).text() };
                optionItem['pcustom'] = false;
                optionItem['pdisabled'] = false;
                optionItem['psel'] = getSafeBoolean($(optionElem).is(':selected'), false);
                selectOptions.push(optionItem);
            }
        }

    });
    setupPicklistManagementElement(elemSource, selectOptions);
    changePicklistItem(elemSource);
}
function togglePickItemSelection(elemSource) {
    var elementText = $(elemSource).text();
    if (!isNullOrEmpty(elementText)) {
        if (elementText.toLowerCase() == 'select all') {
            $(elemSource).text('Deselect all');
            resetAllPicklistItems(elemSource, true, true);
        }
        else {
            $(elemSource).text('Select all');
            resetAllPicklistItems(elemSource, false, true);
        }
    }
}
function resetAllPicklistItems(elemSource, checkVal, isAutoSave) {
    $(elemSource).parents('.picklist-box-wrapper').find('ul.sortable-picklist li').each(function (indx, liElem) {
        if (checkVal) {
            if (!$(liElem).hasClass('selected')) {
                $(liElem).addClass('selected');
            }
        } else {
            if ($(liElem).hasClass('selected')) {
                $(liElem).removeClass('selected');
            }

        }
    });
    if (isAutoSave) {
        changePicklistItem(elemSource);
    }
}
function toggleToSingleOptionState(elemSource, isAutoSave) {
    toggleSingleOptionState(elemSource, true);
}
function toggleSingleOptionState(elemSource, setInitialState) {
    var parentElem = $(elemSource).parents('.picklist-box-wrapper');
    $(parentElem).find('.picklist-box-footer').removeClass('multi-state-add');
    $(parentElem).find('.picklist-box-footer').removeClass('single-state-add');
    $(parentElem).find('.picklist-box').removeClass('multi-line-enabled');
    if (setInitialState) {
        $(parentElem).find('.multi-line-pick').hide();
        if (isNullOrEmpty($(elemSource).val())) {

            $(parentElem).find('.multi-icon-hide').fadeIn("slow");
            $(parentElem).find('.add-pick-icon').hide();
        }
        else { $(parentElem).find('.picklist-box-footer').addClass('single-state-add'); }
    } else {
        $(parentElem).find('.picklist-box-footer').addClass('single-state-add');

        $(parentElem).find('.multi-icon-hide').hide();
        $(parentElem).find('.add-pick-icon').fadeIn("slow");
    }
}
function showMultiPickItems(elemSource) { }
function toggleMultiPickTextArea(elemSource, isAutoSave) {
    var parentElem = $(elemSource).parents('.picklist-box-wrapper').find('.picklist-box-footer');
    var newtext = $(parentElem).parent().find('textarea.multi-line-pick').val();
    if (isNullOrEmpty(newtext) || !$(parentElem).hasClass('multi-state-add')) {
        $(parentElem).removeClass('single-state-add');
        if ($(parentElem).hasClass('multi-state-add')) {
            $(elemSource).parents('.picklist-box-wrapper').removeClass('multi-line-enabled');
            $(parentElem).removeClass('multi-state-add');
            $(parentElem).parent().find('textarea').slideUp();
        }
        else {
            $(elemSource).parents('.picklist-box-wrapper').find('.picklist-box').addClass('multi-line-enabled');
            $(parentElem).addClass('multi-state-add');
            $(parentElem).find('.add-mpick-icon').fadeIn("slow");
            $(parentElem).parent().find('textarea').slideDown();
        }
    }
}
function toggleMultiPickText(elemSource) { }
function addMultiPickItems(elemSource) {
    var parentElem = $(elemSource).parents('.picklist-box-wrapper');
    var newtext = $(parentElem).find('textarea.multi-line-pick').val();
    if (!isNullOrEmpty(newtext)) {
        $(parentElem).find('textarea.multi-line-pick').val('');
        $(parentElem).find('textarea.multi-line-pick').slideUp();
        var newValuesArr = [];
        var newtextLines = newtext.split('\n');
        $.each(newtextLines, function (indx, txt) {
            newValuesArr.push({ 'pval': txt, 'ptxt': txt });
        });

        addNewPicklistItems(elemSource, newValuesArr, true);
    } else {
        toggleSingleOptionState(elemSource, true);
    }
}
function addPickItems(elemSource) {
    var parentElem = $(elemSource).parents('.picklist-box-wrapper');
    var newtext = $(parentElem).find('.picklist-footer-1 input.search-box').val();
    $(parentElem).find('.picklist-footer-1 input.search-box').val('');
    if (!isNullOrEmpty(newtext)) {
        var newValuesArr = [];
        newValuesArr.push({ 'pval': newtext, 'ptxt': newtext });
        addNewPicklistItems(elemSource, newValuesArr, true);
    } else {
        toggleSingleOptionState(elemSource, true);
    }
}
function addNewPicklistItems(elemSource, newItems, isAutoSave) {
    var parentElem = $(elemSource).parents('.picklist-box-wrapper');
    if (newItems != undefined && newItems.length > 0) {

        var ulElem = $(parentElem).find('ul.sortable-picklist');
        $.each(newItems, function (indx, jsonItem) {
            var spanCustomText = $('<span/>', { 'html': ' (custom)' });
            var pItemElem = $('<span/>', { 'class': 'pitem', 'onclick': 'toggleItemSelection(this,true);' });
            var spanValueElem = $('<span/>', { 'class': 'pick-t', 'html': jsonItem.ptxt, 'data-txt': jsonItem.ptxt, 'data-val': jsonItem.pval });
            $(spanValueElem).append(spanCustomText);
            var delElem = $('<span/>', { 'class': 'del-icon', 'onclick': 'removeCustomLi(this);' });
            var chkElem = $('<span/>', { 'class': 'chk-icon' });
            var dragElem = $('<span/>', { 'class': 'drag-ic' });
            var liElem = $('<li/>', { 'class': 'pick-item selected custom-li' });
            $(liElem).html(dragElem);
            $(pItemElem).html(chkElem);
            $(pItemElem).append(spanValueElem);
            $(liElem).append(pItemElem);
            $(liElem).append(delElem);
            $(ulElem).append(liElem);
        });
    }
    $(parentElem).find('.picklist-box-footer').removeClass('single-state-add');
    $(parentElem).find('.picklist-box-footer').removeClass('multi-state-add');
    /*scroll to last li item starts*/
    var scrollableDiv = $(parentElem).find('.picklist-box');
    if (scrollableDiv.length > 0) {
        scrollableDiv.scrollTop(scrollableDiv[0].scrollHeight);
    }
    /*scroll to last item ends*/
    $(elemSource).hide();
    toggleSingleOptionState(elemSource, true);
    changePicklistItem(elemSource);
}
function removeCustomLi(elemSource) {
    var parentUl = $(elemSource).parent().parent();
    $(elemSource).parent().remove();
    changePicklistItem(parentUl);
}
function toggleMultiPickBox(elemSource, hideText) {
    var parentElem = $(elemSource).parents('.picklist-box-footer');
    $(parentElem).removeClass('multi-state-enabled');
    $(parentElem).removeClass('single-state-add');
    if (!hideText) {
        $(parentElem).addClass('multi-state-enabled');
    }

}

function setHoverEventsForMultiPick(elemSource) {
    $(elemSource).hover(
                   function () {
                       toggleMultiPickBox(elemSource, false);
                   },
                   function () {
                       toggleMultiPickBox(elemSource, true);
                   }
               );
}
function toggleItemSelection(elemSource, isAutoSave) {
    var parentLi = $(elemSource).parent();
    if ($(parentLi).hasClass('selected')) {
        $(parentLi).removeClass('selected');
    } else {
        $(parentLi).addClass('selected');
    }
    changePicklistItem(elemSource);
}
function changePicklistItem(elemSource) {
    var expandDivElem = $(elemSource).parents('.ExpandDiv');
    var fieldLiElem = $(expandDivElem).parent();
    var selectDataSetElement = $(fieldLiElem).find('.fieldDiv .selectDataSet select');
    var selectDefaultElement = $(expandDivElem).find('#trForDefaultValue select.ff-select-type');
    var selectElement = $(expandDivElem).parent().find('div.fieldDiv select.ff-select-type');
    var selectedVal = safeStringValue($(selectElement).val(), '');
    $(selectDataSetElement).empty();

    var optionDatasetHtml = $('<div/>');
    var optionHtml = $('<div/>');
    if ($(selectElement).hasClass('ff-singlepicklist')) {
        $(optionHtml).html('<option value="">--select an item--</option>');
        $(optionDatasetHtml).html('<option value="">--select an item--</option>');
    }

    $(expandDivElem).find('.picklist-options-wrapper .picklist-box ul>li').each(function (indx, liItem) {
        var opthtm = $(liItem).find('.pick-t').attr('data-txt');
        var optval = $(liItem).find('.pick-t').attr('data-val');
        if (!isNullOrEmpty(optval)) {
            opthtm = opthtm.replace(' (custom)', '');
            var isCustom = false;
            var isDisabled = true;
            if ($(liItem).hasClass('custom-li')) { isCustom = true; }
            if ($(liItem).hasClass('selected')) {
                isDisabled = false;
                $(optionHtml).append('<option value="' + optval + '">' + opthtm + '</option>');
            }

            $(optionDatasetHtml).append('<option data-iscustom="' + isCustom + '" data-disabled="' + isDisabled + '" value="' + optval + '">' + opthtm + '</option>');
        }

    });


    updateSelectElementsWithCustomData(selectDefaultElement, $(optionHtml).html(), selectedVal);
    updateSelectElementsWithCustomData(selectElement, $(optionHtml).html(), selectedVal);
    updateSelectElementsWithCustomData(selectDataSetElement, $(optionDatasetHtml).html(), selectedVal);

    $(expandDivElem).find('.flex-ctrl-display-as:not(.display-none) select').change();

}
function updateSelectElementsWithCustomData(selectElem, htmlData, selVal) {
    $(selectElem).empty();
    $(selectElem).append(htmlData);
    $(selectElem).val(selVal);
}
function setHiddenSelectDataSet(elemSource) {
    var expandDivElem = $(elemSource).parents('.ExpandDiv');
    var fieldLiElem = $(expandDivElem).parent();

    if ($(fieldLiElem).find('.fieldDiv .selectDataSet').length == 0) {
        $(fieldLiElem).find('.fieldDiv').append($('<div/>', { 'class': 'selectDataSet display-none' }));
        $(fieldLiElem).find('.fieldDiv .selectDataSet').html($(expandDivElem).find('#trForDefaultValue select.ff-select-type').clone().wrap('<p>').parent().html());
        $(fieldLiElem).find('.fieldDiv>select.ff-select-type').attr('data-customset', true);
        var selectId = $(fieldLiElem).find('.fieldDiv>select.ff-select-type').attr('id');
        $(fieldLiElem).find('.fieldDiv .selectDataSet select').removeAttr('class');
        $(fieldLiElem).find('.fieldDiv .selectDataSet select').attr('id', 'vadataset__' + selectId);
    }

}

function testPicklist(elemsource) {
    $(elemsource).SelectToPicklist({ controlType: 'ff-ext-checkbox', alignment: 'horizontal' });
}
/*Picklist management methods end*/
/*Multi payment sprint methods starts*/
function safeLegacyPAYPALPAYMENT(paymentStr) {
    if (!isNullOrEmpty(paymentStr) && paymentStr.indexOf('PAYPALPAYMENT') >= 0) {

        paymentStr = paymentStr.replace('PAYPALPAYMENT', 'FASTFORMSPAYMENT');

    }
    return paymentStr;
}
function getOPaymentTypeVal(paymentType, defaultval, paypalval, iatsval, stripeval, authorizeNetval) {
    var returnResponse = defaultval;
    switch (paymentType) {
        case 'OPayPalPayment':
            returnResponse = paypalval;
            break;
        case 'OiATSPayment':
            returnResponse = iatsval;
            break;
        case 'OStripePayment':
            returnResponse = stripeval;
            break;
        case 'OAuthorizeNetPayment':
            returnResponse = authorizeNetval;
            break;
        default:
            break;
    }
    return returnResponse;
}
function getOTypeFromPaymentVal(paymentType, defaultval, paypalval, iatsval, stripeval, authorizeNetval) {
    var returnResponse = defaultval;
    switch (paymentType.toUpperCase()) {
        case 'PAYPAL PRO':
            returnResponse = paypalval;
            break;
        case 'IATS':
            returnResponse = iatsval;
            break;
        case 'STRIPE':
            returnResponse = stripeval;
            break;
        case 'AUTHORIZENET':
            returnResponse = authorizeNetval;
            break;
        default:
            break;
    }
    return returnResponse;
}
/*Multi payment sprint methods ends*/

/*Repeatable Section methods starts*/
function changeSectionConfig(elemSource) {
    var sectionElemDiv = $(elemSource).parents('.formSectionUl');
    $(sectionElemDiv).attr('data-add-link', $('#txtsecrepAddLink').val());
    $(sectionElemDiv).attr('data-remove-link', $('#txtsecrepRemoveLink').val());
    $(sectionElemDiv).attr('data-min-count', $('#txtsecrepMin').val());
    $(sectionElemDiv).attr('data-max-count', $('#txtsecrepMax').val());
    resetRepeatableSectionFooter(sectionElemDiv);
}
function populateRepeatableSectionConfigInfo(sectionElemDiv) {
    $(sectionElemDiv).find('#txtsecrepAddLink').val(safeHTMLValue($(sectionElemDiv).attr('data-add-link'), '+ add another', true));
    $(sectionElemDiv).find('#txtsecrepRemoveLink').val(safeHTMLValue($(sectionElemDiv).attr('data-remove-link'), '- remove', true));
    $(sectionElemDiv).find('#txtsecrepMin').val(safeStringValue($(sectionElemDiv).attr('data-min-count'), '1'));
    $(sectionElemDiv).find('#txtsecrepMax').val(safeStringValue($(sectionElemDiv).attr('data-max-count'), ''));
}
function resetRepeatableSectionFooter(sectionElemDiv) {
    $(sectionElemDiv).find('.ff-section-footer').find('a.ff-add').html(safeHTMLValue($(sectionElemDiv).attr('data-add-link'), '+Add Another', true));
    $(sectionElemDiv).find('.ff-section-footer').find('a.ff-remove').html(safeHTMLValue($(sectionElemDiv).attr('data-remove-link'), '-Remove', true));
}
/*Repeatable Section methods ends*/
function onFormSettingsChange(elemSource, isAutoSave) {
    if (isAutoSave) {
        setTimeout(function () {
            var saveGroupNumber = '';
            try {
                if ($(elemSource).hasClass('form-row-group')) {
                    saveGroupNumber = $(elemSource).attr('data-savegroup');
                } else {
                    saveGroupNumber = $(elemSource).parents('.form-row-group').attr('data-savegroup');
                }
            } catch (err) { }
            if (!isNullOrEmpty(saveGroupNumber)) {
                updateFormSettingsInfo(saveGroupNumber);
            }
        }, 1000);
    }
}
function onFormNameChange(elemSource, isAutoSave) {
    var formname = $(elemSource).val();
    if (!isNullOrEmpty(formname)) {
        var previousFormRecord = {};
        previousFormRecord.Id = FastFormsRecordId;
        previousFormRecord["Name"] = $(elemSource).val();
        updateFormSettingsInfo(1);
    }
}
function updateFormSettingsInfo(saveGroupNumber) {
    var saveData = false;
    var previousFormRecord = {};
    previousFormRecord.Id = FastFormsRecordId;
    switch (saveGroupNumber) {
        case '1':
            var formOptionsXML = '';
            $('.form-setting-wrapper').find('div.form-row-group[data-savegroup="1"],div.form-row-group[data-savegroup="1"] .col-inputs input[data-ff-prop],div.form-row-group[data-savegroup="1"] .col-inputs select[data-ff-prop],div.form-row-group[data-savegroup="1"] .col-inputs textarea[data-ff-prop],div.form-row-group[data-savegroup="1"] .col-inputs pre[data-ff-prop]').each(function (indx, elem) {
                var dataProp = $(elem).attr('data-ff-prop');
                if (!isNullOrEmpty(dataProp)) {
                    saveData = true;
                    if (dataProp == 'Form_Options__c') {
                        var dataSubProp = $(elem).attr('data-ff-sub');
                        switch (dataSubProp) {
                            case 'submitInfo':
                                formOptionsXML += getSubmitInfo();
                                break;
                            case 'saveForLaterInfo':
                                formOptionsXML += getSaveForLaterInfo()

                                break;
                            case 'multiPageInfo':
                                formOptionsXML += getMultiPageInfo();
                                break;
                            default:

                        }
                    } else if (dataProp == 'JSCode__c') {
                        var jseditor = ace.edit("javascriptEditor");
                        if (jseditor != null && jseditor !== undefined) {
                            //previousFormRecord[dataProp] =  jseditor.getValue();
                            getOrSetJavascriptCodeJS(true, jseditor.getValue());
                            //saveData=true;
                        }
                    } else if (!$(elem).hasClass('form-row-group')) {
                        saveData = true;
                        var ctrlType = $(elem)[0].type;
                        if (ctrlType == 'checkbox') {
                            previousFormRecord[dataProp] = $(elem).is(':checked');
                        }
                        else {
                            previousFormRecord[dataProp] = $(elem).val();
                        }
                    }
                }
            });
            if (!isNullOrEmpty(formOptionsXML)) {
                formOptionsXML = '<formOptions>' + formOptionsXML + '</formOptions>';
                previousFormRecord['Form_Options__c'] = formOptionsXML;
            }
            break;
        case '2':
            $('.form-setting-wrapper').find('div.form-row-group[data-savegroup="2"] .col-inputs input[data-ff-prop],div.form-row-group[data-savegroup="2"] .col-inputs select[data-ff-prop],div.form-row-group[data-savegroup="2"] .col-inputs textarea[data-ff-prop]').each(function (indx, elem) {
                var dataProp = $(elem).attr('data-ff-prop');
                if (!isNullOrEmpty(dataProp)) {
                    saveData = true;
                    var ctrlType = $(elem)[0].type;
                    if (ctrlType == 'checkbox') {
                        previousFormRecord[dataProp] = $(elem).is(':checked');
                    }
                    else {
                        previousFormRecord[dataProp] = $(elem).val();
                    }
                }
            });
            break;
        default:
    }
    if (saveData) {
        draftchanges(true);
        previousFormRecord['Draft_Status__c'] = 'Unpublished';
        remoteUpdateFormSettingsInfoJS(previousFormRecord);

    }

}
function resetFormFooterInfo(formOptionXML) {
    $('#formOptionsHidden').val(formOptionXML);
    var formOptionsElem = getXmlElementFromStr(formOptionXML);
    var btnMessage = firstElementByTagName(formOptionsElem, "btnMessage", true);// getXMLElemFirstNode(submitOptions, "btnMessage");
    var btnText = firstElementByTagName(formOptionsElem, "btnText", true);
    var btnUrl = firstElementByTagName(formOptionsElem, "btnUrl", true);
    var redirectEnabled = firstBooleanElementByTagName(formOptionsElem, "redirectEnabled", false);
    var breadcrumbEnabled = firstBooleanElementByTagName(formOptionsElem, "breadcrumbEnabled", false);
    var breadcrumbPrefix = firstElementByTagName(formOptionsElem, "breadcrumbPrefix", true);
    var breadcrumbPrefixEnabled = firstBooleanElementByTagName(formOptionsElem, "breadcrumbPrefixEnabled", false);
    var breadcrumbNumbered = firstBooleanElementByTagName(formOptionsElem, "breadcrumbNumbered", false);

    var pageValidationType = firstElementByTagName(formOptionsElem, "pageValidationType", true);
    var isFooterCustomized = firstBooleanElementByTagName(formOptionsElem, "isFooterCustomized", false);
    var prevBtnText = firstElementByTagName(formOptionsElem, "prevBtnText", true);
    var nextBtnText = firstElementByTagName(formOptionsElem, "nextBtnText", true);

    var isSaveForLaterEnabled = firstBooleanElementByTagName(formOptionsElem, "saveForLaterEnabled", false);
    var saveBtnText = safeStringValue(firstElementByTagName(formOptionsElem, "saveBtnText", true), 'Save');
    var discardBtnText = safeStringValue(firstElementByTagName(formOptionsElem, "discardBtnText", true), 'Discard');
    resetFooterNavigationBtns(btnText, prevBtnText, nextBtnText, saveBtnText, isSaveForLaterEnabled);
resetFooterNavigation();
}

function getMultiPageInfo() {
    var formoptions = '<multiPageInfo>';
    if ($('#mainMultiPageWrapper').find('.form-canvas-multi-page-inner').find('.fc-multi-page-item').length > 1) {
        formoptions += '<multiPageEnabled>true</multiPageEnabled>';
    }
    else {
        formoptions += '<multiPageEnabled>false</multiPageEnabled>';
    }
    formoptions += '<breadcrumbEnabled>' + getFFCheckBoxElemValue($("#chkFormNavigationBar"), false) + '</breadcrumbEnabled>';
    formoptions += '<breadcrumbPrefixEnabled>' + getFFCheckBoxElemValue($("#chkPrefixNumber"), false) + '</breadcrumbPrefixEnabled>';
    formoptions += '<breadcrumbPrefix>' + safeStringValue($("#inputPrefixNumber").val(), "Back") + '</breadcrumbPrefix>';
    formoptions += '<breadcrumbNumbered>' + getFFCheckBoxElemValue($("#chkPagenumberInNavigation"), false) + '</breadcrumbNumbered>';
    var validationtype = safeStringValue($('#selFormValidationType').select2("val"), "");
    if (validationtype == 'page') {
        formoptions += '<pageValidationType>' + validationtype + '</pageValidationType>';
    }
    else {
        formoptions += '<pageValidationType>form</pageValidationType>';
    }
    formoptions += '<isFooterCustomized>' + getFFCheckBoxElemValue($("#chkCustomizeFooterNavigation"), false) + '</isFooterCustomized>';
    formoptions += '<prevBtnText>' + safeStringValue($("#inputBtnPrev").val(), "Back") + '</prevBtnText>';
    formoptions += '<nextBtnText>' + safeStringValue($("#inputBtnNext").val(), "Next") + '</nextBtnText>';
    formoptions += '</multiPageInfo>';
    return formoptions;
}
function getSaveForLaterInfo() {
    var formoptions = '<saveForLaterInfo>';
    formoptions += '<saveForLaterEnabled>' + getFFCheckBoxElemValue($("#chkCustomizeSaveForLater"), false) + '</saveForLaterEnabled>';
    formoptions += '<saveBtnText>' + safeStringValue($("#inputBtnSFLSave").val(), "Save") + '</saveBtnText>';
    formoptions += '<discardBtnText>' + safeStringValue($("#inputBtnSFLDiscard").val(), "Discard") + '</discardBtnText>';
    formoptions += '</saveForLaterInfo>';
    return formoptions;
}
function getSubmitInfo() {
    var formoptions = '<submitInfo>';

    formoptions += '<btnMessage>' + safeStringValue($("#txtareaThankyoumsg").val(), "Thank you for your submission!") + '</btnMessage>';
    formoptions += '<btnText>' + safeStringValue($("#txtbxSubmitButtonLabel").val(), "Send") + '</btnText>';
    formoptions += '<btnUrl>' + safeStringValue($("#txtbxRedirectUrl").val(), "") + '</btnUrl>';
    if ($('a[href$="#formconfirmationRadio2"]').parent().hasClass('active')) {
        formoptions += '<redirectEnabled>true</redirectEnabled>';
    }
    else {
        formoptions += '<redirectEnabled>false</redirectEnabled>';
    }
    formoptions += '</submitInfo>';
    return formoptions;
}
function setFastFormName(origName) {
    if (!isNullOrEmpty(origName)) {
        $('#formTitle').html(origName);
        $('#breadcrumb-formeditor>span').text(getTruncatedFormName(origName));
    }
}
function getTruncatedFormName(origName) {
    if (!isNullOrEmpty(origName)) {
        if (origName.length > 23)
            return origName.substring(0, 23) + '...';
        else
            return origName;
    } else {
        return '';
    }
}
/*Edit Alert JAVASCRIPT starts*/
function toggleAlertsTab(elemSource,sourceevent,isClicked) {
    if(isClicked && isAlertInfoChanged()){
    sourceevent.stopPropagation();
    var dialogBody = "<div class='dialogHeader'><div class='dialogIcon dialogIconAlert'>&nbsp;</div></div><div class='dialogFont'><div class='primary'>All the changes will be lost. Are you sure you want to close this without saving? <br /><br /></div></div>";
        $("#dialog-confirm").html(dialogBody);

       var dialogOptions=commonDialogOptions;
          dialogOptions["buttons"]={                                        
                                      "Yes":{
                                              click: function () {                                              
                                                  $(this).dialog('close');
                                                  resetAlertChangeIndicator();
                                                  toggleAlertTab(elemSource);
                                                toggleAlertsTab(elemSource,sourceevent,false) 
                                              },
                                              text: 'Yes',
                                              'class': 'vabutton1'
                                      },
                                      "No":{
                                              click: function () {                                                                                              
                                                  $(this).dialog('close');
                                                 
                                              },
                                              text: 'No',
                                              'class': 'vabutton2'
                                      } 
                              };
                      $("#dialog-confirm").dialog(dialogOptions);
    }else{
    toggleAlertsTabCallForward(elemSource);
    }
}
function toggleAlertTab(elemSource){
var currentLiElem=$(elemSource).parent();
    $(currentLiElem).parent().find('.active').removeClass('active');
    $(currentLiElem).addClass('active');
    var toggleTabId=$(elemSource).attr('href');
    var mainAlertTab=$(elemSource).parents('.sfff-alert-editor-body');
    $(mainAlertTab).find('.tab-pane').removeClass('active');
    $(mainAlertTab).find('.tab-pane').removeClass('in');
    $(mainAlertTab).find(''+toggleTabId).addClass('active in');
}
function toggleAlertsTabCallForward(elemSource) {
    if($(elemSource).parents('.sfff-alert-editor-body').find('#selectTypeOfAlertTEMP option').length<=0){
    setAlertTypeDropdownElem(elemSource);
    }
    if (!isNullOrEmpty($(elemSource).attr('id'))) {
        if ($(elemSource).attr('id') == 'systemAlert') {
            remoteGetSystemAlertsInfoJS(elemSource);
        } else if ($(elemSource).attr('id') == 'emailTemplates') {
            remoteGetAlertTemplatesInfoJS(elemSource);
        }else if ($(elemSource).attr('id') == 'customAlert') {
            remoteobjGetCustomAlertsInfo(elemSource);
        }
    }
}
function setAlertTypeDropdownElem(elemSource){
    var selectAlertTypeHTML='<option value="">--select an alert type--</option>';
              for (var key in systemAlertTypeMap) {
      if (systemAlertTypeMap.hasOwnProperty(key)) {
        selectAlertTypeHTML+='<option value="'+key+'">'+systemAlertTypeMap[key]+'</option>';
        
      }
    }
    $(elemSource).parents('.sfff-alert-editor-body').find('#selectTypeOfAlertTEMP').html(selectAlertTypeHTML);
}
function populateEmailTemplatesTab(elemSource, alertListInfo) {
    var alertContentHolderElem = $($(elemSource).attr('href')).find('.alert-content-holder');
    if (alertListInfo.ResultText == 'NORESULT') {
        var newalertHtml = '<div class="create-alert-header-block" data-tabtype="emailtemplate" id="pnlForNewalertBlock"><div class="no-alert-block no-alert-block-show"><h2 class="no-alert-text"  >You haven\'t created any custom templates yet.</h2><h4>Want to get started with first one?</h4><a class="vabuttonB1" data-alert-data="noalert" id="btn1" onclick="switchAlertNewBox(this,true); return false;"><span class="btn-icon-plus"></span><span class="btn-text">New Template</span></a></div></div>';
        $(alertContentHolderElem).html(newalertHtml);
    } else {
        
        var alertInfoArr = JSON.parse(alertListInfo.ResultText);
        var headerInfoArr = [];
        headerInfoArr.push(createHeaderInfoObj(SFOrgPrefix + 'Name__c', 'Name'));
        headerInfoArr.push(createHeaderInfoObj(SFOrgPrefix + 'Subject__c', 'Subject'));
        headerInfoArr.push(createHeaderInfoObj('CreatedDate', 'Created'));
        headerInfoArr.push(createHeaderInfoObj('ACTION', ''));
        renderAlertTable(alertContentHolderElem, headerInfoArr, alertInfoArr,false);

    }

}
function populateCustomAlertTab(elemSource, alertListInfo) {
if(alertListInfo!=null && alertListInfo instanceof Object){
        try{
        alertListInfo=Object.keys(alertListInfo).map(function(k) { return alertListInfo[k] });
        }catch(err){

        }
        }
    var alertContentHolderElem = $($(elemSource).attr('href')).find('.alert-content-holder');
    if (alertListInfo == null ||  alertListInfo.length<=0) {
        var newalertHtml = '<div class="create-alert-header-block" data-tabtype="customalert" id="pnlForNewalertBlock"><div class="no-alert-block no-alert-block-show"><h2 class="no-alert-text"  >You haven\'t created any custom alert yet.</h2><h4>Want to get started with first one?</h4><a class="vabuttonB1" data-alert-data="noalert" id="btn1" onclick="switchAlertNewBox(this,false); return false;"><span class="btn-icon-plus"></span><span class="btn-text">New Alert</span></a></div></div>';
        $(alertContentHolderElem).html(newalertHtml);
    } else {
        
        var alertInfoArr = alertListInfo;

        var headerInfoArr = [];
        headerInfoArr.push(createHeaderInfoObj(SFOrgPrefix + 'Alert_Type__c', 'Alert Type'));
        headerInfoArr.push(createHeaderInfoObj(SFOrgPrefix + 'To__c', 'To'));
        headerInfoArr.push(createHeaderInfoObj('CreatedDate', 'Created'));
        headerInfoArr.push(createHeaderInfoObj(SFOrgPrefix + 'Subject__c', 'Subject'));
        headerInfoArr.push(createHeaderInfoObj(SFOrgPrefix + 'Status__c', 'Status'));
        
        headerInfoArr.push(createHeaderInfoObj('ACTION', ''));
        renderAlertTable(alertContentHolderElem, headerInfoArr, alertInfoArr,false);

    }

}
function populateSystemAlertTab(elemSource, alertListInfo) {
    var alertContentHolderElem = $($(elemSource).attr('href')).find('.alert-content-holder');
    var standardAlertTypesArr = systemAlertTypes.slice();
    if (alertListInfo.ResultText == 'NORESULT') {
      
    }
    else {
         
        var alertInfoArr = JSON.parse(alertListInfo.ResultText);
        var headerInfoArr = [];
        headerInfoArr.push(createHeaderInfoObj(SFOrgPrefix + 'Alert_Type__c', 'Alert Type'));
        headerInfoArr.push(createHeaderInfoObj(SFOrgPrefix + 'To__c', 'To'));
        headerInfoArr.push(createHeaderInfoObj(SFOrgPrefix + 'From__c', 'From'));
        headerInfoArr.push(createHeaderInfoObj( SFOrgPrefix + 'Subject__c', 'Subject'));
        headerInfoArr.push(createHeaderInfoObj('ACTION', ''));
        renderAlertTable(alertContentHolderElem, headerInfoArr, alertInfoArr);
        

        $.each(alertInfoArr, function (indx, alertItem) {
            var itemIndex = $.inArray(alertItem[SFOrgPrefix + 'Alert_Type__c'], standardAlertTypesArr);
            if (itemIndex >= 0) {
                standardAlertTypesArr.splice(itemIndex, 1);
            }
        });
        
    }
    if (standardAlertTypesArr != null && standardAlertTypesArr.length > 0) {
        remoteGetStandardAlertsInfoJS(elemSource, standardAlertTypesArr);
    }
}
function remoteobjGetCustomAlertsInfo(elemSource){
  var ct = new ffAlertNS.ffAlertObj();
 var where_condition={where: {Category__c: {eq: 'Custom' }, Form__c: {eq: FastFormsRecordId }}};
 if (!isNullOrEmpty(SFOrgPrefix)) {
 where_condition={where: {VisualAntidote__Category__c: {eq: 'Custom' }, VisualAntidote__Form__c: {eq: FastFormsRecordId }}};
 }
ct.retrieve(function(){
    return(where_condition);
}, function(error,results,eventobj) {
 
if(eventobj.result!=null){
 populateCustomAlertTab(elemSource,eventobj.result.records);
} 
});
}
function remoteobjCreateAlertInfo(alertContentHolderElem,alertInfoObj,alertTab){
    var ffalert = new ffAlertNS.ffAlertObj();
    var isValid=false;
    if(!isNullOrEmpty(alertInfoObj[SFOrgPrefix + 'Category__c']) &&
    !isNullOrEmpty(alertInfoObj[SFOrgPrefix + 'To__c']) && 
    !isNullOrEmpty(alertInfoObj[SFOrgPrefix + 'Subject__c']) &&
    !isNullOrEmpty(alertInfoObj[SFOrgPrefix + 'Alert_Type__c']) ){
    isValid=true;
    }
    if(isValid){
        ffalert.create(alertInfoObj, function(err,event,obj) {
    if(err) { 
        console.log('ERROR while creating Alert__c object:'+err); 
        alertErrorMessage(alertContentHolderElem, 'Something went wrong while inserting  '+getObjDisplayTypeByAlertTab(alertTab)+' information. Please try again.');
    }
    else {
          console.log(ffalert.get('Id')); // Id is set when create completes
         saveAlertInfoCallback(alertContentHolderElem,true);
         updatePreviousFormObjForPublishToggle('Unpublished');
    }
});
}else{
    alertValidationMessage(alertContentHolderElem,'Please provide values for all the fields marked as <b>*</b>.');
}
}
function populateStandardAlertInfo(elemSource, alertListInfo) {
    var alertContentHolderElem = $($(elemSource).attr('href')).find('.alert-content-holder');
    if (alertListInfo.ResultText == 'NORESULT') {
        console.log('Populate Standard Alert Info  No Result');
    } else {
        console.log('Populate Standard Alert Info :' + JSON.parse(alertListInfo.ResultText));
        var alertInfoArr = JSON.parse(alertListInfo.ResultText);
        var headerInfoArr = [];
        headerInfoArr.push(createHeaderInfoObj(SFOrgPrefix + 'Alert_Type__c', 'Alert Type'));
        headerInfoArr.push(createHeaderInfoObj(SFOrgPrefix + 'To__c', 'To'));
        headerInfoArr.push(createHeaderInfoObj(SFOrgPrefix + 'From__c', 'From'));
        headerInfoArr.push(createHeaderInfoObj(SFOrgPrefix + 'Subject__c', 'Subject'));
        headerInfoArr.push(createHeaderInfoObj('ACTION', ''));
        if ($(alertContentHolderElem).find('.fscontent-table').length>0 && $(alertContentHolderElem).find('.fscontent-table .oar-content-row[data-category="Standard"]').length==0) {
            renderAlertTable(alertContentHolderElem, headerInfoArr, alertInfoArr,true);
        } else {
            renderAlertTable(alertContentHolderElem, headerInfoArr, alertInfoArr,false);
        }
    }
}

 function getAlertTabType(alertTabId){
 var alertTab='system';
 if (!isNullOrEmpty(alertTabId)) {
        switch (alertTabId) {
            case 'sfff-custom-alert':
                alertTab = 'custom';
                break;
            case 'sfff-email-template':
                alertTab = 'emailtemplate';
                break;
            default: break;

        }
    }
    return alertTab;
 }
function renderAlertTable(mainOuterElem, headerInfoArr, rowInfoArr,isAppend) {
    var alertTab=getAlertTabType($(mainOuterElem).parent().attr('id'));
    
        var actionExists = false;
        var mainTable;
        if(!isAppend){
            mainTable= $('<div/>', { 'class': 'fscontent-table', 'id': 'oarContentTable' });
            var thRow = $('<div/>', { 'class': 'oar-header-row' });

   
            $.each(headerInfoArr, function (indx, item) {
                if (item.displayName == 'Status') {
                var thItem = $('<div/>', { 'class': 'oar-th fixed130' });
                    thItem.html('<span class="oar-title" data-name="' + item.name + '">' + item.displayName + '</span>');
                    thRow.append(thItem.clone().wrap('<p>').parent().html());
                }
                else if (item.name != 'ACTION') {
                    var thItem = $('<div/>', { 'class': 'oar-th' });
                    thItem.html('<span class="oar-title" data-name="' + item.name + '">' + item.displayName + '</span>');
                    thRow.append(thItem.clone().wrap('<p>').parent().html());

                } else {
                    actionExists = true;
                }
            });
            if (actionExists) {
                var thItem = $('<div/>', { 'class': 'oar-th action-th' });
                thItem.html('');
                thRow.append(thItem.clone().wrap('<p>').parent().html());

            }
            mainTable.append(thRow);
        }else{
            mainTable = $(mainOuterElem).find('.fscontent-table');
        }
        if (rowInfoArr != null && (rowInfoArr instanceof Array) && rowInfoArr.length > 0) {
            $.each(rowInfoArr, function (rindx, resultItem) {
                var tdRow = $('<div/>', { 'class': 'oar-content-row' });
                if (resultItem[SFOrgPrefix + 'Category__c'] != null && resultItem[SFOrgPrefix + 'Category__c'] != "undefined") {
                    tdRow.attr('data-category', resultItem[SFOrgPrefix + 'Category__c']);
                }
                if (resultItem['Id'] != null) {
                    tdRow.attr('data-recid', resultItem['Id']);
                }
                $.each(headerInfoArr, function (tindx, tditem) {
                    if (tditem.name != 'ACTION') {
                        var isDynamic=false;
                        var text = safeHTMLValue(resultItem[tditem.name], '', true);

                        var fieldvalue = safeHTMLValue(resultItem[tditem.name], '', true);
                        var fieldValueArr=parseStringToMergeFieldArr(fieldvalue);
                        if(fieldValueArr!=null && fieldValueArr.length==1 && isFieldExistOnForm(fieldValueArr[0])){
                            isDynamic=true;
                        }
                        if (tditem.name ==SFOrgPrefix+'To__c'  || tditem.name ==SFOrgPrefix+'From__c' || tditem.name ==SFOrgPrefix+'CC__c'  || tditem.name ==SFOrgPrefix+'BCC__c' ) {
                            if(isFormNative && tditem.name ==SFOrgPrefix+'From__c'){
                                text='User:'+FFUserFullName;
                            }else{
                                if (isDynamic) {
                                    text='Field Id:'+fieldValueArr[0];
                                }else{
                                    if(text.indexOf('[[')>=0){
                                        text= text.replace(/\[\[/g,'').replace(/\]\]/g,'');
                                    }
                                    text='Email:'+text ;
                                }
                            }
                        }else if(SFOrgPrefix + 'Alert_Type__c'==tditem.name){
                            var alertType=resultItem[tditem.name];
                            text=   safeStringValue(systemAlertTypeMap[alertType],alertType);
                        }else if(tditem.name=='CreatedDate'){
                        try{
                        var dt=new Date(resultItem[tditem.name]);
                        text=dt.toLocaleString();
                        }catch(Err){

                        }
                        }else if(SFOrgPrefix + 'Subject__c'==tditem.name){
                        text=subsstringWithReadmoreDots(text,40,'...');
                        }else if(SFOrgPrefix + 'Status__c'==tditem.name){
                        var recId=resultItem['Id'];
                        var isActive=getSafeBoolean(resultItem[tditem.name],false);
                        if(isActive){
                        text='<div class="toggle-mode-box-inner mode-active"><div class="toggle-mode-link" data-toggle-id="'+recId+'" onclick="toggleAlertStatus(this,true);"><div class="toggle-mode-switch">&nbsp;</div></div><div class="toggle-mode-status">Active</div></div>';
                        }else{
                        text='<div class="toggle-mode-box-inner"><div class="toggle-mode-link" data-toggle-id="'+recId+'" onclick="toggleAlertStatus(this,true);"><div class="toggle-mode-switch">&nbsp;</div></div><div class="toggle-mode-status">Inactive</div></div>';
                         }
                        }else{
                            if (tditem.name.split('.').length == 2) {
                                var tdArrName = tditem.name.split('.');
                                text = safeHTMLValue(resultItem[tdArrName[0]][tdArrName[1]], '', true);
                            } else if (tditem.name.split('.').length == 3) {
                                var tdArrName = tditem.name.split('.');
                                text = safeHTMLValue(resultItem[tdArrName[0]][tdArrName[1]][tdArrName[2]], '', true);
                            }
                        }
                        var tdItem = $('<div/>', { 'class': 'oar-td' });
                        tdItem.html('<span class="oar-text" data-name="' + tditem.name + '">' + text + '</span>');
                        tdRow.append(tdItem.clone().wrap('<p>').parent().html());

                    }else{
                        actionExists=true;
                    }
                });
                if (actionExists) {
                    var tdItem = $('<div/>', { 'class': 'oar-td action-td' });
                    if(alertTab=='emailtemplate'){
                        tdItem.html('<span class="oar-text blue-tooltip edit-icon"  onclick="editAlertTemplate(this);"><span class="blue-tooltip-text  -ml20">Edit</span></span>');
                        tdItem.append('<span class="oar-text blue-tooltip duplicate-icon" onclick="duplicateAlertTemplate(this);"><span class="blue-tooltip-text  -ml30">Duplicate</span></span>');
                        tdItem.append('<span class="oar-text blue-tooltip delete-icon"  onclick="deleteAlertTemplate(this);"><span class="blue-tooltip-text  -ml20">Delete</span></span>');
                    }else{
                        tdItem.html('<span class="oar-text blue-tooltip edit-icon "  onclick="editAlert(this);"><span class="blue-tooltip-text  -ml20">Edit</span></span>');
                        tdItem.append('<span class="oar-text blue-tooltip duplicate-icon" onclick="duplicateAlert(this);"><span class="blue-tooltip-text -ml30">Duplicate</span></span>');
                        tdItem.append('<span class="oar-text blue-tooltip delete-icon"  onclick="deleteAlert(this);"><span class="blue-tooltip-text  -ml20">Delete</span></span>');
                    }
                
                    tdRow.append(tdItem.clone().wrap('<p>').parent().html());

                }
                mainTable.append(tdRow);
            });
        }
        if(!isAppend){
            var mainTableWrapper = $('<div/>', { 'class': 'fscontent-wrapper-inner' });
            mainTableWrapper.html(mainTable);
            if ($(mainOuterElem).find('.alert-msg-wrapper').length > 0) {
                $(mainOuterElem).html($(mainOuterElem).find('.alert-msg-wrapper').clone().wrap('<p>').parent().html());
            } else {
                $(mainOuterElem).html('');
            }
            $(mainOuterElem).append(mainTableWrapper);
        }
        if(alertTab=='emailtemplate'){
        var newTemplateHTML='<span class="alert-divider"></span><div class="create-alert-block"><div class="create-alert-inner bottom-link-create-alert"><a class="vabuttonB1" data-alert-data="noalert" onclick="switchAlertNewBox(this,true); return false;" data-alert-index="2"><span class="btn-icon-plus"></span><span class="btn-text">New Template</span></a></div></div>';
        $(mainOuterElem).find('.fscontent-wrapper-inner').append(newTemplateHTML);
        }else if(alertTab=='custom'){
        var newAlertHTML='<span class="alert-divider"></span><div class="create-alert-block"><div class="create-alert-inner bottom-link-create-alert"><a class="vabuttonB1" data-alert-data="noalert" onclick="switchAlertNewBox(this,false); return false;" data-alert-index="2"><span class="btn-icon-plus"></span><span class="btn-text">New Alert</span></a></div></div>';
        $(mainOuterElem).find('.fscontent-wrapper-inner').append(newAlertHTML);
        }
    }
    //var xmlDocElement=getEmailDisplayText(getXmlElementFromStr(xmlstr));
    function getEmailDisplayText(xmlDocElement, tagName, defaultValue) {

        var elem = xmlDocElement.getElementsByTagName(tagName);
        if (elem != 'undefined') {
            defaultValue = $(elem[0]).text();
        }
         
        return defaultValue;
    }
    function createHeaderInfoObj(name, displayname) {
        return { 'name': name, 'displayName': displayname };
    }
    function editAlert(elemSource) {
        var recId = $(elemSource).parents('.oar-content-row').attr('data-recid');
        if (!isNullOrEmpty(recId)) {
            remoteGetAlertInfoToEditJS(elemSource, recId);

        }
    }
    function editAlertTemplate(elemSource) {
        var recId = $(elemSource).parents('.oar-content-row').attr('data-recid');
        if (!isNullOrEmpty(recId)) {
            remoteGetAlertTemplateInfoToEditJS(elemSource, recId);
        }
    }
    

    function populateAlertEditInfo(elemSource, editAlertInfo) {
         
        var alertContentHolderElem = $(elemSource).parents('.alert-content-holder');
        var alertInfoObject ;
        try{
        alertInfoObject= JSON.parse(editAlertInfo.ResultText);
        }catch(err){
         alertInfoObject= JSON.parse($('<div/>').html(editAlertInfo.ResultText).text()); 
        }
        $(alertContentHolderElem).find('.email-edit-content').remove();
        var editEmailContentElem = $('<div/>', { 'class': 'email-edit-content' });
        var alertType = alertInfoObject[SFOrgPrefix + 'Alert_Type__c'];     
        $(editEmailContentElem).attr('data-alerttype', alertType);
        $(editEmailContentElem).attr('data-alert-recid', alertInfoObject['Id']);
        //$(editEmailContentElem).attr('data-alerttemplate-recid', alertInfoObject[SFOrgPrefix + 'Alert_Template__c']);
        $(editEmailContentElem).html('<h3>Edit System Alert</h3><div class="silver-line-separator"></div>');
        $(editEmailContentElem).append($('#emailConfigSectionTEMP').html());
        $(editEmailContentElem).append($('#emailTemplateBoxTEMP').html());
        if(isFormNative){
            $(editEmailContentElem).find('.al-email-to-fields').addClass('native-form');
        }
         $(editEmailContentElem).find('.alert-type-row .attachment-group').remove();
        $(editEmailContentElem).find('.alert-type-row .attachment-group').hide();
        $(editEmailContentElem).find('.alert-type-row .input-fields').append('<div class="attachment-group"><div class="pdf-row"><input class="vff-checkbox" id="chkbxAttachPDF"  type="checkbox"><label class="vff-check-label txt-label" for="chkbxAttachPDF">Attach PDF copy of submission</label></div><div class="pdf-row attach-files"><input class="vff-checkbox" id="chkbxAttachFile"  type="checkbox"><label class="vff-check-label txt-label" for="chkbxAttachFile">Attach uploaded files</label></div></div>');

        var templateListRow='<div class="form-row email-template-row"><label class="label-for">Insert a template</label> <div class="input-fields al-alert-template-type"><select  class="select-elem alert-select sel-340" onchange="insertTemplateContent(this)" id="selectAlertTemplates" ><option>-select a template</option></select><div class="save-as-wrapper al-disabled"><span class="save-as-link" onclick="saveNewAlertTemplateAs(this);">Save as new template</span></div></div></div>';
        $(editEmailContentElem).hide();
        $(editEmailContentElem).find('.al-email-content-box').prepend(templateListRow);
        $(alertContentHolderElem).append($(editEmailContentElem).clone().wrap('<p>').parent().html());
        $(alertContentHolderElem).find('.fscontent-wrapper-inner').fadeOut(function () {
            $(alertContentHolderElem).find('.alert-msg-wrapper').fadeOut();
            $(alertContentHolderElem).find('.email-edit-content').fadeIn();
        });
        $(alertContentHolderElem).find('.remove-temp').each(function (ind, elem) {
            if (!isNullOrEmpty($(elem).attr('id'))) {
                var elemId = $(elem).attr('id').replace('TEMP', '');
                $(elem).attr('id', elemId);
                $(elem).attr('name', elemId);
            }
        });
    
        remoteAvailableFormFieldsSortedJS(alertContentHolderElem,alertInfoObject,false);
    }
    function populateCustomAlertEditInfo(elemSource, editAlertInfo,isNew) {
        
        var alertContentHolderElem = $(elemSource).parents('.alert-content-holder');
        
        var alertInfoObject;
        var headerHTML='<h3>Edit Custom Alert</h3><div class="silver-line-separator"></div>';
        if(isNew){
       alertInfoObject= editAlertInfo;
       headerHTML='<h3>New Custom Alert</h3><div class="silver-line-separator"></div>';
        }else{
        try{
        alertInfoObject= JSON.parse(editAlertInfo.ResultText);
        }catch(err){
         alertInfoObject= JSON.parse($('<div/>').html(editAlertInfo.ResultText).text()); 
        }
        }

        $(alertContentHolderElem).find('.email-edit-content').remove();
        var editEmailContentElem = $('<div/>', { 'class': 'email-edit-content' });
        
        
        
        $(editEmailContentElem).html(headerHTML);
        $(editEmailContentElem).append($('#emailConfigSectionTEMP').html());
        $(editEmailContentElem).append($('#emailTemplateBoxTEMP').html());
        if(isFormNative){
            $(editEmailContentElem).find('.al-email-to-fields').addClass('native-form');
        }
         
        $(editEmailContentElem).find('.alert-type-row .attachment-group').remove();
        $(editEmailContentElem).find('.alert-type-row .attachment-group').hide();
            $(editEmailContentElem).find('.alert-type-row .input-fields').append('<div class="attachment-group"><div class="pdf-row"><input class="vff-checkbox" id="chkbxAttachPDF"  type="checkbox"><label class="vff-check-label txt-label" for="chkbxAttachPDF">Attach PDF copy of submission</label></div><div class="pdf-row attach-files"><input class="vff-checkbox" id="chkbxAttachFile"  type="checkbox"><label class="vff-check-label txt-label" for="chkbxAttachFile">Attach uploaded files</label></div></div>');
        if(!isNew){
        var alertType = alertInfoObject[SFOrgPrefix + 'Alert_Type__c'];     
        $(editEmailContentElem).attr('data-alerttype', alertType);
        $(editEmailContentElem).attr('data-alert-recid', alertInfoObject['Id']);
         
        
        }

         var templateListRow='<div class="form-row email-template-row"><label class="label-for">Insert a template</label> <div class="input-fields al-alert-template-type"><select  class="select-elem alert-select sel-340" onchange="insertTemplateContent(this)" id="selectAlertTemplates" ><option>-select a template</option></select><div class="save-as-wrapper al-disabled"><span class="save-as-link" onclick="saveNewAlertTemplateAs(this);">Save as new template</span></div></div></div>';
        $(editEmailContentElem).hide();
        $(editEmailContentElem).find('.al-email-content-box').prepend(templateListRow);
        $(alertContentHolderElem).append($(editEmailContentElem).clone().wrap('<p>').parent().html());
        
        var existingViewElem;
        if($(alertContentHolderElem).find('.fscontent-wrapper-inner').length>0){
        existingViewElem=$(alertContentHolderElem).find('.fscontent-wrapper-inner');
        }else if($(alertContentHolderElem).find('.create-alert-header-block').length>0){
        existingViewElem=$(alertContentHolderElem).find('.create-alert-header-block');
        }
        $(existingViewElem).fadeOut(function () {
            $(alertContentHolderElem).find('.alert-msg-wrapper').fadeOut();
            $(alertContentHolderElem).find('.email-edit-content').fadeIn();
        });
        $(alertContentHolderElem).find('.remove-temp').each(function (ind, elem) {
            if (!isNullOrEmpty($(elem).attr('id'))) {
                var elemId = $(elem).attr('id').replace('TEMP', '');
                $(elem).attr('id', elemId);
                $(elem).attr('name', elemId);
            }
        });
    $(alertContentHolderElem).find('#selectTypeOfAlert').html('<option>--select an alert type--</option><option value="SUCCESSFUL_SUBMISSION">Successful Submission</option>');
    initializeSelect2PlaceHolder($(alertContentHolderElem).find('#selectTypeOfAlert'));
        remoteAvailableFormFieldsSortedJS(alertContentHolderElem,alertInfoObject,false);
    }
    function populateAlertTemplateEditInfo(elemSource, editAlertInfo,isNew) {
 
        var alertContentHolderElem = $(elemSource).parents('.alert-content-holder');
        var alertInfoObject;
        var headerHTML='<h3>Edit Email Template</h3><div class="silver-line-separator"></div>';
        if(isNew){
       alertInfoObject= editAlertInfo;
       headerHTML='<h3>New Email Template</h3><div class="silver-line-separator"></div>';
        }else{
        try{
        alertInfoObject= JSON.parse(editAlertInfo.ResultText);
        }catch(err){
         alertInfoObject= JSON.parse($('<div/>').html(editAlertInfo.ResultText).text()); 
        }
        }

        $(alertContentHolderElem).find('.email-edit-content').remove();
        var editEmailContentElem = $('<div/>', { 'class': 'email-edit-content' });
        var categoryType = alertInfoObject[SFOrgPrefix + 'Category__c'];     
        $(editEmailContentElem).attr('data-category', categoryType);
        $(editEmailContentElem).html(headerHTML);
        if(!isNew){ 
        $(editEmailContentElem).attr('data-alert-recid', alertInfoObject['Id']); 
        }
     
        
     
        $(editEmailContentElem).append($('#emailTemplateBoxTEMP').html());
     
     var templateListRow='<div class="form-row email-template-row"><label class="label-for">Insert a template</label> <div class="input-fields al-alert-template-type"><select  class="select-elem alert-select sel-340" onchange="insertTemplateContent(this)" id="selectAlertTemplates" ><option>-select a template</option></select></div></div>';
     var nameRow='<div class="form-row al-name-row"><label class="label-for">Name<span class="f-req">*</span></label><input type="text" data-isrequired="true" id="txtbxAlertTemplateName"  onblur="onAlertInfoChange(this);" class="al-text-box" name="txtbxAlertTemplateName"></div>';
        $(editEmailContentElem).hide();
        $(editEmailContentElem).find('.al-email-content-box').prepend(templateListRow);
        $(editEmailContentElem).find('.al-email-content-box').prepend(nameRow);
        $(alertContentHolderElem).append($(editEmailContentElem).clone().wrap('<p>').parent().html());
        var existingViewElem;
        if($(alertContentHolderElem).find('.fscontent-wrapper-inner').length>0){
        existingViewElem=$(alertContentHolderElem).find('.fscontent-wrapper-inner');
        }else if($(alertContentHolderElem).find('.create-alert-header-block').length>0){
        existingViewElem=$(alertContentHolderElem).find('.create-alert-header-block');
        }

        $(existingViewElem).fadeOut(function () {
            $(alertContentHolderElem).find('.alert-msg-wrapper').fadeOut();
            $(alertContentHolderElem).find('.email-edit-content').fadeIn();
        });
        $(alertContentHolderElem).find('.remove-temp').each(function (ind, elem) {
            if (!isNullOrEmpty($(elem).attr('id'))) {
                var elemId = $(elem).attr('id').replace('TEMP', '');
                $(elem).attr('id', elemId);
                $(elem).attr('name', elemId);
            }
        });
    
        remoteAvailableFormFieldsSortedJS(alertContentHolderElem,alertInfoObject,isNew);
    }
    function resetAlertTemplateList(parentElem,ffOptionArr){
  

 var selecthtml = generateAlertTemplateSelectHtml(ffOptionArr,null); 
        $(parentElem).find('.al-alert-template-type select.alert-select,.email-template-row select.email-template-select').each(function (rindx, selectElement) {
             
            var selectedValue = $(selectElement).val();
            var elemClass = $(selectElement).attr("class"); 
            $(selectElement).empty();
            $(selectElement).append(selecthtml);
            //$(selectElement).select2();
            initializeSelect2PlaceHolder(selectElement);
            if (!isNullOrEmpty(selectedValue)) { 
                $(selectElement).select2("val", selectedValue);
            }
        
        });

    }
    function populateEditAlertTemplateInfoInputValues(alertContentHolderElem, alertTemplateInfoObject) {
    
       
        try {
            remoteGetAlertTemplatesListJS(alertContentHolderElem);
            var name = alertTemplateInfoObject[SFOrgPrefix + 'Name__c'];
            var emailSubject = alertTemplateInfoObject[SFOrgPrefix + 'Subject__c'];
            var emailBody = alertTemplateInfoObject[SFOrgPrefix + 'Body__c'];
            if (!isNullOrEmpty(name)) {
                $(alertContentHolderElem).find('.al-name-row input.al-text-box').val(name);
            }
            if (!isNullOrEmpty(emailSubject)) {
                $(alertContentHolderElem).find('.al-subject-row input.al-text-box').val(emailSubject);
            }
            if (!isNullOrEmpty(emailBody)) {

                setContentInCKEditor($(alertContentHolderElem).find('.ckeditortext').attr('id'), emailBody);
            }
        } catch (err) {
            console.log('JS error while populating email subject or body' + err.message);
        }
    }
    function populateEditAlertInfoInputValues(alertContentHolderElem, alertInfoObject) {
    var alertTab=getAlertTabType($(alertContentHolderElem).parent().attr('id'));
    if(isFormNative){
    $(alertContentHolderElem).find('.al-alert-to .help-icon').remove();
    $(alertContentHolderElem).find('.al-alert-from .al-toggle-links').remove();
    }
        $(alertContentHolderElem).find('.al-email-to-fields input.el-text-box,.al-email-to-fields select').each(function (indx, inputElem) {
            var dtProp = $(inputElem).attr('data-prop');
            var isDynamic=false;
            var fieldvalue = safeHTMLValue(alertInfoObject[SFOrgPrefix + dtProp], '', true);
            var fieldValueArr=parseStringToMergeFieldArr(fieldvalue);
            if(fieldValueArr!=null && fieldValueArr.length==1 && isFieldExistOnForm(fieldValueArr[0])){
                isDynamic=true;
            }
            if ($(inputElem)[0].type == 'text' && !isDynamic) {
             
                if (dtProp == 'To__c' || dtProp == 'From__c' || dtProp == 'CC__c' || dtProp == 'BCC__c') {
                    if (!isNullOrEmpty(fieldvalue)) {
                        $(inputElem).val(alertInfoObject[SFOrgPrefix + dtProp]);            

                    }

                    if(dtProp == 'To__c' && alertTab=='system'){
                        var originalText=$(inputElem).val();
                        if(originalText.indexOf('[[')>=0){
                            originalText=originalText.replace(/\[\[/g,'').replace(/\]\]/g,'');
                        }
                        var attrs = { };
                        attrs['html']=originalText;
                        $.each($(inputElem)[0].attributes, function(idx, attr) {
                            attrs[attr.nodeName] = attr.nodeValue;
                        });
                        $(inputElem).replaceWith(function () {
                            return $("<label />", attrs).append($(this).contents());
                        });
                    }else if(dtProp =='From__c' && isFormNative){
                        $(inputElem).replaceWith(function () {
                            return $("<label />",{"data-prop":"From__c"}).html('User: '+FFUserFullName);
                        });
                       
                     
                    }
                } else {
                    $(inputElem).val(alertInfoObject[SFOrgPrefix + dtProp]);
                }
            } else if ($(inputElem)[0].type == 'select-one' && isDynamic) {
                $(inputElem).parent().find('.dynamic-alink a.toggle-field-behaviour').click();
                $(inputElem).select2('val', fieldValueArr[0]);
            }
            else if($(inputElem).hasClass('alert-select')){
                $(inputElem).val('val', alertInfoObject[SFOrgPrefix + dtProp]);
                $(inputElem).select2({placeholderOption: 'first'});
                $(inputElem).select2('val', alertInfoObject[SFOrgPrefix + dtProp]);
            }
            else if ($(inputElem)[0].type == 'checkbox') {
                $(inputElem).prop('checked', getSafeBoolean(alertInfoObject[SFOrgPrefix + dtProp], false));
            }
        });
        try {
            if(getSafeBoolean(alertInfoObject[SFOrgPrefix + 'Attach_Files__c'],false)){
                    $(alertContentHolderElem).find('.attachment-group #chkbxAttachFile').prop('checked',true);
                }
                if(getSafeBoolean(alertInfoObject[SFOrgPrefix + 'Attach_PDF__c'],false)){
                    $(alertContentHolderElem).find('.attachment-group #chkbxAttachPDF').prop('checked',true);
                }
            if( alertTab=='system' && $(alertContentHolderElem).find('.attachment-group').length>0){
                $(alertContentHolderElem).find('.attachment-group #chkbxAttachPDF').prop('disabled',true);
                
            }
            
            var alertType=$(alertContentHolderElem).find('select.alert-select').val();
            if($.inArray(alertType,PDFEnabledAlertTypeArr)<0){
            $(alertContentHolderElem).find('.attachment-group').hide(); 
            }else{
            $(alertContentHolderElem).find('.attachment-group').show();
            }
            var emailSubject = alertInfoObject[SFOrgPrefix + 'Subject__c'];
            var emailBody = alertInfoObject[SFOrgPrefix + 'Body__c'];

            if (!isNullOrEmpty(emailSubject)) {
                $(alertContentHolderElem).find('.al-subject-row input.al-text-box').val(emailSubject);
            }
            if (!isNullOrEmpty(emailBody)) {

                setContentInCKEditor($(alertContentHolderElem).find('.ckeditortext').attr('id'), emailBody);
            }
        } catch (err) {
            console.log('JS error while populating email subject or body' + err.message);
        }
    }

    function populateFormFieldsSelectElem(alertContentHolderElem, ffOptionArr,alertInfoObject,isNew) {
    var alertTab=getAlertTabType($(alertContentHolderElem).parent().attr('id'));
        var mergeFields=[];
        var alertType=$(alertContentHolderElem).find('.email-edit-content').attr('data-alerttype');
        if(!isNullOrEmpty(alertType)){ 
            if(fastformsAlertTypeMergeFieldsMap[alertType]!=null){
                var alertTypeMergeFields=fastformsAlertTypeMergeFieldsMap[alertType];
                $.each(alertTypeMergeFields ,function(indx,item){
                    mergeFields.push({'FFText':item,'FFValue':item}); 
                });
            }
        }
        var selecthtml = generateFormFieldsSelectHtml(ffOptionArr,mergeFields);
        $(alertContentHolderElem).find('select.form-fields-select').each(function (rindx, selectElement) {
            $(selectElement).addClass('pps-261');
            var selectedValue = $(selectElement).val();
            var elemClass = $(selectElement).attr("class"); 
            $(selectElement).empty();
            $(selectElement).append(selecthtml);
           // $(selectElement).select2();
            initializeSelect2PlaceHolder(selectElement);
            if (!isNullOrEmpty(selectedValue)) { 
                $(selectElement).select2("val", selectedValue);
            }
        
        });
       // $(alertContentHolderElem).find('select.alert-select').select2();
         initializeSelect2PlaceHolder($(alertContentHolderElem).find('select.alert-select'));
        var selectHTMLEmailOnlyWrapper=$('<div/>').html(selecthtml);
        $(selectHTMLEmailOnlyWrapper).find('option').each(function (rindx, optionElem) {
            if(rindx>0 && $(optionElem).attr('data-type')!='EMAIL'){
                $(optionElem).attr('disabled',true);
                if($(optionElem).parent().hasClass('ff-merge-grp')){
                    $(optionElem).parent().addClass('display-none');
                }
            }
        });
        $(alertContentHolderElem).find('select.email-only').each(function (rindx, selectElement) {
            $(selectElement).empty();
            $(selectElement).append($(selectHTMLEmailOnlyWrapper).html());
        });
        setAlertEditorToolbar(alertContentHolderElem);
        if(!isNew){
        if(alertTab=='emailtemplate'){
        populateEditAlertTemplateInfoInputValues(alertContentHolderElem, alertInfoObject);
        }else{
        populateEditAlertInfoInputValues(alertContentHolderElem, alertInfoObject);
        remoteGetAlertTemplatesListJS(alertContentHolderElem);
        }
        }else{
        if(alertTab=='emailtemplate'){
        remoteGetAlertTemplatesListJS(alertContentHolderElem);
        }else{
        populateEditAlertInfoInputValues(alertContentHolderElem, alertInfoObject);
        remoteGetAlertTemplatesListJS(alertContentHolderElem);
        }
        }
    }
    function setAlertEditorToolbar(alertContentHolderElem) {
        var selectItems = [];

    
    
        $(alertContentHolderElem).find('select.form-fields-select').find('option').each(function (i, optionElem) {

            selectItems.push([$(optionElem).html(), $(optionElem).val()]);

        });



        try {
        $(alertContentHolderElem).find('.ckeditortext').each(function (indx, editElem) {
        $(editElem).attr('id','alerteditor_'+(new Date().getTime()));
        var ckinstance=CKEDITOR.instances[$(editElem).attr('id')];
            if(ckinstance){
            console.log(' CKEditor Instance: ' + ckinstance);
            CKEDITOR.remove(ckinstance);
            }
            });
            $(alertContentHolderElem).find('.ckeditortext').each(function (indx, editElem) {
            
                CKEDITOR.plugins.addExternal('fftoken', FFCKEditorurlroot + '/plugins/fftoken/', 'plugin.js');
                CKEDITOR.replace($(editElem).attr('id'), {
                    extraPlugins: 'fftoken',
                    availableTokens: selectItems,
                    customConfig: FFCKEditorurlroot + '/config.js'

                });
                CKEDITOR.instances[$(editElem).attr('id')].on('blur', function () {
                    var selectedvalue = brTagSafe(this.getData());
                    $(editElem).val(selectedvalue);
                    unsavedTemplateIndicator(alertContentHolderElem);

                });
                 
            });
        }
        catch (err) {
            console.log(' CKEditor toolbar error: ' + err.message);
        }


    }
    function insertFieldToEmailEditor(elemSource) {
        var parentElemnt = $(elemSource).parents('.al-email-content-box');
        var textareaElem = $(parentElemnt).find('textarea');
        var selectedVal = $(parentElemnt).find('.al-email-body-box select.select-elem').select2('val');
        if (!isNullOrEmpty(selectedVal)) {

            selectedVal = '[[' + selectedVal + ']]';


        }
        if (selectedVal != undefined && selectedVal != '') { 
            insertContentInCKEditor($(textareaElem).attr('id'), selectedVal);        
        }
    }
    function cancelAlert(elemSource) {
        var alertContentHolderElem = $(elemSource).parents('.alert-content-holder');
        var alertTab=getAlertTabType($(alertContentHolderElem).parent().attr('id'));
        $(alertContentHolderElem).find('.email-edit-content').fadeOut(function () {
          
            if($(alertContentHolderElem).find('.fscontent-wrapper-inner').length>0){
            $(alertContentHolderElem).find('.fscontent-wrapper-inner').fadeIn();
            }
            else if((alertTab!='sfff-system-alert') && $(alertContentHolderElem).find('.create-alert-header-block').length>0){
            $(alertContentHolderElem).find('.create-alert-header-block').fadeIn();
            $(alertContentHolderElem).find('.no-alert-block').addClass('no-alert-block-show');
            
            }
        });
        resetAlertChangeIndicator();
    }
    function saveAlert(elemSource) {
        var alertContentHolderElem = $(elemSource).parents('.alert-content-holder');
        saveAlertInfo(alertContentHolderElem);
    
    }
    function saveAlertInfo(alertContentHolderElem) {
        var currentAlertRecId=$(alertContentHolderElem).find('.email-edit-content').attr('data-alert-recid');
        var alertTab=getAlertTabType($(alertContentHolderElem).parent().attr('id'));
        
            var alertInfoObject = {}; 
            if(!isNullOrEmpty(currentAlertRecId)){    
            alertInfoObject.Id = currentAlertRecId;
            }
            if(alertTab!='emailtemplate'){
            $(alertContentHolderElem).find('.al-email-to-fields input.el-text-box:not(.display-none),.al-email-to-fields select:not(.display-none)').each(function (indx, inputElem) {
                var dtProp = $(inputElem).attr('data-prop');
                if(!isNullOrEmpty(dtProp)){
                    if ($(inputElem)[0].type == 'text') {
                        alertInfoObject[SFOrgPrefix + dtProp] = $(inputElem).val();          
            
                    } else if ($(inputElem)[0].type == 'select-one') {
                        if($(inputElem).hasClass('alert-select')){
                            alertInfoObject[SFOrgPrefix + dtProp] = $(inputElem).select2('val');
                        }else{
                            alertInfoObject[SFOrgPrefix + dtProp] = '[['+$(inputElem).select2('val')+']]';
                        }
            
                    }
                    else if ($(inputElem)[0].type == 'checkbox') {
                        alertInfoObject[SFOrgPrefix + dtProp] = $(inputElem).is(':checked');
                    }
                }
            });
             }
            try {
             if(alertTab=='emailtemplate'){
                 alertInfoObject[SFOrgPrefix + 'Name__c']=$(alertContentHolderElem).find('.al-name-row input.al-text-box').val();
                 }else{
                  if($(alertContentHolderElem).find('.attachment-group').length>0){
                    alertInfoObject[SFOrgPrefix + 'Attach_PDF__c']=$(alertContentHolderElem).find('.attachment-group #chkbxAttachPDF').is(':checked');
                    alertInfoObject[SFOrgPrefix + 'Attach_Files__c']=$(alertContentHolderElem).find('.attachment-group #chkbxAttachFile').is(':checked');
                    }
                 }
                alertInfoObject[SFOrgPrefix + 'Subject__c'] = $(alertContentHolderElem).find('.al-subject-row input.al-text-box').val();
                alertInfoObject[SFOrgPrefix + 'Body__c'] = brTagSafe(CKEDITOR.instances[$(alertContentHolderElem).find('.ckeditortext').attr('id')].getData());

 
        
            } catch (err) {
                console.log('JS error while saving email subject or body' + err.message);
            }
            if(!isNullOrEmpty(currentAlertRecId)){    
            if(alertTab=='emailtemplate'){
            var templateName= $(alertContentHolderElem).find('.al-name-row input.al-text-box').val();
            validateAlertTemplateName(alertContentHolderElem,templateName,currentAlertRecId);
             
            }
            else if(alertTab=='custom' || alertTab=='system'){             
            remoteUpdateAlertInfoJS(alertContentHolderElem, alertInfoObject,false);
            }else{
            alertErrorMessage(alertContentHolderElem, 'Something went wrong while updating   '+getObjDisplayTypeByAlertTab(alertTab)+' information. Please try again.');
            }
            }else{
            
            if(alertTab=='emailtemplate'){
            //alertInfoObject[SFOrgPrefix + 'Category__c']='Custom';
            var templateName= $(alertContentHolderElem).find('.al-name-row input.al-text-box').val();
            validateAlertTemplateName(alertContentHolderElem,templateName,'');
            
            }
            else if(alertTab=='custom'){
            console.log(' Custom alert created with form id:'+FastFormsRecordId);
            alertInfoObject[SFOrgPrefix + 'Form__c']=FastFormsRecordId;
            alertInfoObject[SFOrgPrefix + 'Category__c']='Custom';
            remoteobjCreateAlertInfo(alertContentHolderElem,alertInfoObject,alertTab);
            }else{
            alertErrorMessage(alertContentHolderElem, 'Something went wrong while inserting   '+getObjDisplayTypeByAlertTab(alertTab)+' information. Please try again.');
            }
            }
     
       resetAlertChangeIndicator();
    }
    function getObjDisplayTypeByAlertTab(alertTab){
    var returnmsg='Alert';
    if(alertTab=='emailtemplate'){
    returnmsg='Alert Template';
    } 
    return returnmsg;
    }
    function saveAlertInfoCallback(alertContentHolderElem,isNew) {
        var toggleTabId = $(alertContentHolderElem).parent().attr('id');
        var successMSG='Alert successfully updated!';
        if(isNew){
        successMSG='Alert successfully created!';
        }
        if($(alertContentHolderElem).find('.email-edit-content').length>0){
        $(alertContentHolderElem).find('.email-edit-content').fadeOut(function () {
        
            var alertMsgWrapper = $('<div/>', { 'class': 'alert-msg-wrapper' });

            alertMsgWrapper.html('<div class="vff-success " id="successAlertActionBox" ><div class="vff-success-msg msg-text-div" onclick="closeNotification(this);">'+successMSG+'</div></div>');
            $(alertContentHolderElem).html($(alertMsgWrapper).clone().wrap('<p>').parent().html());
            toggleTabId=$('#sfff-alert-editor').find('.alert-pills a[href="#'+toggleTabId+'"]').attr('id');
            if (!isNullOrEmpty(toggleTabId)) {
                toggleAlertsTab($('#'+toggleTabId),null,false);
            }
        });
        }else{
        var alertMsgWrapper = $('<div/>', { 'class': 'alert-msg-wrapper' });

            alertMsgWrapper.html('<div class="vff-success " id="successAlertActionBox" ><div class="vff-success-msg msg-text-div" onclick="closeNotification(this);">'+successMSG+'</div></div>');
            $(alertContentHolderElem).html($(alertMsgWrapper).clone().wrap('<p>').parent().html());
            toggleTabId=$('#sfff-alert-editor').find('.alert-pills a[href="#'+toggleTabId+'"]').attr('id');
            if (!isNullOrEmpty(toggleTabId)) {
                toggleAlertsTab($('#'+toggleTabId),null,false);
            }
        }
    }
    function toggleALFieldBlock(elem, elementState, isAutoSave) {
        var parentElement=$(elem).parents('.input-fields');
        if (elementState == 'dynamic') {
            $(parentElement).find('>div.select2-container').remove();
            $(parentElement).find('.el-text-box').addClass('display-none');
            $(parentElement).find('select').removeClass('display-none'); 
            $(parentElement).find('select').removeClass('select2-offscreen');   
             
            initializeSelect2PlaceHolder($(parentElement).find('select'));
        }
        else {
            $(parentElement).find('.el-text-box').removeClass('display-none');
            $(parentElement).find('select').addClass('display-none');
        }
        $(elem).parents('.al-toggle-links').find('li').each(function (indx, liElement) {
            if ($(liElement).hasClass(elementState + '-alink')) {
                $(liElement).addClass('display-none');
            }
            else {
                $(liElement).removeClass('display-none');

            }
        });
    }
    function switchAlertNewBox(elem,isTemplate){
    if ($(elem).attr('data-alert-data') != undefined && $(elem).attr('data-alert-data') == 'noalert') {
        $(elem).attr('data-alert-data', 'alertexists');
        //$(elem).parents('.create-alert-header-block').find('.no-alert-text').fadeOut('slow');
        $(elem).parents('.create-alert-header-block').find('.no-alert-block').removeClass("no-alert-block-show", 500);
      if(isTemplate){
      showCreateNewAlertTemplateBox(elem);
      }else{
        showCreateNewAlertBox(elem);
        }
    }
    else if ($(elem).attr('data-alert-data') != undefined && $(elem).attr('data-alert-data') == 'alertexists') {
    if(isTemplate){
      showCreateNewAlertTemplateBox(elem);
      }else{
        showCreateNewAlertBox(elem);
        }
    }
}
function saveAlertTemplateInfoCallback(alertContentHolderElem,isNew) {
        var toggleTabId = $(alertContentHolderElem).parent().attr('id');
        var successMSG='Email template successfully updated!';
        if(isNew){
        successMSG='Email template successfully created!';
        }
        if($(alertContentHolderElem).find('.email-edit-content').length>0){
        $(alertContentHolderElem).find('.email-edit-content').fadeOut(function () {
        
            var alertMsgWrapper = $('<div/>', { 'class': 'alert-msg-wrapper' });

            alertMsgWrapper.html('<div class="vff-success " id="successAlertActionBox" ><div class="vff-success-msg msg-text-div" onclick="closeNotification(this);">'+successMSG+'</div></div>');
            $(alertContentHolderElem).html($(alertMsgWrapper).clone().wrap('<p>').parent().html());
            toggleTabId=$('#sfff-alert-editor').find('.alert-pills a[href="#'+toggleTabId+'"]').attr('id');
            if (!isNullOrEmpty(toggleTabId)) {
                toggleAlertsTab($('#'+toggleTabId),null,false);
            }
        });
        }else{
        var alertMsgWrapper = $('<div/>', { 'class': 'alert-msg-wrapper' });

            alertMsgWrapper.html('<div class="vff-success " id="successAlertActionBox" ><div class="vff-success-msg msg-text-div" onclick="closeNotification(this);">'+successMSG+'</div></div>');
            $(alertContentHolderElem).html($(alertMsgWrapper).clone().wrap('<p>').parent().html());
            toggleTabId=$('#sfff-alert-editor').find('.alert-pills a[href="#'+toggleTabId+'"]').attr('id');
            if (!isNullOrEmpty(toggleTabId)) {
                toggleAlertsTab($('#'+toggleTabId),null,false);
            }        
        }
    }
function showCreateNewAlertTemplateBox(elemSource){
var propname=SFOrgPrefix+'Category__c';
var newAlertInfo={};
newAlertInfo[propname]='Custom';
    populateAlertTemplateEditInfo(elemSource, newAlertInfo,true)

}
function showCreateNewAlertBox(elemSource){
var propname=SFOrgPrefix+'Category__c';
var newAlertInfo={};
newAlertInfo[propname]='Custom';
    populateCustomAlertEditInfo(elemSource, newAlertInfo,true)

}

function insertTemplateContent(elemSource){
    var selectedval=$(elemSource).val();
    
    if(!$(elemSource).find('option:selected').hasClass('unsaved-template')){
    $(elemSource).find('option.unsaved-template').remove();
     
    initializeSelect2PlaceHolder(elemSource);
    }
    if(!isNullOrEmpty(selectedval) && selectedval!='--select a template--'){
    remoteGetAlertTemplateInfoJS(elemSource,selectedval);
    }  
    onAlertInfoChange(elemSource);  
}

function remoteGetAlertTemplateInfoJSCallback(elemSource,result){
     var parentElem = $(elemSource).parents('.alert-content-holder');
     var isFeatureAlertType=true;
   var featureType=  safeStringValue($(elemSource).parent().parent().attr('data-feature'),'');
   if(!isNullOrEmpty(featureType) && featureType.indexOf('payment')==0){
parentElem = $(elemSource).parents('.email-to-fields-wrapper');
isFeatureAlertType=false;
   }
        var alertInfoObject= JSON.parse(result.ResultText); 
        var objectType=alertInfoObject['attributes']['type'];
        var subject ='';
        var body ='';
        if(!isNullOrEmpty(objectType) && objectType=='EmailTemplate'){
        /*Salesforce EmailTemplate object fields*/
        subject = parseSFMergeFieldsToFFMergePattern(alertInfoObject['Subject']); 
        if(isNullOrEmpty(alertInfoObject['HtmlValue'])){
          body = parseSFMergeFieldsToFFMergePattern(alertInfoObject['Body']);
          body=newlineToBr(body);
        }else{
        body = parseSFMergeFieldsToFFMergePattern(alertInfoObject['HtmlValue']);
        }
         
         
        }else{
          subject = alertInfoObject[SFOrgPrefix + 'Subject__c']; 
          body = alertInfoObject[SFOrgPrefix + 'Body__c']; 
        }

        var parentSectionElem=$(elemSource).parents('.al-email-content-box');
        if(!isFeatureAlertType){
        parentSectionElem=$(elemSource).parents('.email-content-box');
        $(parentSectionElem).find('.email-subject-row input[type="textbox"]').val(subject);
        }else{
        $(parentSectionElem).find('.al-subject-row input[type="text"]').val(subject);
        }
         
       if (!isNullOrEmpty(body)) { 
       setContentInCKEditor($(parentElem).find('.ckeditortext').attr('id'), body);
       var elemSourceId=$(parentElem).find('.ckeditortext').attr('id');
       if(!isNullOrEmpty($('#'+elemSourceId).attr('data-pp-email'))){
              paymentSetupChange($('#'+elemSourceId));
            }
       }
}
function deleteAlertTemplate(elemSource){
    var contentRowElem=$(elemSource).parents('.oar-content-row');
    var alertContentHolderElem = $(contentRowElem).parents('.alert-content-holder');
    $(contentRowElem).addClass('ff-loading');
    var recId=$(contentRowElem).attr('data-recid');
    if(!isNullOrEmpty(recId)){
    var alertTemplate = new ffAlertTemplateNS.ffAlertTemplateDelObj();
    alertTemplate.del(recId, function(err, ids,objevent){
         if (err) {
         console.log('Delte Callback error:'+err); 
         alertErrorMessage(alertContentHolderElem,'Something went wrong while deleting the email template. Please try again.');
         } else {
         $(contentRowElem).fadeOut(200,function(){$(this).remove();resetContentTableVisibility(alertContentHolderElem);});
         }
    });
    }else{
    alertErrorMessage(alertContentHolderElem,'Email template record id not found. Please try again.');
    }     
}
function deleteAlert(elemSource){
    var contentRowElem=$(elemSource).parents('.oar-content-row');
    var alertContentHolderElem = $(contentRowElem).parents('.alert-content-holder');
    $(contentRowElem).addClass('ff-loading');
    var recId=$(contentRowElem).attr('data-recid');
    if(!isNullOrEmpty(recId)){
    var ffalert = new ffAlertNS.ffAlertObj();
    ffalert.del(recId, function(err, ids,objevent){
         if (err) {
         console.log('Delete Callback error:'+err); 
         alertErrorMessage(alertContentHolderElem, 'Something went wrong while deleting the email template. Please try again.');
         } else {
         $(contentRowElem).fadeOut(200,function(){$(this).remove();resetContentTableVisibility(alertContentHolderElem);});
         }
    });
    }else{
    alertErrorMessage(alertContentHolderElem, 'Alert record id not found. Please try again.');
    }     
}
function resetContentTableVisibility(alertContentHolderElem){
    if ($(alertContentHolderElem).find('.fscontent-wrapper-inner .oar-content-row').length<1) { 
         $(alertContentHolderElem).find('.fscontent-wrapper-inner').remove();
         var toggleTabId=$(alertContentHolderElem).parent().attr('id');
         toggleTabId=$('#sfff-alert-editor').find('.alert-pills a[href="#'+toggleTabId+'"]').attr('id');
         toggleAlertsTab($('#'+toggleTabId),null,false);

    }  
}
function duplicateAlertTemplate(elemSource){
 var contentRowElem=$(elemSource).parents('.oar-content-row');
    var alertContentHolderElem = $(contentRowElem).parents('.alert-content-holder');
    var recId=$(contentRowElem).attr('data-recid');
    if(!isNullOrEmpty(recId)){
    $(contentRowElem).addClass('ff-loading');
    remoteDuplicateAlertTemplateInfoJS(alertContentHolderElem,recId);
    }
}
function duplicateAlert(elemSource){
 var contentRowElem=$(elemSource).parents('.oar-content-row');
    var alertContentHolderElem = $(contentRowElem).parents('.alert-content-holder');
    var recId=$(contentRowElem).attr('data-recid');
    if(!isNullOrEmpty(recId)){
    $(contentRowElem).addClass('ff-loading');
    remoteDuplicateAlertInfoJS(alertContentHolderElem,recId);
    }
}
function onAlertTypeChange(elemSource){
var alertType=$(elemSource).val();
var alertContentHolderElem=$(elemSource).parents('.alert-content-holder');
if(!isNullOrEmpty(alertType) && alertType!='--select an alert type--' && $.inArray(alertType,PDFEnabledAlertTypeArr)>=0){

$(alertContentHolderElem).find('.attachment-group').slideDown();
            }else{
            $(alertContentHolderElem).find('.attachment-group').slideUp();
            }
}
function  alertSuccessMessage(alertContentHolderElem,msg){
 
var alertMsgWrapper = $('<div/>', { 'class': 'alert-msg-wrapper' });

            alertMsgWrapper.html('<div class="vff-success " id="successAlertActionBox" ><div class="vff-success-msg msg-text-div" onclick="closeNotification(this);">'+msg+'</div></div>');
            $(alertContentHolderElem).find('.alert-msg-wrapper').remove();
            $(alertContentHolderElem).prepend($(alertMsgWrapper).clone().wrap('<p>').parent().html());
}
function  alertValidationMessage(alertContentHolderElem,msg){
var alertMsgWrapper = $('<div/>', { 'class': 'alert-msg-wrapper' });

            alertMsgWrapper.html('<div class="vff-alert " id="errorAlertActionBox" ><div class="vff-alert-msg msg-text-div" onclick="closeNotification(this);">'+msg+'</div></div>');
            $(alertContentHolderElem).find('.alert-msg-wrapper').remove();
            $(alertContentHolderElem).find('.al-email-content-box').append($(alertMsgWrapper).clone().wrap('<p>').parent().html());
}
function  alertErrorMessage(alertContentHolderElem,msg){
 
var alertMsgWrapper = $('<div/>', { 'class': 'alert-msg-wrapper' });

            alertMsgWrapper.html('<div class="vff-alert " id="errorAlertActionBox" ><div class="vff-alert-msg msg-text-div" onclick="closeNotification(this);">'+msg+'</div></div>');
            $(alertContentHolderElem).find('.alert-msg-wrapper').remove();
            $(alertContentHolderElem).prepend($(alertMsgWrapper).clone().wrap('<p>').parent().html());
}
function hideAlertNotifications(){
$('.sfff-alert-editor-body').find('.alert-msg-wrapper').remove();
}
function toggleAlertStatus(elemSource, isAutoSave)
{
var toggleStatusParent = $(elemSource).parents('.toggle-mode-box-inner'); 
    if ($(toggleStatusParent).hasClass('mode-active')) {
        remoteobjToggleAlertStatus(elemSource, isAutoSave,false);
    } else {
        remoteobjToggleAlertStatus(elemSource, isAutoSave, true);
    }
     
}
function setAlertStatusToggle(elemSource, alertstatus) {
    var toggleStatusParent = $(elemSource).parents('.toggle-mode-box-inner'); 
    
    if (alertstatus) {
         
        $(toggleStatusParent).find('.toggle-mode-status').html('Active');
        $(toggleStatusParent).addClass('mode-active');
    }
    else {
         
        $(toggleStatusParent).find('.toggle-mode-status').html('Inactive');
         
        $(toggleStatusParent).removeClass('mode-active');
        
    }
}
function remoteobjToggleAlertStatus(elemSource,isAutoSave,alertstatus) {
    
    var contentRowElem = $(elemSource).parents('.oar-content-row');
    var alertContentHolderElem = $(elemSource).parents('.alert-content-holder');
    var recId = $(elemSource).attr('data-toggle-id');
    if (!isNullOrEmpty(recId)) {
        var statusField
        var ffalert;
        if (isNullOrEmpty(SFOrgPrefix)) {
            ffalert = new ffAlertNS.ffAlertObj({ Id: recId, Status__c: alertstatus });
        } else {
            ffalert = new ffAlertNS.ffAlertObj({ Id: recId, VisualAntidote__Status__c: alertstatus });
        }
        ffalert.update( function (err, ids, objevent) {
            if (err) {
                console.log('Update Callback error:' + err);
                alertErrorMessage(alertContentHolderElem, 'Something went wrong while changing the alert status. Please try again.');
            } else {
                setAlertStatusToggle($(contentRowElem).find('.toggle-mode-link'), alertstatus);
                draftchanges(true);
                updatePreviousFormObjForPublishToggle('Unpublished');
            }
        });
    } else {
        alertErrorMessage(alertContentHolderElem, 'Alert record id not found. Please try again.');
    }
}



function saveasAlertTemplate(alertContentHolderElem, alertRecId, name) {
  var alertTab=getAlertTabType($(alertContentHolderElem).parent().attr('id'));
    var alertTemplateObj={};
   
    alertTemplateObj[SFOrgPrefix + 'Subject__c'] = $(alertContentHolderElem).find('.al-subject-row input.al-text-box').val();
    alertTemplateObj[SFOrgPrefix + 'Body__c'] = brTagSafe(CKEDITOR.instances[$(alertContentHolderElem).find('.ckeditortext').attr('id')].getData());
    
    if(!isNullOrEmpty(alertRecId)){
    alertTemplateObj.Id=alertRecId;
    if(!isNullOrEmpty(name)){
    alertTemplateObj[SFOrgPrefix + 'Name__c'] = name;
    }
    var ffUpdateTemplateAlertObj = new ffAlertTemplateNS2.ffAlertTemplateCreateObj(alertTemplateObj);
    ffUpdateTemplateAlertObj.update(function (err, event, obj) {
        if (err) {
            console.log('ERROR while updating Alert_Template__c object:' + err);
            alertErrorMessage(alertContentHolderElem, 'Something went wrong while inserting  new Email Tmeplate information. Please try again.');
        }
        else {
            console.log('Alert template updated: ID- '+ffUpdateTemplateAlertObj.get('Id')); 
            if(alertTab=='emailtemplate'){
            saveAlertTemplateInfoCallback(alertContentHolderElem,false);
            }else{
            var newItem = { "FFText": name, "FFValue": ffUpdateTemplateAlertObj.get('Id') };            
            addCustomTemplateItem($(alertContentHolderElem).find('.email-template-row select'), newItem,false);
            }
        }
    });
    }else{

    alertTemplateObj[SFOrgPrefix + 'Name__c'] = name;
    alertTemplateObj[SFOrgPrefix + 'Category__c'] = 'Custom';
    var ffTemplateAlertObj = new ffAlertTemplateNS2.ffAlertTemplateCreateObj();
    ffTemplateAlertObj.create(alertTemplateObj, function (err, event, obj) {
        if (err) {
            console.log('ERROR while creating Alert_Template__c object:' + err);
            alertErrorMessage(alertContentHolderElem, 'Something went wrong while inserting  new Email Tmeplate information. Please try again.');
        }
        else {
            console.log('New alert template created: ID- '+ffTemplateAlertObj.get('Id')); 
            if(alertTab=='emailtemplate'){
            saveAlertTemplateInfoCallback(alertContentHolderElem,true);
            }else{ 
            var newItem = { "FFText": name, "FFValue": ffTemplateAlertObj.get('Id') };            
            addCustomTemplateItem($(alertContentHolderElem).find('.email-template-row select'), newItem,true);
            }
        }
    });
    }
}
 
function saveNewAlertTemplateAs(elemSource) {
    var alertContentHolderElem = $(elemSource).parents('.alert-content-holder');
    var alertRecId = $(elemSource).parents('.email-edit-content').attr('data-alert-recid');
    
        var dialogBody = "<div class='dialogHeader'><div class='dialogIcon dialogIconAlert'>&nbsp;</div></div><div class='dialogFont'><div class='primary'>Save new template as:<br /><br /></div><div class='secondary'>Name:<input style='margin-left:20px;' id='dialogAlertTemplatename' type='text'></div></div>";
        $("#dialog-confirm").html(dialogBody);

        // Define the Dialog and its properties.
        $("#dialog-confirm").dialog({
            resizable: false,
            modal: true,
            title: "Save",
            height: "auto",
            width: 413,
            buttons: {
                "Yes": {
                    click: function () {
                        
                        var name = $('#dialogAlertTemplatename').val();
                        if(!isNullOrEmpty(name) ){
                        $(this).dialog('close');
                        validateAlertTemplateName(alertContentHolderElem,name,'');
                        }else{

                        }
                    },
                    text: 'Save Template',
                    'class': 'vabutton1'
                },
                "No": {
                    click: function () {
                        $(this).dialog('close');

                    },
                    text: 'Cancel',
                    'class': 'vabutton2'
                }

            },
            open: function (event, ui) {
                $('.ui-dialog :button').blur();
            }
        });
     


}
function overwriteAlertTemplate(alertContentHolderElem,templateId) {
     
    //var alertContentHolderElem = $(elemSource).parents('.alert-content-holder');
    if(!isNullOrEmpty(templateId)){
        var dialogBody = "<div class='dialogHeader'><div class='dialogIcon dialogIconAlert'>&nbsp;</div></div><div class='dialogFont'><div class='primary'>A  template already exists with this name. Do you want to overwrite the existing template?<br /><br /></div></div>";
        $("#dialog-confirm").html(dialogBody);

        // Define the Dialog and its properties.
        $("#dialog-confirm").dialog({
            resizable: false,
            modal: true,
            title: "Save",
            height: "auto",
            width: 413,
            buttons: {
                "Yes": {
                    click: function () {
                         
                        $(this).dialog('close');
                        saveasAlertTemplate(alertContentHolderElem,templateId,'');
                        
                    },
                    text: 'Yes',
                    'class': 'vabutton1'
                },
                "No": {
                    click: function () {
                        $(this).dialog('close');

                    },
                    text: 'No',
                    'class': 'vabutton2'
                }

            },
            open: function (event, ui) {
                $('.ui-dialog :button').blur();
            }
        });
    }


}
 
function validateAlertTemplateName(alertContentHolderElem,templateName,templateId){
    var ffTemplateAlertObj = new ffAlertTemplateNS2.ffAlertTemplateCreateObj();
 var where_condition={};
 if (!isNullOrEmpty(SFOrgPrefix)) {
 where_condition={where: {VisualAntidote__Name__c: {eq: templateName }}};
 if(!isNullOrEmpty(templateId)){
 where_condition={where: {VisualAntidote__Name__c: {eq: templateName },Id: {ne: templateId }}};
 }
 }
 else{
where_condition={where: {Name__c: {eq: templateName } }};
 if(!isNullOrEmpty(templateId)){
 where_condition={where: {Name__c: {eq: templateName } ,Id: {ne: templateId }}};
 }
 }
ffTemplateAlertObj.retrieve(function(){
    return(where_condition);
}, function(error,results,eventobj) {
 
if(eventobj.result!=null && eventobj.result.records[0]!==undefined){
 overwriteAlertTemplate(alertContentHolderElem,eventobj.result.records[0].Id);
 
}else{
    saveasAlertTemplate(alertContentHolderElem,templateId,templateName);
}
});
}
 function validateAlertEmail(elemSource){
var isvalid=false;
  var $emailelem = $(elemSource);
  var regex  =  /^\w+@[a-zA-Z0-9_]+?\.[a-zA-Z]{2,3}$/;
  var emailtext=$emailelem.val();
var fieldsArr=parseStringToMergeFieldArr(emailtext);
  if (isNullOrEmpty(emailtext) || (((fieldsArr instanceof Array) && fieldsArr.length>0) || regex.test(emailtext))){
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
 function onAlertInfoChange(elemSource){
var alertContentHolderElem= $(elemSource).parents('.alert-content-holder');
var tabId=$(alertContentHolderElem).parent().attr('id');
var tabTitleElem=$('#sfff-alert-editor').find('.alert-pills a[href="#'+tabId+'"] .tab-title');
if($(tabTitleElem).find('.alert-changed').length==0){
$(tabTitleElem).append('<i class="alert-changed">*</i>');
}
}
function isAlertInfoChanged(){
    if($('#sfff-alert-editor .nav-pills').find('.alert-changed').length>0){
    return true;
    }
    return false;
}
function resetAlertChangeIndicator(){
    $('#sfff-alert-editor .nav-pills').find('.alert-changed').remove();
}

    /*Edit Alert JAVASCRIPT ends*/


