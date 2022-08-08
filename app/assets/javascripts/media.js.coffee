$ ->
  $(document).on "turbolinks:load", ->
    $('#media, #bookmarks').on 'click', '.btn-bkmark-media', (e) ->
      e.preventDefault()

      item = $(this)
      id = item.data('media-id')
      url = item.data('url')
      bookmarked = item.hasClass('bookmarked')


      if url != undefined
        url = window.location.origin + url

      $.ajax(
        type: 'GET'
        url: url || window.location.pathname + '/bookmark'
        dataType: 'json'
        data: { media: id, destroy: bookmarked ? true : false },
        success: (response) ->
          if response.success
            if url != undefined
              item.parents('.list-group-item').remove()
              return

            if bookmarked
              item.removeClass('bookmarked')
              item.find('span').removeClass('fas')
            else
              item.addClass('fas bookmarked')
              item.find('span').addClass('fas')
      )

      return

  saveProgress = (media) ->
    if media
      isComplete = true
      if !media.data('viewed')
        $.ajax(
          type: 'GET'
          url: window.location.pathname + '/viewedcontent'
          dataType: 'json'
          data: { status: isComplete }
          success: ()->
            media.data('viewed', "true")
        )

        return

  if ($('#media').data('type') == "Image")
    saveProgress($('#media'))
    
  $('#media video').on 'play', ->
    saveProgress($('#media'))
    console.log('played')

  $('#media audio').on 'play', ->
    saveProgress($('#media'))
    console.log('played')
  
    

  $(document).on 'change', '#media_local_type', (e) ->
    val = $(this).find('option:selected').text()
    fields = $('.conditional-field')

    if val == 'Video' || val == 'Audio'
      fields.removeClass('d-none')
      fields.attr('disabled', false)
    else
      fields.addClass('d-none')
      fields.attr('disabled', true)

  # Hide the audio / video -specific fields (by default)
  $('#media_local_type').change()