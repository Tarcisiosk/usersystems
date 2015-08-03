var myApp = angular.module('myApp',['ngSanitize', 'ui.select']); 

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
