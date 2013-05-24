# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

shazbot = ->
  list = $("#repo_Repos_chzn .chzn-choices .search-choice")
  $("#repo_Repos_chzn .chzn-choices .search-choice").remove()
  $("body").append(list)
