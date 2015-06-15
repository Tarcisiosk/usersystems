# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('[name="emp_link"]').click ->
  id = $(this).attr('value')
  $.ajax
    type: 'post'
    url: '/users/set_current_emp'
    data: emp_id: id
  alert 'Chamou'
  return