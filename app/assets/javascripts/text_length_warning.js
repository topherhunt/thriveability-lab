$(function(){
  $('.js-length-limit-warning').each(function(){
    var field_selector = $(this).data('target-field');
    console.log('Registering length warnings for field '+field_selector+'.');
    var field = $(field_selector);
    var max_length = $(this).data('max-length');
    var warning_90pct = $(this).find('.js-length-90pct');
    var warning_exceeded = $(this).find('.js-length-exceeded');

    var check_length = function(){
      var current_length = field.val().length;
      console.log('Checking length for field '+field_selector+'.');
      if (current_length > max_length) {
        warning_90pct.hide();
        warning_exceeded.show();
      } else if (current_length >= max_length * 0.9) {
        warning_90pct.show();
        warning_exceeded.hide();
      } else {
        warning_90pct.hide();
        warning_exceeded.hide();
      }
    }

    field.on('keyup change', function(){ check_length() });

    // For Trix editors, we can't rely on the change event
    if (field.attr('type') == 'hidden') {
      setInterval(check_length, 1000)
    }
  });
});
