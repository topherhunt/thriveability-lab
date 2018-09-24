$(function(){

  $('.this-comment .js-opaque-on-hover').css({opacity: 0.2});
  $('.this-comment').hover(function(){
    $(this).find('.js-opaque-on-hover').css({opacity: 1});
  }, function(){
    $(this).find('.js-opaque-on-hover').css({opacity: 0.2});
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
        loadIntentionSelectListeners();
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

    container.children('.this-comment').load(
      '/posts/' + container.data('id') + '/edit.js', {},
      function() { loadIntentionSelectListeners(); });
  });

  function loadIntentionSelectListeners() {
    $('.js-intention-select').on('change', function(){
      var select = $(this);
      if (select.val() == '- other -'){
        console.log('Value is "other". Showing the write-in field.');
        select.parent().find('.js-intention-write-in').show();
      } else {
        console.log('Hiding the write-in field.');
        select.parent().find('.js-intention-write-in').val('').hide();
      }
    });

    $('.js-intention-write-in').on('keyup change', function(){
      // TODO: I think I can remove this, no need to write in the value anymore
      // var writein_field = $(this);
      // writein_field.parent().find('.js-intention-select')
      //   .children('option:last')
      //   .val(writein_field.val());
    });
  }

  loadIntentionSelectListeners();

});
