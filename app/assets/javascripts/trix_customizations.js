$(function(){

  $('trix-editor').on('trix-file-accept', function(e) {
    // Block the editor from looking like it accepts attachments, since I don't
    // yet do anything with them
    // See https://github.com/basecamp/trix#observing-editor-changes
    e.preventDefault();
  });

});
