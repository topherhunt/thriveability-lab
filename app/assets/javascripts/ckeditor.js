$(function(){

  /* For config, see:
    http://docs.ckeditor.com/#!/guide/dev_toolbarconcepts
    http://ckeditor.com/tmp/4.5.0-beta/ckeditor/samples/toolbarconfigurator/index.html#advanced
    */
  $('textarea.js-ckeditor').each(function(){
    var textarea = $(this);
    var id = textarea.attr('id');
    CKEDITOR.replace(id, {
      toolbar: [
  	    { name: 'styles', items: [ 'Format' ] },
    		{ name: 'basicStyles', items: ['Bold', 'Italic', 'Underline', 'Strike', 'RemoveFormat' ] },
    		{ name: 'paragraph', items: [ 'NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', '-', 'Blockquote' ] },
    		'/',
    		{ name: 'clipboard', items: [ 'PasteText', 'PasteFromWord', '-' ] },
    		{ name: 'editing', items: [ 'Scayt' ] },
    		{ name: 'links', items: [ 'Link', 'Unlink' ] },
    		{ name: 'insert', items: [ 'Image', 'Table', 'HorizontalRule' ] },
    		{ name: 'tools', items: [ 'Maximize' ] },
    		{ name: 'document', items: [ 'Source' ] },
    		{ name: 'about', items: [ 'About' ] }
	    ]
    });

    // Periodically fill the original textarea element with the updated content;
    // sadly ckeditor doesn't do this automatically.
    setInterval(function(){
      textarea.text( CKEDITOR.instances[id].getData() );
    }, 5000);
  });

  // Default open links in a new tab
  // See http://docs.ckeditor.com/#!/guide/dev_howtos_dialog_windows
  // and http://handsomedogstudio.com/ckeditor-set-default-target-blank
  CKEDITOR.on('dialogDefinition', function(e) {
    try {
      var dialogName = e.data.name;
      var dialogDefinition = e.data.definition;
      if (dialogName == 'link') {
        var informationTab = dialogDefinition.getContents('target');
        var targetField = informationTab.get('linkTargetType');
        targetField['default'] = '_blank';
      }
    } catch(exception) {
      alert('Error ' + ev.message);
    }
  });

});
