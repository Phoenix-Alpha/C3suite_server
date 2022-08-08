// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


import $ from 'jquery';

import initKnob from './angle/modules/charts/chart-knob';
import initChartJS from './angle/modules/charts/chart';
import initChartists from './angle/modules/charts/chartist';
import initEasyPieChart from './angle/modules/charts/easypiechart';
import {
    initFlotSpline,
    initFlotArea,
    initFlotBar,
    initFlotBarStacked,
    initFlotDonut,
    initFlotLine,
    initFlotPie
} from './angle/modules/charts/flot';
import initMorris from './angle/modules/charts/morris';
import initSparkline from './angle/modules/charts/sparkline';

$(function() {
    initKnob();
    initChartJS();
    initChartists();
    initEasyPieChart();
    initMorris();
    initSparkline();
    // Flot charts
    initFlotSpline();
    initFlotArea();
    initFlotBar();
    initFlotBarStacked();
    initFlotDonut();
    initFlotLine();
    initFlotPie();
})