## create a sqlite database for demo purposes

library(DBI)

names <- c('alice adams', 'arthur adams', 'annie ansell', 'bob barnes', 'charlie croker', 'daniel davies', 'edward edwards', 'ellis edwards', 'jeremy jenkins', 'kevin keller')

df_users <- data.frame(
  name = names,
  email = sapply(strsplit(names, ' '), function(x) sprintf('%s.%s@my_company.com', x[1], x[2])),
  affiliation = 'my_company',
  bio = paste0(names, ' bio'),
  photo = '',
  stringsAsFactors = FALSE
)

df_schedule <- data.frame(
  day = rep(paste0('2019-08-', 21:23), each=5),
  time = rep(paste0(10:14, ':00-', 11:15, ':00'), 3),
  scheduleitem = rep(paste0('schedule item ', seq(5)), 3),
  stringsAsFactors = FALSE
)

## open database
db <- dbConnect(RSQLite::SQLite(), "conference_app.sqlite")

if(dbExistsTable(db, 'users')) dbRemoveTable(db, 'users')
if(dbExistsTable(db, 'schedule')) dbRemoveTable(db, 'schedule')

## create tables
dbExecute(db, "
  CREATE TABLE users(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name CHAR(75) NOT NULL,
    email CHAR(150) NOT NULL,
    affiliation CHAR(75),
    bio TEXT,
    photo CHAR(20));"
)

dbExecute(db, "
  CREATE TABLE schedule(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    day CHAR(10) NOT NULL,
    time CHAR(11) NOT NULL,
    item CHAR(100));"
)

## upload data
for (i in 1:nrow(df_users)) {
  values <- paste0("'", df_users[i, ], "'", collapse = ',')
  dbExecute(db, sprintf('INSERT INTO users (name,email,affiliation,bio,photo) VALUES (%s)', values))
}

for (i in 1:nrow(df_schedule)) {
  values <- paste0("'", df_schedule[i, ], "'", collapse = ',')
  dbExecute(db, sprintf('INSERT INTO schedule (day,time,item) VALUES (%s)', values))
}

dbDisconnect(db)
