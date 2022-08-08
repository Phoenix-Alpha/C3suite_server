// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

import $ from 'jquery';

import initColorPicker from './angle/modules/forms/color-picker';
import initFormsDemo from './angle/modules/forms/forms';
import initImageCropper from './angle/modules/forms/imagecrop';
import initSelect2 from './angle/modules/forms/select2';
import initDropzone from './angle/modules/forms/upload';
import initWizard from './angle/modules/forms/wizard';
import initXEditable from './angle/modules/forms/xeditable';
import './angle/modules/forms/validation';

$(function() {
    initColorPicker();
    initFormsDemo();
    initImageCropper();
    initSelect2();
    initDropzone();
    initWizard();
    initXEditable();
});
