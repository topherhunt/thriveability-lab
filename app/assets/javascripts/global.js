$(function(){

  $('.js-tagit').each(function(){
    $(this).tagit({
      singleField: true,
      singleFieldNode: $($(this).data('tagit-target')),
      allowSpaces: true
    });
  });

});
