(function($) {
    var SelectToPicklist, root;

    root = typeof window !== "undefined" && window !== null ? window : global;

    root.SelectToPicklist = SelectToPicklist = (function() {

        function SelectToPicklist() {
            this.show = function() {
                var $elem = this.$elem,
                    $widget,
                    $all,
                    isRadio,
                    mainElementId,
                    alignmentClass,
                    localControlType,
                    localClasswrapper,
                    userOptions = this.options,
                    initialOption = [],
                    initialOptionText = [];

                    /*all local functions*/
                    function _localResetCollapsedItems(widgetElem, currentValues) {
                    $(widgetElem).find('.ffp-collapsed-state ul.ff-select-to-picklist-ul').html('');
                    $(widgetElem).find('.ffp-collapsed-state  .ffp-input-toggle .ffp-txt').html('');
                    $(widgetElem).find('.ffp-collapsed-state  .ffp-input-toggle').removeClass('ff-moreitems');
                    if (currentValues!==undefined && currentValues.length > 1) {

                                    $.each(currentValues, function(index, valueitem) {
                                        var val;
                                        val = currentValues[index];
                                    // create item - but only if val is defined
                                   var ulElem=$(widgetElem).find('.ffp-collapsed-state ul.ff-select-to-picklist-ul');
                                    _localAppendLiToUL(val,ulElem,index,'ffp-pill-li');
                                     _localResetMoreItemsText(widgetElem);
                                    });
                                  } else if(currentValues!==undefined) {
                                  var ulElem=$(widgetElem).find('.ffp-collapsed-state ul.ff-select-to-picklist-ul');
                                    _localAppendLiToUL(currentValues,ulElem,0,'ffp-pill-li');
                                  _localResetMoreItemsText(widgetElem);
                                }
                                _localResetBindClicksCollapsedItems();
                    }
                    function _localResetMoreItemsText(widgetElem) {
                    $(widgetElem).find('.ffp-collapsed-state  .ffp-input-toggle .ffp-txt').html('');
                    var ulElem=$(widgetElem).find('.ffp-collapsed-state ul.ff-select-to-picklist-ul');
                    var numberOfRows=_localCalculateNumberOfRowsInUL(ulElem);
                     if(numberOfRows>2){
                       var moreItemCount=_localCalculateNumberOfLIItemsAfterRowIndexInUL(ulElem,2);
                       $(widgetElem).find('.ffp-collapsed-state  .ffp-input-toggle .ffp-txt').html('... +'+moreItemCount);
                       
                     }if(numberOfRows>0){
                     $(widgetElem).find('.ffp-collapsed-state  .ffp-input-toggle').addClass('ff-moreitems');
                     }
                    }
                    function _localCalculateNumberOfLIItemsAfterRowIndexInUL(ulElement,rowIndex) {
                        var numberOfLiItems= 0;
                        var numberOfRows = 0;
                        $(ulElement).find('>li').each(function() {
                            if($(this).prev().length > 0) {
                                if($(this).position().top != $(this).prev().position().top){
                                numberOfRows++;
                                }
                                if(numberOfRows>rowIndex){
                                numberOfLiItems++;
                                }
                            }
                            else {
                                numberOfRows++;   
                            }
                        });
                        return numberOfLiItems;
                    }
                    function _localCalculateNumberOfRowsInUL(ulElement) {
                        var numberOfRows = 0;
                        $(ulElement).find('>li').each(function() {
                            if($(this).prev().length > 0) {
                                if($(this).position().top != $(this).prev().position().top){
                                numberOfRows++;
                                }
                            }
                            else {
                                numberOfRows++;   
                            }
                        });
                        return numberOfRows;
                    }
                    function _localAppendLiToUL(itemVal,ulItem,indx,liItemClass){
                    var   text,  rbId, html, $li, $label, $spanControl;
                     if (!isNullOrEmpty(itemVal)) {
                     text = itemVal;
                                                html = itemVal;
                                                rbId = mainElementId + '__'+indx;
                                                if (html) {
                                                    text = html
                                                }
                                                
                                                    $li = $('<li/>', {
                                                        class:liItemClass 
                                                    });
                                                
                                                $label = $('<label/>', {
                                                    for: rbId,
                                                    text: text,
                                                    'data-val': itemVal
                                                });
                                                 
                                                    $spanControl = $('<span />', {
                                                        'class': 'ff-ext-checkbox-css',
                                                        name: mainElementId,
                                                        id: rbId,
                                                        value: itemVal
                                                    });
                                                 

                                                $li.append($spanControl);
                                                $li.append($label);
                                              $(ulItem).append($li);
                                              }
                    }
                    function _localResetBindClicksCollapsedItems(){
                        $allCollapsedLi = $widget.find('li.ffp-pill-li>span');
                        $allCollapsedLi.unbind( "click" );
                            $allCollapsedLi.on('click', function(event) { 
                                    _localOnItemRemoveClick(this, event);
                                   return false;
                            });
                     
                    }
                    function _localFilterPicklistItems(thisElement,eventElement){
                    var txtToSearch=$(thisElement).val();
                    if(!isNullOrEmpty(txtToSearch) && txtToSearch.length>0)
                         {
                         $(thisElement).parent().find('ul.ff-select-to-picklist-ul>li').each(function(indx,elemLi){
                           var datatext=$(elemLi).find('span').attr('value');
                         if(!isNullOrEmpty(datatext) && datatext.toLowerCase().indexOf(txtToSearch.toLowerCase())>=0){
                               $(elemLi).removeClass('display-none');
                            }
                            else
                            {
                            $(elemLi).addClass('display-none');
                            }
                         });
                         }
                         else{
                         $(thisElement).parent().find('ul.ff-select-to-picklist-ul>li').each(function(indx,elemLi){
                         $(elemLi).removeClass('display-none');
                         });
                         }
                    }
                    function _localOnExpandToggleEvent(thisElement, eventElement) {
                        var $toggleSpan = $(thisElement);
                        $toggleSpan.parents('.ff-select-to-picklist-list').find('.ffp-collapsed-state').removeClass('active');
                        $toggleSpan.parents('.ff-select-to-picklist-list').find('.ffp-expanded-state').addClass('active');
                        _localResetMoreItemsText($toggleSpan.parents('.custom-picklist-control-container'));
                          eventElement.preventDefault();
                    }
                    
                    function _localResetPicklistItems(thisElement,eventElement){
                        eventElement.preventDefault();
                        var valueArr=[];
                        var parentElem=$(thisElement).parents('.ff-select-to-picklist-list');
                        var selectItems=false;
                        if($(thisElement).text()=='Select all'){
                        selectItems=true;
                        }
                          if(selectItems){
                           $(parentElem).find('li.pick-item').each(function(indx,liElem){
                           var currentVal=$(liElem).find('.ff-ext-checkbox-css').attr('value');
                           if(!isNullOrEmpty(currentVal)){
                           valueArr.push(currentVal);
                          /* if(!$(liElem).hasClass('ff-selected')){
                           $(liElem).addClass('ff-selected');
                           }
                             $(liElem).find('span').attr('data-' + localControlType + '-checked', true);*/
                             }
                           });

                           $(thisElement).text('Deselect all');
                           
                          } else{
                          $(thisElement).text('Select all');
                          /*$(parentElem).find('li.pick-item').each(function(indx,liElem){
                             $(liElem).removeClass('ff-selected');
                            $(liElem).find('span').attr('data-' + localControlType + '-checked', false);
                           });                        */
                          }
                          $elem.data('SelectToPicklist').currentItemValue = valueArr;  
                            $widget.trigger('checkboxchange').trigger('checkboxstyle');
                         
                    }
                    function _localOnCollapseToggleEvent(thisElement, eventElement) {
                        var $toggleSpan = $(thisElement);
                        $toggleSpan.parents('.ff-select-to-picklist-list').find('.ffp-collapsed-state').addClass('active');
                        $toggleSpan.parents('.ff-select-to-picklist-list').find('.ffp-expanded-state').removeClass('active');
                        _localResetMoreItemsText($toggleSpan.parents('.custom-picklist-control-container'));
                          eventElement.preventDefault();
                    }
                    
                    /* Handle li clicks- to remove selected li from collapsed list */
                    function _localOnItemRemoveClick(thisElement, eventElement) {
                           var valueArray = [];
                           var ulELem=$(thisElement).parent().parent();
                            eventElement.preventDefault();
                            $(thisElement).parent().remove();
                        $(ulELem).find('li').each(function(i, liElement) {
                             if(!isNullOrEmpty($(liElement).find('label').attr('data-val'))){
                                valueArray.push($(liElement).find('label').attr('data-val'));
                                }
                             
                        });


                        $elem.data('SelectToPicklist').currentItemValue = valueArray;
 
                        // onSelect callback
                        $widget.trigger('checkboxchange').trigger('checkboxstyle');
                        userOptions.onSelect.call(
                            thisElement,
                            $elem.data('SelectToPicklist').currentItemValue,
                            ''
                        );

                        }
                        /* Handle li clicks- for checkbox button list */
                    function _localOnItemSelectClick(thisElement, eventElement) {
                        var valueArray = [];
                        var $li = $(thisElement),
                            value, text;

                        eventElement.preventDefault();

                        console.log(' Li value ' + value + ' text' + text);
                        if ($li.hasClass('ff-selected')) {
                            $li.removeClass('ff-selected');
                            $li.find('span').attr('data-' + localControlType + '-checked', false);
                             
                        } else {
                            $li.addClass('ff-selected');
                            $li.find('span').attr('data-' + localControlType + '-checked', true);
                        }

                        $(thisElement).parent().find('li span').each(function(i, spanelement) {
                            if ($(spanelement).attr('data-' + localControlType + '-checked') == 'true') {
                                valueArray.push($(spanelement).attr('value'));
                            }
                        });


                        $elem.data('SelectToPicklist').currentItemValue = valueArray;
 
                        // onSelect callback
                        $widget.trigger('checkboxchange').trigger('checkboxstyle');
                        userOptions.onSelect.call(
                            thisElement,
                            $elem.data('SelectToPicklist').currentItemValue,
                            ''
                        );

                    }
                    /*all local functions end*/
                // run only once
                if (!$elem.data('SelectToPicklist')) {

                    if (userOptions.initialSelectValue) {
                        initialOption = $('option[value="' + userOptions.initialSelectValue + '"]', $elem);
                    } else {
                        
                        $elem.find('option').each(function(indx,optionElem){
                        if($(optionElem).is(':selected')){
                        
                        initialOption.push($(optionElem).attr('value'));
                        initialOptionText.push($(optionElem).text());
                        } 
                        });
                        
                       /* intialvalues = $('option:selected', $elem);
                        if (intialvalues instanceof Array && intialvalues.length > 1) {
                            $.each(intialvalues, function(index, valueitem) {
                                $elem.find('option[value="' + valueitem + '"]').prop('selected', true);
                                initialOption.push($(valueitem).attr('value'));
                                initialOptionText.push($(valueitem).text());
                            });

                        } else {
                        var valueitem=intialvalues;
                             initialOption.push($(valueitem).attr('value'));
                                initialOptionText.push($(valueitem).text());
                        }*/
                    }
                    if (userOptions.alignment == 'horizontal') {
                        alignmentClass = 'ff-ext-horizontal';
                    } else {
                        alignmentClass = 'ff-ext-vertical';
                    }
                    isRadio = false;
                    localControlType = "ff-ext-checkbox";
                     localClasswrapper='picklist';
                    

                    $elem.data('SelectToPicklist', {

                        userOptions: userOptions,

                        // initial radio based on the OPTION value
                        currentItemValue: initialOption,
                        currentItemText: initialOptionText,

                        // radio will be restored by calling clear method
                        originalItemValue: initialOption,
                        originalItemText: initialOptionText

                    });
                   /* $elem.attr('id');*/
                    
                    mainElementId =  Math.random().toString(36).substr(2, 9);
                       
                    $widget = $('<div />', {
                        'class': 'ff-select-to-'+localClasswrapper+'-list custom-picklist-control-container'
                    }).insertBefore($elem);
                    
                    $collapsedStateWrapper = $('<div />', {
                        'class': 'ffp-collapsed-state custom-picklist-container-item active'
                    });
                    $expandedStateWrapper = $('<div />', {
                        'class': 'ffp-expanded-state custom-picklist-container-item'
                    });
                    
                    var $inputToggleElem = $('<span />', {
                       'id':'spanToggle_'+mainElementId, 'class': 'ffp-input-toggle'
                    });
                    var $inputToggleTxtElem = $('<span />', {
                       'id':'spanTxt_'+mainElementId, 'class': 'ffp-txt'
                    });
                    var $inputToggleIconElem = $('<span />', {  'class': 'ffp-ic'
                    });
                    
                    
                     var $inputSearchElem = $('<input />', { type:'textbox',
                       'id':'inputPick_'+mainElementId, 'class': 'ffp-input-search','placeholder':'Search for values'
                    });
                    var $picklistFooterElem = $('<div />', {
                       'id':'divFooter_'+mainElementId, 'class': 'ffp-footer'
                    });
                    var $toggleSelectOptionsElem = $('<span />', {
                       'id':'selectToggle_'+mainElementId, 'class': 'ffp-select-toggle','html':'Deselect all'
                    });
                    var $footerInputToggleElem = $('<span />', {
                       'id':'spanFooterToggle_'+mainElementId, 'class': 'ffp-input-footer-toggle'
                    });
                    $inputToggleElem.html($inputToggleTxtElem);
                    $inputToggleElem.append($inputToggleIconElem);
                     $picklistFooterElem.html($toggleSelectOptionsElem);
                     $picklistFooterElem.append($footerInputToggleElem);
                     
                     var $rbUl = $('<ul />', {
                       'id':'ul'+mainElementId, 'class': 'ff-select-to-'+localClasswrapper+'-ul ' + alignmentClass
                    });
                    /* create li elements that will replace OPTIONs*/
                    $elem.find('option').each(function(index) {
                        var val;
                        val = $(this).val();
                       var ulElem=$rbUl;
                       /*Last argument in following function decides which Ul Items to be updated -[pick-item] is for expanded LI items and  [ffp-pill-li] is for collapsed LI items*/
                       _localAppendLiToUL(val,ulElem,index,'pick-item');                         

                    });
                    var $rbSelectedUl = $('<ul />', {
                       'id':'ulPick_'+mainElementId, 'class': 'ff-select-to-picklist-ul'
                    });
                     if (initialOption instanceof Array && initialOption.length>0) {
                    $.each(initialOption,function(index) {
                        var val;
                        val = initialOption[index];
                        var ulElem=$rbSelectedUl;
                       _localAppendLiToUL(val,ulElem,index,'ffp-pill-li');

                    });
                    }else{
                    var val;

                        val = initialOption;
                        var ulElem=$rbSelectedUl;
                        _localAppendLiToUL(val,ulElem,0,'ffp-pill-li');                        

                    }
                    $collapsedStateWrapper.html($rbSelectedUl);
                    $collapsedStateWrapper.append($inputToggleElem);
                    $expandedStateWrapper.html($inputSearchElem);
                    $expandedStateWrapper.append($rbUl);
                    $expandedStateWrapper.append($picklistFooterElem);
                    $widget.append($collapsedStateWrapper);
                    $widget.append($expandedStateWrapper);



                    // first OPTION empty - allow deselecting of radiobtns
                    $elem.data('SelectToPicklist').deselectable = (!$elem.find('option:first').val()) ? true : false;
                    _localResetBindClicksCollapsedItems();
                     

                    if (userOptions.readonly) {
                        $widget.addClass('ff-ext-readonly');
                    } 
                        /*checkbox style event- it updates the actual hidden select element widget is binded to*/
                        $widget.on('checkboxchange',
                            function(event, value, text) {


                                value = value ? value : $elem.data('SelectToPicklist').currentItemValue;
                                    /*added to fix val() issue */
                                    $elem.find('option').prop('selected', false);
                                    /*added to fix val() issue */
                                if (value!==undefined && value.length > 1) {
                                    $elem.find('option').prop('selected', false);
                                    $.each(value, function(index, valueitem) {
                                        $elem.find('option[value="' + valueitem + '"]').prop('selected', true);
                                    });
                                } else if(value!==undefined) {
                                    // change selected OPTION in the select box (now hidden)
                                    $elem.find('option[value="' + value + '"]').prop('selected', true);
                                }
                                else{

                                }

                                $elem.change();



                            }).trigger('checkboxchange');

                       /*checkbox style event- it updates the visible elements of the widget*/
                        $widget.on('checkboxstyle',
                            function(event) {
                                $widget.find('.ffp-expanded-state li').removeClass('ff-selected');

                                var value = $elem.data('SelectToPicklist').currentItemValue;
                                $widget.find('.ffp-expanded-state li  span').each(function(indx,elem){
                                $(elem).attr('data-' + localControlType + '-checked', false);
                                });
                                if (value!==undefined && value.length > 1) {

                                    $.each(value, function(index, valueitem) {
                                        $widget.find('.ffp-expanded-state li  span[value="' + valueitem + '"]').attr('data-' + localControlType + '-checked', true);
                                        $widget.find('.ffp-expanded-state li span[value="' + valueitem + '"]').parent().addClass('ff-selected');
                                    });
                                  } else if(value!==undefined) {
                                   
                                    $widget.find('.ffp-expanded-state li  span[value="' + value + '"]').attr('data-' + localControlType + '-checked', true);
                                    $widget.find('.ffp-expanded-state li span[value="' + value + '"]').parent().addClass('ff-selected');
                                }
                                _localResetCollapsedItems($widget,value);
                            }).trigger('checkboxstyle');
                     
                    $allExpandedLi = $widget.find('li.pick-item');
                    /*Event binding*/
                    if (!userOptions.readonly) {
                        $allExpandedLi.on('click', function(event) {     
                                _localOnItemSelectClick(this, event);
                            return false;
                        });
                    }

                    $expandPicklist = $widget.find('.custom-picklist-container-item .ffp-input-toggle');
                    if (!userOptions.readonly) {

                        $expandPicklist.on('click', function(event) {                         
                                _localOnExpandToggleEvent(this, event);
                              return false;
                        });
                    }
                    $collapsePicklist = $widget.find('.custom-picklist-container-item .ffp-input-footer-toggle');
                    if (!userOptions.readonly) {

                        $collapsePicklist.on('click', function(event) {                         
                                _localOnCollapseToggleEvent(this, event);
                              return false;
                        });
                    }
                    $widget.find('.ffp-select-toggle').on('click', function(event) {                         
                                _localResetPicklistItems(this, event);
                              return false;
                        });
                    $widget.find('.ffp-input-search').on('keyup', function(event) {                         
                                _localFilterPicklistItems(this, event);
                              return false;
                        });



                    

                    // hide the select box
                    
                    if (!$elem.hasClass('custom-select-offscreen')) {
                        $elem.addClass('custom-select-offscreen');
                    }
                }
            };
            this.destroy = function() {

                var value = this.$elem.data('SelectToPicklist').currentItemValue;
                var text = this.$elem.data('SelectToPicklist').currentItemText;
                var options = this.$elem.data('SelectToPicklist').userOptions;

                this.$elem.removeData('SelectToPicklist');

                this.$widget.off().remove(); 
                this.$elem.removeClass('custom-select-offscreen');

                // onDestroy callback
                options.onDestroy.call(
                    this,
                    value,
                    text
                );

            };

        }

        SelectToPicklist.prototype.init = function(options, elem) {
            var self;
            self = this;
            self.elem = elem;
            self.$elem = $(elem);

            return self.options = $.extend({}, $.fn.SelectToPicklist.defaults, options);
        };

        return SelectToPicklist;

    })();

    $.fn.SelectToPicklist = function(method, options) {
        return this.each(function() {
            var plugin = new SelectToPicklist();

            // plugin works with select fields
            if (!$(this).is('select')) {
                $.error('Sorry, this plugin only works with select fields.');
            }

            // method supplied
            if (plugin.hasOwnProperty(method)) {
                plugin.init(options, this);
                if (method === 'show') {
                    return plugin.show(options);
                } else {
                    if (!$(this).hasClass('custom-select-offscreen')) {
                        $(this).addClass('custom-select-offscreen')
                    }
                    if (this.options.controlType == "ff-ext-checkbox") {
                        plugin.$widget = $(this).prev('.ff-select-to-checkbox-list');
                    } else {
                        plugin.$widget = $(this).prev('.ff-select-to-radiobtn-list');
                    }
                    // widget exists?
                    if (plugin.$widget && plugin.$elem.data('SelectToPicklist')) {
                        return plugin[method](options);
                    }
                }

                // no method supplied or only options supplied
            } else if (typeof method === 'object' || !method) {
                options = method;
                plugin.init(options, this);
                return plugin.show();

            } else {
                $.error('Method ' + method + ' does not exist on jQuery.SelectToPicklist');
            }

        });
    };
    return $.fn.SelectToPicklist.defaults = {
        initialSelectValue: null, // initial radio value
        controlType: 'ff-ext-checkbox',
        alignment: 'vertical', // layout vertical or horizontal
        readonly: false, // make the radio ready-only?
        onSelect: function(value, text) {}, // callback fired when a radio is selected 
         onDestroy: function(value, text) {} // callback fired when a widget is destroyed
    };
})(jQuery);