$(function(){
  $(".js-intention-selector").change(function(){
    var select = $(this);
    var text_field = $(select.data("target"));

    text_field.val(select.val());

    if (select.val() == "something else") {
      select.fadeOut(200);
      setTimeout(function(){ text_field.fadeIn(200).val("").focus(); }, 200);
    }
  })
});
