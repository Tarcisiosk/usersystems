myApp.controller('MovimentomsCtrl', ['$scope', function($scope)
{
	var auxfrete = $scope.totalfrete;
	var auxdesconto = $scope.totaldesconto;
	var auxseguro = $scope.totalseguro;
	var auxoutros = $scope.totaloutros;
	var auxproduto = [];
	var auxindex = 0;

	$scope.data = [];
	$scope.mensagens = [];
	$scope.lbl = 'Expandir';	
	$scope.entidade_opts = [];
	$scope.produto_opts = [];
	$scope.produtos_choosen = [];
	$scope.produto_selected = [];
	$scope.isEditing = false;
	$scope.totalpreco = 0;
	$scope.totalfrete = 0;
	$scope.totaldesconto = 0;
	$scope.totalseguro = 0;
	$scope.totaloutros = 0;
	$scope.totalipi = 0;
	$scope.totalicms = 0;
	$scope.basecalculo = 0;

	$scope.interEstadual = false;
	$scope.aliqInterEstadual = 0;
	//icms do estado da empresa logada
	$scope.icmsProdutoSelected = '';
	//icms do estado do cliente 
	$scope.icmsEntidadeSelected = '';

	$scope.entidade_selected = JSON.parse($('#EditingObjId').attr("cliente"));
	$scope.empresa_atual = JSON.parse($('#EditingObjId').attr("empresa_atual"));
	$scope.estado_atual = $scope.empresa_atual.uf;
	$scope.ipicsts = JSON.parse($('#EditingObjId').attr("ipi"));
	$scope.icmscsts = JSON.parse($('#EditingObjId').attr("icms"));
	$scope.modalidadebcicmssts = JSON.parse($('#EditingObjId').attr("modalidade"));

	$scope.isDisabled = false;
	//dados gerais
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

	//entidades disponiveis
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
				$scope.entidade_selected = data[0];
				
				if($scope.data.entidade_id == undefined)
				{
					$scope.data.entidade_id = data[0].id;
				}

				//set entidade selecionada de acordo com a salva no banco de dados
				for(var i = 0; i < $scope.entidade_opts.length; i++)
				{
				  	if($scope.entidade_opts[i].id == $scope.data.entidade_id)
				 	{
						$scope.entidade_selected = $scope.entidade_opts[i];
					}
				}
				//seta consumidor final de acordo com o cliente
				if($scope.entidade_selected.cnpj.length < 14 || $scope.insc_estadual == 'ISENTO')
				{
					$scope.data.consumidor_final = true;
					$scope.isDisabled = true;
				}
				else
				{
					//seta somente se nao existir um valor para consumidor final
					if($scope.data.consumidor_final == undefined)
					{
						$scope.data.consumidor_final = false;
						$scope.isDisabled = false;
					}
					$scope.isDisabled = false;
				}
			},
			error: function()
			{      			     			
				alert('ué');
			}
		});
	}

	//produtos
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
				$scope.produto_selected.icms_aliquota = $scope.icmsProdutoSelected.aliquota;

			},
			error: function()
			{      			     			
				alert('ué');
			}
		});
	}
	//icms do estado da entidade ou do produto...
	$scope.getIcms = function(id_produto, ent)
	{
		$.ajax({
			async:false,
			method: 'get',
			url: '/movimentoms/get_icms/' + id_produto,
			data: {"uf" : $scope.estado_atual, "ent" : ent, "ent_id" : $scope.data.entidade_id},
			dataType: 'json',
			success: function(data)
			{
				if(ent)
				{
					$scope.icmsEntidadeSelected = data[0];
				}
				else
				{
					$scope.icmsProdutoSelected = data[0];
				}
			},
			error: function()
			{      	
				alert('ué');
			}
		});	
	}
	
	$scope.getIcmsInterEstadual = function(origem, destino)
	{
		$.ajax({
			async:false,
			method: 'get',
			url: '/movimentoms/get_icmsinterestadual/',
			data: {"or" : origem, "dest" : destino },
			dataType: 'json',
			success: function(data)
			{
				$scope.aliqInterEstadual = data[0].icms;
			},
			error: function()
			{      			     			
				alert('ué');
			}
		});	
	}

	$scope.getData();	
	$scope.getEntidades();

	//salva
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

	$scope.setEntidadeSelected = function(data)
	{
		$scope.entidade_selected = data;
		if($scope.entidade_selected.cnpj.length < 14 || $scope.insc_estadual == 'ISENTO')
		{
			$scope.data.consumidor_final = true;
			$scope.isDisabled = true;
		}
		else
		{
			$scope.data.consumidor_final = false;
			$scope.isDisabled = false;
		}
	}

	$scope.setCheckboxes = function(id, varCheck)
	{
		// console.log(varCheck);
		// console.log('uniform-' + id);
		if(id == 'consumidorfinal' || id == 'reducaomva') 
		{
			if(varCheck == false)
			{
				$('span', $('#uniform-' + id)).removeClass("checked");
				$(id).removeAttr("checked");
			}
			else
			{
				$('span', $('#uniform-' + id)).addClass("checked");
				$(id).attr("checked");
			}
		
			if(id == 'consumidorfinal')
			{
				if($scope.isDisabled == false)
				{
					$('#uniform-' + id).removeClass("disabled");
				}
				else
				{
					$('#uniform-' + id).addClass("disabled");
				}
			}
		}
		else
		{
			if(varCheck == 0)
			{
				$('span', $('#uniform-' + id)).removeClass("checked");
				$(id).removeAttr("checked");
			}
			else
			{
				$('span', $('#uniform-' + id)).addClass("checked");
				$(id).attr("checked");
			}
		
		}
	}

	$scope.preSetCheckbox = function()
	{
		$scope.setCheckboxes('freteipi', $scope.produto_selected.calcFreteIpi);
		$scope.setCheckboxes('descontoipi', $scope.produto_selected.calcDescontoIpi);
		$scope.setCheckboxes('seguroipi', $scope.produto_selected.calcSeguroIpi);
		$scope.setCheckboxes('outrosipi', $scope.produto_selected.calcOutrosipi);
		$scope.setCheckboxes('ipiicms', $scope.produto_selected.calcIpiIcms);
		$scope.setCheckboxes('freteicms', $scope.produto_selected.calcFreteIcms);
		$scope.setCheckboxes('descontoicms', $scope.produto_selected.calcDescontoIcms);
		$scope.setCheckboxes('seguroicms', $scope.produto_selected.calcSeguroIcms);
		$scope.setCheckboxes('outrosicms', $scope.produto_selected.calcOutrosIcms);
		$scope.setCheckboxes('ipiicmsst', $scope.produto_selected.calcIpiIcmsst);
		$scope.setCheckboxes('freteicmsst', $scope.produto_selected.calcFreteIcmsst);
		$scope.setCheckboxes('descontoicmsst', $scope.produto_selected.calcDescontoIcmsst);
		$scope.setCheckboxes('descontoicms', $scope.produto_selected.calcDescontoIcms);
		$scope.setCheckboxes('outrosicmsst', $scope.produto_selected.calcOutrosIcmsst);
		$scope.setCheckboxes('reducaomva', $scope.icmsProdutoSelected.reducaomva);
	}

	//verifica se icms deve ser calculado pelo valor interestadual
	$scope.verifyInter = function()
	{
		console.log('Estado do Cliente: ' + $scope.icmsEntidadeSelected.estado_id);
		console.log('Estado da Empresa: ' + $scope.icmsProdutoSelected.estado_id);
		if($scope.icmsEntidadeSelected.estado_id != $scope.icmsProdutoSelected.estado_id || !$scope.data.consumidor_final)
		{
			$scope.interEstadual = true;
			$scope.getIcmsInterEstadual($scope.icmsProdutoSelected.estado_id, $scope.icmsEntidadeSelected.estado_id);
		}
		else
		{
			$scope.interEstadual = false;
		}
	}

	//seta se a informação foi editada para nao recalcular.
	$scope.setEdited = function(i)
	{
		$scope.verifyUndefined();
		//ipi
		if(i == 0)
		{
			if($scope.produto_selected.wasIpiEdited == false)
			{
				$scope.produto_selected.wasIpiEdited = true;
			}
			console.log($scope.produto_selected.wasIpiEdited);
		}
		//icms
		else if(i == 1)
		{
			if($scope.produto_selected.wasIcmsEdited == false)
			{
				$scope.produto_selected.wasIcmsEdited = true;
			}
			console.log($scope.produto_selected.wasIcmsEdited);
		}
		//icmsst
		else if(i == 2)
		{
			if($scope.produto_selected.wasIcmsstEdited == false)
			{
				$scope.produto_selected.wasIcmsstEdited = true;
			}
			console.log($scope.produto_selected.wasIcmsstEdited);
		}
	}

	//calcula base de calculo IPI
	$scope.calcBcIpi = function()
	{
		$scope.produto_selected.basecalculoIpi = ($scope.produto_selected.preco * $scope.produto_selected.qtde) + 
												 ($scope.produto_selected.frete * $scope.produto_selected.calcFreteIpi) + 
												 ($scope.produto_selected.seguro * $scope.produto_selected.calcSeguroIpi) + 
												 ($scope.produto_selected.outros * $scope.produto_selected.calcOutrosIpi) - 
												 ($scope.produto_selected.desconto * $scope.produto_selected.calcDescontoIpi);

		$scope.produto_selected.valoripi = $scope.produto_selected.basecalculoIpi * ($scope.produto_selected.ipi_aliquota/100).toFixed(2);
	}

	//seta os valores do IPI
	$scope.setIpi = function()
	{
		var auxbc = $scope.produto_selected.basecalculoIpi;
		$scope.verifyUndefined();

		if(!$scope.produto_selected.wasIpiEdited)
		{
			if( $scope.produto_selected.ipi_cst_id == 8 )
			{
				$$scope.calcBcIpi();
			}
			//saida tributada com aliquota zero
			if( $scope.produto_selected.ipi_cst_id == 9)
			{
				$$scope.calcBcIpi();

				$scope.produto_selected.ipi_aliquota = 0;
				$scope.produto_selected.valoripi = 0;
			}

			//outras saidas...
			if( $scope.produto_selected.ipi_cst_id != 8 && $scope.produto_selected.ipi_cst_id != 9)
			{
				$scope.produto_selected.basecalculoIpi = 0;
			}
		}
		else
		{
			if( $scope.produto_selected.ipi_cst_id == 8 )
			{
				$scope.produto_selected.valoripi = $scope.produto_selected.basecalculoIpi * ($scope.produto_selected.ipi_aliquota/100).toFixed(2);		
			}
			if($scope.produto_selected.ipi_cst_id == 9)
			{
				$scope.produto_selected.ipi_aliquota = 0;
				$scope.produto_selected.valoripi = 0;
			}
			if( $scope.produto_selected.ipi_cst_id != 8 && $scope.produto_selected.ipi_cst_id != 9)
			{
				$scope.produto_selected.basecalculoIpi = 0;
				$scope.produto_selected.ipi_aliquota = 0;
				$scope.produto_selected.valoripi = 0;
			}
		}
		

		if($scope.produto_selected.basecalculoIpi != auxbc)
		{
			$("[name='alt']").effect( "pulsate", {times:1}, 100 );
		}
	}
	
	//calcula base de calculo do ICMS
	$scope.calcBcIcms = function()
	{
		$scope.produto_selected.basecalculoIcms = ($scope.produto_selected.preco * $scope.produto_selected.qtde) + 
												  ($scope.produto_selected.frete * $scope.produto_selected.calcFreteIcms) + 
												  ($scope.produto_selected.valoripi * $scope.produto_selected.calcIpiIcms) + 
												  ($scope.produto_selected.seguro * $scope.produto_selected.calcSeguroIcms) + 
												  ($scope.produto_selected.outros * $scope.produto_selected.calcOutrosIcms) - 
												  ($scope.produto_selected.desconto * $scope.produto_selected.calcDescontoIcms);
	}

	//seta os valores ICMS
	$scope.setIcms = function()
	{
		var auxbcicms = $scope.produto_selected.basecalculoIcms;
			
		$scope.verifyUndefined();

		if($scope.isEditing == false)
		{
			if(!$scope.produto_selected.wasIcmsEdited)
			{
				if($scope.icmsProdutoSelected.aliquota > 0)
				{	
					//00
					if($scope.icmsProdutoSelected.reducaobasecalculo == 0 && $scope.icmsProdutoSelected.diferimento == 0  && $scope.icmsProdutoSelected.icmsst == false)
					{
						$scope.produto_selected.icms_cst_id = 1;
					}
					//51
					else if($scope.icmsProdutoSelected.reducaobasecalculo == 0 && $scope.icmsProdutoSelected.diferimento > 0  && $scope.icmsProdutoSelected.icmsst == false)
					{
						$scope.produto_selected.icms_cst_id = 8;
					}
					//10
					else if($scope.icmsProdutoSelected.reducaobasecalculo == 0  && $scope.icmsProdutoSelected.icmsst == true)
					{
						$scope.produto_selected.icms_cst_id = 2;
						$scope.setIcmsst();
						$scope.calcBcIcmsst();
					}
					//20
					else if($scope.icmsProdutoSelected.reducaobasecalculo > 0  && $scope.icmsProdutoSelected.icmsst == false)
					{
						$scope.produto_selected.icms_cst_id = 3;
					}
					//70
					else if($scope.icmsProdutoSelected.reducaobasecalculo > 0  && $scope.icmsProdutoSelected.icmsst == true)
					{
						$scope.produto_selected.icms_cst_id = 10;
						$scope.setIcmsst();
						$scope.calcBcIcmsst();
					}
				}
				else
				{
					//30
					if($scope.icmsProdutoSelected.icmsst == true)
					{
						$scope.produto_selected.icms_cst_id = 4;
						$scope.setIcmsst();
						$scope.calcBcIcmsst();
					}
					//40				
					else if($scope.icmsProdutoSelected.icmsst == false)
					{
						$scope.produto_selected.icms_cst_id = 5;
					}
				}
			}
		}

		if(!$scope.produto_selected.wasIcmsEdited)
		{
			//tributado integralmente
			if( $scope.produto_selected.icms_cst_id == 1 ||  $scope.produto_selected.icms_cst_id == 2 ||
				$scope.produto_selected.icms_cst_id == 3 ||  $scope.produto_selected.icms_cst_id == 8 ||
				$scope.produto_selected.icms_cst_id == 10 ||  $scope.produto_selected.icms_cst_id == 11)
			{
				$scope.calcBcIcms();

				if($scope.produto_selected.icms_aliquota == undefined)
				{
					$scope.produto_selected.icms_aliquota = $scope.icmsProdutoSelected.aliquota;
				}

				if($scope.interEstadual)
				{
					$scope.produto_selected.icms_aliquota = $scope.aliqInterEstadual;
				}

				$scope.produto_selected.valoricms = $scope.produto_selected.basecalculoIcms * ($scope.produto_selected.icms_aliquota/100).toFixed(2);

			}
			else if ($scope.produto_selected.icms_cst_id == 5 ||  $scope.produto_selected.icms_cst_id == 6 ||
					 $scope.produto_selected.icms_cst_id == 7 ||  $scope.produto_selected.icms_cst_id == 9)
			{
				$scope.produto_selected.basecalculoIcms = 0;
				$scope.produto_selected.icms_aliquota = 0;
				$scope.produto_selected.valoricms = 0;
			}
			else
			{
				$scope.calcBcIcms();

				if($scope.produto_selected.valoricms == 0 || $scope.produto_selected.valoricms == undefined)
				{
					$scope.produto_selected.valoricms = $scope.produto_selected.basecalculoIcms * ($scope.produto_selected.icms_aliquota/100).toFixed(2);
				}

				$scope.produto_selected.icms_aliquota = 0;
				$scope.produto_selected.valoricms = 0;
			}
		}
		else
		{
			if($scope.produto_selected.icms_cst_id == 1 )
			{
				$scope.icmsProdutoSelected.icmsst == false
				$scope.produto_selected.valoricms = $scope.produto_selected.basecalculoIcms * ($scope.produto_selected.icms_aliquota/100).toFixed(2);
			}
			else if($scope.produto_selected.icms_cst_id == 2 || $scope.produto_selected.icms_cst_id == 4 || $scope.produto_selected.icms_cst_id == 10)
			{
				$scope.icmsProdutoSelected.icmsst == true;
			}
			else if ($scope.produto_selected.icms_cst_id == 5 ||  $scope.produto_selected.icms_cst_id == 6 ||
					 $scope.produto_selected.icms_cst_id == 7 ||  $scope.produto_selected.icms_cst_id == 9)
			{
				$scope.icmsProdutoSelected.icmsst == false
				$scope.produto_selected.basecalculoIcms = 0;
				$scope.produto_selected.icms_aliquota = 0;
				$scope.produto_selected.valoricms = 0;
			}
			else
			{
				$scope.icmsProdutoSelected.icmsst == false
				$scope.produto_selected.icms_aliquota = 0;
				$scope.produto_selected.valoricms = 0;
			}
		}

		if($scope.produto_selected.basecalculoIcms != auxbcicms)
		{
			$("[name='alticms']").effect( "pulsate", {times:1}, 500 );
		}
	}

	//calcula base de calculo ICMSST
	$scope.calcBcIcmsst = function()
	{
		$scope.produto_selected.basecalculoIcmsst = ($scope.produto_selected.preco * $scope.produto_selected.qtde) + 
												  ($scope.produto_selected.frete * $scope.produto_selected.calcFreteIcmsst) + 
												  ($scope.produto_selected.valoripi * $scope.produto_selected.calcIpiIcmsst) + 
												  ($scope.produto_selected.seguro * $scope.produto_selected.calcSeguroIcmsst) + 
												  ($scope.produto_selected.outros * $scope.produto_selected.calcOutrosIcmsst) - 
												  ($scope.produto_selected.desconto * $scope.produto_selected.calcDescontoIcmsst);

		$scope.produto_selected.basecalculoIcmsst += $scope.produto_selected.basecalculoIcmsst * ($scope.icmsProdutoSelected.mva/100);	
	}

	//seta os valores ICMSST
	$scope.setIcmsst = function()
	{
		var auxbcicmsst = $scope.produto_selected.basecalculoIcmsst;
	
		$scope.verifyUndefined();

		if(!$scope.produto_selected.wasIcmsstEdited)
		{
			//margem valor agregado mva
			if($scope.icmsProdutoSelected.modalidadebcicmsst_id == 5)
			{
				$scope.calcBcIcmsst();
				$scope.produto_selected.icmsst_aliquota = 0;

			}
		}
		else
		{
		
		}

		if($scope.produto_selected.basecalculoIcmsst != auxbcicmsst)
		{
			$("[name='alticmsst']").effect( "pulsate", {times:1}, 500 );
		}

	}
	
	//Atualiza produtos
	$scope.refreshProdutos = function(input) 
	{
	    if(input.length < 2 )
	    {
			$scope.produto_opts = [];
	    }
	    else
	    {	
	    	$scope.getProdutos();
	    }
	}

	//foco no campo quando abrir tela de produtos
	$scope.setFocusInput = function()
	{		
		$scope.produto_selected = []
		setTimeout(function(){
  				$scope.$broadcast('setFocus');
        }, 500);
	   
	}

	//seta o produto selecionado
	$scope.setProdutoSelected = function(item)
	{
		$scope.produto_selected = item;
	}
	
	//pula para o prox campo
	$scope.NextField = function()
	{
		setTimeout(function(){
           $("#qtde").focus();
        }, 2);
        $scope.setIpi();
	}

	//add produto
	$scope.addProduto = function(produto)
	{	
		if($scope.isEditing == false){
			var pos = $scope.produtos_choosen.map(function(e) { return e.descricao; }).indexOf($scope.produto_selected.descricao);
			if(pos <= -1)
			{
				$scope.produtos_choosen.push(produto);
				$scope.data.produtos_list = JSON.stringify($scope.produtos_choosen);
			}
		}
	}

	//edita o produto
	$scope.edit_produto = function(index)
	{

		$scope.isEditing = true;
		$scope.produto_selected = $scope.produtos_choosen[index];
		auxproduto = JSON.parse($scope.data.produtos_list)[index]; 
		auxindex = index;
	}

	//salva o produto
	$scope.saveProduto = function(produto)
	{
		if($scope.isEditing == true)
		{
			$scope.produtos_choosen[auxindex] = produto;
		}
		$scope.endEdit();
	}

	//cancela edicao
	$scope.cancelEdit = function()
	{		
		if($scope.isEditing == true)
		{
			$scope.produtos_choosen[auxindex] = auxproduto;
		}
		
		$scope.endEdit();
	}

	//funçoes para termino de ediçao
	$scope.endEdit = function()
	{
		auxproduto = [];
		auxindex = 0;
		$scope.setTotal();
		$scope.isEditing = false;
	}

	//deleta o produto
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

	//seta os valores totais
	$scope.setTotal = function()
	{	

		$scope.data.totalquantidade = 0;
		$scope.data.totalvalor = 0;
		$scope.totalpreco = 0;
		$scope.totalfrete = 0;
		$scope.totaldesconto = 0;
		$scope.totalseguro = 0;
		$scope.totaloutros = 0;
		$scope.totalipi = 0;
		$scope.totalicms = 0;

		var i = 0;
		for(i = 0; i < $scope.produtos_choosen.length; i++)
		{
			$scope.data.totalquantidade += parseFloat($scope.produtos_choosen[i].qtde);
			//$scope.data.totalvalor += parseFloat($scope.produtos_choosen[i].preco * $scope.produtos_choosen[i].qtde);
			$scope.totalpreco += parseFloat($scope.produtos_choosen[i].preco * $scope.produtos_choosen[i].qtde);
			$scope.totalfrete += parseFloat($scope.produtos_choosen[i].frete);
			$scope.totaldesconto += parseFloat($scope.produtos_choosen[i].desconto);
			$scope.totalseguro += parseFloat($scope.produtos_choosen[i].seguro);
			$scope.totaloutros += parseFloat($scope.produtos_choosen[i].outros);
			$scope.totalipi += parseFloat($scope.produtos_choosen[i].valoripi);
			$scope.totalicms += parseFloat($scope.produtos_choosen[i].valoricms);

		}

		$scope.data.totalvalor = ($scope.totalpreco + $scope.totalfrete + $scope.totalseguro + $scope.totaloutros + $scope.totalipi) - $scope.totaldesconto;
		$scope.data.produtos_list = JSON.stringify($scope.produtos_choosen);
	}
	
	$scope.setTotal();

	//cria valores auxiliares no caso de cancelamento
	$scope.preCalcRatio = function()
	{
		auxfrete = $scope.totalfrete;
		auxdesconto = $scope.totaldesconto;
		auxseguro = $scope.totalseguro;
		auxoutros = $scope.totaloutros;
	}

	//retorna os valores iniciais caso cancelamento
	$scope.cancelRatio = function()
	{
		$scope.totalfrete = auxfrete;
		$scope.totaldesconto = auxdesconto;
		$scope.totalseguro = auxseguro;
		$scope.totaloutros = auxoutros; 
	}
	
	//calcula o rateio de acordo com os valores dos produtos
	$scope.calcRatio = function()
	{	
		var i = 0;
		var ratio = 0;
		var total = 0;
		var dif = 0;
		var rounder = [];

		if($scope.totalfrete != auxfrete)
		{
			for(i = 0; i < $scope.produtos_choosen.length; i++)
			{
				ratio = ($scope.produtos_choosen[i].preco * $scope.produtos_choosen[i].qtde) / $scope.totalpreco;
				$scope.produtos_choosen[i].frete = ($scope.totalfrete * ratio).toFixed(2);
				rounder.push($scope.produtos_choosen[i].frete );
			}
			$.each(rounder,function() {
			    total += (this * 1);
			}); 			
			if (total != $scope.totalfrete)
			{
				dif = ($scope.totalfrete - total).toFixed(2);
				$scope.produtos_choosen[$scope.produtos_choosen.length-1].frete = (($scope.produtos_choosen[$scope.produtos_choosen.length-1].frete * 1) + (dif * 1)).toFixed(2);
			}
		}

		ratio = 0;
		total = 0;
		dif = 0;
		rounder = [];
		
		if($scope.totaldesconto != auxdesconto)
		{
			for(i = 0; i < $scope.produtos_choosen.length; i++)
			{
				ratio = ($scope.produtos_choosen[i].preco * $scope.produtos_choosen[i].qtde) / $scope.totalpreco;
				$scope.produtos_choosen[i].desconto = ($scope.totaldesconto * ratio).toFixed(2);
				rounder.push($scope.produtos_choosen[i].desconto );
			}
			$.each(rounder,function() {
			    total += (this * 1);
			}); 			
			if (total != $scope.totaldesconto)
			{
				dif = ($scope.totaldesconto - total).toFixed(2);
				$scope.produtos_choosen[$scope.produtos_choosen.length-1].desconto = (($scope.produtos_choosen[$scope.produtos_choosen.length-1].desconto * 1) + (dif * 1)).toFixed(2);
			}
		}
		
		ratio = 0;
		total = 0;
		dif = 0;
		rounder = [];

		if($scope.totalseguro != auxseguro)
		{
			for(i = 0; i < $scope.produtos_choosen.length; i++)
			{
				ratio = ($scope.produtos_choosen[i].preco * $scope.produtos_choosen[i].qtde) / $scope.totalpreco;
				$scope.produtos_choosen[i].seguro = ($scope.totalseguro * ratio).toFixed(2);
				rounder.push($scope.produtos_choosen[i].seguro);
			}
			$.each(rounder,function() {
			    total += (this * 1);
			}); 			
			if (total != $scope.totalseguro)
			{
				dif = ($scope.totalseguro - total).toFixed(2);
				$scope.produtos_choosen[$scope.produtos_choosen.length-1].seguro = (($scope.produtos_choosen[$scope.produtos_choosen.length-1].seguro * 1) + (dif * 1)).toFixed(2);
			}
		}

		ratio = 0;
		total = 0;
		dif = 0;
		rounder = [];

		if($scope.totaloutros != auxoutros)
		{
			for(i = 0; i < $scope.produtos_choosen.length; i++)
			{
				ratio = ($scope.produtos_choosen[i].preco * $scope.produtos_choosen[i].qtde) / $scope.totalpreco;
				$scope.produtos_choosen[i].outros = ($scope.totaloutros * ratio).toFixed(2);
				rounder.push($scope.produtos_choosen[i].outros);
			}
			$.each(rounder,function() {
			    total += (this * 1);
			}); 			
			if (total != $scope.totaloutros)
			{
				dif = ($scope.totaloutros - total).toFixed(2);
				$scope.produtos_choosen[$scope.produtos_choosen.length-1].outros = (($scope.produtos_choosen[$scope.produtos_choosen.length-1].outros * 1) + (dif * 1)).toFixed(2);
			}
		}

		$scope.setTotal();
	}

	//modifica o label da tela produtos
	$scope.changelbl = function()
	{
		if($scope.lbl == 'Expandir')
		{
			$scope.lbl = 'Retrair';
		}else
		{
			$scope.lbl = 'Expandir';
		}
	}

	// verifica se um dos valores nao esta definido para casos de produtos novos
	$scope.verifyUndefined = function()
	{
		if($scope.produto_selected.wasIpiEdited == undefined)
		{
			$scope.produto_selected.wasIpiEdited = false;
		}
		if($scope.produto_selected.wasIcmsEdited == undefined)
		{
			$scope.produto_selected.wasIcmsEdited = false;
		}
		if($scope.produto_selected.wasIcmsstEdited == undefined)
		{
			$scope.produto_selected.wasIcmsstEdited = false;
		}
		//IPI
		if($scope.produto_selected.calcFreteIpi == undefined)
		{
			$scope.produto_selected.calcFreteIpi = 1;
		}
		if($scope.produto_selected.calcDescontoIpi == undefined)
		{
			$scope.produto_selected.calcDescontoIpi = 1;
		}
		if($scope.produto_selected.calcSeguroIpi == undefined)
		{
			$scope.produto_selected.calcSeguroIpi = 1;
		}
		if($scope.produto_selected.calcOutrosIpi == undefined)
		{
			$scope.produto_selected.calcOutrosIpi = 1;
		}
		if($scope.produto_selected.valoripi == undefined)
		{
			$scope.produto_selected.valoripi = 0;
		}
		//ICMS
		if($scope.produto_selected.valoricms == undefined)
		{
			$scope.produto_selected.valoricms = 0;
		}
		if($scope.produto_selected.calcIpiIcms == undefined)
		{
			$scope.produto_selected.calcIpiIcms = 1;
		}
		if($scope.produto_selected.calcFreteIcms == undefined)
		{
			$scope.produto_selected.calcFreteIcms = 1;
		}
		if($scope.produto_selected.calcDescontoIcms == undefined)
		{
			$scope.produto_selected.calcDescontoIcms = 1;
		}
		if($scope.produto_selected.calcSeguroIcms == undefined)
		{
			$scope.produto_selected.calcSeguroIcms = 1;
		}
		if( $scope.produto_selected.calcOutrosIcms== undefined)
		{
			$scope.produto_selected.calcOutrosIcms = 1;
		}
		//ICMSST
		if($scope.produto_selected.valoricmsst == undefined)
		{
			$scope.produto_selected.valoricmsst = 0;
		}
		if($scope.produto_selected.calcIpiIcmsst == undefined)
		{
			$scope.produto_selected.calcIpiIcmsst = 1;
		}
		if($scope.produto_selected.calcFreteIcmsst == undefined)
		{
			$scope.produto_selected.calcFreteIcmsst = 1;
		}
		if($scope.produto_selected.calcDescontoIcmsst == undefined)
		{
			$scope.produto_selected.calcDescontoIcmsst = 1;
		}
		if($scope.produto_selected.calcSeguroIcmsst == undefined)
		{
			$scope.produto_selected.calcSeguroIcmsst = 1;
		}
		if( $scope.produto_selected.calcOutrosIcmsst == undefined)
		{
			$scope.produto_selected.calcOutrosIcmsst = 1;
		}
	}

	/* END ANGULAR FUNCTIONS */

	//pula para prox input caso teclado enter
	$(':input').keydown(function (e) 
	{
    	if (e.which === 13) {
         	var index = $(':input').index(this) + 1;
         	$(':input').eq(index).focus();
     	}
 	}); 		

	function isNumeric(num)
	{
    	return !isNaN(num)
	}

 	$(document).ready(function() 
 	{
 		//seta data para hoje
		if($scope.data.data == "")
		{
			 $('#datepicker').datepicker('setDate', 'today');
		}

		//informações dentro da row dos produtos
		function format (d)  {
		    // `d` is the original data object for the row
		    return '<div class="col-md-5">' + 
						'<table class="table table-hover"  border="0">'+
							'<tr>'+
				    	        '<td><b>Frete:</b></td>'+
				    	        '<td><b>Seguro:</b></td>'+
					            '<td><b>Outros:</b></td>'+
					            '<td><b>Desconto:</b></td>'+
					        '</tr>'+
					        '<tr>'+
					        	'<td style="color: blue;">'+ '+ ' +  d[2] +'</td>'+
					            '<td style="color: blue;">'+ '+ ' + d[4] +'</td>'+
					        	'<td style="color: blue;">'+ '+ ' + d[5] +'</td>'+
					            '<td style="color: red;">'+ '- ' + d[3] +'</td>'+
					        '</tr>'+
					   	'</table>'+
			    	'</div>'
		}

		//datatable
	 	var table = $('#produtos').DataTable({
	 		  "bSort" : false,
	 		  "iDisplayLength": 100,
	 	});

    	//funcao para verificacao de mostrar ou nao os detalhes do produto
	 	$('#produtos tbody').on('click', 'td.details-control', function () {
	        var tr = $(this).closest('tr');
	        var row = table.row( tr );
	        if (row.child.isShown()) {
	            // This row is already open - close it
	            row.child.hide();
	            tr.removeClass('shown');
	        }
	        else 
	        {
	            row.child( format(row.data()) ).show();
	            tr.addClass('shown');
	        }
	    });
});

}]);