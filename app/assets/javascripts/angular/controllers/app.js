var myApp = angular.module('myApp',['ui.utils.masks', 'ngSanitize', 'ui.select']); 

//diretiva para somente numeros
myApp.directive('numbersOnly', function(){
	return { require: 'ngModel',
		link: function(scope, element, attrs, modelCtrl) {
			modelCtrl.$parsers.push(function (inputValue) {
				if (inputValue == undefined) return '' 
				var transformedInput = inputValue.replace(/[^0-9]/g, ''); 
				if (transformedInput!=inputValue)
				{
					modelCtrl.$setViewValue(transformedInput);
					modelCtrl.$render();
				}         
				return transformedInput;         
			});
		}
	};
});

//diretiva para tamanho maximo
myApp.directive('maxlength', function() {
  return {
	require: 'ngModel',
	link: function (scope, element, attrs, ngModelCtrl) {
	  var maxlength = Number(attrs.myMaxlength);
	  function fromUser(text) {
		  if (text.length > maxlength) {
			var transformedInput = text.substring(0, maxlength);
			ngModelCtrl.$setViewValue(transformedInput);
			ngModelCtrl.$render();
			return transformedInput;
		  } 
		  return text;
	  }
	  ngModelCtrl.$parsers.push(fromUser);
	}
  }; 
});

//diretiva para tamanho minimo
myApp.directive('minlength',function(){
  return {
	require: 'ngModel',
	link: function(scope,elm,attr,ngModel){

	  var minlength = 0;

	  var minLengthValidator = function(value){     
		var validity = ngModel.$isEmpty(value) || value.length >= minlength;
		ngModel.$setValidity('minlength',  validity);
		return validity ? value : undefined;
	  };

	  attr.$observe('myMinlength', function(val){
		 minlength = parseInt(val,10);
		 minLengthValidator(ngModel.$viewValue);
	  });

	  ngModel.$parsers.push(minLengthValidator);
	  ngModel.$formatters.push(minLengthValidator);
	} 
  };
});

myApp.directive("fileread", [function () {
	return {
		scope: {
			fileread: "="
		},
		link: function (scope, element, attributes) {
			element.bind("change", function (changeEvent) {
				var reader = new FileReader();
				reader.onload = function (loadEvent) {
					scope.$apply(function () {
						scope.fileread = loadEvent.target.result;
					});
				}
				reader.readAsDataURL(changeEvent.target.files[0]);
			});
		}
	}
}]);

myApp.directive('resetSearchModel',function () {
	return {
		restrict: 'A',
		require: ['^ngModel','uiSelect'],
		link: function (scope, element, attrs, ctrls) {
			if (attrs.resetSearchModel === "true" || attrs.resetSearchModel === true) {
				scope.$watch(attrs.ngModel,function (newval,oldval,scope) {
					scope.$select.selected = undefined;
				});
			}
		}
	};
})

myApp.directive('focusMe', function($timeout, $parse) {
  return {
    //scope: true,   // optionally create a child scope
    link: function(scope, element, attrs) {
      var model = $parse(attrs.focusMe);
      scope.$watch(model, function(value) {
        console.log('value=',value);
        if(value === true) { 
          $timeout(function() {
            element[0].focus(); 
          });
        }
      });
      // to address @blesh's comment, set attribute value to 'false'
      // on blur event:
      element.bind('blur', function() {
         console.log('blur');
         scope.$apply(model.assign(scope, false));
      });
    }
  };
});

myApp.directive('parseInt', [function () {
    return {
        restrict: 'A',
        require: 'ngModel',
        link: function (scope, elem, attrs, controller) {
            controller.$formatters.push(function (modelValue) {
                console.log('model', modelValue, typeof modelValue);
                return '' + modelValue;
            });

            controller.$parsers.push(function (viewValue) {
                console.log('view', viewValue, typeof viewValue);
                return parseInt(viewValue,10);
            });
        }
    }
} ])

myApp.filter("customCurrency", function (numberFilter)
  {
    function isNumeric(value)
    {
      return (!isNaN(parseFloat(value)) && isFinite(value));
    }

    return function (inputNumber, currencySymbol, decimalSeparator, thousandsSeparator, decimalDigits) {
      if (isNumeric(inputNumber))
      {
        // Default values for the optional arguments
        currencySymbol = (typeof currencySymbol === "undefined") ? "" : currencySymbol;
        decimalSeparator = (typeof decimalSeparator === "undefined") ? "," : decimalSeparator;
        thousandsSeparator = (typeof thousandsSeparator === "undefined") ? "." : thousandsSeparator;
        decimalDigits = (typeof decimalDigits === "undefined" || !isNumeric(decimalDigits)) ? 2 : decimalDigits;

        if (decimalDigits < 0) decimalDigits = 0;

        // Format the input number through the number filter
        // The resulting number will have "," as a thousands separator
        // and "." as a decimal separator.
        var formattedNumber = numberFilter(inputNumber, decimalDigits);

        // Extract the integral and the decimal parts
        var numberParts = formattedNumber.split(".");

        // Replace the "," symbol in the integral part
        // with the specified thousands separator.
        numberParts[0] = numberParts[0].split(",").join(thousandsSeparator);

        // Compose the final result
        var result = currencySymbol + numberParts[0];

        if (numberParts.length == 2)
        {
          result += decimalSeparator + numberParts[1];
        }

        return result;
      }
      else
      {
        return inputNumber;
      }
    };
  });


myApp.config(function(uiSelectConfig) {
  uiSelectConfig.resetSearchInput = true;
});
/*
myApp.config(function ($routeProvider) {
	$routeProvider
	.when('/cfops/*', {
		controller: 'CfopCtrl'
	})
	.when('/entidade/*', {
		controller: 'EntidadeCtrl'
	})
	.when('/grupo/*', {
		controller: 'GrupoCtrl'
	})
	.when('/subgrupo/*', {
		controller: 'SubgrupoCtrl'
	})
	.when('/produto/*', {
		controller: 'ProdutoCtrl'
	})
	.when('/unidade/*', {
		controller: 'UnidadeCtrl'
	})
});
*/
myApp.controller('IndexCtrl', ['$scope', function($scope)
{
	$scope.dataoptionselected = 'Ativos';
	$scope.auxAcesso = false;

	$scope.setDataOption = function(data)
	{
		$scope.dataoptionselected = data;
	}
	
	$scope.populateDropdowns =  function()
	{
		$("table > tbody > tr > td > [id^='Opt']").each(function() 
		{
			id = $("table > tbody > tr > td > [id^='Opt']").attr('id').replace("Opt","").trim();
			control = $('#data').attr('controller');
			lbl = $("table > tbody > tr > td > [state]").attr('state');

			if(lbl == 'Ativo')
			{
				lbl = 'Inativar';
			}
			else if( lbl == 'Inativo')
			{
				lbl = 'Ativar';
			}
			
			statepath = control + '/statusset/' + id;
			deletepath = (control.substring(0, control.length - 1)) + '/' + id;
			contacorrentepath = '/contacorrentes?entidade=' + id;

			statelink = '<a href="' +statepath+ '" data-confirm="Você tem certeza?" data-method="get"> ' +lbl+ '</a>'
		  	deletelink = '<a href="' +deletepath+ '" data-confirm="Você tem certeza que deseja excluir?" data-method="delete">Deletar</a>'
		  	contacorrentelink = '<a href="' +contacorrentepath+ '" data-method="get">Conta Corrente</a>'


		  	if($('#acessos').attr('inativar') == 'false')
		  	{
		  		statelink = '<a class="hidden" href="' +statepath+ '" data-confirm="Você tem certeza?" data-method="get"> ' +lbl+ '</a>'
		  	}
		  	if($('#acessos').attr('deletar') == 'false')
			{
		  		deletelink = '<a class="hidden" href="' +deletepath+ '" data-confirm="Você tem certeza que deseja excluir?" data-method="delete">Deletar</a>'
			}

		  	$(this).wrap('<div class="btn-group" style="position:absolute !important;"><div class="dropup"></div></div>');		  	
		  	if(control == 'entidades')
		  	{
		  		$(this).after('<ul class="dropdown-menu"><li>'+contacorrentelink +'</li><li class="divider"></li> <li>' +statelink+ '</li> <li>' +deletelink+ '</li></ul>');
		  	}
		  	else
		  	{
				$(this).after('<ul class="dropdown-menu"><li>' +statelink+ '</li> <li>' +deletelink+ '</li></ul>');
		  	}
		});
	}

	$(document).ready(function()
	{		
		setTimeout($scope.populateDropdowns, 1000);

		 setTimeout(function() { $('#flash').slideUp(); }, 5000);		
	});

	//id = $("table > tbody > tr > td > [id^='Opt']").attr('id').replace("Opt","").trim();
	// $("#contacorrente").click(function(){
	// 	window.location.replace("/contacorrentes?entidade="+idEntidade);
	// });
}]);

jQuery(document).ready(function() {       	
	Metronic.init(); // init metronic core components
	Layout.init(); // init current layout
	TableManaged.init();
	ComponentsDropdowns.init();
	Demo.init(); // init demo features		
    ComponentsPickers.init();

	var options = 
	{
		denoteDirtyForm: true,
		denoteDirtyOptions: true,
		trimText:true,
	};

	$('#date').datepicker({
      dateFormat: 'dd-mm-yy'
	});

	$('form').dirtyFields(options);

	$('a:not([ncheck])').click(function() 
	{    
		if ($(".dirtyForm").length > 0) 
		{
			var r = confirm("Se sair agora as mudanças serão perdidas, deseja sair?");
			return r;
		}
	});


	$('[name="emp_link"]').click(function () 
	{
		var id = $(this).attr('value');
		$.ajax
		({
			async: false, 
			type: 'post',
			url: '/users/set_current_emp',
			data: {emp_id : id},
			success: function(msg) {
			window.location.reload(true);
		}
		});
	});
});
