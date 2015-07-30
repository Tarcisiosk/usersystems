myApp.controller('ProdutoCtrl', ['$scope', function($scope)
{
	$scope.data = [];
	$scope.mensagens = [];				
	$scope.grupo_opts = [];
	$scope.subgrupo_opts = [];
	$scope.unidade_opts = [];
	$scope.classfisc_opts = [];			
	$scope.empresas_total = [];
	$scope.piscofinscsts = JSON.parse($('#EditingObjId').attr("pis"));
	$scope.ipicsts = JSON.parse($('#EditingObjId').attr("ipi"));
	$scope.empresa_atual = $('#EditingObjId').attr("empresa_atual");
	$scope.modalidadebcicmssts = JSON.parse($('#EditingObjId').attr("modalidade"));
	$scope.icmsproduto = JSON.parse($('#EditingObjId').attr("icmsproduto"));
	$scope.estados = JSON.parse($('#EditingObjId').attr("estados"));
	$scope.icmsCFAtual = {};

	$scope.getData = function() 
	{
		$.ajax({
			async:false,
			method: 'get',
			url: '/produtos/get_json',
			success: function(data)
			{
				$scope.data = data;
			}
		});
		console.log($scope.data);

	}

	$scope.getEmpresas = function() 
	{
		$.ajax({
			async:false,
			method: 'get',
			url: '/produtos/get_empresa',
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
	
	$scope.getUnidades = function()
	{
		$.ajax({
			async: false,
			method: 'get',
			url: '/produtos/uniempresa/',
			data: { empresas: $scope.data.empresas },	
			success: function(data)
			{
				$scope.unidade_opts = data;
				if($scope.unidade_opts.length > 0)
				{
					if ($scope.data.unidade == null){
						$scope.data.unidade = $scope.unidade_opts[0].descricao;
					}
				}

			}
		});
	}

	$scope.getGrupos = function()
	{
		$.ajax({
			async: false,
			method: 'get',
			url: '/produtos/empresagrupo/',
			data: { empresas: $scope.data.empresas },	
			success: function(data)
			{
				$scope.grupo_opts = data;
				if($scope.grupo_opts.length > 0)
				{
					$scope.data.grupo_id = $scope.grupo_opts[0].id;
				}
				$scope.getSubGrupos();

			}
		});
		console.log($scope.data);

	}
	
	$scope.getSubGrupos = function()
	{
		$.ajax({
			async: false,
			method: 'get',
			url: '/produtos/subgrupogrupo/',
			data: { gid: $scope.data.grupo_id },
			success: function(data)
			{
				$scope.subgrupo_opts = data;
				if ($scope.subgrupo_opts.length > 0)
				{
					$scope.data.subgrupo_id = $scope.subgrupo_opts[0].id;
				}
			}
		});
		console.log($scope.data);

	}

	$scope.getClassFisc = function()
	{
		$.ajax({
			async: false,
			method: 'get',
			url: '/produtos/get_class/',
			success: function(data)
			{
				$scope.classfisc_opts = data;
			}
		});
	}

	$scope.getUnidades();
	$scope.getGrupos();
	$scope.getSubGrupos();
	$scope.getClassFisc();
	$scope.save = function() 
	{   	
		Metronic.startPageLoading({animate: true});

		var request;
		request = $.ajax({
			async: false,
			method: 'post',
			url: '/produtos/save_angular/' +  $('#EditingObjId').attr("data"),
			data: { data: $scope.data, icmsproduto: JSON.stringify($scope.icmsproduto) },
			success: function(data)
			{
				window.location.replace('/produtos');
					Metronic.stopPageLoading();
			},
			error: function (jqXHR, textStatus, errorThrown)
			{      			     			
				$scope.mensagens = JSON.parse(jqXHR.responseText);
				Metronic.stopPageLoading();
				}
		});
	}

	$scope.setImage = function()
	{
		console.log($scope.data);
	}


	$scope.getValue = function(event, index) 
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
				//$("#grupoDrop").val($scope.data.grupo_id.toString()).trigger("change");

	}

	if($scope.data.descricao == '')
	{
		if($scope.grupo_opts.length > 0)
		{
			$scope.data.grupo_id = $scope.grupo_opts[0].id;
		}
		if ($scope.subgrupo_opts.length > 0)
		{
			$scope.data.subgrupo_id = $scope.subgrupo_opts[0].id;
		}
	}

	$('#pictureInput').on('change', function(event) {
		var files = event.target.files;
		var image = files[0]
		var reader = new FileReader();
		reader.onload = function(file) {
			var img = new Image();
			//console.log(file);
			img.src = file.target.result;
			$('#target').html(img);
		}
		reader.readAsDataURL(image);
	});

	$scope.indexIcmsCFPorEstado = function(id){			
		for(var index=0;index < $scope.icmsproduto.length;index++){
			if($scope.icmsproduto[index].estado_id == id){
				return index;
			}
		}						
		return -1;
	}

	$scope.estadoPorId = function(id){
		for(var index=0;index < $scope.estados.length;index++){
			if($scope.estados[index].id == id){
				return $scope.estados[index];
			}
		}
		return "";
	}

	$scope.modalidadebcicmsstPorId = function(id){
		for(var index=0;index < $scope.modalidadebcicmssts.length;index++){
			if($scope.modalidadebcicmssts[index].id == id){
				return $scope.modalidadebcicmssts[index];
			}
		}
		return "";
	}
		
	$scope.clickIcmsst = function(event){
		$scope.icmsproduto[$scope.indexIcmsCF].icmsst = event.target.checked;
		if(event.target.checked == false){
			$scope.icmsproduto[$scope.indexIcmsCF].modalidadebcicmsst_id = '';
			$scope.icmsproduto[$scope.indexIcmsCF].mva = '';
			$('span', $('#uniform-reducaomva')).removeClass("checked");
			$('#reducaomva').removeAttr("checked");
		}		
	}

	$scope.clickReducaomva = function(event){
		$scope.icmsproduto[$scope.indexIcmsCF].reducaomva = event.target.checked;
	}

	$scope.setIcmsCF = function(id){			
		$scope.indexIcmsCF = $scope.indexIcmsCFPorEstado(id);
		angular.copy($scope.icmsproduto[$scope.indexIcmsCF],$scope.icmsCFAtual);					
		if($scope.icmsproduto[$scope.indexIcmsCF].icmsst == false){
			$('span', $('#uniform-icmsst')).removeClass("checked");
			$('#icmsst').removeAttr("checked");
		}else{
			$('span', $('#uniform-icmsst')).addClass("checked");
			$('#icmsst').attr("checked");
		}
		if($scope.icmsproduto[$scope.indexIcmsCF].reducaomva == false){
			$('span', $('#uniform-reducaomva')).removeClass("checked");
			$('#reducaomva').removeAttr("checked");
		}else{
			$('span', $('#uniform-reducaomva')).addClass("checked");
			$('#reducaomva').attr("checked");
		}													
	}

	$scope.limparMensagensIcms = function(){
		$scope.mensagensIcms = [];
	}

	$scope.cleanIcms = function(){		
		angular.copy($scope.icmsCFAtual,$scope.icmsproduto[$scope.indexIcmsCF]);		
	}


	$scope.setIcmsCF = function(id){			
		$scope.indexIcmsCF = $scope.indexIcmsCFPorEstado(id);
		angular.copy($scope.icmsproduto[$scope.indexIcmsCF],$scope.icmsCFAtual);					
		if($scope.icmsproduto[$scope.indexIcmsCF].icmsst == false){
			$('span', $('#uniform-icmsst')).removeClass("checked");
			$('#icmsst').removeAttr("checked");
		}else{
			$('span', $('#uniform-icmsst')).addClass("checked");
			$('#icmsst').attr("checked");
		}
		if($scope.icmsproduto[$scope.indexIcmsCF].reducaomva == false){
			$('span', $('#uniform-reducaomva')).removeClass("checked");
			$('#reducaomva').removeAttr("checked");
		}else{
			$('span', $('#uniform-reducaomva')).addClass("checked");
			$('#reducaomva').attr("checked");
		}													
	}

	$scope.limparMensagensIcms = function(){
		$scope.mensagensIcms = [];
	}

	$scope.cleanIcms = function(){		
		angular.copy($scope.icmsCFAtual,$scope.icmsproduto[$scope.indexIcmsCF]);		
	}

	$scope.saveIcms = function(){
		$.ajax({
			async: false, 
			method: 'post',
			url: '/produtos/saveIcms/',
			data: {icmsproduto: $scope.icmsproduto[$scope.indexIcmsCF]},
			success: function(data){
				$('#popupIcms').modal('toggle');
				$scope.limparMensagensIcms();
			},
			error: function(jqXHR, textStatus, errorThrown){
				$scope.mensagensIcms = JSON.parse(jqXHR.responseText);
			}
		});		
	}		
	$("[name='money']").maskMoney({ allowNegative: false, thousands:'', decimal:'.', affixesStay: false});

}]);