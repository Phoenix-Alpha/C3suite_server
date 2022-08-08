// HTML5 Sortable demo
// -----------------------------------

// Sortable
import sortable from 'html5sortable/dist/html5sortable.es.js';

function initSortable() {

    if (typeof sortable === 'undefined') return;

    sortable('.sortable', {
        forcePlaceholderSize: true,
        placeholder: '<div class="box-placeholder p0 m0"><div></div></div>'
    });

}

export default initSortable;
