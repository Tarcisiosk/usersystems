myApp.controller('PlanocontaCtrl', ['$scope', function($scope)
{
	$scope.data = JSON.parse($('#planoconta').attr("value"));	
	$scope.nivel1 = $('#nivel1').attr("value");
	$scope.pai = JSON.parse($('#pai').attr("value"));	
	$scope.mensagens = [];	

	$scope.save = function() 
	{   		
		var request;
		request = $.ajax({
			async: false,
			method: 'post',
			url: '/planocontas/save/',
			data: { planoconta: $scope.data },
			success: function (data)
			{      			     			
				window.location.replace('/planocontas');
			},
			error: function (jqXHR, textStatus, errorThrown)
			{      			     			
				$scope.mensagens = JSON.parse(jqXHR.responseText);
				console.log(jqXHR.responseText);
			}
		});
	}	
}]);