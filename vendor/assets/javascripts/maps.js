// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

import $ from 'jquery';

import initVectorMap from './angle/modules/maps/vector.map.demo';
import initGoogleMaps from './angle/modules/maps/gmap';

$(function() {
    initVectorMap();
    initGoogleMaps();
});
