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

  $('.js-chosen').chosen({
    allow_single_deselect: true,
    search_contains: true,
    width: '100%'
  });

  $('.js-fadeout-on-hover').hover(function(){
    console.log("Fading out.");
    $(this).animate({opacity: 0}, 250);
  }, function(){
    console.log("Fading in.");
    $(this).animate({opacity: 1}, 250);
  });

});
