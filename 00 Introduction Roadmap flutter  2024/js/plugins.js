/* global jQuery, alert, var , $ */

$(!document).ready((function () {

    "use strict";

    // /Nice Sroll :
    $('html').niceScroll();

    // [A] Setting the carousel custome timeout:
    $('carousel').carousel({
        interval: 3500
    });
    // --------------------------------------------------

    // [B] Function of the [option box] main section: 
    // [B] / 1) Showing the [Toggle] of the color box when clicking on the {Gear Box}:
    $('.gear-option').click((function () {
        $('.color-option').fadeToggle();
        // $('.color-option').toggle();
        // $('.color-option').showToggle();
    }
    ));

    // [B] / 2) Setting the change of color palets by Jqurey and css property :                 
    var colorLi = $('.color-option ul li');

    // Setting colors in order [red , blue , purple , yellow]: 
    colorLi
        .eq(0).css('backgroundColor', '#E41B17').end()
        .eq(1).css('backgroundColor', '#009AFF').end()
        .eq(2).css('backgroundColor', '#E426D5').end()
        .eq(3).css('backgroundColor', '#FFD500');

    // [B] / 3) Chaning color of the whole template by clicking on each li color by following steps [when click function on the li] :        
    // 1- Searching for the link with attribute of the value [href] that contains {theme} -> [which is the css default_theme.css file ]
    // 2- Replacing the value of herf attribute with the value of the (li) attribute [data-value] value }          
    colorLi.click(function () {
        console.log($(this).attr("data-value"));
        $('link[href*="theme"]').attr('href', $(this).attr('data-value'));
    });
    // --------------------------------------------------

    // [C] Preloader page coding :
    $(window).load(function () {
        $('.loading-overlay .spinner').fadeOut(2000, function () {
            // Changingf the property {overflow} of body to {auto} while the fading out of spinner & before fading the parent :
            $("body").css("overflow", "auto");

            $(this).parent().fadeOut(1000, function () {
                // Removing the overloading section form the DOM
                $(this).remove();
            });
        });
    });


    // [D] Scrolling top button :
    var scrollButton = $('#scroll-top');

    // Show/hide function upon the current scrolltop value :
    $(window).scroll(function () {
        console.log($(this).scrollTop());

        // Original if condition:  
        // if ($(this).scrollTop() >= 700) {
        //     scrollButton.show();
        // } else {                
        //     scrollButton.hide();
        // }

        // Shortcut of the if condition:
        $(this).scrollTop() >= 700 ? scrollButton.show() : scrollButton.hide();
    });

    // Scrolling top function on click :
    scrollButton.click(function () {
        $('html,body').animate({ scrollTop: 0 }, 600);
    });


    // [E] / 1) Showing the [Toggle] of the [Hover Gallery Section] when clicking on the {Hover button}:
    var hoverBtn = $('.gear-option0');

    hoverBtn.click((function () {
        // $('.color-option').toggle();
        $('.hover-box').fadeToggle();
        $('html,body').animate({ scrollTop: 6000 }, 800);
        // $('.color-option').showToggle();
    }
    ));

    // [E] / 2) Showing the [Toggle] of the [Animation Libraray Section] when clicking on the {Animation Button}:
    var wowBtn = $('.gear-option1');

    wowBtn.click((function () {
        // $('.color-option').toggle();
        $('.animation-box').fadeToggle();
        $('html,body').animate({ scrollTop: 6000 }, 800);
        // $('.color-option').showToggle();
    }
    ));

    // [E] / 3) Showing the [Toggle] of the [Animation to Video Section ] when clicking on the {video nav item }:
    var videoLink = $('.videoLink');

    videoLink.click((function () {
        // $('.color-option').toggle();
        // $('.animation-box').fadeToggle();
        $('html,body').animate({ scrollTop: 1127 }, 800);
        // $('.color-option').showToggle();
    }
    ));

}));

// --------------------------------------------------
// --------------------------------------------------

function test() {
    "use strict";

    // /Nice Sroll :
    $('html').niceScroll();

    // [A] Setting the carousel custome timeout:
    $('carousel').carousel({
        interval: 3500
    });
    // --------------------------------------------------

    // [B] Function of the [option box] main section: 
    // [B] / 1) Showing the [Toggle] of the color box when clicking on the {Gear Box}:
    $('.gear-option').click((function () {
        $('.color-option').fadeToggle();
        // $('.color-option').toggle();
        // $('.color-option').showToggle();
    }
    ));

    // [B] / 2) Setting the change of color palets by Jqurey and css property :                 
    var colorLi = $('.color-option ul li');

    // Setting colors in order [red , blue , purple , yellow]: 
    colorLi
        .eq(0).css('backgroundColor', '#E41B17').end()
        .eq(1).css('backgroundColor', '#009AFF').end()
        .eq(2).css('backgroundColor', '#E426D5').end()
        .eq(3).css('backgroundColor', '#FFD500');

    // [B] / 3) Chaning color of the whole template by clicking on each li color by following steps [when click function on the li] :        
    // 1- Searching for the link with attribute of the value [href] that contains {theme} -> [which is the css default_theme.css file ]
    // 2- Replacing the value of herf attribute with the value of the (li) attribute [data-value] value }          
    colorLi.click(function () {
        console.log($(this).attr("data-value"));
        $('link[href*="theme"]').attr('href', $(this).attr('data-value'));
    });
    // --------------------------------------------------

    // [C] Preloader page coding :
    $(window).load(function () {
        $('.loading-overlay .spinner').fadeOut(2000, function () {
            // Changingf the property {overflow} of body to {auto} while the fading out of spinner & before fading the parent :
            $("body").css("overflow", "auto");

            $(this).parent().fadeOut(1000, function () {
                // Removing the overloading section form the DOM
                $(this).remove();
            });
        });
    });


    // [D] Scrolling top button :
    var scrollButton = $('#scroll-top');

    // Show/hide function upon the current scrolltop value :
    $(window).scroll(function () {
        console.log($(this).scrollTop());

        // Original if condition:  
        // if ($(this).scrollTop() >= 700) {
        //     scrollButton.show();
        // } else {                
        //     scrollButton.hide();
        // }

        // Shortcut of the if condition:
        $(this).scrollTop() >= 700 ? scrollButton.show() : scrollButton.hide();
    });

    // Scrolling top function on click :
    scrollButton.click(function () {
        $('html,body').animate({ scrollTop: 0 }, 600);
    });


    // [E] / 1) Showing the [Toggle] of the [Hover Gallery Section] when clicking on the {Hover button}:
    var hoverBtn = $('.gear-option0');

    hoverBtn.click((function () {
        // $('.color-option').toggle();
        $('.hover-box').fadeToggle();
        $('html,body').animate({ scrollTop: 6000 }, 800);
        // $('.color-option').showToggle();
    }
    ));

    // [E] / 2) Showing the [Toggle] of the [Animation Libraray Section] when clicking on the {Animation Button}:
    var wowBtn = $('.gear-option1');

    wowBtn.click((function () {
        // $('.color-option').toggle();
        $('.animation-box').fadeToggle();
        $('html,body').animate({ scrollTop: 6000 }, 800);
        // $('.color-option').showToggle();
    }
    ));
}

// -----------------------------------------------
