$(function(){

  $('.this-comment .js-show-on-hover').hide();
  $('.this-comment').hover(function(){
    $(this).find('.js-show-on-hover').stop().fadeIn(200);
  }, function(){
    $(this).find('.js-show-on-hover').stop().fadeOut(200);
  });

  // JS-disabled functionality isn't a priority right now.
  $('.js-new-reply').click(function(e){
    e.preventDefault();
    var link = $(this);
    var parent_id = link.data('post-id');
    var loading_indicator = link.siblings('.loading');
    var new_reply_div = $('.new-reply-container[data-parent-id="'+parent_id+'"]');
    link.hide();
    loading_indicator.show();

    $.ajax({
      url: '/posts.js?parent_id='+parent_id,
      method: 'POST',
      dataType: 'json',
      success: function(data){
        new_reply_div.show().html(data.form_html);
        loading_indicator.hide();
      },
      error: function(){
        alert("Error loading this post. Please refresh your browser page.");
      }
    });
  });

  $('.js-edit-reply').click(function(e){
    e.preventDefault();
    var link = $(this);
    var container = link.parents('.bottom-comment').first();
    link.hide();
    link.siblings('.loading').show();

    container.children('.this-comment').load('/posts/' + container.data('id') + '/edit.js');
    // The partial should init autosave once it's loaded
  });

});
