(function() {


}).call(this);
(function() {


}).call(this);
(function() {


}).call(this);
(function() {


}).call(this);
(function() {
  jQuery(function() {
    $.getJSON($('#tabela').data('source'), null, function(json) {
      return $('#tabela').DataTable({
        search: {
          caseInsensitive: true,
          regex: true
        },
        sAjaxSource: $('#tabela').data('source'),
        bStateSave: false,
        sPaginationType: "full_numbers",
        responsive: true,
        bAutoWidth: true,
        bProcessing: true,
        bServerSide: true,
        aoColumns: json.aaColumns
      });
    });
    return $().ready(function() {
      $('#Ativas').click(function() {
        !$('#Ativas option:selected').remove().appendTo('#Inativas');
        return $('option:selected').prop('selected', false);
      });
      $('#Inativas').click(function() {
        !$('#Inativas option:selected').remove().appendTo('#Ativas');
        return $('option:selected').prop('selected', false);
      });
    });
  });

}).call(this);
(function() {


}).call(this);
(function() {


}).call(this);
// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
// require jquery
// require jquery_ujs
// require turbolinks
// require jquery.turbolinks
// require dataTables/jquery.dataTables

