// Full Calendar
// -----------------------------------

import { Calendar } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';
import timeGridPlugin from '@fullcalendar/timegrid';
import interactionPlugin, { Draggable } from '@fullcalendar/interaction';
import listPlugin from '@fullcalendar/list';
import bootstrapPlugin from '@fullcalendar/bootstrap';

function initCalendar() {
    initExternalEvents();
    initFullCalendar();
}

function initFullCalendar() {
    /* initialize the calendar */
    var calendarEl = document.getElementById('calendar');
    var calendar = new Calendar(calendarEl, {
        events: createDemoEvents(),
        plugins: [interactionPlugin, dayGridPlugin, timeGridPlugin, listPlugin, bootstrapPlugin],
        themeSystem: 'bootstrap',
        header: {
            left: 'prev,next today',
            center: 'title',
            right: 'dayGridMonth,timeGridWeek,timeGridDay,listWeek'
        },
        editable: true,
        droppable: true, // this allows things to be dropped onto the calendar
        eventReceive: function(info) {
            var styles = getComputedStyle(info.draggedEl);
            info.event.setProp('backgroundColor', styles.backgroundColor);
            info.event.setProp('borderColor', styles.borderColor);

            // is the "remove after drop" checkbox checked?
            if (document.getElementById('drop-remove').checked) {
                // if so, remove the element from the "Draggable Events" list
                info.draggedEl.parentNode.removeChild(info.draggedEl);
            }
        }
    });

    /* initialize the external events */
    var containerEl = document.getElementById('external-events-list');
    new Draggable(containerEl, {
        itemSelector: '.fce-event',
        eventData: function(eventEl) {
            return {
                title: eventEl.innerText.trim()
            };
        }
    });

    calendar.render();
}

function initExternalEvents() {
    var colorSelectorContainer = document.getElementById('external-event-color-selector');
    var addEventButton = document.getElementById('external-event-add-btn');
    var eventNameInput = document.getElementById('external-event-name');
    var colorSelectors = [].slice.call(colorSelectorContainer.querySelectorAll('.circle'));
    var currentSelector = colorSelectorContainer.querySelector('.circle'); // select first as default
    var containerEl = document.getElementById('external-events-list');

    // control the color selector selectable behavior
    colorSelectors.forEach(function(sel) {
        sel.addEventListener('click', selectColorSelector(sel));
    });
    // Create and add a new event to the list
    addEventButton.addEventListener('click', addNewExternalEvent);

    function selectColorSelector(sel) {
        return function(e) {
            // deselect all
            colorSelectors.forEach(unselectAllColorSelector);
            // select current
            sel.classList.add('selected');
            currentSelector = sel;
        };
    }

    function unselectAllColorSelector(el) {
        el.classList.remove('selected');
    }

    function addNewExternalEvent() {
        var name = eventNameInput.value;
        if (name) {
            var el = createElement(currentSelector);
            el.innerText = name;
            containerEl.insertBefore(el, containerEl.firstChild); // preppend
        }
    }

    function createElement(baseElement) {
        var styles = getComputedStyle(currentSelector);
        var element = document.createElement('div');
        element.style.backgroundColor = styles.backgroundColor;
        element.style.borderColor = styles.borderColor;
        element.style.color = '#fff';
        element.className = 'fce-event'; // make draggable
        return element;
    }
}

/**
 * Creates an array of events to display in the first load of the calendar
 * Wrap into this function a request to a source to get via ajax the stored events
 * @return Array The array with the events
 */
function createDemoEvents() {
    // Date for the calendar events (dummy data)
    var date = new Date();
    var d = date.getDate(),
        m = date.getMonth(),
        y = date.getFullYear();

    return [
        {
            title: 'All Day Event',
            start: new Date(y, m, 1),
            backgroundColor: '#f56954', //red
            borderColor: '#f56954' //red
        },
        {
            title: 'Long Event',
            start: new Date(y, m, d - 5),
            end: new Date(y, m, d - 2),
            backgroundColor: '#f39c12', //yellow
            borderColor: '#f39c12' //yellow
        },
        {
            title: 'Meeting',
            start: new Date(y, m, d, 10, 30),
            allDay: false,
            backgroundColor: '#0073b7', //Blue
            borderColor: '#0073b7' //Blue
        },
        {
            title: 'Lunch',
            start: new Date(y, m, d, 12, 0),
            end: new Date(y, m, d, 14, 0),
            allDay: false,
            backgroundColor: '#00c0ef', //Info (aqua)
            borderColor: '#00c0ef' //Info (aqua)
        },
        {
            title: 'Birthday Party',
            start: new Date(y, m, d + 1, 19, 0),
            end: new Date(y, m, d + 1, 22, 30),
            allDay: false,
            backgroundColor: '#00a65a', //Success (green)
            borderColor: '#00a65a' //Success (green)
        },
        {
            title: 'Open Google',
            start: new Date(y, m, 28),
            end: new Date(y, m, 29),
            url: '//google.com/',
            backgroundColor: '#3c8dbc', //Primary (light-blue)
            borderColor: '#3c8dbc' //Primary (light-blue)
        }
    ];
}

export default initCalendar;
