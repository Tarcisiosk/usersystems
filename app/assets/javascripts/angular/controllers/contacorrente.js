myApp.controller('ContaCorrenteCtrl', ['$scope', '$filter', function($scope, $filter)
{
	$scope.contacorrente = JSON.parse($('#contacorrente').attr("value"));	
	if(!$scope.contacorrente.compensado || $scope.contacorrente.compensado == 'Compensado'){
		$scope.contacorrente.compensado = 'Compensado';
		$scope.compensado = true;
	}else{
		$scope.contacorrente.compensado = '';
		$scope.compensado = false;
	}	
	console.log($scope.compensado);
	$scope.mensagens = [];	

	$scope.clickCompensado = function(){		
		if($scope.compensado == true){
			$scope.contacorrente.compensado = 'Compensado';
		}else{
			$scope.contacorrente.compensado = '';
		}				
	}

	$scope.$watch('contacorrente.data', function (newValue) {
		if(newValue){
    		$scope.contacorrente.data = $filter('date')(newValue, 'dd/MM/yyyy');
    	}else{
    		$scope.contacorrente.data = $filter('date')(new Date(), 'dd/MM/yyyy');
    	} 
	});

	$scope.save = function() 
	{   		
		var request;
		request = $.ajax({
			async: false,
			method: 'post',
			url: '/contacorrentes/save/',
			data: { contacorrente: $scope.contacorrente },
			success: function (data){      			     			
				window.location.replace('/contacorrentes?entidade='+data);
			},
			error: function (jqXHR, textStatus, errorThrown){      			     			
				$scope.mensagens = JSON.parse(jqXHR.responseText);
				console.log(jqXHR.responseText);
			}
		});
	}	
}]);