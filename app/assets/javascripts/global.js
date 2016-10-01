$(function(){

  $('.js-tooltip').each(function(){
    var target = $(this);
    target.tooltip({
      placement: target.data('placement') || 'top',
      title:     target.data('tooltip'),
      delay:     100
    });
  });

  // TODO: Unperformant?
  $('.js-show-on-parent-hover').each(function(){
    $(this).hide();
    $(this).parent().hover(function(){
      $(this).find('.js-show-on-parent-hover').show();
    }, function(){
      $(this).find('.js-show-on-parent-hover').hide();
    });
  });

});
