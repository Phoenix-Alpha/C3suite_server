// Select2
// -----------------------------------

import $ from 'jquery';
// Select2
import 'select2';
// import 'select2/dist/css/select2.min.css';
// import '@ttskch/select2-bootstrap4-theme/dist/select2-bootstrap4.css';


function initSelect2() {

    if (!$.fn.select2) return;

    // Select 2

    $('#select2-1').select2({
        theme: 'bootstrap4'
    });
    $('#select2-2').select2({
        theme: 'bootstrap4'
    });
    $('#select2-3').select2({
        theme: 'bootstrap4'
    });
    $('#select2-4').select2({
        placeholder: 'Select a state',
        allowClear: true,
        theme: 'bootstrap4'
    });

}

export default initSelect2