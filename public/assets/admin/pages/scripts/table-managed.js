var TableManaged = function () {
            
    var initTable1 = function () {
        var tableTipoEntidade = $('#TipoEntidadeTable');
        tableTipoEntidade.dataTable({
            // Internationalisation. For more info refer to http://datatables.net/manual/i18n
            "language": {
                "aria": {
                    "sortAscending": ": activate to sort column ascending",
                    "sortDescending": ": activate to sort column descending"
                },
                "emptyTable": "Sem cadastros",
                "info": "_START_ a _END_ de _TOTAL_ resultados",
                "infoEmpty": "Nenhum resultado encontrado",
                "infoFiltered": "(filtrados de um total de _MAX_ resultados)",
                "lengthMenu": "Mostrar _MENU_ resutados",
                "search": "Procurar:",
                "zeroRecords": "Nenhum resultado foi encontrado"
            },
            "bStateSave": true, // save datatable state(pagination, sort, etc) in cookie.
            "paging": false,
            "searchable":false,

            "columnDefs": [{  // set default column settings
                'orderable': false,
                'targets': [0]
            }, {
                "searchable": false,
                "targets": [0]
            }],
            "order": [
                [1, "asc"]
            ] // set first column as a default sort by asc
        });

        var tableWrapper = jQuery('#SimpleTable_wrapper');

        tableTipoEntidade.find('.group-checkable').change(function () {
            var set = jQuery(this).attr("data-set");
            var checked = jQuery(this).is(":checked");
            jQuery(set).each(function () {
                if (checked) {
                    $(this).attr("checked", true);
                } else {
                    $(this).attr("checked", false);
                }
            });
            jQuery.uniform.update(set);
        });
        tableWrapper.find('.dataTables_length select').select2(); // initialize select2 dropdown
    }

    var initTable2 = function () {
        var tableEntidadeEmpresas = $('#EntidadeEmpresaTable');
        tableEntidadeEmpresas.dataTable({
            // Internationalisation. For more info refer to http://datatables.net/manual/i18n
            "language": {
                "aria": {
                    "sortAscending": ": activate to sort column ascending",
                    "sortDescending": ": activate to sort column descending"
                },
               "emptyTable": "Sem cadastros",
                "info": "_START_ a _END_ de _TOTAL_ resultados",
                "infoEmpty": "Nenhum resultado encontrado",
                "infoFiltered": "(filtrados de um total de _MAX_ resultados)",
                "lengthMenu": "Mostrar _MENU_ resutados",
                "search": "Procurar:",
                "zeroRecords": "Nenhum resultado foi encontrado"
            },
            "bStateSave": true, // save datatable state(pagination, sort, etc) in cookie.
            "paging": false,
            "searchable":false,
            "columnDefs": [{  // set default column settings
                'orderable': false,
                'targets': [0]
            }, {
                "searchable": false,
                "targets": [0]
            }],
            "order": [
                [1, "asc"]
            ] // set first column as a default sort by asc
        });

        var tableWrapper = jQuery('#SimpleTable_wrapper');

        tableEntidadeEmpresas.find('.group-checkable').change(function () {
            var set = jQuery(this).attr("data-set");
            var checked = jQuery(this).is(":checked");
            jQuery(set).each(function () {
                if (checked) {
                    $(this).attr("checked", true);
                } else {
                    $(this).attr("checked", false);
                }
            });
            jQuery.uniform.update(set);
        });
        tableWrapper.find('.dataTables_length select').select2(); // initialize select2 dropdown
    }

    var initTable3 = function () {
        var table = $('#SimpleTable');
        table.dataTable({
            // Internationalisation. For more info refer to http://datatables.net/manual/i18n
            "language": {
                "aria": {
                    "sortAscending": ": activate to sort column ascending",
                    "sortDescending": ": activate to sort column descending"
                },
               "emptyTable": "Sem cadastros",
                "info": "_START_ a _END_ de _TOTAL_ resultados",
                "infoEmpty": "Nenhum resultado encontrado",
                "infoFiltered": "(filtrados de um total de _MAX_ resultados)",
                "lengthMenu": "Mostrar _MENU_ resutados",
                "search": "Procurar:",
                "zeroRecords": "Nenhum resultado foi encontrado"
            },
            "bStateSave": true, // save datatable state(pagination, sort, etc) in cookie.
            "paging": false,
            "searchable":false,
            "columnDefs": [{  // set default column settings
                'orderable': false,
                'targets': [0]
            }, {
                "searchable": false,
                "targets": [0]
            }],
            "order": [
                [1, "asc"]
            ] // set first column as a default sort by asc
        });

        var tableWrapper = jQuery('#SimpleTable_wrapper');

        table.find('.group-checkable').change(function () {
            var set = jQuery(this).attr("data-set");
            var checked = jQuery(this).is(":checked");
            jQuery(set).each(function () {
                if (checked) {
                    $(this).attr("checked", true);
                } else {
                    $(this).attr("checked", false);
                }
            });
            jQuery.uniform.update(set);
        });
        tableWrapper.find('.dataTables_length select').select2(); // initialize select2 dropdown
    }

    
    return {

        //main function to initiate the module
        init: function () {
            if (!jQuery().dataTable) {
                return;
            }
            initTable1();
            initTable2();
            initTable3();
        }

    };

}();