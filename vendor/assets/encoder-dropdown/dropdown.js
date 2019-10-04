$(document).ready(function () {
    /* Função básica do evento de clicar fora de um element */
    $.fn.clickOut = function (callback, selfDestroy) {
        var clicked = false;
        var parent = this;
        var destroy = selfDestroy || true;

        parent.click(function () {
            clicked = true;
        });

        $(document).click(function (event) {
            if (!clicked)
                callback(parent, event);

            if (destroy) {
                //parent.clickOff = function() {};
                //parent.off("click");
                //$(document).off("click");
                //parent.off("clickOff");
            }

            clicked = false;
        });
    };

    // Mostrar/esconder menu ao clicar no título
    $('.dropdown .dropdown-title').click(function (e) {
        // esconder todos os menus que estiverem abertos
        if (!$(this).is('.item'))
            $('.dropdown .menu').hide();

        if (!$(this).parent('.dropdown').is('.item'))
            menu_show($('.menu:first', $(this).parent('.dropdown')));
    });

    // Mostrar/esconder menu ao posicionar o cursos no título
    $('.dropdown .dropdown-title').hover(function () {
        if ($('.menu.hover', $(this).parent('.dropdown')).length)
            $('.menu.hover', $(this).parent('.dropdown')).show();
    }, function () {
        if ($('.menu.hover', $(this).parent('.dropdown')).length)
            $('.menu.hover', $(this).parent('.dropdown')).hide();
    });

    // Ao clicar ou posicionar o mouse em um item de dropdown escondemos os demais
    // dropdowns abertos e exibimos o menu filho do item atual, caso exista.
    $('.dropdown .menu.hover .item').hover(function () {
        show_children($(this));
    });

    $('.dropdown.item').hover(function () {
        show_children($(this));
    });

    // Escoder todos os dropdowns abertos ao clicar em um
    // elemento que não seja ou não esteja dentro de um dropdown
    $('.dropdown').clickOut(function (e) {
        $('.dropdown .menu').attr('style', 'display: none !important;');
    });
    
    

    /**
     * Exibe o menu de um item que também é um dropdown.
     *
     * @param {Object} item
     * @returns {void}
     */
    function show_children(item) {
        // exibindo menu filho do item atual caso exista
        menu_show($('.menu:first', item));

        // percorrendo itens irmãos e escondendo seus sub-dropdowns
        item.siblings().each(function (a, b) {
            $('.menu', $(b)).hide();
        });
    }

    function menu_show(menu) {
        // exibindo menu filho do item atual caso exista
        if (menu.is(':visible'))
            menu.hide();
        else
            menu.show();
    }
});
