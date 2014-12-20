console.log("trying")
console.log($("#ouibounce-modal")[0])

var _ouibounce = ouibounce($("#ouibounce-modal"), {
  aggressive: true,
  timer: 0,
  callback: function() { console.log('ouibounce fired!'); }
});

$('body').on('click', function() {
  $('#ouibounce-modal').hide();
});

$('#ouibounce-modal .modal-footer').on('click', function() {
  $('#ouibounce-modal').hide();
});

$('#ouibounce-modal .modal').on('click', function(e) {
  e.stopPropagation();
});
