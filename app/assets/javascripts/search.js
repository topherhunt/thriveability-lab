$(function(){

  $('.js-search-models-selector').on('change', function(event, params){
    var models_string = ($(event.target).val() || []).join(",");
    $('.js-search-models-target').val(models_string);
  });

});
