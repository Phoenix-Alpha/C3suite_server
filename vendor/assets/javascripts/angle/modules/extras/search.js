// Search Results
// -----------------------------------

import $ from 'jquery';
// Chosen
// import 'chosen-js/chosen.css';
import 'chosen-js/chosen.jquery.js';
// Datetimepicker
// import 'bootstrap-datepicker/dist/css/bootstrap-datepicker.css';
import 'bootstrap-datepicker/dist/js/bootstrap-datepicker.js';
// Range slider
// import 'bootstrap-slider/dist/css/bootstrap-slider.min.css';
import 'bootstrap-slider/dist/bootstrap-slider.min.js';


function initSearch() {

    if (!$.fn.slider) return;
    if (!$.fn.chosen) return;
    if (!$.fn.datepicker) return;

    // BOOTSTRAP SLIDER CTRL
    // -----------------------------------

    $('[data-ui-slider]').slider();

    // CHOSEN
    // -----------------------------------

    $('.chosen-select').chosen();

    // DATETIMEPICKER
    // -----------------------------------

    $('#datetimepicker').datepicker({
        orientation: 'bottom',
        icons: {
            time: 'fa fa-clock-o',
            date: 'fa fa-calendar',
            up: 'fa fa-chevron-up',
            down: 'fa fa-chevron-down',
            previous: 'fa fa-chevron-left',
            next: 'fa fa-chevron-right',
            today: 'fa fa-crosshairs',
            clear: 'fa fa-trash'
        }
    });

}

export default initSearch;
