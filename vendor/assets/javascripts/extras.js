// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
import $ from 'jquery';

import initSearch from './angle/modules/extras/search';
import initFullCalendar from './angle/modules/extras/calendar';
import initSparkline from './angle/modules/charts/sparkline';
import initSlimsSroll from './angle/modules/common/slimscroll';
import initDatatables from './angle/modules/tables/datatable';
import initGoogleMaps from './angle/modules/maps/gmap';

$(function() {
    initSearch();
    initFullCalendar();
    initSparkline();
    initSlimsSroll();
    initDatatables();
    initGoogleMaps();
});
