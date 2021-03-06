# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
        $.getJSON $('#tabela').data('source'), null, (json) ->
                $('#tabela').DataTable(
                    search: {caseInsensitive: true, regex: true }
                    sAjaxSource: $('#tabela').data('source')
                    bStateSave:false
                    sPaginationType: "full_numbers"
                    responsive: true
                    bAutoWidth: true
                    bProcessing: true
                    bServerSide: true
                    sAjaxDataProp: 'aData'
                    aoColumns: json.aaColumns)
        $().ready ->
          $('#Ativas').click ->
            !$('#Ativas option:selected').remove().appendTo('#Inativas')
            $('option:selected').prop 'selected', false
          $('#Inativas').click ->
            !$('#Inativas option:selected').remove().appendTo('#Ativas')
            $('option:selected').prop 'selected', false
          return


jQuery ->
        $.getJSON $('#tabelainact').data('source'), null, (json) ->
                $('#tabelainact').DataTable(
                    search: {caseInsensitive: true, regex: true }
                    sAjaxSource: $('#tabelainact').data('source')
                    sPaginationType: "full_numbers"
                    bStateSave: false
                    responsive: true
                    bAutoWidth: true
                    bProcessing: true
                    bServerSide: true
                    sAjaxDataProp: 'iData'
                    aoColumns: json.aaColumns)

        $().ready ->
          $('#Ativas').click ->
            !$('#Ativas option:selected').remove().appendTo('#Inativas')
            $('option:selected').prop 'selected', false
          $('#Inativas').click ->
            !$('#Inativas option:selected').remove().appendTo('#Ativas')
            $('option:selected').prop 'selected', false
          return