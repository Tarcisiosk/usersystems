myApp.controller('SubgrupoCtrl', ['$scope', function($scope)
{

	$scope.data = [];
	$scope.mensagens = [];				
	$scope.grupo_opts = [];				
	$scope.empresa_atual = $('#EditingObjId').attr("empresa_atual");
	$scope.empresas_total = [];

	$scope.getData = function() 
	{
		$.ajax({
			async: false,
			method: 'get',
			url: '/subgrupos/get_json',
			success: function(data)
			{
				$scope.data = data;
			}
		});
	}

	$scope.getItensUsuario = function() 
	{
		$.ajax({
			async: false,
			method: 'get',
			url: '/subgrupos/get_itens',
			success: function(data)
			{
				$scope.grupo_opts = JSON.parse(data);

			}
		});
	}

	$scope.getData();
	$scope.getItensUsuario();


	if ($scope.data.empresas.indexOf($scope.empresa_atual) <= -1)
	{
		$scope.data.empresas.push($scope.empresa_atual);
	}

	if ($scope.data.descricao == '')
	{
		$scope.data.grupo_id = $scope.grupo_opts[0].id;

	}

	$scope.getEmpresas = function()
	{
		var empresas;
		empresas = $.ajax({
			async: false,
			method: 'get',
			url: '/subgrupos/grupoempresa/' + $scope.data.grupo_id,
			success: function(data)
			{
				$scope.empresas_total = data;

			}
		});
		$scope.data.empresas = [];
		$scope.data.empresas.push($scope.empresa_atual);
	}
	
	$scope.getEmpresas();


	// console.log($scope.empresas_total);

	$scope.save = function() 
	{   		
		var request;
		request = $.ajax({
			async: false,
			method: 'post',
			url: '/subgrupos/save_angular/' +  $('#EditingObjId').attr("data"),
			data: { data: $scope.data },
			success: function(data)
			{
				window.location.replace('/subgrupos');
			},
			error: function (jqXHR, textStatus, errorThrown)
			{      			     			
				$scope.mensagens = JSON.parse(jqXHR.responseText);
				console.log(jqXHR.responseText);
			}
		});
		
	}

	$scope.getValue = function(event, index, caso) 
	{
		if ($scope.data.empresas.indexOf(Number(event.target.value)) <= -1)
		{
			$scope.data.empresas.push(Number(event.target.value));
		}
		else
		{
			var indexArray = $scope.data.empresas.indexOf(Number(event.target.value));
			if (index > -1) 
			{
				$scope.data.empresas.splice(indexArray, 1);
			}
		}
		console.log($scope.data.empresas);

	};

}]);