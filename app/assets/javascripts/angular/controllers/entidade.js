myApp.controller('EntidadeCtrl', ['$scope', function($scope)
{
	$scope.data = [];
	$scope.mensagens = [];				
	$scope.tipos_total = [];
	$scope.empresas_total = [];
	$scope.empresa_atual = $('#EditingObjId').attr("empresa_atual");
	$scope.estados_total = [];
	$scope.enderecoEditar = '';

	$scope.opt = ["Principal", "Cobrança", "Entrega"];
	$scope.novo = false;
	
	$scope.getData = function() 
	{
		$.ajax({
			async:false,
			method: 'get',
			url: '/entidades/get_json',
			success: function(data)
			{
				$scope.data = data;
			}
		});
	}

	$scope.getItensUsuario = function() 
	{
		$.ajax({
			async:false,
			method: 'get',
			url: '/entidades/get_itens',
			success: function(data)
			{
				$scope.tipos_total = JSON.parse(data);
					console.log(data);

			}
		});
	}

	$scope.getEmpresas = function() 
	{
		$.ajax({
			async:false,
			method: 'get',
			url: '/entidades/get_empresa',
			success: function(data)
			{
				$scope.empresas_total = data;
			}
		});
	}

	$scope.getEstados = function() 
	{
		$.ajax({
			async:false,
			method: 'get',
			url: '/entidades/get_estado',
			success: function(data)
			{
				$scope.estados_total = data;
			}
		});
	}
	$scope.getData();
	$scope.getItensUsuario();
	$scope.getEmpresas();
	$scope.getEstados();

	console.log($scope.tipos_total);

	if ($scope.data.empresas.indexOf($scope.empresa_atual) <= -1)
	{
		$scope.data.empresas.push($scope.empresa_atual);
	}
	
	$scope.save = function(reload) 
	{
		$scope.RemoveMask(2);
		if($scope.data.tipoentidades.length <= 0 )
		{
			bootbox.alert("Escolha no mínimo um tipo de entidade!");
		} 
		else
		{
			var request;
			request = $.ajax({
				async:false,
				method: 'post',
				url: '/entidades/save_angular/' + $('#EditingObjId').attr("data"),
				data: { data: $scope.data },
				success: function(data)
				{
					if(reload)
					{
						window.location.replace('/entidades');
					}
				},
				error: function (jqXHR, textStatus, errorThrown)
				{      			     			
					$scope.mensagens = JSON.parse(jqXHR.responseText);
					console.log(jqXHR.responseText);
				}
			});
		}
	}

	$scope.getValue = function(event, index, caso) 
	{
		if(caso == 1)
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
		}
		else if(caso == 2)
		{
			if ($scope.data.tipoentidades.indexOf(Number(event.target.value)) <= -1)
			{
				$scope.data.tipoentidades.push(Number(event.target.value));
			}
			else
			{
				var indexArray = $scope.data.tipoentidades.indexOf(Number(event.target.value));
				if (index > -1) 
				{
					$scope.data.tipoentidades.splice(indexArray, 1);
				}
			}
		}
	}

	$scope.find_cep = function(cep, id)
	{
		Metronic.blockUI({
			target: '#end_form',
			animate: true
		});
		if($scope.enderecoEditar.cep.length == 8)
		{
			$.getJSON("//viacep.com.br/ws/"+ cep +"/json/?callback=?", function(dados) 
			{
				if (!("erro" in dados)) 
				{
					$("[name=rua"+ id + "]").val(dados.logradouro);
					$("[name=bairro"+ id + "]").val(dados.bairro);
					$("[name=cidade"+ id + "]").val(dados.localidade);

					$scope.enderecoEditar.rua = dados.logradouro;
					$scope.enderecoEditar.bairro = dados.bairro;
					$scope.enderecoEditar.cidade = dados.localidade;
					$scope.enderecoEditar.uf = dados.uf;

					Metronic.unblockUI('#end_form');
					$("#camponum").focus();

				}
				else 
				{
					bootbox.alert("CEP não encontrado.");
					Metronic.unblockUI('#end_form');
				}
			});
		}
		else
		{
			bootbox.alert("CEP inválido");
			Metronic.unblockUI('#end_form');
		}
	}

	$scope.add_blank_end = function()
	{
		var blank_end = {"tipo_endereco":"", "rua":"","num_rua":"","cep":"","uf":"","cidade":"","bairro":""};
		$scope.enderecoEditar = blank_end;
		$scope.novo = true;
	}
	
	$scope.set_novo = function()
	{
		$scope.novo = false;
		console.log($scope.data.tipoentidades)
	}

	$scope.edit_end = function(index)
	{
		$scope.enderecoEditar =  $scope.data.endereco[index];
		console.log($scope.tipoentidades);
	}

	$scope.delete_end = function(index)
	{
		var deleteEnd = window.confirm('Voce deseja excluir esse endereço? A ação não pode ser desfeita!');

		if (deleteEnd) 
		{
			$scope.data.endereco.splice(index, 1);    
			$scope.save(false);
		}
	}

	$scope.save_end = function(index)
	{
		if($scope.enderecoEditar.cep.length <= 6 || $scope.enderecoEditar.rua.length < 3)
		{
			bootbox.alert("Endereco invalido!");
		}
		else
		{
			if(!$scope.novo)
			{
				$scope.data.endereco[index] = $scope.enderecoEditar;
			}
			else
			{
				$scope.data.endereco.push($scope.enderecoEditar);
				$scope.novo = false;
			}
			$scope.save(false);
		}
	}

	$scope.ApplyMask= function(caso)
	{	
		if(caso == 1)
		{
			if($scope.enderecoEditar.cep.length == 8)
			{
				$("#campocep").mask("99999-999");
			}
			else
			{
			}
		}
		else if (caso == 2)
		{
			if($scope.data.cnpj.length == 11)
			{
				$("#campocnpj").mask("999.999.999-99");
			}
			else if($scope.data.cnpj.length == 14)
			{
				$("#campocnpj").mask("99.999.999/9999-99");
			}
			else
			{
			}
		}
	}

	$scope.RemoveMask = function(caso)
	{
		if(caso == 1)
		{
			$("#campocep").unmask();
		}	
		else if(caso == 2)
		{
			$("#campocnpj").unmask();
		}
	}
}]);