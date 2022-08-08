$ ->
  $(document).on "turbolinks:load", ->
    # Verify Header Format for Flashcard File Upload
    $('#upload-flashcard-file').change (e) ->
      file = e.target.files[0]
      
      if file != undefined
        reader = new FileReader
        reader.onload = (e) ->
          val = e.target.result
          s = val.split('\n')
          o = s[0].toLowerCase().split(',')
          if o[0] != "chapter" || o[1] != "question" || o[2].indexOf("answer") == -1
            $('.uploadbutton').prop('disabled', true);
            $('.error-div').show();
          else
            $('.uploadbutton').prop('disabled', false);
            $('.error-div').hide();
        reader.readAsText(file)

    # Verify Header Format for Quiz File Upload
    $('#upload-quiz-file').change (e) ->
      self = this
      file = e.target.files[0]
      
      if file != undefined
        reader = new FileReader
        reader.onload = (e) ->
          val = e.target.result
          s = val.split('\n')
          o = s[0].split(',')
          if o[0] != "Chapter" || o[1] != "Question" || o[2] != "Hint" || o[3] != "Explanation" || o[4] != "Correct Answer" || o[5] != "Distractor 1" || o[6] != "Distractor 2"|| o[7].indexOf("Distractor 3") == -1
            $('.uploadbutton').prop('disabled', true);
            $('.error-div').show();
            $(self).val('')
          else
            $('.uploadbutton').prop('disabled', false);
            $('.error-div').hide();
        reader.readAsText(file)


    $('.attachment-field').change (e) ->
      $(this).parent('.form-group').find('.attached-label').addClass('d-none')    


    $('.media-field').change (e) ->
      window.URL = window.URL || window.webkitURL
      file = e.target.files[0]
      fileType = file.type
      
      validVideo = ["video/mp4", "video/webm"]
      validAudio = ["audio/mp3", "audio/mpeg"]

      if (validVideo.includes(fileType))
        video = document.createElement('video')
        video.preload = 'metadata'

        video.onloadedmetadata = () ->
          window.URL.revokeObjectURL(video.src)
          duration = Math.round(video.duration)
          form = e.target.closest('form')
          $(form).find('.media-duration').val(duration)
          
        video.src = URL.createObjectURL(file)

      else if (validAudio.includes(fileType))
        audio = new Audio();
        audio.onloadedmetadata = () ->
          duration = Math.round(audio.duration)
          form = e.target.closest('form')
          $(form).find('.media-duration').val(duration)
          
        audio.src = URL.createObjectURL(file)

      
