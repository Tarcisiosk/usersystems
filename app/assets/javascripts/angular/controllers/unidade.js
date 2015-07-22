
myApp.controller('UnidadeCtrl', ['$scope', function($scope)
{
	$scope.data = [];
	$scope.mensagens = [];				
	$scope.empresas_total = [];
	$scope.empresa_atual = $('#EditingObjId').attr("empresa_atual");

	$scope.getData = function() 
	{
		$.ajax({
			async:false,
			method: 'get',
			url: '/unidades/get_json',
			success: function(data)
			{
				$scope.data = data;
			}
		});
	}

	$scope.getEmpresas = function() 
	{
		$.ajax({
			async:false,
			method: 'get',
			url: '/unidades/get_empresa',
			success: function(data)
			{
				$scope.empresas_total = data;
			}
		});
	}

	$scope.getData();
	$scope.getEmpresas();
	
	if ($scope.data.empresas.indexOf($scope.empresa_atual) <= -1)
	{
		$scope.data.empresas.push($scope.empresa_atual);
	}

	$scope.save = function() 
	{   		
		var request;
		request = $.ajax({
			async: false,
			method: 'post',
			url: '/unidades/save_angular/' + $('#EditingObjId').attr("data"),
			data: { data: $scope.data },
			success: function (data)
			{      			     			
				window.location.replace('/unidades');
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
		console.log($scope.data);
	}

}]);