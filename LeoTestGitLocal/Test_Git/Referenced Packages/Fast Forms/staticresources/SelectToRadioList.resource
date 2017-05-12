(function($) {
    var SelectToRadio, root;

    root = typeof window !== "undefined" && window !== null ? window : global;

    root.SelectToRadio = SelectToRadio = (function() {

        function SelectToRadio() {
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

                // run only once
                if (!$elem.data('SelectToRadio')) {

                    if (userOptions.initialSelectValue) {
                        initialOption = $('option[value="' + userOptions.initialSelectValue + '"]', $elem);
                    } else {
                        var intialvalues=[];
                        intialvalues = $('option:selected', $elem);
                        if (intialvalues.length > 1) {
                            $.each(intialvalues, function(index, valueitem) {
                                $elem.find('option[value="' + valueitem + '"]').prop('selected', true);
                                initialOption.push($(valueitem).attr('value'));
                                initialOptionText.push($(valueitem).text());
                            });

                        } else {
                        var valueitem=intialvalues;
                             initialOption.push($(valueitem).attr('value'));
                                initialOptionText.push($(valueitem).text());
                        }
                    }
                    if (userOptions.alignment == 'horizontal') {
                        alignmentClass = 'ff-ext-horizontal';
                    } else {
                        alignmentClass = 'ff-ext-vertical';
                    }
                    if (userOptions.controlType == 'ff-ext-checkbox') {
                        isRadio = false;
                        localControlType = "ff-ext-checkbox";
                        localClasswrapper='checkbox';
                    } else {
                        isRadio = true;
                        localControlType = "ff-ext-radio";
                        localClasswrapper='radiobtn';
                    }

                    $elem.data('SelectToRadio', {

                        userOptions: userOptions,

                        // initial radio based on the OPTION value
                        currentItemValue: initialOption,
                        currentItemText: initialOptionText,

                        // radio will be restored by calling clear method
                        originalItemValue: initialOption,
                        originalItemText: initialOptionText

                    });
                    mainElementId = $elem.attr('id');
                    $widget = $('<div />', {
                        'class': 'ff-select-to-'+localClasswrapper+'-list custom-flex-control-container'
                    }).insertBefore($elem);
                    var $rbUl = $('<ul />', {
                       'id':'ul'+mainElementId, 'class': 'ff-select-to-'+localClasswrapper+'-ul ' + alignmentClass
                    });

                    // create li elements that will replace OPTIONs
                    $elem.find('option').each(function(index) {
                        var val, text,  rbId, html, $li, $label, $inputControl;

                        val = $(this).val();

                        // create radios - but only if val is defined
                        if (val) {
                            
                            text = $(this).text();
                            html = $(this).data('html');
                            rbId = mainElementId + '__' + index;
                            if (html) {
                                text = html
                            }
                            $li = $('<li/>', {
                                class: 'ff-radio-li'
                            });
                            if (!isRadio) {
                                $li = $('<li/>', {
                                    class: 'ff-checkbox-li'
                                });
                            }
                            $label = $('<label/>', {
                                for: rbId,
                                text: text
                            });
                            if (isRadio) {
                                $inputControl = $('<span />', {
                                    'class': 'ff-ext-radio-css',
                                    name: mainElementId,
                                    id: rbId,
                                    value: val
                                });
                            } else {
                                $inputControl = $('<span />', {
                                    'class': 'ff-ext-checkbox-css',
                                    name: mainElementId,
                                    id: rbId,
                                    value: val
                                });
                            }

                            $li.append($inputControl);
                            $li.append($label);
                            $rbUl.append($li);
                        }

                    });
                    $widget.append($rbUl);


                    // first OPTION empty - allow deselecting of radiobtns
                    $elem.data('SelectToRadio').deselectable = (!$elem.find('option:first').val()) ? true : false;

                    // use different jQuery function depending on the 'reverse' setting


                    // additional classes for the widget


                    if (userOptions.readonly) {
                        $widget.addClass('ff-ext-readonly');
                    }

                    // radio change event
                    if (isRadio) 
                    {
                        $widget.on('radiochange',
                            function(event, value, text) {

                                // value or text undefined?
                                value = value ? value : $elem.data('SelectToRadio').currentItemValue;
                                text = text ? text : $elem.data('SelectToRadio').currentItemText;

                                // change selected OPTION in the select box (now hidden)
                                $elem.find('option[value="' + value + '"]').prop('selected', true);
                                console.log(' Item selected' + text);
                                $elem.change();



                            }).trigger('radiochange');

                        // radio style event
                        $widget.on('radiostyle',
                            function(event) {
                                $widget.find('li>span').removeClass('ff-ext-selected');
                                $widget.find('li>span').attr('data-' + localControlType + '-checked', false);

                                // add classes
                                //$(this).find('li  span[value="' + selectedValue + '"]').addClass('ff-ext-selected');
                                var selectedValue = $elem.data('SelectToRadio').currentItemValue;
                                console.log(' currentItemValue '+$elem.data('SelectToRadio').currentItemValue);
                                $(this).find('li  span[value="' + selectedValue + '"]').attr('data-' + localControlType + '-checked', true);
                                $(this).find('li  span[value="' + selectedValue + '"]').addClass('ff-ext-selected');
                            }).trigger('radiostyle');
                    } 
                    else 
                    {
                        //checkbox change event
                        $widget.on('checkboxchange',
                            function(event, value, text) {


                                value = value ? value : $elem.data('SelectToRadio').currentItemValue;
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

                        //checkbox style event
                        $widget.on('checkboxstyle',
                            function(event) {
                                $widget.find('li').removeClass('ff-ext-selected');

                                var value = $elem.data('SelectToRadio').currentItemValue;

                                if (value!==undefined && value.length > 1) {

                                    $.each(value, function(index, valueitem) {
                                        $widget.find('li  span[value="' + valueitem + '"]').attr('data-' + localControlType + '-checked', true);
                                        $widget.find('li span[value="' + valueitem + '"]').addClass('ff-ext-selected');
                                    });
                                  } else if(value!==undefined) {
                                    // change selected OPTION in the select box (now hidden)
                                    $widget.find('li  span[value="' + value + '"]').attr('data-' + localControlType + '-checked', true);
                                    $widget.find('li span[value="' + value + '"]').addClass('ff-ext-selected');
                                }
                            }).trigger('checkboxstyle');
                    }
                    $allLI = $widget.find('li');

                    // fast clicks
                    // do not react to click events if radio is read-only
                    if (userOptions.readonly) {
                        $allLI.on('click', function(event) {
                            event.preventDefault();
                        });
                    }

                    // add interactions
                    if (!userOptions.readonly) {

                        $allLI.on('click', function(event) {
                        
                            if (isRadio) {
                                callBackOnClickEvent(this, event);
                               
                            } else {
                                checkBoxCallBackOnClickEvent(this, event);
                              
                            }
                         
                            return false;
                        });
                    }

                    $allRadios = $widget.find('li span');

                    /* Handle li clicks- for radio button list */
                    function callBackOnClickEvent(thisElement, eventElement) {
                            var $li = $(thisElement),
                                value, text;

                            eventElement.preventDefault();

                            // $allLI.find('span').removeClass('ff-ext-selected');
                            // $li.find('span').addClass('ff-ext-selected');

                            value = $li.find('span').attr('value');
                            text = $li.find('label').text();
                            console.log(' Li value ' + value + ' text' + text);
                            // is current and deselectable?
                            //$elem.find('option').removeAttr('selected');
                            if ($li.find('span').hasClass('ff-ext-selected')) {
                                $li.find('span').removeClass('ff-ext-selected');
                                $li.find('span').attr('data-' + localControlType + '-checked', true);
                                // value = '', text = '';
                            } else {
                                $widget.find('span').removeClass('ff-ext-selected');
                                $widget.find('span').attr('data-' + localControlType + '-checked', false);
                                $li.find('span').addClass('ff-ext-selected');
                                $li.find('span').attr('data-' + localControlType + '-checked', true);
                            }

                            // remember selected radio
                            $elem.data('SelectToRadio').currentItemValue = value;
                            $elem.data('SelectToRadio').currentItemText = text;

                            console.log(' RBText-' + $elem.data('SelectToRadio').currentItemText);
                            // onSelect callback
                            $widget.trigger('radiochange').trigger('radiostyle');
                            userOptions.onSelect.call(
                                thisElement,
                                $elem.data('SelectToRadio').currentItemValue,
                                $elem.data('SelectToRadio').currentItemText
                            );

                        }
                        /* Handle li clicks- for checkbox button list */
                    function checkBoxCallBackOnClickEvent(thisElement, eventElement) {
                        var valueArray = [];
                        var $li = $(thisElement),
                            value, text;

                        eventElement.preventDefault();

                        console.log(' Li value ' + value + ' text' + text);
                        if ($li.find('span').hasClass('ff-ext-selected')) {
                            $li.find('span').removeClass('ff-ext-selected');
                            $li.find('span').attr('data-' + localControlType + '-checked', false);
                            // value = '', text = '';
                        } else {
                            $li.find('span').addClass('ff-ext-selected');
                            $li.find('span').attr('data-' + localControlType + '-checked', true);
                        }

                        $(thisElement).parent().find('li span').each(function(i, spanelement) {
                            if ($(spanelement).attr('data-' + localControlType + '-checked') == 'true') {
                                valueArray.push($(spanelement).attr('value'));
                            }
                        });


                        $elem.data('SelectToRadio').currentItemValue = valueArray;


                        console.log(' Checkbox text-' + $elem.data('SelectToRadio').currentItemValue);
                        // onSelect callback
                        $widget.trigger('checkboxchange').trigger('checkboxstyle');
                        userOptions.onSelect.call(
                            thisElement,
                            $elem.data('SelectToRadio').currentItemValue,
                            ''
                        );

                    }

                    // hide the select box
                    //$elem.hide();
                    if (!$elem.hasClass('custom-select-offscreen')) {
                        $elem.addClass('custom-select-offscreen');
                    }
                }
            };
            this.destroy = function() {

                var value = this.$elem.data('SelectToRadio').currentItemValue;
                var text = this.$elem.data('SelectToRadio').currentItemText;
                var options = this.$elem.data('SelectToRadio').userOptions;

                this.$elem.removeData('SelectToRadio');

                this.$widget.off().remove();

                // show the select box
                //this.$elem.show();
                this.$elem.removeClass('custom-select-offscreen');

                // onDestroy callback
                options.onDestroy.call(
                    this,
                    value,
                    text
                );

            };
        }

        SelectToRadio.prototype.init = function(options, elem) {
            var self;
            self = this;
            self.elem = elem;
            self.$elem = $(elem);

            return self.options = $.extend({}, $.fn.SelectToRadio.defaults, options);
        };

        return SelectToRadio;

    })();

    $.fn.SelectToRadio = function(method, options) {
        return this.each(function() {
            var plugin = new SelectToRadio();

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
                    if (plugin.$widget && plugin.$elem.data('SelectToRadio')) {
                        return plugin[method](options);
                    }
                }

                // no method supplied or only options supplied
            } else if (typeof method === 'object' || !method) {
                options = method;
                plugin.init(options, this);
                return plugin.show();

            } else {
                $.error('Method ' + method + ' does not exist on jQuery.SelectToRadio');
            }

        });
    };
    return $.fn.SelectToRadio.defaults = {
        initialSelectValue: null, // initial radio value
        controlType: 'ff-ext-radio',
        alignment: 'vertical', // layout vertical or horizontal
        readonly: false, // make the radio ready-only?
        onSelect: function(value, text) {}, // callback fired when a radio is selected
        onDestroy: function(value, text) {} // callback fired when a widget is destroyed
    };
})(jQuery);