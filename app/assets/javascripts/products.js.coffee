$(document).on "turbolinks:load", ->

  formatResult = (node) ->
    $result = $('<span style="padding-left:' + 10 * node.level + 'px;"><label class="label label-default">' + node.type + '</label> ' + node.text + '</span>')
    $result

  # Select2
  ## declare function to convert default select to select2
  toSelect2 = (item, triggerUpdated) ->
    $el = $(item).find(".permission_contents_field > select")
    return if !$el.length

    pathPieces = window.location.pathname.split('/')
    pathPieces.splice(-1, 1)
    pathname = window.location.origin + pathPieces.join('/') + '/contents'

    $.ajax
      url: pathname,
      dataType: 'json',
      success: (data) ->
        $select = $(item).find(".permission_contents_field > select")

        # delete all the select options
        $select.html ''
        items = []
        i = 0

        while i < data.results.length
          items.push
            'id': data.results[i].id
            'text': data.results[i].text
            'type': data.results[i].type
            'level': data.results[i].level

          $select.append '<option value="' + data.results[i].id + '">' + data.results[i].text + '</option>'
          i++

        $select.chosen()

        if triggerUpdated
          for field in $select
            selected = $(field).siblings('.selected_contents').val()
            $select.val(selected)
            $(field).trigger("chosen:updated")

  # for newly added items
  $(document).on 'cocoon:after-insert', (e, item) ->
    toSelect2(item, false)
    $('.chosen-select').chosen()

  # --------------------------------------------

  # Update roles when user select field changes for "Permission"
  setUserRoles = (select) ->
    if select
      $.ajax
        url: '/manage/users/' + select.val() + '/get_user_roles'
        dataType: 'json'
        type: 'GET'
        success: (data) ->
          roles_selector = select.parent().next().find('#user_role_select_field')
          roles_selector.empty()
          
          options = []
          options[0] = new Option('Select Role')
          
          $.each(data, (index, text) ->
            options[index+1] = new Option(text[1], text[0])
          )
          roles_selector.append(options)
          roles_selector.trigger('chosen:updated')
          

          return
  #-------------------------------------------


  #-------------------------------------------
  #show auditable options if checkbox is checked
  $('#product_auditable').on 'click', (e) ->
    auditable_options()     

  auditable_options = () ->
    if !$('#product_auditable').prop('checked')
      $('#auditable_questions').hide()
      $('#auditable_flashcards').hide()
    else
      $('#auditable_questions').show()
      $('#auditable_flashcards').show()
  
  auditable_options()
  #-------------------------------------------

    #show comprehensive question option if checkbox is checked
  $('#product_allow_comprehensive_quizzes').on 'click', (e) ->
    comprehensive_quiz_option()     

  comprehensive_quiz_option = () ->
    if !$('#product_allow_comprehensive_quizzes').prop('checked')
      $('#comprehensive_quiz_option').hide()
    else
      $('#comprehensive_quiz_option').show()
  
  comprehensive_quiz_option()
  #-------------------------------------------


  showPermissionField = () ->
    
    $('form .nested-fields').on 'change', 'select#user_role_select_field', (e) ->
      if $(this).val() == '2'          #// id '2' for Product manager 
        $(this).closest('.nested-fields').find('.permission_contents_field').addClass('d-none')
      else
        $(this).closest('.nested-fields').find('.permission_contents_field').removeClass('d-none')
  
  $('#permissions-container').on 'cocoon:after-insert', (e, item) ->
    $(item).on 'change', 'select.user_select_field', ->
      setUserRoles($(this))
      showPermissionField()
  
  $('form .nested-fields').on 'change', 'select.user_select_field', (e) ->
    setUserRoles($(this))
  
  showPermissionField()
      
        
  # --------------------------------------------

  ### Control contents' access for PM vs all the other roles
  $('form .nested-fields').on 'change', 'select.user_role_select_field', (e) ->
    select = $('.permission_contents_field > select')

    if $(this).find('option:selected').text() == 'Product Manager'
      # Add new option for "all" contents access
      # select.prepend($('<option>', {value: 'all', text: 'All'}));

      # remove all the selected options
      select.find('option').attr('selected', false)

      # select "all" option
      select.find('option[value="all"]').attr('selected', true)

      # disable the options
      select.next().addClass('readonly')
    else
      # remove "all" options as no user besides PM (and manage, ofcourse!) has access to all product contents
      select.find('option[value="all"]').remove()
      select.next().removeClass('readonly')
    return
  ###

  # Show the raw image for the (to be) uploaded image
  $('#product_asset_source, #content_asset_source, #media_source').on 'change', ->
    if $('#media_local_type').length
      type = $('#media_local_type')[0].value
    else if $('#content_asset_local_type').length
      type = $('#content_asset_local_type')[0].value
    else if $('#product_asset_local_type').length
      type = $('#product_asset_local_type')[0].value

    countFiles = $(this)[0].files.length
    imgPath = $(this)[0].value
    extn = imgPath.substring(imgPath.lastIndexOf('.') + 1).toLowerCase()
    image_holder = $('#image-holder')
    image_holder.empty()

    if type == 'Image'
      if extn == 'gif' or extn == 'png' or extn == 'jpg' or extn == 'jpeg'
        if typeof FileReader != 'undefined'
          reader = new FileReader
          reader.onload = (e) ->
            $('<img />',
              'src': e.target.result
              'class': 'thumb-image').appendTo image_holder
            return

          image_holder.show()
          reader.readAsDataURL $(this)[0].files[0]
        else
          alert 'This is an old browser which does not support FileReader.'
      else
        alert 'Please only select images.'
    return
  # --------------------------------------------


  # Make content items sortable
  $('.sortable').sortable({
    # containment: 'parent',
    update: (e, ui) ->
      content_id = ui.item.data('content-id')
      position = ui.item.index()
      $.ajax(
        type: 'GET'
        url: '/manage/contents/update_content_position'
        dataType: 'json'
        data: { content: { content_id: content_id, row_order_position: position } }
      )
  })
  # --------------------------------------------
  $('.bg-check').on 'click', '.bg-color', (e) ->
    current = $(this).closest('.background-settings')
    if $('.bg-image').prop('checked')
      current.find('.bg-image').prop('checked', !this.checked)
    
    if this.checked
      $(this).closest('.background-settings').find('#bg-image-field').addClass('d-none')
      $(this).closest('.background-settings').find('#bg-color-field').removeClass('d-none')
    else
      $(this).closest('.background-settings').find('#bg-color-field').addClass('d-none')
      $(this).closest('.background-settings').find('#bg-image-field').removeClass('d-none')

  $('.bg-check').on 'click', '.bg-image', (e) ->
    current = $(this).closest('.background-settings')
    if $('.bg-color').prop('checked')
      current.find('.bg-color').prop('checked', !this.checked)

    if this.checked
      $(this).closest('.background-settings').find('#bg-color-field').addClass('d-none')
      $(this).closest('.background-settings').find('#bg-image-field').removeClass('d-none')
    else
      $(this).closest('.background-settings').find('#bg-image-field').addClass('d-none')
      $(this).closest('.background-settings').find('#bg-color-field').removeClass('d-none')

  $('.layout-check').on 'click', '.tile-view', (e) ->
    current = $(this).closest('.layout-settings')
    if $('.list-view').prop('checked')
      current.find('.list-view').prop('checked', !this.checked)

  $('.layout-check').on 'click', '.list-view', (e) ->
    current = $(this).closest('.layout-settings')
    if $('.tile-view').prop('checked')
      current.find('.tile-view').prop('checked', !this.checked)


