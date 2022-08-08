$ ->
  $(document).on "turbolinks:load", ->
    $('#html-templates, #bookmarks').on 'click', '.btn-bkmark-html', (e) ->
      e.preventDefault()

      item = $(this)
      id = item.data('html-id')
      url = item.data('url')
      bookmarked = item.hasClass('bookmarked')

      if url != undefined
        url = window.location.origin + url

      $.ajax(
        type: 'GET'
        url: url || window.location.pathname + '/bookmark'
        dataType: 'json'
        data: { html: id, destroy: bookmarked ? true : false },

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

  saveProgress = (html) ->
    if html
      isComplete = true
      if !html.data('html-viewed')
        $.ajax(
          type: 'GET'
          url: window.location.pathname + '/viewedcontent'
          dataType: 'json'
          data: { status: isComplete }
          success: ()->
            html.data('html-viewed', "true")
            html.siblings('span').html("<em class='icon-check'></em> Marked as read")
            html.siblings('span').removeClass('text-muted').addClass 'text-success'
            html.addClass('d-none')
        )

        return

  $('#html-templates').on 'click', '.btn-viewed-html', (e) ->
    console.log(window.location.pathname + '/viewedcontent')
    saveProgress($(this))
