// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

import $ from 'jquery';

import initBootgrid from './angle/modules/tables/bootgrid';
import initDatatables from './angle/modules/tables/datatable';
import initTableCheckAll from './angle/modules/common/table-checkall.js';

$(function() {
    initBootgrid();
    initDatatables();
    initTableCheckAll();
});
