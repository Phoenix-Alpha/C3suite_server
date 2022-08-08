// Forms Demo
// -----------------------------------

import $ from 'jquery';
// Chosen
// import 'chosen-js/chosen.css';
import 'chosen-js/chosen.jquery.js';
// Input Mask
import 'inputmask/dist/jquery.inputmask.bundle.js';
// Datetimepicker
// import 'bootstrap-datepicker/dist/css/bootstrap-datepicker.css';
import 'bootstrap-datepicker/dist/js/bootstrap-datepicker.js';
// Wysiwig
// import 'bootstrap-wysiwyg/css/style.css';
import 'bootstrap-wysiwyg/js/bootstrap-wysiwyg.min.js';
// TagsInput
// import 'bootstrap-tagsinput/dist/bootstrap-tagsinput.css';
import 'bootstrap-tagsinput/dist/bootstrap-tagsinput.min.js';
// Filestyle
import 'bootstrap-filestyle/src/bootstrap-filestyle.min.js';
// Range slider
// import 'bootstrap-slider/dist/css/bootstrap-slider.min.css';
import 'bootstrap-slider/dist/bootstrap-slider.min.js';

function initFormsDemo() {

    if (!$.fn.slider) return;
    if (!$.fn.chosen) return;
    if (!$.fn.inputmask) return;
    if (!$.fn.filestyle) return;
    if (!$.fn.wysiwyg) return;
    if (!$.fn.datepicker) return;

    // BOOTSTRAP SLIDER CTRL
    // -----------------------------------

    $('[data-ui-slider]').slider();

    // CHOSEN
    // -----------------------------------

    $('.chosen-select').chosen();

    // MASKED
    // -----------------------------------

    $('[data-masked]').inputmask();

    // FILESTYLE
    // -----------------------------------

    $('.filestyle').filestyle();

    // WYSIWYG
    // -----------------------------------

    $('.wysiwyg').wysiwyg();


    // DATETIMEPICKER
    // -----------------------------------

    $('#datetimepicker1').datepicker({
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
    // only time
    $('#datetimepicker2').datepicker({
        format: 'mm-dd-yyyy'
    });

}

export default initFormsDemo;
