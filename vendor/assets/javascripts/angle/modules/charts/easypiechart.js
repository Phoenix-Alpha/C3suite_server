// Easypie chart Loader
// -----------------------------------

import $ from 'jquery';
import EasyPieChart from 'easy-pie-chart';

import { APP_COLORS } from '../common/constants';

function initEasyPieChart() {

    // Usage via data attributes
    // <div class="easypie-chart" data-easypiechart data-percent="X" data-optionName="value"></div>
    $('[data-easypiechart]').each(function() {
        var options = $(this).data() || {};
        new EasyPieChart(this, options)
    });

    // programmatic usage
    var pieOptions1 = {
        animate: {
            duration: 800,
            enabled: true
        },
        barColor: APP_COLORS['success'],
        trackColor: false,
        scaleColor: false,
        lineWidth: 10,
        lineCap: 'circle'
    };
    const easypie1 = document.getElementById('easypie1');
    if(easypie1)
        new EasyPieChart(easypie1, pieOptions1);

    var pieOptions2 = {
        animate: {
            duration: 800,
            enabled: true
        },
        barColor: APP_COLORS['warning'],
        trackColor: false,
        scaleColor: false,
        lineWidth: 4,
        lineCap: 'circle'
    };
    const easypie2 = document.getElementById('easypie2');
    if(easypie2)
        new EasyPieChart(easypie2, pieOptions2);

    var pieOptions3 = {
        animate: {
            duration: 800,
            enabled: true
        },
        barColor: APP_COLORS['danger'],
        trackColor: false,
        scaleColor: APP_COLORS['gray'],
        lineWidth: 15,
        lineCap: 'circle'
    };
    const easypie3 = document.getElementById('easypie3');
    if(easypie3)
        new EasyPieChart(easypie3, pieOptions3);

    var pieOptions4 = {
        animate: {
            duration: 800,
            enabled: true
        },
        barColor: APP_COLORS['danger'],
        trackColor: APP_COLORS['yellow'],
        scaleColor: APP_COLORS['gray-dark'],
        lineWidth: 15,
        lineCap: 'circle'
    };
    const easypie4 = document.getElementById('easypie4');
    if(easypie4)
        new EasyPieChart(easypie4, pieOptions4);

}

export default initEasyPieChart;