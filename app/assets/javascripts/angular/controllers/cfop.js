myApp.controller('CfopCtrl', ['$scope', function($scope)
{
	$scope.data = []
	$scope.mensagens = [];				

	$scope.getData = function()
	{	
		$.ajax({
			async:false,
			method: 'get',
			url: '/cfops/get_json',
			success: function(data)
			{
				$scope.data = data;
			}
		});
	}
	$scope.getData();

	$scope.save = function() 
	{   		
		var request;
		request = $.ajax({
			async: false,
			method: 'post',
			url: '/cfops/save_angular/' + $('#EditingObjId').attr("data"),
			data: { data: $scope.data },
			success: function (data)
			{      			     			
				window.location.replace('/cfops');
			},
			error: function (jqXHR, textStatus, errorThrown)
			{      			     			
				$scope.mensagens = JSON.parse(jqXHR.responseText);
				console.log(jqXHR.responseText);
			}
		});
	}

	$scope.ApplyMask= function(caso)
	{	
		if($scope.data.codigo.length == 4)
		{
			$("#campocod").mask("9.999");
		}
	}

	$scope.RemoveMask = function(caso)
	{
		$("#campocod").mask();
	}

}]);
