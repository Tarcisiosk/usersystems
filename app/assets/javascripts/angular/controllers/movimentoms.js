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
	$scope.totalicms = 0
	$scope.icmsProdutoSelected = ''; 

	$scope.basecalculo = 0;
	$scope.empresa_atual = JSON.parse($('#EditingObjId').attr("empresa_atual"));
	$scope.estado_atual = $scope.empresa_atual.uf;
	$scope.ipicsts = JSON.parse($('#EditingObjId').attr("ipi"));
	$scope.icmscsts = JSON.parse($('#EditingObjId').attr("icms"));
	$scope.modalidadebcicmssts = JSON.parse($('#EditingObjId').attr("modalidade"));

	

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
				$scope.data.entidade_id = data[0].id;
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
				$scope.produto_selected.icms_aliquota = $scope.icmsProdutoSelected.aliquota;

			},
			error: function()
			{      			     			
				alert('ué');
			}
		});
	}

	$scope.getIcms = function(id_produto)
	{
		$.ajax({
			async:false,
			method: 'get',
			url: '/movimentoms/get_icms/' + id_produto,
			data: {"uf" : $scope.estado_atual},
			dataType: 'json',
			success: function(data)
			{
				$scope.icmsProdutoSelected = data[0];
			},
			error: function()
			{      			     			
				alert('ué');
			}
		});	
	}

	$scope.getData();	
	$scope.getEntidades();

	$scope.setEdited = function(i)
	{
		
		if($scope.produto_selected.wasIpiEdited == undefined)
		{
			$scope.produto_selected.wasIpiEdited = false;
		}
		if($scope.produto_selected.wasIcmsEdited == undefined)
		{
			$scope.produto_selected.wasIcmsEdited = false;
		}
		//ipi
		if(i == 0)
		{
			if($scope.produto_selected.wasIpiEdited == false)
			{
				$scope.produto_selected.wasIpiEdited = true;
			}
					console.log($scope.produto_selected.wasIpiEdited);

			// else
			// {
			// 	$scope.produto_selected.wasIpiEdited == false;
			// }
		}
		//icms
		else if(i == 1)
		{
			if($scope.produto_selected.wasIcmsEdited == false)
			{
				$scope.produto_selected.wasIcmsEdited = true;
			}
					console.log($scope.produto_selected.wasIcmsEdited);

			// else
			// {
			// 	$scope.produto_selected.wasIcmsEdited == false;
			// }
		}
	}
	
	$scope.calcBcIpi = function()
	{
		$scope.produto_selected.basecalculoIpi = ($scope.produto_selected.preco * $scope.produto_selected.qtde) + 
														 ($scope.produto_selected.frete * $scope.produto_selected.calcFreteIpi) + 
														 ($scope.produto_selected.seguro * $scope.produto_selected.calcSeguroIpi) + 
														 ($scope.produto_selected.outros * $scope.produto_selected.calcOutrosIpi) - 
														 ($scope.produto_selected.desconto * $scope.produto_selected.calcDescontoIpi);

		$scope.produto_selected.valoripi = $scope.produto_selected.basecalculoIpi * ($scope.produto_selected.ipi_aliquota/100).toFixed(2);
	}

	$scope.setIpi = function()
	{
		var auxbc = $scope.produto_selected.basecalculoIpi;

		if($scope.produto_selected.wasIpiEdited == undefined)
		{
			$scope.produto_selected.wasIpiEdited = false;
		}
		if($scope.produto_selected.wasIcmsEdited == undefined)
		{
			$scope.produto_selected.wasIcmsEdited = false;
		}
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

		if(!$scope.produto_selected.wasIpiEdited)
		{
			if( $scope.produto_selected.ipi_cst_id == 8 )
			{
				$scope.produto_selected.basecalculoIpi = ($scope.produto_selected.preco * $scope.produto_selected.qtde) + 
														 ($scope.produto_selected.frete * $scope.produto_selected.calcFreteIpi) + 
														 ($scope.produto_selected.seguro * $scope.produto_selected.calcSeguroIpi) + 
														 ($scope.produto_selected.outros * $scope.produto_selected.calcOutrosIpi) - 
														 ($scope.produto_selected.desconto * $scope.produto_selected.calcDescontoIpi);

				$scope.produto_selected.valoripi = $scope.produto_selected.basecalculoIpi * ($scope.produto_selected.ipi_aliquota/100).toFixed(2);		
			}
			//saida tributada com aliquota zero
			if( $scope.produto_selected.ipi_cst_id == 9)
			{
				$scope.produto_selected.basecalculoIpi = ($scope.produto_selected.preco * $scope.produto_selected.qtde) + 
														 ($scope.produto_selected.frete * $scope.produto_selected.calcFreteIpi) + 
														 ($scope.produto_selected.seguro * $scope.produto_selected.calcSeguroIpi) + 
														 ($scope.produto_selected.outros * $scope.produto_selected.calcOutrosIpi) - 
														 ($scope.produto_selected.desconto * $scope.produto_selected.calcDescontoIpi);

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
			}
		}
		

		if($scope.produto_selected.basecalculoIpi != auxbc)
		{
			$("[name='alt']").effect( "pulsate", {times:1}, 100 );
		}
	}

	$scope.calcBcIcms = function()
	{
		$scope.produto_selected.basecalculoIcms = ($scope.produto_selected.preco * $scope.produto_selected.qtde) + 
														  ($scope.produto_selected.frete * $scope.produto_selected.calcFreteIcms) + 
														  ($scope.produto_selected.valoripi * $scope.produto_selected.calcIpiIcms) + 
														  ($scope.produto_selected.seguro * $scope.produto_selected.calcSeguroIcms) + 
														  ($scope.produto_selected.outros * $scope.produto_selected.calcOutrosIcms) - 
														  ($scope.produto_selected.desconto * $scope.produto_selected.calcDescontoIcms);
	}

	$scope.setIcms = function()
	{
		var auxbcicms = $scope.produto_selected.basecalculoIcms;
	
		if($scope.produto_selected.wasIpiEdited == undefined)
		{
			$scope.produto_selected.wasIpiEdited = false;
		}
		if($scope.produto_selected.wasIcmsEdited == undefined)
		{
			$scope.produto_selected.wasIcmsEdited = false;
		}
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
					}
				}
				else
				{
					//30
					if($scope.icmsProdutoSelected.icmsst == true)
					{
						$scope.produto_selected.icms_cst_id = 4;
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
			if( $scope.produto_selected.icms_cst_id == 1 )
			{
				$scope.produto_selected.basecalculoIcms = ($scope.produto_selected.preco * $scope.produto_selected.qtde) + 
														  ($scope.produto_selected.frete * $scope.produto_selected.calcFreteIcms) + 
														  ($scope.produto_selected.valoripi * $scope.produto_selected.calcIpiIcms) + 
														  ($scope.produto_selected.seguro * $scope.produto_selected.calcSeguroIcms) + 
														  ($scope.produto_selected.outros * $scope.produto_selected.calcOutrosIcms) - 
														  ($scope.produto_selected.desconto * $scope.produto_selected.calcDescontoIcms);
				
				if($scope.produto_selected.icms_aliquota == undefined)
				{
					$scope.produto_selected.icms_aliquota = $scope.icmsProdutoSelected.aliquota;
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
				$scope.produto_selected.basecalculoIcms = ($scope.produto_selected.preco * $scope.produto_selected.qtde) + 
														  ($scope.produto_selected.frete * $scope.produto_selected.calcFreteIcms) + 
														  ($scope.produto_selected.valoripi * $scope.produto_selected.calcIpiIcms) + 
														  ($scope.produto_selected.seguro * $scope.produto_selected.calcSeguroIcms) + 
														  ($scope.produto_selected.outros * $scope.produto_selected.calcOutrosIcms) - 
														  ($scope.produto_selected.desconto * $scope.produto_selected.calcDescontoIcms);
				
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
		$scope.produto_selected = []


		setTimeout(function(){
  				$scope.$broadcast('setFocus');
        }, 500);
	   
	}

	$scope.setProdutoSelected = function(item)
	{
		$scope.produto_selected = item;
	}

	$scope.NextField = function()
	{
		setTimeout(function(){
           $("#qtde").focus();
        }, 2);
        $scope.setIpi();
	}

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
	
	$scope.edit_produto = function(index)
	{

		$scope.isEditing = true;
		$scope.produto_selected = $scope.produtos_choosen[index];
		auxproduto = JSON.parse($scope.data.produtos_list)[index]; 
		auxindex = index;
	}

	$scope.saveProduto = function(produto)
	{
		if($scope.isEditing == true)
		{
			$scope.produtos_choosen[auxindex] = produto;
		}
		$scope.endEdit();
	}

	$scope.cancelEdit = function()
	{		
		if($scope.isEditing == true)
		{
			$scope.produtos_choosen[auxindex] = auxproduto;
		}
		
		$scope.endEdit();
	}

	$scope.endEdit = function()
	{
		auxproduto = [];
		auxindex = 0;
		// $scope.setIpi();
		// $scope.setIcms();
		$scope.setTotal();
		$scope.isEditing = false;

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

	$scope.preCalcRatio = function()
	{
		auxfrete = $scope.totalfrete;
		auxdesconto = $scope.totaldesconto;
		auxseguro = $scope.totalseguro;
		auxoutros = $scope.totaloutros;
	}

	$scope.cancelRatio = function()
	{
		$scope.totalfrete = auxfrete;
		$scope.totaldesconto = auxdesconto;
		$scope.totalseguro = auxseguro;
		$scope.totaloutros = auxoutros; 
	}

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

	$(':input').keydown(function (e) {
    	if (e.which === 13) {
         	var index = $(':input').index(this) + 1;
         	$(':input').eq(index).focus();
     	}
 	}); 		

	


 	$(document).ready(function() {
 	
		if($scope.data.data == "")
		{
			 $('#datepicker').datepicker('setDate', 'today');
		}

		function format (d)  {
		    // `d` is the original data object for the row
		    return '<div class="col-md-8">' + 
						'<table  class="table table-hover"  class="display" border="0" style="padding-left:200px;">'+
							'<tr>'+
				    	        '<td><b>Frete:</b></td>'+
					            '<td align="right">'+ d[2] +'</td>'+
					        '</tr>'+
					        '<tr>'+
					            '<td><b>Seguro:</b></td>'+
					            '<td align="right">'+ d[4] +'</td>'+
					        '</tr>'+
					        '<tr>'+
					            '<td><b>Outros:</b></td>'+
					            '<td align="right">'+ d[5] +'</td>'+
					        '</tr>'+
					        '<tr>'+
					            '<td><b>Desconto:</b></td>'+
					            '<td align="right">'+ d[3] +'</td>'+
					        '</tr>'+
					   	'</table>'+
			    	'</div>'
		}

	 	var table = $('#produtos').DataTable({
	 		  "bSort" : false,
	 	});
    
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