$ ->
  loadFlashcardScripts = () ->
    firstID = null
    lastID = null
    currID = null
    isComplete = false

    calculateProgress = ->
      firstID = $('.card:first').data('flashcarditem-id')
      lastID = $('.card:last').data('flashcarditem-id')
      currID = $('.card:not(.d-none)').data('flashcarditem-id')

      if currID == lastID
        isComplete = true

    calculateProgress()

    saveProgress =(item) ->
      if item
        id = item.data('flashcarditem-id')
        contentId = window.location.search.split('content_id=')[1];
        if !item.data('visited')
          if (window.location.href.indexOf("manage") < 0 && window.location.href.indexOf("audit") < 0 && window.location.href.indexOf("bookmarks") < 0) 
            $.ajax(
                type: 'GET'
                url: window.location.pathname + '/viewedcontent'
                dataType: 'json'
                data: { flashcarditem: id, status: isComplete, content_id: contentId}
                success: ()->
                  item.data('visited', "true")
            )

            return

    flipFlashcard =(card) ->
      
      sides = card.find('.card-body > .flashcard-sides').children()
      
      front = sides.first()
      back = front.next()
      thirdSide = sides.last()
      
      if sides.length == 2
        if front.hasClass('d-none')
          front.removeClass('d-none')
          card.removeClass('bg-gray')
          back.addClass('d-none')
          
        else if back.hasClass('d-none')
          back.removeClass('d-none')
          card.addClass('bg-gray')
          front.addClass('d-none')
          
      else if sides.length == 3
        if front.hasClass('d-none') && back.hasClass('d-none')
          front.removeClass('d-none')
          card.removeClass('bg-gray')
          card.removeClass('bg-gray-lighter')
          back.addClass('d-none')
          thirdSide.addClass('d-none')

        else if back.hasClass('d-none') && thirdSide.hasClass('d-none')
          back.removeClass('d-none')
          card.removeClass('bg-gray-lighter')
          card.addClass('bg-gray')
          front.addClass('d-none')
          thirdSide.addClass('d-none')
          
        else if front.hasClass('d-none') && thirdSide.hasClass('d-none')  
          thirdSide.removeClass('d-none')
          card.addClass('bg-gray-lighter')
          card.removeClass('bg-gray')
          back.addClass('d-none')          
          front.addClass('d-none')        


    ##setTimeout(() ->
    $('#flashcard-deck').on 'click', '.card > .card-footer .btn-flip-flashcard', (e) ->
      e.preventDefault()
      card = $(this).parents('.card')
      
      flipFlashcard(card)
      
      if currID == lastID
        $('.next-card').addClass('d-none')
        $('#flip-all-btn').addClass('d-none')
        $('.prev-card').addClass('d-none')
        $('.flashcard-startover').removeClass('d-none')

      saveProgress(card)


    $('#flashcard-deck').on 'click', '.front-btn', (e) ->
      card = $(this).parents('.card')
      card.removeClass('bg-gray')
      card.removeClass('bg-gray-lighter')

      sides = card.find('.card-body > .flashcard-sides')
      sides.find('.front-item').removeClass('d-none')
      sides.find('.back-item').addClass('d-none')
      sides.find('.side-item').addClass('d-none')
      

    $('#flashcard-deck').on 'click', '.back-btn', (e) ->
    
      card = $(this).parents('.card')
      card.addClass('bg-gray')
      card.removeClass('bg-lighter')

      sides = card.find('.card-body > .flashcard-sides')
      sides.find('.back-item').removeClass('d-none')
      sides.find('.front-item').addClass('d-none')
      sides.find('.side-item').addClass('d-none')
      
      if !$(this).is(':first-child')
        saveProgress(card)

      
    $('#flashcard-deck').on 'click', '.side-btn', (e) ->
      card = $(this).parents('.card')
      card.removeClass('bg-gray')
      card.addClass('bg-lighter')

      sides = card.find('.card-body > .flashcard-sides')
      sides.find('.side-item').removeClass('d-none')
      sides.find('.back-item').addClass('d-none')
      sides.find('.front-item').addClass('d-none')
      
      if !$(this).is(':first-child')
        saveProgress(card)


    $('#flashcard-deck').on 'click', '#flip-all-btn', (e) ->
      e.preventDefault()

      $('.card').each (indx, item) ->
        flipFlashcard($(item))

      return
    #, 1000)


    $('#flashcard-deck').on 'click', '.next-card', (e) ->
      e.preventDefault()
      
      curr = $('#flashcard-deck .card:not(.d-none)')
      next = curr.next('.card')

      if !next.hasClass('card')
        next = $('#flashcard-deck .card:first')

      #reset previous card before going to next...
      sides = curr.find('.card-body > .flashcard-sides').children()
      
      front = sides.first()
      back = front.next()
      thirdSide = sides.last()
      
      front.removeClass('d-none')
      curr.removeClass('bg-gray')
      back.addClass('d-none')
      
      if sides.length == 3
        thirdSide.addClass('d-none')
        curr.removeClass('bg-gray-lighter')

      curr.addClass('d-none')
      next.removeClass('d-none')

      calculateProgress()

      return

    $('#flashcard-deck').on 'click', '.prev-card', (e) ->
      e.preventDefault()
      
      curr = $('#flashcard-deck .card:not(.d-none)')
      prev = curr.prev('.card')

      if !prev.hasClass('card')
        prev = $('#flashcard-deck .card:last')

      curr.addClass('d-none')
      prev.removeClass('d-none')

      calculateProgress()
      
      return

    $('#flashcard-deck, #bookmarks').on 'click', '.btn-bkmark-flashcard', (e) ->
      e.preventDefault()

      item = $(e.target.closest('.btn-bkmark-flashcard'))
      id = item.data('flashcarditem-id')
      flashcardId = item.data('flashcard-id')
      url = window.location.origin+'/flashcards/bookmark'
     

      $.ajax(
        type: 'GET'
        url: url
        dataType: 'json'
        data: { flashcarditem: id, destroy: item.hasClass('bookmarked') ? true : false },

        success: (response) ->
          if response.success 
            if item.parents('.list-group-item').length > 0
              item.parents('.list-group-item').remove()
              return
          
            if item.hasClass('bookmarked')
              item.removeClass('bookmarked')
              item.find('span').removeClass('fas')
              item.data('message', "Added to Bookmarks")
            else
              item.addClass('fas bookmarked')
              item.find('span').addClass('fas')
              item.data('message', "Removed from Bookmarks")
      )

      return

    $('#sortable_flashcard_items').sortable({
      # containment: 'parent'
      update: (e, ui) ->
        flashcard_item_id = ui.item.data('flashcard-item-id')
        position = ui.item.index()
        $.ajax(
          type: 'GET'
          url: window.location.pathname + '/update_flashcard_item_position'
          dataType: 'json'
          data: { flashcard: { flashcard_items_attributes: [{ id: flashcard_item_id, row_order_position: position }] } }
        )
    })

  $(document).on "turbolinks:load", ->
    loadFlashcardScripts()

  loadFlashcardScripts()
