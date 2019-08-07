## Home Module

## UI for Home Module
module_homeUI <- function(id) {
  ns <- NS(id)
  uiOutput(ns('uiHome'))
}

## server function for Home Module
module_home <- function(input, output, session) {
  
  ns <- session$ns
    
  output$uiHome <- renderUI({
    buttons <- list (
      list(name = 'Feed', icon = 'list'),
      list(name = 'Profile', icon = 'person'),
      list(name = 'Schedule', icon = 'event_available'),
      list(name = 'Attendees', icon = 'people'), 
      list(name = 'Location', icon = 'place')
      )
    f7Card(title = 'Home',
           tags$div(class = 'list inset',
                    
                    tags$ul(
                      tagList(
                        lapply(buttons, function(x) {
                          div(class = 'item-content',
                              div(class = 'item-media',
                                  f7Icon(x[['icon']], lib = 'md')
                                  ),
                              div(class = 'item-inner',
                                  tags$a(href = '#', id = ns(paste('but', x[['name']], sep='_')), class = 'action-button item-link list-button', x[['name']])
                                  )
                              )
                          })
                        )
                      )
                    )
           )
  })
  
  observeEvent(input$but_Feed, {
    tab_select(session, 'Feed')
  })
  
  observeEvent(input$but_Profile, {
    tab_select(session, 'Profile')
  })
  
  observeEvent(input$but_Schedule, {
    tab_select(session, 'Schedule')
  })
  
  observeEvent(input$but_Attendees, {
    tab_select(session, 'Attendees')
  })
  
  observeEvent(input$but_Location, {
    tab_select(session, 'Location')
  })
  
}
