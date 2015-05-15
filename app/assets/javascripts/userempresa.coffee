# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#jQuery ->
#        selected = []
#        $.getJSON $('#tabelaEmpresa').data('source'), null, (json) ->
#                $('#tabelaEmpresa').DataTable(
#                        sAjaxSource: $('#tabelaEmpresa').data('source')
#                        aoColumns: json.aaColumns
#                        bStateSave:true
#                        bPaginate:false
#                        bSortable:false
#                        responsive: true
#                        bAutoWidth: true
#                        bProcessing: true
#                        bServerSide: true
#                       rowCallback: (row, data) ->
#                             if $.inArray(data.DT_RowId, selected) != -1
#                                $(row).addClass 'selected')
#
#        $('#tabelaEmpresa tbody').on 'click', 'tr', ->
#            id = @id
#            index = $.inArray(id, selected)
#            if index == -1
#              selected.push id
#            else
#              selected.splice index, 1
#            $(this).toggleClass 'selected'
#        return