// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

import $ from 'jquery';
import initSparkline from './angle/modules/charts/sparkline';
import { initFlotSpline, initFlotBarStacked } from './angle/modules/charts/flot';
import initEasyPieChart from './angle/modules/charts/easypiechart';
import initSlimsSroll from './angle/modules/common/slimscroll';
import initNowTimer from './angle/modules/common/now';
import initVectorMap from './angle/modules/maps/vector.map.demo';

$(function() {
    initSparkline();
    initFlotSpline();
    initEasyPieChart();
    initSlimsSroll();
    initNowTimer();
    initFlotBarStacked();
    initVectorMap();
});
