/**=========================================================
 * Module: portlet.js
 * Drag and drop any card to change its position
 * The Selector should could be applied to any object that contains
 * card, so .col-* element are ideal.
 =========================================================*/

import $ from 'jquery';
// Storages
import Storages from 'js-storage';
// jQueryUI
import 'components-jqueryui/jquery-ui.js';
import 'components-jqueryui/themes/smoothness/jquery-ui.css';

const STORAGE_KEY_NAME = 'jq-portletState';

function initPortlets() {

    // Component is NOT optional
    if (!$.fn.sortable) return;

    var Selector = '[data-toggle="portlet"]';

    $(Selector).sortable({
        connectWith:          Selector,
        items:                'div.card',
        handle:               '.portlet-handler',
        opacity:              0.7,
        placeholder:          'portlet box-placeholder',
        cancel:               '.portlet-cancel',
        forcePlaceholderSize: true,
        iframeFix:            false,
        tolerance:            'pointer',
        helper:               'original',
        revert:               200,
        forceHelperSize:      true,
        update:               savePortletOrder,
        create:               loadPortletOrder
    })
    // optionally disables mouse selection
    //.disableSelection()
    ;

    // Reset porlet save state
    window.resetPorlets = function(e) {
        Storages.localStorage.remove(STORAGE_KEY_NAME);
        // reload the page
        window.location.reload();
    }

}

function savePortletOrder(event, ui) {

    var data = Storages.localStorage.get(STORAGE_KEY_NAME);

    if (!data) { data = {}; }

    data[this.id] = $(this).sortable('toArray');

    if (data) {
        Storages.localStorage.set(STORAGE_KEY_NAME, data);
    }

}

function loadPortletOrder() {

    var data = Storages.localStorage.get(STORAGE_KEY_NAME);

    if (data) {

        var porletId = this.id,
            cards = data[porletId];

        if (cards) {
            var portlet = $('#' + porletId);

            $.each(cards, function(index, value) {
                $('#' + value).appendTo(portlet);
            });
        }

    }

}


export default initPortlets;
