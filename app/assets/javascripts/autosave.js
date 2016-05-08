$(function(){
  /* A general-purpose autosave system.
  Usage:
  - Add the class js-autosave to any form
  - The endpoint that the form submits to, should have a .js format which renders
    the response json { success: true } or { errors: [array of errors] }.
  - Assumes the resource has already been saved and will be valid regardless of
    what values are submitted.
    */
  $('form.js-autosave').each(function(){
    var form = $(this);
    var indicator = $('<div class="js-autosave-indicator">Autosave enabled</div>');
    $('body').append(indicator);

    function post_changes(){
      console.log("Starting post_changes().");
      display_saving();
      $.ajax({
        method: 'PATCH',
        url: form.attr('action') + '.js',
        data: form.serializeArray(),
        dataType: 'json',
        success: function(data){
          if (data.success) {
            setTimeout(display_saved, 1000);
            setTimeout(post_changes, 60 * 1000);
          } else {
            console.error("Jquery .ajax success() called, but data.success was blank.");
            display_error();
          }
        },
        error: function(){
          console.error("Jquery .ajax error() called.");
          display_error();
        }
      });
    }

    function display_saving(){
      indicator.html('<span class="text-warning"><i class="fa fa-spinner"></i> Saving...</span>');
    }

    function display_saved(){
      indicator.html('<span class="text-success"><i class="fa fa-check"></i> Saved</span>');
    }

    function display_error(){
      indicator.html('<span class="text-danger"><i class="fa fa-times"></i> Can\'t autosave changes</span>');
      // alert("ERROR autosaving your changes. Your data may be lost if you lose network connection or your browser crashes.");
    }

    setTimeout(post_changes, 60 * 1000);
  });
});
