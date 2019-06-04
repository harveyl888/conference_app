## Profile Module


# ## demo user data
# user_name <- 'bob'
# user_email <- 'bob@bob.com'
 user_image <- 'https://randomuser.me/api/portraits/men/32.jpg'
# user_affiliation <- 'bob\'s company'
# user_bio <- 'this is my bio'


## UI for Profile Module
module_profileUI <- function(id) {
  ns <- NS(id)
  uiOutput(ns('uiProfile'))
}

## server function for Profile Module
module_profile <- function(input, output, session, pool, user) {
  
  ns <- session$ns
  
  user_data <- dbGetQuery(pool, sprintf('SELECT * FROM users WHERE name = \'%s\'', user))
  
  output$uiProfile <- renderUI({
    f7Card(title = user_data$ssname,
           div(style = 'text-align: center;',
               tags$div(style = 'height: 120px; width: 120px; display: inline-block;',
                        tags$img(style='height: 100%; width: 100%; object-fit: contain', src=user_image)
                        ),
               br(),
               h3(user_data$name),
               h3(user_data$email),
               h3(user_data$affiliation),
               f7Block(strong = TRUE, inset = TRUE,
                       f7Text(ns('txt_bio'), 'bio', value = user_data$bio)
                   # f7InputList(
                   #   list(
                   #     list(type = 'textarea', label = 'bio', inputId = ns('txt_bio'), value = user_data$bio, clearButton = FALSE)
                   #   ),
                   #   outline = FALSE,
                   #   labels = 'stacked'
                   # )
               )
               
               )
           )
  })

}
