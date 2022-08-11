library(DBI)
library(RMySQL)
library(dplyr)
library(ggplot2)

MyDataBase <- dbConnect(
  drv = RMySQL::MySQL(),
  dbname = "shinydemo",
  host = "shiny-demo.csa7qlmguqrf.us-east-1.rds.amazonaws.com",
  username = "guest",
  password = "guest")

dbListTables(MyDataBase)
dbListFields(MyDataBase, 'CountryLanguage')

#Una vez hecha la conexión a la BDD, generar una búsqueda 
#con dplyr que devuelva el porcentaje de personas que 
#hablan español en todos los países

DataDB <- dbGetQuery(MyDataBase, "select * from CountryLanguage")
head(DataDB)

esp <-  DataDB %>% filter(Language == "Spanish")
head(esp)
class(esp)

#Realizar una gráfica con ggplot que represente este porcentaje 
#de tal modo que en el eje de las Y aparezca el país y en X el 
#porcentaje, y que diferencíe entre aquellos que es su lengua oficial 
#y los que no, con diferente color (puedes utilizar geom_bin2d() ó 
#geom_bar() y coord_flip(), si es necesario para visualizar mejor tus gráficas)

esp %>% ggplot(aes( x = CountryCode, y=Percentage, fill = IsOfficial )) + 
  geom_bin2d() +
  coord_flip()
