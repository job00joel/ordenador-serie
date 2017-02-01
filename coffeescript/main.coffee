jQuery(document).ready ($) ->

	app = {

		force_numbers: (e) ->
			if e.keyCode == 13
				app.add_number()
				return false

			if $.inArray(e.keyCode, [46, 8, 9, 27, 110, 190]) != -1 || (e.keyCode == 65 && e.ctrlKey == true) || (e.keyCode >= 35 && e.keyCode <= 39)
				return false

			charValue = String.fromCharCode e.keyCode
			valid = /^[0-9]+$/.test charValue

			if !valid
				e.preventDefault()

		add_number: ->

			val = $('input.number').val()
			if val.length == 0
				return false

			exists = false
			$.each $('.boxes .box'), ->
				if val == $(this).text()
					exists = true

			if !exists
				$('.numbers .boxes').append('<div class="box" id="'+val+'">'+val+'</div>')

			$('input.number').val('').focus()

		sort_number: (a, b) ->
			a - b
		
		get_numbers: ->

			numbers = []

			$.each $('.numbers .boxes .box'), ->
				numbers.push parseInt $(this).text()

			numbers.sort app.sort_number

		clone_number: (index, number) ->

			$div = $('.numbers .boxes #'+number)

			$('.ordered').append $div.clone()
			$('.ordered div').css 'visibility', 'hidden'

		move_number: (element, pos)->

			$target_element = $( $('.ordered div')[pos] )

			$parent_offset = $('.numbers').offset()
			
			ordered_top = $('.ordered div').offset().top
			target_top = ordered_top - $parent_offset.top
			
			target_left = $target_element.offset().left - $parent_offset.left 


			$(element).css 'position', 'absolute'
			$(element).css 'width', 'auto'
			$(element).animate { top: target_top+"px" }, 1000;
			$(element).animate { left: target_left+"px" }, 1000;
			$(element).hide 'slow', ->
				$target_element.css 'visibility', 'visible'
				$(element).remove()

		sort: ->

			$('.sort').css 'disabled', 'disabled'

			$('.ordered div').remove()

			numbers = app.get_numbers()

			$.each numbers, (index, number)->
				app.clone_number(index, number)

			
			$.each $('.numbers .boxes .box').get().reverse(), (i, element) ->
				setTimeout ->
					app.move_number element, numbers.indexOf parseInt $(element).text()
				, 500 * i

			

			
		init: ->
			$('input.number').on 'keypress', (e) -> app.force_numbers e

			$('button.add-number').on 'click', -> app.add_number()

			$('.sort').on 'click', -> app.sort()
			

	}
	
		

	app.init()