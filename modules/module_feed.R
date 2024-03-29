## Feed Module

## UI for Feed Module
module_feedUI <- function(id) {
  ns <- NS(id)
  uiOutput(ns('uiFeed'))
}

## server function for Feed Module
module_feed <- function(input, output, session) {
  output$uiFeed <- renderUI({
    f7Card(title = 'feed',
           h4('feed')
    )
  })
}
