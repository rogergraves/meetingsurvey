//$('.question > input[type="radio"]:checked').parents('label').css('color', 'yellow');

$(function() {
        function set_why_color(label) {
            var why = label.closest(".question").find(".why");
            why.css('display', 'inline');
            if(label.hasClass('btn-yes')) {
                why.css('color', '#00BA59');
            } else {
                why.css('color', '#FF4449');
            }
        }

        $('.question input[type="radio"]').change(function() {
                var radio = $(this);
                $.each(radio.parents('.question').find('label'), function(i, v) {
                    var label = $(v);
                    if(label.children('input[type="radio"]:checked').length) {
                        label.addClass('active');
                        set_why_color(label);
                    } else {
                        label.removeClass('active');
                    }
                });

            }
        );
    }
);
