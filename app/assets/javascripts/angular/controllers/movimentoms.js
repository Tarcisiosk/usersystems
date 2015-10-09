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
	$scope.icmssupersimples = JSON.parse($('#EditingObjId').attr("icmsss"));
	$scope.modalidadebcicmssts = JSON.parse($('#EditingObjId').attr("modalidade"));
	$scope.piscofinscst = JSON.parse($('#EditingObjId').attr("piscofinscst"));
	$scope.tipomovimentacao = JSON.parse($('#EditingObjId').attr("tipomov"));
	$scope.valormva = 0;
	$scope.isDisabled = false;
	$scope.isNew = true;

	//dados gerais
	$scope.getData = function() 
	{
		$.ajax({
			async:false,
			method: 'post',
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
			method: 'post',
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
			method: 'post',
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
			method: 'post',
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
			method: 'post',
			url: '/movimentoms/get_icmsinterestadual/' ,
			data: {"or" : origem, "dest" : destino },
			dataType: 'json',
			success: function(data)
			{
				if(data[0] != undefined)
				{
					$scope.aliqInterEstadual = data[0].icms;
				}
				else
				{
					$scope.aliqInterEstadual = 0;
				}
			},
			error: function()
			{
				alert('ué');
			}
		});	
	}

	//pega aliq da empresa caso esteja marcado buscar da empresa.
	$scope.getAliqPisCofins = function(id_produto)
	{
		$.ajax({
			async: false,
			method: 'post',
			url: '/movimentoms/get_piscofins/' + id_produto,
			dataType: 'json',
			success: function(data)
			{
				$scope.produto_selected.pis_aliquota = data[0];
				$scope.produto_selected.cofins_aliquota = data[1];
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
				var tpm = $('#EditingObjId').attr("id_tipo");
				window.location.replace('/movimentoms/' + tpm);
			},
			error: function (jqXHR, textStatus, errorThrown)
			{
				$scope.mensagens = JSON.parse(jqXHR.responseText);
			}
		});
	}

	$scope.setNew = function()
	{
		$scope.isNew = true;
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

	//verifica se icms deve ser calculado pelo valor interestadual
	$scope.verifyInter = function()
	{
		// console.log("Estado cliente: " + $scope.icmsEntidadeSelected.estado_id);
		// console.log("Estado empresa: " +  $scope.icmsProdutoSelected.estado_id);
		if($scope.icmsEntidadeSelected.estado_id != $scope.icmsProdutoSelected.estado_id && !$scope.data.consumidor_final)
		{
			$scope.interEstadual = true;
			console.log("Essa é interestadual");

			if($scope.tipomovimentacao.tipo == 'Entrada')
			{
				console.log("e é uma entrada");
				console.log("Estado empresa: " +  $scope.icmsProdutoSelected.estado_id);
				console.log("Estado fornecedor: " + $scope.icmsEntidadeSelected.estado_id);
				$scope.getIcmsInterEstadual($scope.icmsEntidadeSelected.estado_id, $scope.icmsProdutoSelected.estado_id);
			}
			else
			{
				console.log("mas nao é uma entrada");
				console.log("Estado empresa: " + $scope.icmsProdutoSelected.estado_id);
				console.log("Estado cliente: " +  $scope.icmsEntidadeSelected.estado_id);
				$scope.getIcmsInterEstadual($scope.icmsProdutoSelected.estado_id, $scope.icmsEntidadeSelected.estado_id);
			}
		}
		else
		{
			$scope.interEstadual = false;
		}
	}

	//seta se a informação foi editada para nao recalcular.
	$scope.setEdited = function(i, val)
	{
		$scope.verifyUndefined();
		//ipi
		if(i == 0)
		{
			$scope.produto_selected.wasIpiEdited = val;
		}
		//icms
		else if(i == 1)
		{
			$scope.produto_selected.wasIcmsEdited = val;
		}
		//icmsst
		else if(i == 2)
		{
			$scope.produto_selected.wasIcmsstEdited = val;
		}
		//pis cofins
		else if(i == 3)
		{
			$scope.produto_selected.wasPisCofinstEdited = val;
		}
	}

	//calcula base de calculo IPI
	$scope.calcBcIpi = function()
	{
		if(!$scope.produto_selected.wasIpiEdited)
		{
			$scope.produto_selected.basecalculoIpi = ($scope.produto_selected.preco * $scope.produto_selected.qtde) + 
												 ($scope.produto_selected.frete * $scope.produto_selected.calcFreteIpi) + 
												 ($scope.produto_selected.seguro * $scope.produto_selected.calcSeguroIpi) + 
												 ($scope.produto_selected.outros * $scope.produto_selected.calcOutrosIpi) - 
												 ($scope.produto_selected.desconto * $scope.produto_selected.calcDescontoIpi);
		}
		$scope.produto_selected.valoripi = $scope.produto_selected.basecalculoIpi * ($scope.produto_selected.ipi_aliquota/100).toFixed(2);
	}

	//seta os valores do IPI
	$scope.setIpi = function()
	{	
		var auxbc = $scope.produto_selected.basecalculoIpi;

		//$scope.produto_selected.ipi_aliquota = $scope.icmsProdutoSelected.ipi_aliquota;
		//$scope.produto_selected.ipi_cst_id = $scope.icmsProdutoSelected.ipi_cst_id;

		$scope.verifyUndefined();
		if( $scope.produto_selected.ipi_cst_id == 8 )
		{
			$scope.calcBcIpi();
		}
		//outras saidas...
		if( $scope.produto_selected.ipi_cst_id != 8 || $scope.produto_selected.industrializado == false)
		{
			$scope.produto_selected.ipi_aliquota = 0;
			$scope.produto_selected.valoripi = 0;
			$scope.produto_selected.basecalculoIpi = 0;
		}
		if($scope.produto_selected.basecalculoIpi != auxbc)
		{
			$("[name='alt']").effect( "pulsate", {times:1}, 100 );
		}
	}
	
	//calcula base de calculo do ICMS
	$scope.calcBcIcms = function()
	{
		if(!$scope.produto_selected.wasIcmsEdited)
		{
			$scope.produto_selected.basecalculoIcms = ($scope.produto_selected.preco * $scope.produto_selected.qtde) + 
													  ($scope.produto_selected.frete * $scope.produto_selected.calcFreteIcms) + 
													  ($scope.produto_selected.valoripi * $scope.produto_selected.calcIpiIcms) + 
													  ($scope.produto_selected.seguro * $scope.produto_selected.calcSeguroIcms) + 
													  ($scope.produto_selected.outros * $scope.produto_selected.calcOutrosIcms) - 
													  ($scope.produto_selected.desconto * $scope.produto_selected.calcDescontoIcms);
		}
		
		$scope.produto_selected.valoricms = $scope.produto_selected.basecalculoIcms * ($scope.produto_selected.icms_aliquota/100).toFixed(2);

		if($scope.produto_selected.icms_cst_id == 3 || $scope.produto_selected.icms_cst_id == 10 || $scope.produto_selected.icms_cst_id == 11 || ($scope.empresa_atual.supersimples && $scope.produto_selected.icms_cst_id == 9))
		{
			if($scope.produto_selected.reducaobc == undefined)
			{
				$scope.produto_selected.reducaobc = $scope.icmsProdutoSelected.reducaobasecalculo;
			}
			var red = $scope.produto_selected.basecalculoIcms * ($scope.produto_selected.reducaobc/100);
			$scope.produto_selected.valoricms = ($scope.produto_selected.basecalculoIcms - red) * ($scope.produto_selected.icms_aliquota/100).toFixed(2);
			
			if($scope.produto_selected.valoricms < 0)
			{
				$scope.produto_selected.valoricms = 0;
			}
		}
		//com diferimento
		if( $scope.produto_selected.icms_cst_id == 8)
		{
			if($scope.produto_selected.diferimento == undefined)
			{
				$scope.produto_selected.diferimento = $scope.icmsProdutoSelected.diferimento;
			}
			$scope.produto_selected.valoricmsdiferido = ($scope.produto_selected.valoricms * ($scope.produto_selected.diferimento/100));
			
			if($scope.produto_selected.valoricmsdiferido < 0)
			{
				$scope.produto_selected.valoricmsdiferido = 0;
			}
		}
	}

	//seta os valores ICMS
	$scope.setIcms = function()
	{
		var auxbcicms = $scope.produto_selected.basecalculoIcms;
		$scope.verifyUndefined();
		//para puxar o icms :)
		if($scope.isEditing == false && $scope.isNew)
		{
			if($scope.icmsProdutoSelected.aliquota > 0)
			{	
				//00 - Trib. Integralmente
				if($scope.icmsProdutoSelected.reducaobasecalculo == 0 && $scope.icmsProdutoSelected.diferimento == 0  && $scope.icmsProdutoSelected.icmsst == false)
				{
					$scope.produto_selected.icms_cst_id = 1;
				}
				//51 - Com diferimento
				else if($scope.icmsProdutoSelected.reducaobasecalculo == 0 && $scope.icmsProdutoSelected.diferimento > 0  && $scope.icmsProdutoSelected.icmsst == false)
				{
					$scope.produto_selected.icms_cst_id = 8;
				}
				//10 - Trib. Icmsst
				else if($scope.icmsProdutoSelected.reducaobasecalculo == 0  && $scope.icmsProdutoSelected.icmsst == true)
				{
					$scope.produto_selected.icms_cst_id = 2;
					$scope.setIcmsst();
					$scope.calcBcIcmsst();
				}
				//20 - Com Red. BC
				else if($scope.icmsProdutoSelected.reducaobasecalculo > 0  && $scope.icmsProdutoSelected.icmsst == false)
				{
					$scope.produto_selected.icms_cst_id = 3;
				}
				//70 - Com Red. BC Icmsst
				else if($scope.icmsProdutoSelected.reducaobasecalculo > 0  && $scope.icmsProdutoSelected.icmsst == true)
				{
					$scope.produto_selected.icms_cst_id = 10;
					$scope.setIcmsst();
					$scope.calcBcIcmsst();
				}
				$scope.aliqPelaOrigem();
			}
			else
			{
				//30 - Isenta/ou nao trib. Icmsst
				if($scope.icmsProdutoSelected.icmsst == true)
				{
					$scope.produto_selected.icms_cst_id = 4;
					$scope.setIcmsst();
					$scope.calcBcIcmsst();
				}
				//40 - Isenta
				else if($scope.icmsProdutoSelected.icmsst == false)
				{
					$scope.produto_selected.icms_cst_id = 5;
				}
			}
			if($scope.empresa_atual.supersimples)
			{
				if($scope.produto_selected.icms_cst_id == 1 || $scope.produto_selected.icms_cst_id == 3 || $scope.produto_selected.icms_cst_id == 8)
				{
					$scope.produto_selected.icms_cst_id = 1;
				}
				else if($scope.produto_selected.icms_cst_id == 2 || $scope.produto_selected.icms_cst_id == 4 || $scope.produto_selected.icms_cst_id == 10)
				{
					$scope.produto_selected.icms_cst_id == 4;
				}
				else if($scope.produto_selected.icms_cst_id == 9)
				{
					$scope.produto_selected.icms_cst_id == 8;
				}
				else if($scope.produto_selected.icms_cst_id == 6)
				{
					$scope.produto_selected.icms_cst_id == 6;
				}
				else if($scope.produto_selected.icms_cst_id == 5 || $scope.produto_selected.icms_cst_id == 7)
				{
					$scope.produto_selected.icms_cst_id == 7;
				}
			}
			$scope.isNew = false;
		}

		//tributado integralmente - 00/10/20/51/70/90
		if( $scope.produto_selected.icms_cst_id == 1 || $scope.produto_selected.icms_cst_id == 2 ||
			$scope.produto_selected.icms_cst_id == 3 || $scope.produto_selected.icms_cst_id == 8 ||
			$scope.produto_selected.icms_cst_id == 10 || $scope.produto_selected.icms_cst_id == 11 || ($scope.produto_selected.icms_cst_id == 9 && $scope.empresa_atual.supersimples == true))
		{
			if($scope.produto_selected.icms_aliquota == undefined)
			{
				$scope.produto_selected.icms_aliquota = $scope.icmsProdutoSelected.aliquota;
				if($scope.interEstadual)
				{
					$scope.produto_selected.icms_aliquota = $scope.aliqInterEstadual;
				}
			}

			$scope.aliqPelaOrigem();
	
			$scope.calcBcIcms();

		}

		//40/41/50/60
		else if ($scope.produto_selected.icms_cst_id == 5 || $scope.produto_selected.icms_cst_id == 6 ||
				 $scope.produto_selected.icms_cst_id == 7 || ($scope.produto_selected.icms_cst_id == 9 && $scope.empresa_atual.supersimples == false))
		{
			$scope.produto_selected.basecalculoIcms = 0;
			$scope.produto_selected.icms_aliquota = 0;
			$scope.produto_selected.valoricms = 0;
		}
		//30
		else
		{
			$scope.produto_selected.bcfins = $scope.produto_selected.basecalculoIcms;
			$scope.produto_selected.icms_aliquota = 0;
			$scope.produto_selected.valoricms = 0;
			$scope.produto_selected.basecalculoIcms = 0;
		}

		if($scope.empresa_atual.supersimples == true)
		{
			$scope.produto_selected.valoricms = 0;
		}

		if($scope.produto_selected.basecalculoIcms != auxbcicms)
		{
			$("[name='alticms']").effect( "pulsate", {times:1}, 500 );
		}
	}

	//calcula base de calculo ICMSST
	$scope.calcBcIcmsst = function()
	{	

		if($scope.produto_selected.reducaobcst == undefined)
		{
			$scope.produto_selected.reducaobcst = 0;
		}

		if(!$scope.produto_selected.wasIcmsstEdited)
		{
			$scope.produto_selected.icmsst_aliquota = $scope.icmsEntidadeSelected.aliquota;
			$scope.produto_selected.basecalculoIcmsst = ($scope.produto_selected.preco * $scope.produto_selected.qtde) + 
												  ($scope.produto_selected.frete * $scope.produto_selected.calcFreteIcmsst) + 
												  ($scope.produto_selected.valoripi * $scope.produto_selected.calcIpiIcmsst) + 
												  ($scope.produto_selected.seguro * $scope.produto_selected.calcSeguroIcmsst) + 
												  ($scope.produto_selected.outros * $scope.produto_selected.calcOutrosIcmsst) - 
												  ($scope.produto_selected.desconto * $scope.produto_selected.calcDescontoIcmsst);

			if($scope.icmsProdutoSelected.mva == undefined)
			{
				$scope.icmsProdutoSelected.mva = 0;
			}

			if($scope.produto_selected.reducaobcst > 0)
			{				
				var red = $scope.produto_selected.basecalculoIcmsst * ($scope.produto_selected.reducaobcst/100);
				$scope.produto_selected.basecalculoIcmsst = $scope.produto_selected.basecalculoIcmsst - red;
			}

			$scope.valormva = $scope.produto_selected.basecalculoIcmsst * ($scope.icmsProdutoSelected.mva/100);
			$scope.produto_selected.basecalculoIcmsst += $scope.valormva;
		}

		$scope.produto_selected.valoricmsst = ($scope.produto_selected.basecalculoIcmsst * $scope.produto_selected.icmsst_aliquota/100) - $scope.produto_selected.valoricms;
		
		if ($scope.produto_selected.icms_cst_id == 4 || $scope.produto_selected.icms_cst_id == 9)
		{
			if($scope.produto_selected.aliquotafins == undefined)
			{
				$scope.produto_selected.aliquotafins = $scope.icmsProdutoSelected.aliquotafinscalculo;
			}
			if($scope.produto_selected.bcfins == undefined)
			{
				$scope.produto_selected.bcfins = $scope.produto_selected.basecalculoIcms;
			}
			$scope.produto_selected.valoricmsst = ($scope.produto_selected.basecalculoIcmsst * $scope.produto_selected.icmsst_aliquota/100) - 
												  ($scope.produto_selected.bcfins * $scope.produto_selected.aliquotafins/100).toFixed(2);
		}
		if($scope.empresa_atual.supersimples)
		{
			//201, 202, 203
			if ($scope.produto_selected.icms_cst_id == 3 || $scope.produto_selected.icms_cst_id == 4 || $scope.produto_selected.icms_cst_id == 5)
			{
				$scope.produto_selected.valoricmsst = ($scope.produto_selected.basecalculoIcmsst * $scope.produto_selected.icmsst_aliquota/100) - 
													  ($scope.produto_selected.bcfins * $scope.produto_selected.aliquotafins/100).toFixed(2);
			}
		}
		if($scope.produto_selected.valoricmsst < 0)
		{
			$scope.produto_selected.valoricmsst = 0;
		}
	}

	//seta os valores ICMSST
	$scope.setIcmsst = function()
	{
		var auxbcicmsst = $scope.produto_selected.basecalculoIcmsst;
		$scope.verifyUndefined();

		//margem valor agregado mva
		if($scope.icmsProdutoSelected.modalidadebcicmsst_id == 5)
		{
			$scope.calcBcIcmsst();
		}

		if($scope.empresa_atual.supersimples)
		{
			if ($scope.produto_selected.icms_cst_id == 3 || $scope.produto_selected.icms_cst_id == 4 || $scope.produto_selected.icms_cst_id == 5)
			{
				if($scope.produto_selected.aliquotafins == undefined)
				{
					$scope.produto_selected.aliquotafins = $scope.icmsProdutoSelected.aliquotafinscalculo;
				}
				if($scope.produto_selected.bcfins == undefined)
				{
					$scope.produto_selected.bcfins = $scope.produto_selected.basecalculoIcms;
				}
				$scope.calcBcIcmsst();
			}
		}

		if($scope.produto_selected.basecalculoIcmsst != auxbcicmsst)
		{
			$("[name='alticmsst']").effect( "pulsate", {times:1}, 500 );
		}
	}

	
	//calcula o pis e cofins
	$scope.calcBcPisCofins = function()
	{
		if(!$scope.produto_selected.wasPisCofinstEdited)
		{
			$scope.produto_selected.basecalculopc = ($scope.produto_selected.preco * $scope.produto_selected.qtde) + 
												 ($scope.produto_selected.frete * $scope.produto_selected.calcFretePC) + 
												 ($scope.produto_selected.seguro * $scope.produto_selected.calcSeguroPC) + 
												 ($scope.produto_selected.outros * $scope.produto_selected.calcOutrosPC) - 
												 ($scope.produto_selected.desconto * $scope.produto_selected.calcDescontoPC);
			
			$scope.produto_selected.valorp = $scope.produto_selected.basecalculopc * ($scope.produto_selected.pis_aliquota/100);
			$scope.produto_selected.valorc = $scope.produto_selected.basecalculopc * ($scope.produto_selected.cofins_aliquota/100);
		}
	}

	//seta de acordo com a st do pis 
	$scope.setPisCofins = function()
	{
		//06 - tributavel aliq = zero 
		if($scope.produto_selected.pis_cst_id == 6)
		{
			$scope.calcBcPisCofins();
			$scope.produto_selected.pis_aliquota = 0;
			$scope.produto_selected.cofins_aliquota = 0;
			$scope.produto_selected.valorp = 0;
			$scope.produto_selected.valorc = 0;
		}
		//07 08 09 - csts inuteis que fazem a mesma coisa
		else if($scope.produto_selected.pis_cst_id == 7 || $scope.produto_selected.pis_cst_id == 8 || $scope.produto_selected.pis_cst_id == 9)
		{
			$scope.produto_selected.basecalculopc = 0;
			$scope.produto_selected.pis_aliquota = 0;
			$scope.produto_selected.cofins_aliquota = 0;
			$scope.produto_selected.valorp = 0;
			$scope.produto_selected.valorc = 0;
		}
		else
		{
			$scope.calcBcPisCofins();
		}
	}

	
	//atualiza a aliquota do icms de acordo com a origem
	$scope.aliqPelaOrigem = function()
	{
		if($scope.data.consumidor_final == false && $scope.interEstadual == true && $scope.produto_selected.origem_id != 1 && 
		  $scope.produto_selected.origem_id != 5 && $scope.produto_selected.origem_id != 6)
		{
			$scope.produto_selected.icms_aliquota = 4;
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
		setTimeout(function(){ $scope.$broadcast('setFocus');}, 500);
	}

	//seta o produto selecionado
	$scope.setProdutoSelected = function(item)
	{
		$scope.produto_selected = item;
		$scope.preSetCheckbox();
	}
	
	//pula para o prox campo
	$scope.NextField = function()
	{
		setTimeout(function(){ $("#qtde").focus(); }, 2);
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
				rounder.push($scope.produtos_choosen[i].frete);
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
		}
		else
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
		if($scope.produto_selected.calcOutrosIcms== undefined)
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
		if($scope.produto_selected.calcOutrosIcmsst == undefined)
		{
			$scope.produto_selected.calcOutrosIcmsst = 1;
		}		
		if($scope.icmsProdutoSelected == undefined)
		{
			$scope.getIcms($scope.produto_selected.id, false);
		}
		//PIS/COFINS
		if($scope.produto_selected.valorp == undefined)
		{
			$scope.produto_selected.valorp = 0;
		}
		if($scope.produto_selected.valorc == undefined)
		{
			$scope.produto_selected.valorc = 0;
		}
		if($scope.produto_selected.calcFretePC == undefined)
		{
			$scope.produto_selected.calcFretePC = 1;
		}
		if($scope.produto_selected.calcDescontoPC == undefined)
		{
			$scope.produto_selected.calcDescontoPC = 1;
		}
		if($scope.produto_selected.calcSeguroPC == undefined)
		{
			$scope.produto_selected.calcSeguroPC = 1;
		}
		if($scope.produto_selected.calcOutrosPC == undefined)
		{
			$scope.produto_selected.calcOutrosPC = 1;
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
		$scope.setCheckboxes('seguroicmsst', $scope.produto_selected.calcSeguroIcmsst);
		$scope.setCheckboxes('outrosicmsst', $scope.produto_selected.calcOutrosIcmsst);
		$scope.setCheckboxes('reducaomva', $scope.icmsProdutoSelected.reducaomva);
		$scope.setCheckboxes('fretepc', $scope.produto_selected.calcFretePC);
		$scope.setCheckboxes('descontopc', $scope.produto_selected.calcDescontoPC);
		$scope.setCheckboxes('seguropc', $scope.produto_selected.calcSeguroPC);
		$scope.setCheckboxes('outrospc', $scope.produto_selected.calcOutrosPC);
	}

	$scope.setCheckboxes = function(id, varCheck)
	{
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
				// else
				// {
				// 	$('#uniform-' + id).addClass("disabled");
				// }
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

	$scope.clearPanel = function($event)
	{
		//$('#tabs').tabs();
		//$( "#tabs" ).tabs( "option", "active", 0 );
		//$('#produto').prop('selectedIndex', 0);
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
		function format (d)  
		{
			return '<div class="col-md-5">' + 
						'<table class="table table-hover"  border="0">'+
							'<tr>'+
								'<td><b>Frete:</b></td>'+
								'<td><b>Seguro:</b></td>'+
								'<td><b>Outros:</b></td>'+
								'<td><b>Desconto:</b></td>'+
							'</tr>'+
							'<tr>'+
								'<td style="color: blue;">'+ '+ ' + $scope.produtos_choosen[d].frete + '</td>'+
								'<td style="color: blue;">'+ '+ ' + $scope.produtos_choosen[d].seguro + '</td>'+
								'<td style="color: blue;">'+ '+ ' + $scope.produtos_choosen[d].outros + '</td>'+
								'<td style="color: red;">'+ '- ' + $scope.produtos_choosen[d].desconto + '</td>'+
							'</tr>'+
						'</table>'+
					'</div>'
		}
		//datatable
		var table = $('#produtos').DataTable({
			  "bSort" : false,
			  "iDisplayLength": 100
		});

		//funcao para verificacao de mostrar ou nao os detalhes do produto
		$('#produtos tbody').on('click', 'td.details-control', function () {
			var tr = $(this).closest('tr');
			var row = table.row( tr );
			if (row.child.isShown()) 
			{
				// This row is already open - close it
				row.child.hide();
				tr.removeClass('shown');
			}
			else 
			{
				row.child( format(row.index())).show();
				tr.addClass('shown');
			}
		});
	});
}]);
