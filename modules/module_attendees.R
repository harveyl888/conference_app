## Attendees Module

## UI for Attendees Module
module_attendeesUI <- function(id) {
  ns <- NS(id)
  uiOutput(ns('uiAttendees'))
}

## server function for Attendees Module
module_attendees <- function(input, output, session, pool) {
  
  ns <- session$ns
  
  df_users <- dbReadTable(pool, 'users') %>%
    select(id, name) %>%
    mutate(grouping = substr(name, 1, 1))
  l_users <- split.data.frame(df_users, df_users$grouping)
  

  output$uiAttendees <- renderUI({
    f7Card(title = 'Attendees',
           ## attendees list (framework 7 contact list)
           tags$div(class = 'list contacts-list',
                    tagList(
                      lapply(seq_along(l_users), function(i) {
                        tags$div(class = 'list-group',
                                 tags$ul(
                                   tags$li(class = 'list-group-title', names(l_users)[i]),
                                   tagList(
                                     apply(l_users[[i]], 1, function(x) {
                                       tags$li(
                                         tags$div(class = 'item-content',
                                                  tags$div(class = 'item-inner',
                                                           ## on click, update a shiny variable with the id of current selected user
                                                           tags$div(class = 'item-title', as.character(x['name']), onclick = paste0('Shiny.setInputValue("', ns('selected_contact'), '", ', x['id'], ', {priority: "event"})'))
                                                           )
                                                  )
                                         )
                                       })
                                     )
                                   )
                                 )
                        })
                      )
                    )
           )
  })

  observeEvent(input$selected_contact, {
    user_name <- df_users[df_users$id == input$selected_contact, ]$name
    user_data <- dbGetQuery(pool, sprintf('SELECT * FROM users WHERE name = \'%s\'', user_name))
    user_image <- 'https://randomuser.me/api/portraits/men/32.jpg'
    
    insertUI(selector = "#app", where = "beforeEnd", immediate = FALSE,
             ui = div(id = 'div_popup', class = 'popup my-popup modal-in popup-tablet-fullscreen',
                      div(class = 'view',
                          div(class = 'page',
                              div(
                                f7Card(title = user_name,
                                       div(style = 'text-align: center;',
                                           tags$div(style = 'height: 120px; width: 120px; display: inline-block;',
                                                    tags$img(style='height: 100%; width: 100%; object-fit: contain', src=user_image)
                                                    ),
                                           br(),
                                           h3(user_data$name),
                                           h3(user_data$email),
                                           h3(user_data$affiliation),
                                           h3(user_data$bio)
                                           ),
                                       footer = tagList(a(class = 'link popup-close', 'Close'))
                                       )
                                )
                              )
                          )
                      )
             )
  })
  
}
