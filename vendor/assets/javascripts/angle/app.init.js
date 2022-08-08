/*!
 *
 * Angle - Bootstrap Admin Template
 *
 * Version: 4.7.5
 * Author: @themicon_co
 * Website: http://themicon.co
 * License: https://wrapbootstrap.com/help/licenses
 *
 */

import $ from 'jquery';

import initScreenFull from './modules/common/fullscreen';
import initLoadCSS from './modules/common/load-css';
import initTranslation from './modules/common/localize';
import initNavbarSearch from './modules/common/navbar-search';
import initSidebar from './modules/common/sidebar';
import initTableCheckAll from './modules/common/table-checkall';
import initTriggerResize from './modules/common/trigger-resize';
import { StateToggler, initToggleState } from './modules/common/toggle-state';
import { initCardDismiss, initCardCollapse, initCardRefresh } from './modules/common/card-tools';
import initBootstrap from './modules/common/bootstrap-start';

export default function initApp() {
    // Init modules
    initBootstrap();
    initScreenFull();
    initLoadCSS();
    initTranslation();
    initNavbarSearch();
    initSidebar();
    initTableCheckAll();
    initTriggerResize();
    initToggleState();
    // card tools
    initCardDismiss();
    initCardCollapse();
    initCardRefresh();

    // Restore body classes
    // -----------------------------------
    var $body = $('body');
    new StateToggler().restoreState($body);

    // enable settings toggle after restore
    $('#chk-fixed').prop('checked', $body.hasClass('layout-fixed'));
    $('#chk-collapsed').prop('checked', $body.hasClass('aside-collapsed'));
    $('#chk-collapsed-text').prop('checked', $body.hasClass('aside-collapsed-text'));
    $('#chk-boxed').prop('checked', $body.hasClass('layout-boxed'));
    $('#chk-float').prop('checked', $body.hasClass('aside-float'));
    $('#chk-hover').prop('checked', $body.hasClass('aside-hover'));

    // When ready display the offsidebar
    $('.offsidebar.d-none').removeClass('d-none');
}
