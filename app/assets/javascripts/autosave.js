
/* A general-purpose autosave system.
Usage:
- Call init_autosave(container), providing a jquery div selection containing an eligible form
- OR add the class js-autosave to any form that loads on page load
- The endpoint that the form submits to, should have a .js format which renders
  the response json { success: true } or { errors: [array of errors] }.
- Assumes the resource has already been saved and will be valid regardless of
  what values are submitted.
  */

function init_autosave(container){
  if (container.length != 1) {
    console.error("Can't init autosave: There are "+container.length+" matching container elements.");
    return;
  }

  var form = container.find('form');
  var indicator = container.find('.js-autosave-indicator');
  var timer;
  var latest_data_json;
  indicator.text('Last saved '+current_time()+'');

  function post_changes(){
    // We can skip autosave if the form contents haven't changed.
    // Keep in mind during testing: CKeditor takes a few seconds to transfer
    // updates from the editor into the parent textarea element.
    var current_data_json = JSON.stringify(form.serializeArray());
    if (current_data_json == latest_data_json) { return; } // No changes to send
    else { latest_data_json = current_data_json; }

    display_saving();
    $.ajax({
      method: 'PATCH',
      url: form.attr('action') + '.js',
      data: form.serializeArray(),
      dataType: 'json',
      success: function(data){
        if (data.success) {
          setTimeout(display_saved, 1000);
          timer = setTimeout(post_changes, 60 * 1000);
        } else {
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
    indicator.html('<span class="text-success"><i class="fa fa-check"></i> Saved '+current_time()+'</span>');
  }

  function display_error(){
    indicator.html('<span class="text-danger"><i class="fa fa-times"></i> Can\'t autosave changes</span>');
    // alert("ERROR autosaving your changes. Your data may be lost if you lose network connection or your browser crashes.");
  }

  function current_time(){
    var d = new Date();
    var hours = d.getHours();
    var minutes = d.getMinutes();
    var ampm = (hours < 12 ? "am" : "pm");
    if (hours > 12) { hours -= 12; }
    return hours + ':' + minutes + ' ' + ampm;
  }

  timer = setTimeout(post_changes, 60 * 1000);

  indicator.click(function(){
    clearTimeout(timer);
    post_changes();
  });
}

$(function(){
  // Init autosave for each matching element found on page load.
  // You can alsoa init autosave manually for AJAX-loaded elements.
  $('.js-autosave').each(function(){
    // TODO: Rip out all this code (separate commit plz)
    // init_autosave($(this));
  });
});
