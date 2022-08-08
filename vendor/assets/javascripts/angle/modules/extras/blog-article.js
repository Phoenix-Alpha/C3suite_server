import $ from 'jquery';
// Wysiwig
// import 'bootstrap-wysiwyg/css/style.css';
import 'bootstrap-wysiwyg/js/bootstrap-wysiwyg.min.js';
// Chosen
// import 'chosen-js/chosen.css';
import 'chosen-js/chosen.jquery.js';

function initBlogArticleView() {
    // CHOSEN
    // -----------------------------------

    $('.chosen-select').chosen();
    // WYSIWYG
    // -----------------------------------

    $('.wysiwyg').wysiwyg();
}

export default initBlogArticleView;
