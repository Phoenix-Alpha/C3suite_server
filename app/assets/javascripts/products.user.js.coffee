$ ->
  $(document).on 'click', '#sidebarCollapse, #dismiss', (e) ->
    $("#modules-sidebar").toggleClass("active")