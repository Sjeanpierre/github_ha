var MoveList = function () {
    var x = $("#repo_Repos_chzn .chzn-choices .search-choice");
    $("#repo_Repos_chzn .chzn-choices .search-choice").remove();
    $("#selected_items .chzn-choices").append(x);
};

$(document).on("click", ".search-choice-close", function(event) {
    var $text = $(event.target).parent().text();
    $(event.target).parent().remove();
    $('.chzn-select option:selected').filter(function () { return $(this).html() == $text; }).removeAttr('selected');
    $('.chzn-select').trigger('liszt:updated');
    $("#repo_Repos_chzn .chzn-choices .search-choice").remove();
});


var ResetForm = function () {
    $('.chzn-select option:selected').removeAttr('selected');
    $('.chzn-select').trigger('liszt:updated');
    $("#selected_items .chzn-choices").empty();
};

$(document).on("click", "#reset-form", ResetForm);