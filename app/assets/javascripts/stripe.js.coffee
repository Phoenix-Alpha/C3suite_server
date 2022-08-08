$(document).on "turbolinks:load", ->
	$('#checkout').on 'click', (e) ->
		key = $(this).data('key')
		session = $.ajax
			type: 'GET'
			url: window.location.pathname + '/create_checkout_session'
			dataType: 'json'
			success: (data) ->
				if(data.session)
					stripe = Stripe(key)
					stripe.redirectToCheckout({
						sessionId: data.session.id
					})
				else if(data.error)
					alert('Error: ' + data.error)
				else
					alert('Error: Problem occured while checking out.')
				