// DATATABLES
// -----------------------------------

import $ from 'jquery';

// Libraries for buttons
import * as JSZip from "jszip";
window.JSZip = JSZip;
require('pdfmake/build/pdfmake.js');
require('pdfmake/build/vfs_fonts.js');
// Datatables
require('datatables.net-bs')
require('datatables.net-bs4/js/dataTables.bootstrap4.js')
require('datatables.net-bs4/css/dataTables.bootstrap4.css')
require('datatables.net-buttons')
require('datatables.net-buttons-bs')
require('datatables.net-responsive')
require('datatables.net-responsive-bs')
require('datatables.net-responsive-bs/css/responsive.bootstrap.css')
require('datatables.net-buttons/js/buttons.colVis.js') // Column visibility
require('datatables.net-buttons/js/buttons.html5.js') // HTML 5 file export
require('datatables.net-buttons/js/buttons.flash.js') // Flash file export
require('datatables.net-buttons/js/buttons.print.js') // Print view button
require('datatables.net-keytable');
require('datatables.net-keytable-bs/css/keyTable.bootstrap.css')

function initDatatables() {

    if (!$.fn.DataTable) return;

    // Zero configuration

    $('#datatable1').DataTable({
        'paging': true, // Table pagination
        'ordering': true, // Column ordering
        'info': true, // Bottom left status text
        responsive: true,
        // Text translation options
        // Note the required keywords between underscores (e.g _MENU_)
        oLanguage: {
            sSearch: '<em class="fas fa-search"></em>',
            sLengthMenu: '_MENU_ records per page',
            info: 'Showing page _PAGE_ of _PAGES_',
            zeroRecords: 'Nothing found - sorry',
            infoEmpty: 'No records available',
            infoFiltered: '(filtered from _MAX_ total records)',
            oPaginate: {
                sNext: '<em class="fa fa-caret-right"></em>',
                sPrevious: '<em class="fa fa-caret-left"></em>'
            }
        }
    });


    // Filter

    $('#datatable2').DataTable({
        'paging': true, // Table pagination
        'ordering': true, // Column ordering
        'info': true, // Bottom left status text
        responsive: true,
        // Text translation options
        // Note the required keywords between underscores (e.g _MENU_)
        oLanguage: {
            sSearch: 'Search all columns:',
            sLengthMenu: '_MENU_ records per page',
            info: 'Showing page _PAGE_ of _PAGES_',
            zeroRecords: 'Nothing found - sorry',
            infoEmpty: 'No records available',
            infoFiltered: '(filtered from _MAX_ total records)',
            oPaginate: {
                sNext: '<em class="fa fa-caret-right"></em>',
                sPrevious: '<em class="fa fa-caret-left"></em>'
            }
        },
        // Datatable Buttons setup
        dom: 'Bfrtip',
        buttons: [
            { extend: 'copy', className: 'btn-info' },
            { extend: 'csv', className: 'btn-info' },
            { extend: 'excel', className: 'btn-info', title: 'XLS-File' },
            { extend: 'pdf', className: 'btn-info', title: $('title').text() },
            { extend: 'print', className: 'btn-info' }
        ]
    });

    $('#datatable3').DataTable({
        'paging': true, // Table pagination
        'ordering': true, // Column ordering
        'info': true, // Bottom left status text
        responsive: true,
        // Text translation options
        // Note the required keywords between underscores (e.g _MENU_)
        oLanguage: {
            sSearch: 'Search all columns:',
            sLengthMenu: '_MENU_ records per page',
            info: 'Showing page _PAGE_ of _PAGES_',
            zeroRecords: 'Nothing found - sorry',
            infoEmpty: 'No records available',
            infoFiltered: '(filtered from _MAX_ total records)',
            oPaginate: {
                sNext: '<em class="fa fa-caret-right"></em>',
                sPrevious: '<em class="fa fa-caret-left"></em>'
            }
        },
        // Datatable key setup
        keys: true
    });

}

export default initDatatables;
