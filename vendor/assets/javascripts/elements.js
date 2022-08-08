// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

import $ from 'jquery';

import { initNotify } from './angle/modules/elements/notify';
import initSweetAlert from './angle/modules/elements/sweetalert';
import initNestable from './angle/modules/elements/nestable';
import initSortable from './angle/modules/elements/sortable';
import initCardDemo from './angle/modules/elements/cards';
import initPortlets from './angle/modules/elements/porlets';

$(function() {
    initNotify();
    initSweetAlert();
    initNestable();
    initSortable();
    initCardDemo();
    initPortlets();
});
