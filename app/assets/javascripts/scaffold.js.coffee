$ ->
  # enable chosen js
  $('.chzn-select').chosen
    allow_single_deselect: true
    no_results_text: 'No results matched'
  $(".chzn-select").chosen().change(MoveList)
  MoveList()

