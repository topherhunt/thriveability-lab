$(function(){

  // JS-disabled functionality isn't a priority right now.
  $('.js-new-reply').click(function(){
    var link = $(this);
    var parent_id = link.data('post-id');
    link.hide();
    link.siblings('.loading').show();

    $.ajax({
      url: '/posts/new?parent_id='+parent_id,
      method: 'GET',
      success: function(data){
        link.siblings('.reply-form-container')
          .load('/posts/'+data.id+'/edit?format=reply_bottom', function(){
            link.siblings('.loading').hide();
          });
      }
    });
  });
});
