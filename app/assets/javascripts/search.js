$(function(){

  $('.js-search-classes-selector').on('change', function(event, params){
    var classes_string = ($(event.target).val() || []).join(",");
    $('.js-search-classes-target').val(classes_string);
  });

});
