$(function(){

  $('.js-tagit').each(function(){
    $(this).tagit({
      singleField: true,
      singleFieldNode: $($(this).data('tagit-target')),
      allowSpaces: true
    });
  });

  $('.js-tooltip').each(function(){
    var target = $(this);
    target.tooltip({
      placement: target.data('placement') || 'top',
      title:     target.data('tooltip'),
      delay:     100
    });
  });

});
