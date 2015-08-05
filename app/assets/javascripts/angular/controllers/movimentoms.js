myApp.controller('MovimentomsCtrl', ['$scope', function($scope)
{
	$scope.data = [];
	$scope.mensagens = [];	
	$scope.entidade_opts = [];
	$scope.produto_opts = [];
	$scope.produtos_choosen = [];
	$scope.produto_selected = {};
	$scope.empresa_atual =  $('#EditingObjId').attr("empresa_atual");
	$scope.getData = function() 
	{
		$.ajax({
			async:false,
			method: 'get',
			url: '/movimentoms/get_json/',
			dataType: 'json',
			success: function(data)
			{
				$scope.data = data;
			},
			error: function()
			{      			     			
				alert('ué');
			}
		});

		if($scope.data.produtos_list)
		{
			$scope.produtos_choosen = JSON.parse($scope.data.produtos_list);
		}
	}

	$scope.getEntidades = function() 
	{
		$.ajax({
			async:false,
			method: 'get',
			url: '/movimentoms/get_entidades/',
			dataType: 'json',
			success: function(data)
			{
				$scope.entidade_opts = data;
			},
			error: function()
			{      			     			
				alert('ué');
			}
		});
	}

	$scope.getProdutos = function() 
	{
		$.ajax({
			async:false,
			method: 'get',
			url: '/movimentoms/get_produtos/',
			dataType: 'json',
			success: function(data)
			{
				$scope.produto_opts = data;
			},
			error: function()
			{      			     			
				alert('ué');
			}
		});
	}

	$scope.getData();	
	$scope.getEntidades();

	$scope.refreshProdutos = function(input) {
	    if(input.length < 2 )
	    {
			$scope.produto_opts = [];
	    }
	    else
	    {	
	    	$scope.getProdutos();
	    }
	}

	$scope.setFocusInput = function()
	{		
		$scope.produto_selected = {}
	    setTimeout(function(){
  				$scope.$broadcast('setFocus');
          }, 500);
	   
	}
	
	$scope.NextField = function()
	{
		setTimeout(function(){
           $("#qtde").focus();
        }, 2);
		
	}

	$scope.setProdutoSelected = function(item)
	{
		$scope.produto_selected = item;
		//$scope.produto_selected.preco = $scope.produto_selected.preco * 100;
	}	

	$scope.addProduto = function(produto)
	{	
		var pos = $scope.produtos_choosen.map(function(e) { return e.descricao; }).indexOf($scope.produto_selected.descricao);
		if(pos <= -1)
		{
			$scope.produtos_choosen.push(produto);
			$scope.data.produtos_list = JSON.stringify($scope.produtos_choosen);
		}
	}
	
	$scope.edit_produto = function(index)
	{
		$scope.produto_selected = $scope.produtos_choosen[index];
	}

	$scope.delete_produto = function(index)
	{
		var deleteEnd = window.confirm('Voce deseja excluir esse produto?');

		if (deleteEnd) 
		{
			$scope.produtos_choosen.splice(index, 1);    
		}
		$scope.data.produtos_list = JSON.stringify($scope.produtos_choosen);

		$scope.setTotal();
	}

	$scope.setTotal = function()
	{	
		$scope.data.totalquantidade = 0;
		$scope.data.totalvalor = 0;
		var i = 0;
		for(i = 0; i < $scope.produtos_choosen.length; i++)
		{
			$scope.data.totalquantidade += parseFloat($scope.produtos_choosen[i].qtde);
			$scope.data.totalvalor += parseFloat($scope.produtos_choosen[i].preco * $scope.produtos_choosen[i].qtde);
		}
		
	

		// setTimeout(function(){
		// 	$(".money").mask('#.##0,00', {reverse: true});
  //   	}, 2);

	
	}
	
	$scope.setTotal();

	$scope.save = function() 
	{   		
		var request;
		request = $.ajax({
			async: false,
 			method: 'post',
			url: '/movimentoms/save_angular/' + $('#EditingObjId').attr("data"),
			data: { data: $scope.data },
			success: function (data)
			{      			     			
				window.location.replace('/movimentoms');
			},
			error: function (jqXHR, textStatus, errorThrown)
			{      			     			
				$scope.mensagens = JSON.parse(jqXHR.responseText);
			}
		});
	}

	

 	$(':input').keydown(function (e) {
    	if (e.which === 13) {
         	var index = $(':input').index(this) + 1;
         	$(':input').eq(index).focus();
     	}
 	});
}]);