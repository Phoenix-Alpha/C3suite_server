// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
import $ from 'jquery';

import initWordCloud from './angle/modules/extras/jqcloud';
import initDatatables from './angle/modules/tables/datatable';
import initBlogArticleView from './angle/modules/extras/blog-article';

$(function() {
    initWordCloud();
    initDatatables();
    initBlogArticleView();
});
