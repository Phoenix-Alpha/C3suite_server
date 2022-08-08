// NOW TIMER
// -----------------------------------

import $ from 'jquery';
import moment from 'moment';

function initNowTimer() {

    if (typeof moment === 'undefined') return;

    $('[data-now]').each(function() {
        var element = $(this),
            format = element.data('format');

        function updateTime() {
            var dt = moment(new Date()).format(format);
            element.text(dt);
        }

        updateTime();
        setInterval(updateTime, 1000);

    });
}

export default initNowTimer;