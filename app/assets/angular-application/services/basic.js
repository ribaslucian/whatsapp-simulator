app.service('$basic', function () {

    this.mobile = function () {
        return mobile();
    };

    this.globals = {
        set: function (key, value) {
            window['globals'][key] = value;
        },
        get: function (key) {
            return window['globals'][key];
        }
    }

    this.acronym = function (a) {
        return acronym(a);
    };

    this.type = function (a) {
        return type(a);
    };

    this.brl_to_float = function (a, b) {
        return brl_to_float(a, b);
    };

    this.float_to_brl = function (a) {
        return float_to_brl(a);
    };

    this.float_to_brl_clean = function (a) {
        return float_to_brl_clean(a);
    };

    this.fix_brl = function (a) {
        return fix_brl(a);
    };

    this.float_fix = function (a, b) {
        return float_fix(a, b);
    };

    this.object_length = function (a) {
        return object_length(a);
    };

    this.l = function (a) {
        return l(a);
    };

    this.no_left_zeros = function (a) {
        return no_left_zeros(a);
    };

    this.to_f = function (a) {
        return parseFloat(a);
    };

    this.currency_to_float = function (a) {
        return currency_to_float(a);
    };

    this.float_to_currency = function (a) {
        return float_to_brl_clean(a)
    };

    this.utc_to_local = function (a) {
        return utc_to_local(a);
    };

    this.utc_to_local_no_time = function (a) {
        return utc_to_local_no_time(a);
    };

    this.url_param = function (a) {
        return url_param(a);
    };

    this.date_current = function () {
        return date_current();
    };

    this.data_explode = function (a) {
        return data_explode(a);
    };

    this.mask_card_code = function (a) {
        return mask_card_code(a);
    };

    this.str_limit = function (a) {
        if (a != undefined)
            return str_limit(a);
    };

    this.delete = function (array, key) {
        delete array[key];
    };

    this.token = function () {
        return token();
    };

    this.len = function (s) {
        return len(s);
    };

    this.json = function (s) {
        if (s)
            return json(s);

        return ''
    };

    this.date_compare = function (a, b) {
        return date_compare(a, b);
    };

    this.date_str_br = function (a) {
        return date_str_br(a);
    };

    this.loading = function () {
        loading();
    };

    this.date_today = function () {
        var t = new Date();
        var d = ("0" + t.getDate()).slice(-2);
        var m = ("0" + (t.getMonth() + 1)).slice(-2);
        var h = ("0" + t.getHours()).slice(-2);
        var min = ("0" + t.getMinutes()).slice(-2);

        return (d + '/' + (m) + '/' + t.getFullYear() + ' ' + h + ':' + min)
    };

    this.date_time_compare = function (a, b) {
        return date_compare_time(a, b);
    };

    this.date_str_br_full = function (a) {
        return date_str_br_full(a);
    };

    this.date_get_hour = function (a) {
        return date_get_hour(a);
    };

    this.key = function (a, k) {
        return k in a;
    };
    
    this.isMobile = function () {
        return isMobile();
    };

});

app.run(function ($rootScope, $basic) {
    $rootScope.$basic = $basic;
});