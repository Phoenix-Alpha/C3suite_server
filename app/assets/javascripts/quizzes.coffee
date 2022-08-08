$(document).on "ready turbolinks:load", ->
  $(window).on 'popstate', (e) ->
    if window.location.href.indexOf("exam") > 0 
      history.go(-2)
    else
      e.preventDefault()  

  $(document).on 'click', '.card-header .clickable', (e) ->
    e.preventDefault()

    $this = $(this)

    if !$this.hasClass('collapsed')
      $this.find('span').removeClass('fa-chevron-down').addClass 'fa-chevron-up'
    else
      $this.find('span').removeClass('fa-chevron-up').addClass 'fa-chevron-down'
    return

  viewcontent = (id, index, order, completed, time_left,content_id) ->
    $.ajax(
      type: 'GET'
      url: window.location.pathname + '/viewedcontent'
      dataType: 'json'
      data: { question: id, index: index, order: order, completed: completed, time_left: time_left, content_id: content_id }
    )

  $('#quiz-results').on 'click', '.toggle-explanation', (e) ->
    card = $(e.target).parents('.card')
    question = card.find('.question')

    if question.data('state') == 0
      question.find('.explanation').html('<hr/><b>Explanation</b>: ' + question.data('explanation'))
      question.data('state', 1)
    else
      question.find('.explanation').html('')
      question.data('state', 0)


  $(document).on "turbolinks:before-visit", (e) ->
    $('#timer').countdown('pause')
    quiz_id = $('#quiz-view').data('quiz-id')
    quiz_time = $('#timer').data("time")

    if quiz_id
      id = $('#quiz-view .question:not(.d-none)').data('question-id')
      index = $("div[data-question-id='" + id + "'] input:checked").data('index')
      order = $("div[data-question-id='" + id + "']").data('order')
      time_left = if quiz_time then localStorage.getItem('quiz_'+quiz_id)
      if time_left > 10
        if (confirm "Are you sure to leave Quiz? You can continue with your progress any time. ")
          contentId = window.location.search.split('content_id=')[1];
          viewcontent(id, index, order, false, time_left, contentId)
          localStorage.removeItem('quiz_' + quiz_id)
        else
          e.preventDefault()
      else if (time_left > 0 && time_left < 10)          # if remaining time_left is less then 3 secs when user leaving quiz page, then quiz is about to complete, 
        if(confirm "Warning! This Quiz will be finished on leaving now. Please wrap up if you didn't finished.")  
          contentId = window.location.search.split('content_id=')[1];
          viewcontent(id, index, order, true, time_left, contentId)
          localStorage.removeItem('quiz_' + quiz_id)
        else
          e.preventDefault()


  mode = $('#quiz-view').data('mode')   
  firstId = $('#quiz-view .question:first').data('question-id')
  lastId = $('#quiz-view .question:last').data('question-id')
  curr_id = $('#quiz-view .question:not(.d-none)').data('question-id')
  lastFlag = false
  timesUp = false
  if curr_id == firstId
    status = "start"
  else if curr_id == lastId
    status = "end"
  else 
    status = "mid"

  $('#quiz-view').on 'click', '.next-question', (e) ->
    e.preventDefault()
    lastId = $('#quiz-view .question:last').data('question-id')
    curr = $('#quiz-view .question:not(.d-none)')
    next = curr.nextAll('.question').first()
    curr.prev('.btn-bkmark-quiz').addClass('d-none')
    next.prev('.btn-bkmark-quiz').removeClass('d-none')
    curr.data('visited', "true")
    status = "mid"
    
    if next.data('question-id') == lastId
      lastFlag = true

    if (mode != undefined and mode == "study")
      $('.explanation').html('')

      if status != "start"
        $('.prev-question').removeClass('d-none')
      
      if !next.hasClass('question')
        next = $('#quiz-view .question:first')
    else if mode == "exam"
      id = curr.data('question-id')
      index = $("div[data-question-id='" + id + "'] input:checked").data('index')
      order = $("div[data-question-id='" + id + "']").data('order')
      contentId = $('#quiz-view ').data('content-id')
      time_left = if quiz_time then localStorage.getItem('quiz_'+quiz_id)
      
      viewcontent(id, index, order, false, time_left,contentId)

    curr.addClass('d-none')
    next.removeClass('d-none')

  lastSkipped = false

  $(document).on 'click', '.skip-question', (e) ->
    e.preventDefault()
    lastId = $('#quiz-view .question:last').data('question-id')
    curr = $('#quiz-view .question:not(.d-none)')
    next = curr.nextAll('.question').first()
    status = "mid"
    $('.next-question').addClass('d-none')
    if curr.data('question-id') == lastId
      lastSkipped = true
      lastFlag = true
      $(this).addClass('d-none')
      $('input').attr('disabled', true)
      $('.btn-result').removeClass('d-none')
      $('#timer').countdown('pause')
      

    if !lastFlag

      curr.prev('.btn-bkmark-quiz').addClass('d-none')
      next.prev('.btn-bkmark-quiz').removeClass('d-none')

      if mode == "study"
        $('.explanation').html('')

        if !next.hasClass('question')
          next = $('#quiz-view .question:first')
      else
        id = curr.data('question-id')
        index = "-1"
        order = $("div[data-question-id='" + id + "']").data('order')
        
        contentId = window.location.search.split('content_id=')[1];
        time_left = if quiz_time then localStorage.getItem('quiz_'+quiz_id)
        viewcontent(id, index, order, lastFlag, time_left,contentId)

      curr.addClass('d-none')
      next.removeClass('d-none')  

  $(document).on 'click', '.prev-question', (e) ->
    e.preventDefault()
    curr = $('#quiz-view .question:not(.d-none)')
    prev = curr.prevAll('.question').first()

    prev.next('.btn-bkmark-quiz').addClass('d-none')
    prev.prev('.btn-bkmark-quiz').removeClass('d-none')

    if !prev.hasClass('question')
      prev = $('#quiz-view .question:last')

    $('.next-question').removeClass('d-none')
    $('.explanation').html('')

    curr.addClass('d-none')
    prev.removeClass('d-none')

    return

  $(document).on 'click', '.btn-result', (e) ->
    if $('.btn-result').data('link')
      e.preventDefault()
      if !timesUp
        id = $('#quiz-view .question:not(.d-none)').data('question-id')
        if status != "start"
          check = $("div[data-question-id='" + id + "'] :input").is(':checked')
          
          if (!lastSkipped && check)
            index = $("div[data-question-id='" + id + "'] input:checked").data('index')
            console.log('Not last skipped: '+index)
          else if lastSkipped
            index = "-1" 
            console.log('last skipped: '+index)
          
          order = $("div[data-question-id='" + id + "']").data('order')
          contentId = window.location.search.split('content_id=')[1];
          time_left = if quiz_time then localStorage.getItem('quiz_'+quiz_id)
          localStorage.removeItem('quiz_' + quiz_id)
          $('#timer').countdown('destroy')
          viewcontent(id, index, order, true, time_left, contentId).then(
            Turbolinks.visit($('.btn-result').data('link'))
          ) 
      else
        Turbolinks.visit($('.btn-result').data('link'))


  $(document).on 'click', 'input[type=radio]', (e) ->
    siblings = $(this).closest('.card-body').find('.nested-fields, .answers').find('input[type=radio]').not(this)

    siblings.attr('checked', false)
    siblings.val(false)
        
    $(this).val(true)
    lastId = $('#quiz-view .question:last').data('question-id')
    curr = $('#quiz-view .question:not(.d-none)')
    lastFlag = curr.data('question-id') == lastId ? true : false
    if mode == "exam"
      if lastFlag or status == "end"
        $('.btn-result').removeClass('d-none')
      else
        $('.next-question').removeClass('d-none')


  $('#quiz-view').on 'click', '.distractors input[type=radio]', (e) ->
    el = $(this)
    distractors = el.parent('.distractors')
    distractors.find('div').prop('style', 'color: #000;')

    if mode == "study"
      if el.data("value")
        $('.explanation').html("<hr/><strong>Correct!</strong> " + el.parents('.question').data("explanation"))
        el.next('span').prop('style', 'color: green;')
        if status != "start"
          $('.prev-question').removeClass('d-none')
        $('.next-question').removeClass('d-none')
        
        if window.location.href.indexOf("incorrect") > 0 
          curr = $('#quiz-view .question:not(.d-none)')
          id = curr.data('question-id')
          index = $("div[data-question-id='" + id + "'] input:checked").data('index')
          order = $("div[data-question-id='" + id + "']").data('order')  
          contentId = $('#quiz-view ').data('content-id')
          time_left = if quiz_time then localStorage.getItem('quiz_'+quiz_id)
          viewcontent(id, index, order, false, time_left,contentId)
      else
        el.next('span').prop('style', 'color: red;')
      
  # Quiz Time's Up
  liftOff = ->
    timesUp = true
    localStorage.removeItem('quiz_' + quiz_id)
    $('#timer').countdown('destroy')
    $('.next-question').addClass('d-none')
    $('.prev-question').addClass('d-none')
    $('.skip-question').addClass('d-none')
    $('input').attr('disabled', true)
    id = $('#quiz-view .question:not(.d-none)').data('question-id')
    check = $("div[data-question-id='" + id + "'] input:checked")
    index = check.data('index')
    order = $("div[data-question-id='" + id + "']").data('order')
    contentId = window.location.search.split('content_id=')[1];
    if status != "start"
      $('.btn-result').removeClass('d-none')
      if check
        viewcontent(id, index, order, true, 0, contentId) #//if timesUp then set completed: true and remaining_time: 0
      else
        viewcontent('', index, order, true, 0, contentId)

  quiz_id = $('#quiz-view').data('quiz-id')

  # On countdown update
  watchCountdown = (periods) ->
    secondsLeft = periods[5] * 60 + periods[6]
    localStorage.setItem('quiz_' + quiz_id, secondsLeft)

  lastTickSecs = localStorage.getItem('quiz_' + quiz_id)

  if lastTickSecs && lastTickSecs > 0
    quiz_time = lastTickSecs
  else
    quiz_time = $('#timer').data("time")

  $('#timer').countdown({
    until: quiz_time, format: 'H:M:S', compact: true,
    padZeroes: true,
    onExpiry: liftOff, expiryText: "Time's Up",
    onTick: watchCountdown
  })

  # Reset Timer as Start Over Button Action
  $('.btn-startover').on 'click', (e) ->
    if confirm('Are you sure? This shall remove your current progress with the Quiz.')
      localStorage.setItem('quiz_' + quiz_id, 0)
      $('#timer').countdown('destroy')


  quiz_mode = $('#quiz-view').data('mode')

  # Handle user bookmark / unbookmark actions
  $('#quiz-view, #user-bookmarks, #result-bookmarks, #bookmarks').on 'click', '.btn-bkmark-quiz', (e) ->
    e.preventDefault()

    item = $(e.target.closest('.btn-bkmark-quiz'))
    id = item.data('question-id')
    url = window.location.origin+'/quizzes/bookmark'
    
    $.ajax(
      type: 'GET'
      url: url
      dataType: 'json'
      data: { question: id, destroy: item.hasClass('bookmarked') ? true : false },

      success: (response) ->
        if response.success
          if item.parents('.list-group-item').length > 0
            item.parents('.list-group-item').remove()
          
          
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

  # Make Quiz Tile Actionable
  $('.tile').on 'click', (e) ->
    window.location = $(this).data('path')
    return


  # <--- Manage Quizzes
  ## Time limit checkbox
  $('#set_time_limit').on 'click', (e) ->
    cbox = $(this)

    if !cbox.prop('checked')
      $('#quiz_time_limit').attr('readonly', true)
      $('#quiz_time_limit').val('')
      $('#quiz_time_limit').attr('value', '')
    else
      $('#quiz_time_limit').attr('readonly', false)
  # --->
