// LOAD CUSTOM CSS
// -----------------------------------

import $ from 'jquery';

function initLoadCSS() {

    $('[data-load-css]').on('click', function(e) {

        var element = $(this);

        if (element.is('a'))
            e.preventDefault();

        var uri = element.data('loadCss'),
            link;

        if (uri) {
            link = createLink(uri);
            if (!link) {
                $.error('Error creating stylesheet link element.');
            }
        } else {
            $.error('No stylesheet location defined.');
        }

    });
}

function createLink(uri) {
    var linkId = 'autoloaded-stylesheet',
        oldLink = $('#' + linkId).attr('id', linkId + '-old');

    $('head').append($('<link/>').attr({
        'id': linkId,
        'rel': 'stylesheet',
        'href': uri
    }));

    if (oldLink.length) {
        // delay removal of previous stylesheet to avoid some flickering
        setTimeout(function() {
            oldLink.remove();
    	}, 300);
    }

    return $('#' + linkId);
}

export default initLoadCSS;
