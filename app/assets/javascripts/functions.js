function to_float(string_number) {
    return parseFloat(string_number);
}

function brl_to_float(brl) {
    brl = '' + brl;

    // "R$ 1.234,56" -> "R$1.234,56"
    brl = brl.replace(/\s/g, '');

    // "R$1.234,56" -> "1234,56"
    brl = brl.replace(/[^\d|\,]/g, '');

    // "R$1.234,56" -> "," | two or more virgules ?
    if (brl.replace(/[^,]/g, '').length > 1)
        return -1;

    // "R$1.234,56" -> "56" | two more digits for cents ?
    var cents = brl.split(',');
    if (cents[1] != undefined && (cents[1].length > 2))
        return -2;

    // "1234,56" -> "1234.56"
    brl = brl.replace(/\,/g, '.');

    // "1234.56" -> 1234.56
    brl = parseFloat(brl);
    return parseFloat(brl.toFixed(2));
}


function float_to_brl(val, options) {
    if (val == null || isNaN(val))
        val = 0;

    // https://pt.stackoverflow.com/questions/215656/formatar-string-ou-float-para-moeda

    var brl = new Intl.NumberFormat('pt-BR', {
        style: 'currency',
        currency: 'BRL',
        minimumFractionDigits: 2,
    }).format(parseFloat(val));

    if (typeof options == 'object') {
        if (options.sign == false)
            brl = $.trim(brl.replace('R$', ''));

        if (options.points == false)
            return brl.replace(/\./, '');
    }

    return brl.trim();
}


function float_to_brl_clean(val) {
    return float_to_brl(val, {points: false, sign: false});
}

function l(str) {
    console.log(str);
}


function random_hash(length) {
    var result = '';
    var characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    var charactersLength = characters.length;

    for (var i = 0; i < length; i++)
        result += characters.charAt(Math.floor(Math.random() * charactersLength));

    return result;
}

function loading() {
    $('#global-content').addClass('custom-blur');
    $('#global-loader-jquery').show();
}

function loaded() {
    $('#global-content').removeClass('custom-blur');
    $('#global-loader-jquery').hide();
}

function sidebar() {
    $('.ui.sidebar').sidebar('setting', {
        transition: 'overlay',
        dimPage: true,
    }).sidebar('toggle');

//                                #f4f6fb
    $('#global-content').css('background', '#f4f6fb');
}






/**
 * Move um elemento ao centro da tela atraves de um metodo
 * primitivo > elemento.center()
 *
 * @returns {jQuery.fn}
 */
jQuery.fn.center = function () {
    this.css('position', 'fixed');
    this.css('left', '50%');
    this.css('top', '50%');
    this.css('top', ($(document).height() - this.height()) / 2 + 'px');
    this.css('left', ($(document).width() - this.width()) / 2 + 'px');
    return this;
}


/**
 * Retira todos os caracteres nao numericos de uma string.
 *
 * @param {string} str
 * @returns {string}
 */
function only_numbers(str) {
    return str.match(/\d+/g).join('');
}


function get_user_time_to_expire() {
    var date = new Date(new Date());
    date.setMinutes(date.getMinutes() + 240);
    return date;
}


function get_date_to_extract() {
    var date = new Date(new Date());
    date.setMonth(date.getMonth() - 3);
    return date.toISOString();
}


function toFloat(string_number) {
    return parseFloat(string_number);
}




function type(val) {
    return jQuery.type(val);
}


function no_left_zeros(val) {
    return (val + "").replace(/^(0+)(\d)/g, '$2');
}


function object_length(obj) {
    try {
        return Object.keys(obj).length;
    } catch (err) {
        return 0;
    }
}


function fix_brl(val_brl) {
    var val_float = brl_to_float(val_brl) || 0;

    if (val_float == 0)
        return '0,00';

    if ((val_brl.indexOf(',') != -1
            && val_float > 1
            && val_brl.charAt(0) == '0')) {
        return float_to_brl_clean(val_float);
    }

    if (val_brl.length > 2)
        return float_to_brl_clean(val_float);

    return val_brl;
}


function mask_cpf(cpf) {
    return (cpf + "").replace(/^(\d{3})(\d{3})(\d{3})(\d{2}).*/, '$1.$2.$3-$4');
}


/**
 * Get the user IP throught the webkitRTCPeerConnection
 * @param onNewIP {Function} listener function to expose the IP locally
 * @return undefined
 */
function ipv4_private_callable(onNewIP) { //  onNewIp - your listener function for new IPs
    //compatibility for firefox and chrome
    var myPeerConnection = window.RTCPeerConnection || window.mozRTCPeerConnection || window.webkitRTCPeerConnection;
    var pc = new myPeerConnection({
        iceServers: []
    }),
            noop = function () {},
            localIPs = {},
            ipRegex = /([0-9]{1,3}(\.[0-9]{1,3}){3}|[a-f0-9]{1,4}(:[a-f0-9]{1,4}){7})/g,
            key;

    function iterateIP(ip) {
        if (!localIPs[ip])
            onNewIP(ip);
        localIPs[ip] = true;
    }

    //create a bogus data channel
    pc.createDataChannel("");

    // create offer and set local description
    pc.createOffer().then(function (sdp) {
        sdp.sdp.split('\n').forEach(function (line) {
            if (line.indexOf('candidate') < 0)
                return;
            line.match(ipRegex).forEach(iterateIP);
        });

        pc.setLocalDescription(sdp, noop, noop);
    }).catch(function (reason) {
        // An error occurred, so handle the failure to connect
    });

    //listen for candidate events
    pc.onicecandidate = function (ice) {
        if (!ice || !ice.candidate || !ice.candidate.candidate || !ice.candidate.candidate.match(ipRegex))
            return;
        ice.candidate.candidate.match(ipRegex).forEach(iterateIP);
    };
}


function ipv4_public() {
    var ip = '000.000.000.000/00';

    $.ajax({
        url: 'https://api.ipify.org/?format=json',
        async: false,
        success: function (data) {
            ip = data.ip;
        }
    });

    return ip;
}


function browser_info() {
    var nVer = navigator.appVersion;
    var nAgt = navigator.userAgent;
    var browserName = navigator.appName;
    var fullVersion = '' + parseFloat(navigator.appVersion);
    var majorVersion = parseInt(navigator.appVersion, 10);
    var nameOffset, verOffset, ix;

    // In Opera 15+, the true version is after "OPR/"
    if ((verOffset = nAgt.indexOf("OPR/")) != -1) {
        browserName = "Opera";
        fullVersion = nAgt.substring(verOffset + 4);
    }
    // In older Opera, the true version is after "Opera" or after "Version"
    else if ((verOffset = nAgt.indexOf("Opera")) != -1) {
        browserName = "Opera";
        fullVersion = nAgt.substring(verOffset + 6);
        if ((verOffset = nAgt.indexOf("Version")) != -1)
            fullVersion = nAgt.substring(verOffset + 8);
    }
    // In MSIE, the true version is after "MSIE" in userAgent
    else if ((verOffset = nAgt.indexOf("MSIE")) != -1) {
        browserName = "Microsoft Internet Explorer";
        fullVersion = nAgt.substring(verOffset + 5);
    }
    // In Chrome, the true version is after "Chrome"
    else if ((verOffset = nAgt.indexOf("Chrome")) != -1) {
        browserName = "Chrome";
        fullVersion = nAgt.substring(verOffset + 7);
    }
    // In Safari, the true version is after "Safari" or after "Version"
    else if ((verOffset = nAgt.indexOf("Safari")) != -1) {
        browserName = "Safari";
        fullVersion = nAgt.substring(verOffset + 7);
        if ((verOffset = nAgt.indexOf("Version")) != -1)
            fullVersion = nAgt.substring(verOffset + 8);
    }
    // In Firefox, the true version is after "Firefox"
    else if ((verOffset = nAgt.indexOf("Firefox")) != -1) {
        browserName = "Firefox";
        fullVersion = nAgt.substring(verOffset + 8);
    }
    // In most other browsers, "name/version" is at the end of userAgent
    else if ((nameOffset = nAgt.lastIndexOf(' ') + 1) <
            (verOffset = nAgt.lastIndexOf('/')))
    {
        browserName = nAgt.substring(nameOffset, verOffset);
        fullVersion = nAgt.substring(verOffset + 1);
        if (browserName.toLowerCase() == browserName.toUpperCase()) {
            browserName = navigator.appName;
        }
    }

    // trim the fullVersion string at semicolon/space if present
    if ((ix = fullVersion.indexOf(";")) != -1)
        fullVersion = fullVersion.substring(0, ix);
    if ((ix = fullVersion.indexOf(" ")) != -1)
        fullVersion = fullVersion.substring(0, ix);

    majorVersion = parseInt('' + fullVersion, 10);
    if (isNaN(majorVersion)) {
        fullVersion = '' + parseFloat(navigator.appVersion);
        majorVersion = parseInt(navigator.appVersion, 10);
    }

    return browserName + ' ' + fullVersion;
}


function request_info(ipv4) {
    if (ipv4 == undefined)
        return {
            os: navigator.platform,
            browser: browser_info()
        };

    return {
        ipv4_public: ipv4_public(),
        os: navigator.platform,
        browser: browser_info()
    };
}


/**
 * Converte uma moeda brasileira em float.
 *
 * @param {type} str
 *
 * @returns {float}
 */
function currency_to_float(current) {
    current = current.replace('.', '');
    current = current.replace(',', '.')
    return parseFloat(current.replace(',', '.'));
}


/**
 * Converte uma moeda brasileira em float.
 *
 * @param {type} str
 *
 * @returns {float}
 */
function float_to_currency(value) {
    value = parseFloat(value);
    value = value.toFixed(2).replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,");
    value = value.replace(',', '_');
    value = value.replace('.', ',');
    value = value.replace('_', '.');

    if (value == '-0,00')
        value = '0,00';

    return value;
}


//function utc_to_local(date) {
//    date = new Date(date);
//    return date.toLocaleString('pt-BR').substr(0, 16);
//}

function old_utc_to_local(date) {
    if (!date)
        return;

    date = new Date(date);
    var newDate = new Date(date.getTime() + date.getTimezoneOffset() * 60 * 1000);

    var offset = date.getTimezoneOffset() / 60;
    var hours = date.getHours();

    newDate.setHours(hours - offset);

    return newDate.toLocaleString('pt-BR').substr(0, 16);
}
function utc_to_local(date) {
    if (!date)
        return;

    year = date.substr(0, 4);
    month = date.substr(5, 2);
    day = date.substr(8, 2);
    hours = date.substr(11, 2);
    mins = date.substr(14, 2);

    date = new Date(Date.UTC(year, month - 1, day, hours, mins, 0, 0, 0));
    return date.toLocaleString('pt-BR').substr(0, 16);
}

function utc_to_local_full(date) {
    date = new Date(date);
    var newDate = new Date(date.getTime() + date.getTimezoneOffset() * 60 * 1000);

    var offset = date.getTimezoneOffset() / 60;
    var hours = date.getHours();

    newDate.setHours(hours - offset);

    return newDate.toLocaleString('pt-BR');
}


function utc_to_local_no_time(date) {
    date = new Date(date);
    return date.toLocaleString('pt-BR').substr(0, 10);
}

function date_current() {
    var date = new Date(new Date());
    return date.toLocaleString('pt-BR').substr(0, 16);
}

function data_explode(date) {
    date = utc_to_local(date);
    date = date.split(' ');

    var time = date[1].split(':');
    date = date[0].split('/');

    return {
        day: date[0],
        month: date[1],
        year: date[2],
        hour: time[0],
        min: time[1],
    };
}


function random_number(rage) {
    return Math.floor((Math.random() * rage) + 1);
}


function random_date() {
    var start = new Date(2017, 0, 1);
    return new Date(start.getTime() + Math.random());
}

function acronym(id) {
    return ACRONYMS[id];
}

function $app() {
    return angular.element("[ng-app='ProjectRaw']").scope().$app;
}

function modal_alone(name) {
    $('.modal').modal().modal('close');
    $('[data-modal="' + name + '"]').modal().modal('open');
}
function modal_close_all() {
    $('.modal').modal().modal('close');
}

function float_fix(value, boxes) {
    value = parseFloat(value).toFixed(boxes);

    if (value == -0.00)
        value = 0.00;

    return value;
}

function url_param(name) {
    var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
    return results[1] || 0;
}

function mask_card_code(code) {
    return '**** **** **** ' + code.substr(12, 15);
}

function mobile() {
    return MOBILE;
}

function md5(s) {
    return $.md5(s);
}

function str_limit(str) {
    var len = 13;

    str = str.replace(/\SUPERMERCADO/g, '')

    if (str.length > len)
        return str.substring(0, len) + '...';

    return str;
}

function len(s) {
    if (s == '' || s == null || s == undefined)
        return 0;

    return s.length;
}

function json(s) {
    return JSON.stringify(s);
}

var rand = function () {
    return Math.random().toString(16).substr(2); // remove `0.`
};

var token = function () {
    return rand() + rand(); // to make it longer
};


function date_compare(str_less, str_greather) {

    if (len(str_less) <= 0 || len(str_greather) <= 0) {
        return null;
    }


    var start = str_less.split(' ')
    var start_hour = start[1].split(':');
    var start = start[0].split('/')

    var end = str_greather.split(' ')
    var end_hour = end[1].split(':');
    var end = end[0].split('/')

    str_less = new Date(start[2], start[1], start[0], start_hour[0], start_hour[1]);
    str_greather = new Date(end[2], end[1], end[0], end_hour[0], end_hour[1]);

    if (str_less == str_greather) {
        return 0;
    }

    if (str_less > str_greather) {
        return 1;
    }

    if (str_less < str_greather) {
        return -1;
    }

    return 0;
}


// 2019-02-01 > 01/02/2019
function date_str_br(date) {
    if (len(date) <= 0)
        return null;

    date = date.split(' ');
    date = date[0].split('-');

    return date[2] + '/' + date[1] + '/' + date[0];
}

// 2019-02-01 11:59 > 01/02/2019 11:59
function date_str_br_full(date) {
    if (len(date) <= 0)
        return null;

    date = date.split(' ');
    var hours = date[1];
    date = date[0].split('-');
    ;

    var d = date[2];
    var m = date[1];
    var y = date[0];

    return (d + '/' + m + '/' + y + ' ' + hours);
}

function date_get_hour(date) {
    if (len(date) <= 0)
        return null;

    date = date.split(' ');

    return date[1];
}

var rand_pass = function () {
    return Math.random().toString(16).substr(2, 5); // remove `0.`
};

function isMobile() {
    if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent))
        return true;

    return false;
}


//function only_numbers(inputString) {
//    var regex = /\d+\.\d+|\.\d+|\d+/g,
//            results = [],
//            n;
//
//    while (n = regex.exec(inputString)) {
//        results.push(parseFloat(n[0]));
//    }
//
//    return results.join('');
//}






/*
 * [js-sha1]{@link https://github.com/emn178/js-sha1}
 *
 * @version 0.6.0
 * @author Chen, Yi-Cyuan [emn178@gmail.com]
 * @copyright Chen, Yi-Cyuan 2014-2017
 * @license MIT
 */
!function () {
    "use strict";
    function t(t) {
        t ? (f[0] = f[16] = f[1] = f[2] = f[3] = f[4] = f[5] = f[6] = f[7] = f[8] = f[9] = f[10] = f[11] = f[12] = f[13] = f[14] = f[15] = 0, this.blocks = f) : this.blocks = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], this.h0 = 1732584193, this.h1 = 4023233417, this.h2 = 2562383102, this.h3 = 271733878, this.h4 = 3285377520, this.block = this.start = this.bytes = this.hBytes = 0, this.finalized = this.hashed = !1, this.first = !0
    }
    var h = "object" == typeof window ? window : {}, s = !h.JS_SHA1_NO_NODE_JS && "object" == typeof process && process.versions && process.versions.node;
    s && (h = global);
    var i = !h.JS_SHA1_NO_COMMON_JS && "object" == typeof module && module.exports, e = "function" == typeof define && define.amd, r = "0123456789abcdef".split(""), o = [-2147483648, 8388608, 32768, 128], n = [24, 16, 8, 0], a = ["hex", "array", "digest", "arrayBuffer"], f = [], u = function (h) {
        return function (s) {
            return new t(!0).update(s)[h]()
        }
    }, c = function () {
        var h = u("hex");
        s && (h = p(h)), h.create = function () {
            return new t
        }, h.update = function (t) {
            return h.create().update(t)
        };
        for (var i = 0; i < a.length; ++i) {
            var e = a[i];
            h[e] = u(e)
        }
        return h
    }, p = function (t) {
        var h = eval("require('crypto')"), s = eval("require('buffer').Buffer"), i = function (i) {
            if ("string" == typeof i)
                return h.createHash("sha1").update(i, "utf8").digest("hex");
            if (i.constructor === ArrayBuffer)
                i = new Uint8Array(i);
            else if (void 0 === i.length)
                return t(i);
            return h.createHash("sha1").update(new s(i)).digest("hex")
        };
        return i
    };
    t.prototype.update = function (t) {
        if (!this.finalized) {
            var s = "string" != typeof t;
            s && t.constructor === h.ArrayBuffer && (t = new Uint8Array(t));
            for (var i, e, r = 0, o = t.length || 0, a = this.blocks; r < o; ) {
                if (this.hashed && (this.hashed = !1, a[0] = this.block, a[16] = a[1] = a[2] = a[3] = a[4] = a[5] = a[6] = a[7] = a[8] = a[9] = a[10] = a[11] = a[12] = a[13] = a[14] = a[15] = 0), s)
                    for (e = this.start; r < o && e < 64; ++r)
                        a[e >> 2] |= t[r] << n[3 & e++];
                else
                    for (e = this.start; r < o && e < 64; ++r)
                        (i = t.charCodeAt(r)) < 128 ? a[e >> 2] |= i << n[3 & e++] : i < 2048 ? (a[e >> 2] |= (192 | i >> 6) << n[3 & e++], a[e >> 2] |= (128 | 63 & i) << n[3 & e++]) : i < 55296 || i >= 57344 ? (a[e >> 2] |= (224 | i >> 12) << n[3 & e++], a[e >> 2] |= (128 | i >> 6 & 63) << n[3 & e++], a[e >> 2] |= (128 | 63 & i) << n[3 & e++]) : (i = 65536 + ((1023 & i) << 10 | 1023 & t.charCodeAt(++r)), a[e >> 2] |= (240 | i >> 18) << n[3 & e++], a[e >> 2] |= (128 | i >> 12 & 63) << n[3 & e++], a[e >> 2] |= (128 | i >> 6 & 63) << n[3 & e++], a[e >> 2] |= (128 | 63 & i) << n[3 & e++]);
                this.lastByteIndex = e, this.bytes += e - this.start, e >= 64 ? (this.block = a[16], this.start = e - 64, this.hash(), this.hashed = !0) : this.start = e
            }
            return this.bytes > 4294967295 && (this.hBytes += this.bytes / 4294967296 << 0, this.bytes = this.bytes % 4294967296), this
        }
    }, t.prototype.finalize = function () {
        if (!this.finalized) {
            this.finalized = !0;
            var t = this.blocks, h = this.lastByteIndex;
            t[16] = this.block, t[h >> 2] |= o[3 & h], this.block = t[16], h >= 56 && (this.hashed || this.hash(), t[0] = this.block, t[16] = t[1] = t[2] = t[3] = t[4] = t[5] = t[6] = t[7] = t[8] = t[9] = t[10] = t[11] = t[12] = t[13] = t[14] = t[15] = 0), t[14] = this.hBytes << 3 | this.bytes >>> 29, t[15] = this.bytes << 3, this.hash()
        }
    }, t.prototype.hash = function () {
        var t, h, s = this.h0, i = this.h1, e = this.h2, r = this.h3, o = this.h4, n = this.blocks;
        for (t = 16; t < 80; ++t)
            h = n[t - 3] ^ n[t - 8] ^ n[t - 14] ^ n[t - 16], n[t] = h << 1 | h >>> 31;
        for (t = 0; t < 20; t += 5)
            s = (h = (i = (h = (e = (h = (r = (h = (o = (h = s << 5 | s >>> 27) + (i & e | ~i & r) + o + 1518500249 + n[t] << 0) << 5 | o >>> 27) + (s & (i = i << 30 | i >>> 2) | ~s & e) + r + 1518500249 + n[t + 1] << 0) << 5 | r >>> 27) + (o & (s = s << 30 | s >>> 2) | ~o & i) + e + 1518500249 + n[t + 2] << 0) << 5 | e >>> 27) + (r & (o = o << 30 | o >>> 2) | ~r & s) + i + 1518500249 + n[t + 3] << 0) << 5 | i >>> 27) + (e & (r = r << 30 | r >>> 2) | ~e & o) + s + 1518500249 + n[t + 4] << 0, e = e << 30 | e >>> 2;
        for (; t < 40; t += 5)
            s = (h = (i = (h = (e = (h = (r = (h = (o = (h = s << 5 | s >>> 27) + (i ^ e ^ r) + o + 1859775393 + n[t] << 0) << 5 | o >>> 27) + (s ^ (i = i << 30 | i >>> 2) ^ e) + r + 1859775393 + n[t + 1] << 0) << 5 | r >>> 27) + (o ^ (s = s << 30 | s >>> 2) ^ i) + e + 1859775393 + n[t + 2] << 0) << 5 | e >>> 27) + (r ^ (o = o << 30 | o >>> 2) ^ s) + i + 1859775393 + n[t + 3] << 0) << 5 | i >>> 27) + (e ^ (r = r << 30 | r >>> 2) ^ o) + s + 1859775393 + n[t + 4] << 0, e = e << 30 | e >>> 2;
        for (; t < 60; t += 5)
            s = (h = (i = (h = (e = (h = (r = (h = (o = (h = s << 5 | s >>> 27) + (i & e | i & r | e & r) + o - 1894007588 + n[t] << 0) << 5 | o >>> 27) + (s & (i = i << 30 | i >>> 2) | s & e | i & e) + r - 1894007588 + n[t + 1] << 0) << 5 | r >>> 27) + (o & (s = s << 30 | s >>> 2) | o & i | s & i) + e - 1894007588 + n[t + 2] << 0) << 5 | e >>> 27) + (r & (o = o << 30 | o >>> 2) | r & s | o & s) + i - 1894007588 + n[t + 3] << 0) << 5 | i >>> 27) + (e & (r = r << 30 | r >>> 2) | e & o | r & o) + s - 1894007588 + n[t + 4] << 0, e = e << 30 | e >>> 2;
        for (; t < 80; t += 5)
            s = (h = (i = (h = (e = (h = (r = (h = (o = (h = s << 5 | s >>> 27) + (i ^ e ^ r) + o - 899497514 + n[t] << 0) << 5 | o >>> 27) + (s ^ (i = i << 30 | i >>> 2) ^ e) + r - 899497514 + n[t + 1] << 0) << 5 | r >>> 27) + (o ^ (s = s << 30 | s >>> 2) ^ i) + e - 899497514 + n[t + 2] << 0) << 5 | e >>> 27) + (r ^ (o = o << 30 | o >>> 2) ^ s) + i - 899497514 + n[t + 3] << 0) << 5 | i >>> 27) + (e ^ (r = r << 30 | r >>> 2) ^ o) + s - 899497514 + n[t + 4] << 0, e = e << 30 | e >>> 2;
        this.h0 = this.h0 + s << 0, this.h1 = this.h1 + i << 0, this.h2 = this.h2 + e << 0, this.h3 = this.h3 + r << 0, this.h4 = this.h4 + o << 0
    }, t.prototype.hex = function () {
        this.finalize();
        var t = this.h0, h = this.h1, s = this.h2, i = this.h3, e = this.h4;
        return r[t >> 28 & 15] + r[t >> 24 & 15] + r[t >> 20 & 15] + r[t >> 16 & 15] + r[t >> 12 & 15] + r[t >> 8 & 15] + r[t >> 4 & 15] + r[15 & t] + r[h >> 28 & 15] + r[h >> 24 & 15] + r[h >> 20 & 15] + r[h >> 16 & 15] + r[h >> 12 & 15] + r[h >> 8 & 15] + r[h >> 4 & 15] + r[15 & h] + r[s >> 28 & 15] + r[s >> 24 & 15] + r[s >> 20 & 15] + r[s >> 16 & 15] + r[s >> 12 & 15] + r[s >> 8 & 15] + r[s >> 4 & 15] + r[15 & s] + r[i >> 28 & 15] + r[i >> 24 & 15] + r[i >> 20 & 15] + r[i >> 16 & 15] + r[i >> 12 & 15] + r[i >> 8 & 15] + r[i >> 4 & 15] + r[15 & i] + r[e >> 28 & 15] + r[e >> 24 & 15] + r[e >> 20 & 15] + r[e >> 16 & 15] + r[e >> 12 & 15] + r[e >> 8 & 15] + r[e >> 4 & 15] + r[15 & e]
    }, t.prototype.toString = t.prototype.hex, t.prototype.digest = function () {
        this.finalize();
        var t = this.h0, h = this.h1, s = this.h2, i = this.h3, e = this.h4;
        return[t >> 24 & 255, t >> 16 & 255, t >> 8 & 255, 255 & t, h >> 24 & 255, h >> 16 & 255, h >> 8 & 255, 255 & h, s >> 24 & 255, s >> 16 & 255, s >> 8 & 255, 255 & s, i >> 24 & 255, i >> 16 & 255, i >> 8 & 255, 255 & i, e >> 24 & 255, e >> 16 & 255, e >> 8 & 255, 255 & e]
    }, t.prototype.array = t.prototype.digest, t.prototype.arrayBuffer = function () {
        this.finalize();
        var t = new ArrayBuffer(20), h = new DataView(t);
        return h.setUint32(0, this.h0), h.setUint32(4, this.h1), h.setUint32(8, this.h2), h.setUint32(12, this.h3), h.setUint32(16, this.h4), t
    };
    var y = c();
    i ? module.exports = y : (h.sha1 = y, e && define(function () {
        return y
    }))
}();

