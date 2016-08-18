$(function(){

  // JS-disabled functionality isn't a priority right now.
  $('.js-new-reply').click(function(e){
    e.preventDefault();
    var link = $(this);
    var parent_id = link.data('post-id');
    link.hide();
    link.siblings('.loading').show();

    $.ajax({
      url: '/posts.js?parent_id='+parent_id,
      method: 'POST',
      dataType: 'json',
      success: function(data){
        link.siblings('.new-reply-container').show().html(data.form_html);
        link.siblings('.loading').hide();
      },
      error: function(){
        alert("Error loading this post. Please refresh your browser page.");
      }
    });
  });

  $('.js-edit-reply').click(function(e){
    e.preventDefault();
    var link = $(this);
    var container = link.parent().parent();
    var parent_id = link.data('post-id');
    link.hide();
    link.siblings('.loading').show();

    container.load('/posts/' + container.data('id') + '/edit.js');
    // The partial should init autosave once it's loaded
  });
});
