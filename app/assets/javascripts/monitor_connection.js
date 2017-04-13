$(function(){
  if ($('.js-monitor-connection').length > 0){

    function ping(){
      $.ajax({
        type: 'GET',
        url: '/ping',
        success: function(){ set_ping_timer(); },
        error: function(){ $('.js-monitor-connection').show(200); }
      });
    }

    function set_ping_timer(){
      setTimeout(
        function(){ ping(); },
        15 * 1000);
    }

    set_ping_timer();

  }
});
