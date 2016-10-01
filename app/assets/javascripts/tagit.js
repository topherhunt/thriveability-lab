$(function(){

  $('.js-tagit').each(function(){
    var container = $(this);
    var tag_limit = container.data('tag-limit') || null;
    container.tagit({
      singleField: true,
      singleFieldNode: $(container.data('tagit-target')),
      allowSpaces: true,
      tagLimit: tag_limit,
      availableTags: container.data('available-tags') || [],
      onTagLimitExceeded: function(){
        var show = container.siblings('.js-show-if-tagit-limit-exceeded');
        var hide = container.siblings('.js-hide-if-tagit-limit-exceeded');
        show.show(200);
        hide.hide(200);
        setTimeout(function(){
          show.hide(200);
          hide.show(200);
        }, 3000);
      },
      autocomplete: {
        // Override autocomplete.source to match ANY part of a tag, not just
        // the beginning
        source: function(search, showChoices) {
            var filter = search.term.toLowerCase();
            var choices = $.grep(this.options.availableTags, function(element) {
              return (element.toLowerCase().indexOf(filter) >= 0); });
            if (!this.options.allowDuplicates) {
              choices = this._subtractArray(choices, this.assignedTags());   }
            showChoices(choices); }
      }
    });
  });

  $('.js-add-tag').click(function(e){
    e.preventDefault();
    var hotspot = $(this);
    $(hotspot.data('target')).tagit('createTag', hotspot.text());
  });

});
