$(document).on "turbolinks:load", ->
  $(document).on 'click', '#allow-comprehensive-quiz-checkbox', (e) ->
    ch = $(this)
    settings = $('#comprehensive-quiz-settings')
    
    if ch.prop('checked')
      settings.removeClass('d-none')
    else
      settings.addClass('d-none')

  $('.chapter-panel').on 'click', '.btn-toggle', (e) ->
    current = $(e.target.closest('.chapter-panel'))
    current.find(".card-body").toggleClass("d-none")
    if current.find(".card-body").hasClass("d-none")
      current.find(".icon").removeClass('fa-chevron-up').addClass 'fa-chevron-down'
    else
      current.find(".icon").removeClass('fa-chevron-down').addClass 'fa-chevron-up'

  $('.module-panel').on 'click', '.checkAllFromModule', (e) ->
    current = $(e.target.closest('form'))
    current.find(".btn-restore").removeClass('d-none');
    current.find("input:checkbox").not(this).prop('checked', this.checked);
    if current.find(".card-body").hasClass("d-none")
      current.find(".card-body").removeClass("d-none")
      current.find(".icon").removeClass('fa-chevron-down').addClass 'fa-chevron-up'
    else
      current.find(".card-body").addClass("d-none")
      current.find(".icon").removeClass('fa-chevron-up').addClass 'fa-chevron-down'

  
  $('.chapter-panel').on 'click', '.checkAllFromChapter', (e) ->
    current = $(this).closest('.chapter-panel')
    current.find("input:checkbox").not(this).prop('checked', this.checked);

    if current.find(".card-body").hasClass("d-none")
      current.find('label').addClass('active')
      current.find(".card-body").removeClass("d-none")
      current.find(".icon").removeClass('fa-chevron-down').addClass 'fa-chevron-up'
    else
      current.find('label').removeClass('active')
      current.find(".card-body").addClass("d-none")
      current.find(".icon").removeClass('fa-chevron-up').addClass 'fa-chevron-down'


  $('#attachment-side').on 'click', 'input:checkbox', (e) ->
    current = $(e.target.closest('#attachment-side'))
    current.find("input:checkbox").not(this).prop('checked', false);
    if current.find("input:checkbox:checked").length == 0
      current.find("input:checkbox:last").prop('checked', true)
    

  $('#flashcard-sides').on 'click', '.two-sided', (e) ->
    current = $(this).closest('#flashcard-sides')
    current.find(".three-sided").prop('checked', !this.checked)
    $(this).closest('#flashcard-setting').find('#attachment-side').addClass('d-none')
    $(this).closest('#flashcard-setting').find('#labels-setting > #side').addClass('d-none')
    
  $('#flashcard-sides').on 'click', '.three-sided', (e) ->
    current = $(this).closest('#flashcard-sides')
    current.find(".two-sided").prop('checked', !this.checked)
    $(this).closest('#flashcard-setting').find('#attachment-side').removeClass('d-none')
    $(this).closest('#flashcard-setting').find('#labels-setting > #side').removeClass('d-none')
  
  $('#inherit-product-settings').on 'click', 'input:checkbox', (e) ->
    if $(this).prop('checked')
      $('.modulee-settings').addClass('d-none')
    else
      $('.modulee-settings').removeClass('d-none')

  $('#inherit-modulee-settings').on 'click', 'input:checkbox', (e) ->
    if $(this).prop('checked')
      $('.quiz-settings').addClass('d-none')
    else
      $('.quiz-settings').removeClass('d-none')

  $('#modulee_auditable').on 'click', (e) ->
    auditable_options()  

  auditable_options = () ->
    if !$('#modulee_auditable').prop('checked')
      $('#modulee_auditable_config').hide()
    else
      $('#modulee_auditable_config').show()
      
  auditable_options()
