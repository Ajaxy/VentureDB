$(function () {
    $('.icon-remove').on('ajax:success', function () {
        var $li = $(this).parents('li');
        $li.fadeOut(null, function () { $li.remove(); });
    });
});