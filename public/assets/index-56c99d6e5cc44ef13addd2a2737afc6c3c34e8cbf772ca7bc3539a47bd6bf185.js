(function() {
  jQuery(function() {
    return $('[name="emp_link"]').click(function() {
      var id;
      id = $(this).attr('value');
      $.ajax({
        type: 'post',
        url: '/users/set_current_emp',
        data: {
          emp_id: id
        }
      });
    });
  });

}).call(this);
