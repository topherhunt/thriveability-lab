$(function(){

  var prettyPrintJson = function(string){
    try {
      return JSON.stringify(JSON.parse(string), null, '  ')
    } catch(e) {
      alert("Error parsing JSON.");
      raise(e);
    }
  };

  $('#js-submit-query').click(function(e){
    e.preventDefault();
    // This quote-wrapping may break on queries where strings contain ':'
    var query = $('#js-query-input').val().replace(/(\w+):/g, '"$1":');
    var indexes = ($('#js-query-indexes').val() || []).join(",");

    $('#js-query-stats').hide();
    $('#js-query-output').hide();
    $('#js-response-error').hide();

    var cleaned_query = prettyPrintJson(query);
    $('#js-query-input').val(cleaned_query);

    $.ajax({
      method: 'POST',
      url: '/admin/elasticsearch_gui/query',
      data: {query: query, indexes: indexes},
      success: function(response){
        console.log(response);
        if (response.success) {
          $('#js-query-stats').show();
          $('#js-query-num-results').text(response.num_results);
          $('#js-query-output').show().text(prettyPrintJson(response.results));
        } else {
          $('#js-response-error').show().text(response.error);
        }
      },
      error: function(){
        $('#js-response-error').show().text('Error: no response or malformed response from server.');
      }
    });
  });

  $('#js-query-stats').hide();
  $('#js-query-output').hide();
  $('#js-response-error').hide();

});
