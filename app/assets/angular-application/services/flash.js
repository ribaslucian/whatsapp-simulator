/**
 * https://github.com/Foxandxss/angular-toastr
 */
app.config(function (toastrConfig) {
    angular.extend(toastrConfig, {
        closeButton: true,
        progressBar: true,
        timeOut: 10000,
        messageClass: 'toast-message',
        preventOpenDuplicates: true,
        positionClass: 'toast-top-center',
        iconClasses: {
            error: 'custom-toast-red',
            info: 'custom-toast-blue',
            success: 'custom-toast-green',
            warning: 'custom-toast-orange',
        },
    });
});

app.service('$flash', function (toastr) {
    this.green = function (message, title) {
        toastr.success(message, title, {
            allowHtml: true
        });
    }

    this.blue = function (message, title) {
        l('oi')
        toastr.info(message, title, {
            allowHtml: true
        });
    }

    this.orange = function (message, title) {
        toastr.warning(message, title, {
            allowHtml: true
        });
    }

    this.red = function (message, title) {
        toastr.error(message, title, {
            allowHtml: true
        });
    }
});

app.run(function ($rootScope, $flash) {
    $rootScope.flash = $flash;
});