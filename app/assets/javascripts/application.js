// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
// require rails-ujs
// require activestorage
// require turbolinks
//
// customs
//= require jquery3.min
//= require mask-input.min
//= require qrcode.min
//= require mask-money
//= require md5
//
//= require semantic-ui
//
//= require dist/owl.carousel.min
// require owl.min
//
//= require flatpickr
//
//= require functions
//
//= require angular
//= require angular-messages
//= require mask.min
//= require toastr/tpls.min
//
//= require init
//= require services/flash
//= require services/basic

$(document).ready(function () {


    /**
     * custom masks
     */

    $(".mask-money").maskMoney({allowNegative: false, thousands: '.', decimal: ',', affixesStay: false});

    $('body').on('keydown', '.custom-mask-cpf', function () {
        $(this).mask('000.000.000-00');
    });

    $('body').on('keydown', '.custom-mask-cnpj', function () {
        $(this).mask('00.000.000/0000-00');
    });

    $('body').on('keydown', '.custom-mask-date', function () {
        $(this).mask('00/00/0000');
    });

    $('body').on('keydown', '.custom-mask-hour', function () {
        $(this).mask('00:00');
    });

    $('body').on('keydown', '.custom-mask-number-natural', function (e) {
        allow_key_code = [8, 9, 13, 37, 38, 39, 40, 46, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 116];
        return $.inArray(e.keyCode, allow_key_code) == -1 ? false : true;
    });


    $('.custom-mask-card').mask('9999 9999 9999 9999');


    jQuery(".custom-mask-phone")
            .mask("(99) 9999-9999?9")
            .focusout(function (event) {
                var target, phone, element;
                target = (event.currentTarget) ? event.currentTarget : event.srcElement;
                phone = target.value.replace(/\D/g, '');
                element = $(target);
                element.unmask();
                if (phone.length > 10) {
                    element.mask("(99) 9 9999-999?9");
                } else {
                    element.mask("(99) 9999-9999?9");
                }
            });



    /**
     * semantic inits
     */

    $('.popup').popup({transition: 'fade'});

    $('.modal').modal({duration: 300, transition: 'drop'});

    $('.ui.dropdown').dropdown({
        transition: 'drop'
    });

    $('.ui.checkbox').checkbox();
    $('.ui.checkbox').click(function () {
        var id = $(this).attr('id');
        angular.element(document.getElementById(id)).scope().apply();
    });


    /**
     * owl carousel
     */
    $('.owl-carousel').owlCarousel({
        loop: false,
        margin: 25,
        nav: true,
        mouseDrag: false,
        responsive: {
            1024: {
                items: 3
            },
            768: {
                items: 2
            },
            480: {
                items: 1
            },
            0: {
                items: 1
            },
        },
        navText: [
            "<div class='ui button circular icon large'><i class='icon arrow left'></i></div>",
            "<div class='ui button circular icon large'><i class='icon arrow right'></i></div>",
        ]
    });

//    $('#modal-extract-filter').modal({duration: 300, transition: 'drop'}).modal('show');
//    $('#modal-extract-filter').modal('show');
//    $('#pos-card-data').modal('show');

    $("[date-input]").flatpickr({
        enableTime: true,
        dateFormat: "d/m/Y H:i",
        time_24hr: true,
        onReady: function (dateObj, dateStr, instance) {
            var $cal = $(instance.calendarContainer);
            if ($cal.find('.flatpickr-clear').length < 1) {
                $cal.append('<div class="flatpickr-clear custom-pointer">Limpar</div>');
                $cal.find('.flatpickr-clear').on('click', function () {
                    instance.clear();
                    instance.close();
                });
            }
        }
    });

    $("[date-input-start]").flatpickr({
        enableTime: true,
        dateFormat: "d/m/Y H:i",
        time_24hr: true,
        defaultHour: 00,
        defaultMinute: 00,
        onReady: function (dateObj, dateStr, instance) {
            var $cal = $(instance.calendarContainer);
            if ($cal.find('.flatpickr-clear').length < 1) {
                $cal.append('<div class="flatpickr-clear custom-pointer">Limpar</div>');
                $cal.find('.flatpickr-clear').on('click', function () {
                    instance.clear();
                    instance.close();
                });
            }
        }
    });

    $("[date-input-end]").flatpickr({
        enableTime: true,
        dateFormat: "d/m/Y H:i",
        time_24hr: true,
        defaultHour: 23,
        defaultMinute: 55,
        onReady: function (dateObj, dateStr, instance) {
            var $cal = $(instance.calendarContainer);
            if ($cal.find('.flatpickr-clear').length < 1) {
                $cal.append('<div class="flatpickr-clear custom-pointer">Limpar</div>');
                $cal.find('.flatpickr-clear').on('click', function () {
                    instance.clear();
                    instance.close();
                });
            }
        }
    });

    $("[date-input]").click(function () {
        return false;
    });


    loaded();

    window.onbeforeunload = function () {
        loading();
    };

    $('.entity-qrcode').qrcode({width: 170, height: 170, text: $('.entity-qrcode').attr('text')});
});
