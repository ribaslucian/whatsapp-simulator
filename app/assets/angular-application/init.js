//var app = angular.module('App', [
//    'ngMessages', 'ngMask', 'toastr'
//]);

var app = angular.module('ProjectRaw', ['toastr', 'ngMessages', 'ngMask']);

app.run(function ($rootScope) {
    $rootScope.$jQuery = jQuery;
    $rootScope.globals = {
        loading: false
    };


    // basic functions

    $rootScope.l = function (a) {
        l(a);
    }

    $rootScope.brl_to_float = function (a) {
        return brl_to_float(a);
    }

    $rootScope.float_to_brl = function (a) {
        return float_to_brl_clean(a);
    }

    $rootScope.random_hash = function (l) {
        return random_hash(l);
    }

    $rootScope.semantic_enable_checkboxes = function () {
        $('.ui.checkbox').checkbox('enable');
    }




    // form validations 

    $rootScope.form_input_validation_positive_value = function (form_input, model_value) {
        var value_float = brl_to_float(model_value);

        if (value_float == 0)
            form_input.$setValidity('money', false);
        else
            form_input.$setValidity('money', true);
    }

    $rootScope.form_input_validation_insert_cents = function (form_input, model_value) {
        if (model_value == undefined)
            return;

        if (model_value.indexOf(',') > -1) {
            form_input.$setValidity('cents', true);
//            model_value = 0;
//            $scope.recharge.default_value = 0;
        } else {
            form_input.$setValidity('cents', false);
        }
    }

    $rootScope.form_input_validation_remove_left_zeros = function (form_input) {
//        if (model_value.length) {

//        l($('#default_value').val());
//        }
    }

    $rootScope.input_validation_document_length = function (form_input, model_value) {
        if (model_value == undefined)
            return;
        
        if (model_value.length != 11 && model_value.length != 14) {
            form_input.$setValidity('document_length', false);
        } else {
            form_input.$setValidity('document_length', true);
        }
    }
    
    

    $rootScope.loading = function () {
        $('#global-content').addClass('custom-blur');
        $rootScope.globals.loading = true;
    }
    
    $rootScope.loaded = function () {
        $('#global-content').removeClass('custom-blur');
        $rootScope.globals.loading = false;
    }
});



app.filter('range', function () {
    return function (input, total) {

        total = parseInt(total);

        for (var i = 0; i < total; i++)
            input.push(i);

        return input;
    };
});




//angular.module('preventTemplateCache')
//        .factory('preventTemplateCache', function ($injector) {
//            var ENV = $injector.get('ENV');
//            return {
//                'request': function (config) {
//                    if (config.url.indexOf('views') !== -1) {
//                        config.url = config.url + '?t=' + ENV.build;
//                    }
//                    return config;
//                }
//            }
//        })
//        .config(function ($httpProvider) {
//            $httpProvider.interceptors.push('preventTemplateCache');
//        });

app.run(function ($rootScope, $templateCache) {
    $rootScope.$on('$viewContentLoaded', function () {
        $templateCache.removeAll();
    });
});