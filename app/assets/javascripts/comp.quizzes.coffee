$ ->
  mode = $('#quiz-view').data('mode')

  viewcontent = (content_id, qId, index, order, completed) ->
    $.ajax(
      type: 'GET'
      url: window.location.pathname + '/viewedcontent'
      dataType: 'json'
      data: { content_id: content_id, question: qId, index: index, order: order, completed: completed }
    )

  $(document).on "turbolinks:load", ->
    mode = $('#quiz-view').data('mode')
    firstId = $('#quiz-view .question:first').data('questionId')
    lastId = $('#quiz-view .question:last').data('questionId')
    curr_id = $('#quiz-view .question:not(.d-none)').data('questionId')
    lastFlag = 0
    timesUp = false

    if curr_id == firstId
      status = "start"
    else if curr_id == lastId
      status = "end"
    else 
      status = "mid"

    $(document).on 'click', '.distractors input[type=radio]', (e) ->
      el = $(this)
      distractors = el.parent('.distractors')

      distractors.find('span').prop('style', 'color: #000;')

      if el.data("value")
        if mode == "study"
          $('.explanation').html("<hr/><strong>Correct!</strong> " + el.parents('.question').data("explanation"))
          el.next('span').prop('style', 'color: green;')

          $('.prev-comp-question').removeClass('d-none')
          $('.next-comp-question').removeClass('d-none')
        else if mode == "exam"
          if lastFlag or status == "end"
            $('.btn-comp-result').removeClass('d-none')
          else
            $('.next-comp-question').removeClass('d-none')
            el.attr('checked', 'checked')
      else
        if mode == "study"
          el.next('span').prop('style', 'color: red;')
        else if mode == "exam"
          if lastFlag or status == "end"
            $('.btn-comp-result').removeClass('d-none')
          else
            $('.next-comp-question').removeClass('d-none')


    $(document).on 'click', '.next-comp-question', (e) ->
      lastId = $('#quiz-view .question:last').data('questionId')
      curr = $('#quiz-view .question:not(.d-none)')
      next = curr.nextAll('.question').first()
      curr.prev('.btn-bkmark-quiz').addClass('d-none')
      next.prev('.btn-bkmark-quiz').removeClass('d-none')
      $(this).addClass('d-none')
      status = "mid"
      
      if next.data('questionId') == lastId
        lastFlag = 1

      if mode == "study"
        $('.explanation').html('')
        $('.prev-comp-question').addClass('d-none')

        if !next.hasClass('question')
          next = $('#quiz-view .question:first')

      
      qId = curr.data('questionId')
      index = $("div[data-question-id='" + qId + "'] input:checked").data('index')
      order = $("div[data-question-id='" + qId + "']").data('order')
      contentId = window.location.search.split('content_id=')[1];
      viewcontent(contentId, qId, index, order, false)

      curr.addClass('d-none')
      next.removeClass('d-none')

    $(document).on 'click', '.prev-comp-question', (e) ->
      curr = $('#quiz-view .question:not(.d-none)')
      prev = curr.prevAll('.question').first()

      prev.next('.btn-bkmark-quiz').addClass('d-none')
      prev.prev('.btn-bkmark-quiz').removeClass('d-none')

      if !prev.hasClass('question')
        prev = $('#quiz-view .question:last')

      $('.explanation').html('')

      curr.addClass('d-none')
      prev.removeClass('d-none')

      return

    $(document).on 'click', '.btn-comp-result', (e) ->
        qId = $('#quiz-view .question:not(.d-none)').data('questionId')
        if status != "start"
          check = $("div[data-question-id='" + qId + "'] :input").is(':checked')
          
          if check
            index = $("div[data-question-id='" + qId + "'] input:checked").data('index')
            order = $("div[data-question-id='" + qId + "']").data('order')
            contentId = window.location.search.split('content_id=')[1];
            viewcontent(contentId, qId, index, order, true)

    


