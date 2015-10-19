myApp.controller('TipomovimentacaoCtrl', ['$scope', function($scope)
{
	var auxwf = [];
	var auxindex = 0;

	$scope.mensagens = [];
	$scope.data = [];	
	$scope.tipos = [{'codigo':1,'descricao':'Entrada'},{'codigo':2,'descricao':'Saída'},{'codigo':3,'descricao':'Outros'}];
	
	$scope.isEditing = false;
	$scope.workflow_list = [];
	$scope.workflow_selected = '';

	$scope.getData = function() 
	{
		$.ajax({
			async: false,
			method: 'get',
			url: '/tipomovimentacaos/get_json',
			success: function(data)
			{
				$scope.data = data;
				if($scope.data.workflow_list)
				{
					$scope.workflow_list = JSON.parse($scope.data.workflow_list);
				}
				console.log($scope.workflow_list);

			}
		});
	}
	$scope.getData();

	//add workflow
	$scope.addWorkflow = function(wf)
	{	
		if($scope.isEditing == false)
		{
			var pos = $scope.workflow_list.map(function(e) { return e.descricao; }).indexOf($scope.workflow_selected.descricao);
			if(pos <= -1)
			{
				wf.ordem = $scope.workflow_list.length +1;
				$scope.workflow_list.push(wf);
				$scope.data.workflow_list = JSON.stringify($scope.workflow_list);
			}
		}
	}


	//seta o workflow selecionado
	$scope.setWorkflowSelected = function(wf)
	{
		$scope.workflow_selected = wf;
		console.log($scope.workflow_selected);
	}

	//edita o workflow
	$scope.editWorkflow = function(index)
	{
		$scope.isEditing = true;
		$scope.workflow_selected = $scope.workflow_list[index];
		auxwf = JSON.parse($scope.data.workflow_list)[index]; 
		auxindex = index;
		console.log($scope.workflow_selected);
	}

	//salva o workflow
	$scope.saveWorkflow = function(wf)
	{
		if($scope.isEditing == true)
		{
			$scope.workflow_list[auxindex] = wf;
		}
		$scope.data.workflow_list = JSON.stringify($scope.workflow_list);
		$scope.endEdit();
	}

	//cancela edicao
	$scope.cancelEdit = function()
	{		
		if($scope.isEditing == true)
		{
			$scope.workflow_list[auxindex] = auxwf;
		}	
		$scope.endEdit();
	}

	//funçoes para termino de ediçao
	$scope.endEdit = function()
	{
		auxwf = [];
		auxindex = 0;
		$scope.isEditing = false;
	}

	//deleta o produto
	$scope.deleteWorkflow = function(index)
	{
		var deleteEnd = window.confirm('Voce deseja excluir esse workflow?');
		if (deleteEnd) 
		{
			$scope.workflow_list.splice(index, 1);    
		}
		$scope.data.workflow_list = JSON.stringify($scope.workflow_list);
	}

	$scope.reorderWorkflow = function()
	{
		var newArray = [];

		for(var i = 0; i < $scope.workflow_list.length; i++)
		{
			var tableRow = $("td").filter(function() {
			    return $(this).text() == $scope.workflow_list[i].descricao;
			}).closest("tr");

			$scope.workflow_list[i].ordem = tableRow.index()+1;
		}
		$scope.workflow_list.sort(compare);
		$scope.data.workflow_list = JSON.stringify($scope.workflow_list);
	}
  //scope.reorderWorkflow();


	$scope.save = function() 
	{   		
		var request;
		request = $.ajax({
			async: false,
			method: 'post',
			url: '/tipomovimentacaos/save_angular/' +  $('#EditingObjId').attr("data"),
			data: { data: $scope.data },
			success: function (data)
			{      			     			
				window.location.replace('/tipomovimentacaos');
			},
			error: function (jqXHR, textStatus, errorThrown)
			{      			     			
				$scope.mensagens = JSON.parse(jqXHR.responseText);
				console.log(jqXHR.responseText);
			}
		});
	}

	function compare(a,b) 
	{
	  if (a.ordem < b.ordem)
	    return -1;
	  if (a.ordem > b.ordem)
	    return 1;
	  return 0;
	}

	$("tbody").sortable({
	    items: "> tr",
	    appendTo: "parent",
	    helper: "clone"
	}).disableSelection();

	$("#workflow_table").droppable
	({
	    hoverClass: "drophover",
	    tolerance: "pointer",
	    drop: function(e, ui) 
	    {
	       	$scope.reorderWorkflow();
	    },
	    over: function() 
	    {
   	    	//$scope.reorderWorkflow();
    	}	
	});

}]);