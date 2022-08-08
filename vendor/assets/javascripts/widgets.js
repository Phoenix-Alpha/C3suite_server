// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

import $ from 'jquery';
import initSparkline from './angle/modules/charts/sparkline';
import initGoogleMaps from './angle/modules/maps/gmap';

$(function() {
    initGoogleMaps();
    initSparkline();
});
