#Predicción de sobrevivientes en el Titanic
##Repositorio de experimentos
**Acerca de:** Este repositorio se crea con la intención de dar seguimiento a los experimentos realizados sobre el [dataset](https://www.kaggle.com/c/titanic/data) de la competición [*Titanic: Machine Learning from Disaster*](https://www.kaggle.com/c/titanic) en la plataforma [Kaggle](https://www.kaggle.com/)

**Herramienta utilizada:** R Studio, versión 3.2.5

**Usuario en Kaggle:** [jmrodriguez90](https://www.kaggle.com/jmrodriguez90)

[![GPL V3](http://www.openra.net/images/gplv3.svg)](http://www.gnu.org/licenses/gpl-3.0.html)



---

###Instalación de R
Para instalar R, habrá que dirigirse a su [página web](https://www.r-project.org/) para descargarlo. Pedirá que se elija el [servidor geográfico del cuál descargarlo](https://cran.r-project.org/mirrors.html), esto ayudará para que el lenguaje aparezca en español. Una vez se haya seleccionado el servidor, lanzará directamente la página con el [enlace de descarga](http://www.est.colpos.mx/R-mirror/) para los distintos sistemas operativos.

La instalación sobre Windows que fue la realizada en este ejercicio no contiene nada diferente a una instalación cualquiera en Windows, mediante el asistente de instalación marcando siguiente en las casillas se llega a instalar R sin ningún contratiempo.

####Instalación de paquetes en R.
La instalación que se realizó es básica, por esto se tendrán que instalar los paquetes necesarios para los experimentos que se realicen. Para la instalación de paquetes, en el menú superior encontraremos la pestaña *Paquetes* en la que  encontraremos a su vez la opción *Instalar paquete(s)*, al hacer clic, inmediatamente nos lanza una ventana en la que podremos elegir en qué servidor bucar paquetes, para efectos de este ejercicio se ha seleccionado la primera opción *HTTPS*, cuando se haya seleccionado lo anterior, aparecerá el abanico de paquetes que se pueden utilizar, haciendo doble clic sobre cualquiera lo instalaremos.

Cuando se necesite utilizar un paquete puede hacerse de la siguiente manera:

`>` `library(ggplot2)`

Si quisiera utilizarse el paquete ggplot por ejemplo.



###Experimentos

####Prueba 1 sobre los datos
* Técnica usada: randomFores
* Detalles: 
  * Aplicación de 100 árboles de decisión tomando como variable objetivo la supervivencia de las personas.
* Experiencia adquirida: Una primera interacción con R, leyendo los comandos utilizados e interpretándolos. La carga de un dataset dentro de una variable. La exportación de un archivo de imagen. Instalación y carga de paquetes. EL score subió a 0.78469

####Prueba 2 sobre los datos
* Técnica usada: randomFores
* Detalles: 
  * Repetición de randomForest con 50 árboles
* Experiencia adquirida: disminución de score a 0.77033

####Prueba 3 sobre los datos
Técnica usada: randomFores
Detalles: 
Repetición de randomForest con 300 árboles
Experiencia adquirida: El score subió a 0.77990 pero sigue por debajo de usar sólo 100 árboles.

####Prueba 4 sobre los datos
* Técnica usada: MissingValues 
* Detalles: 
  * Combinando los datos de entrenamiento y test para facilitar el preprocesado de valores perdidos
  `train<-rbind(train, cbind(test, Survived=rep(NA, nrow(test))))`
  * Revisando los valores perdidos, para esto fue necesaria la librería Reshape
  ```
  train.miss <- melt(apply(train[, -2], 2, function(x) sum(is.na(x) | x=="")))
  cbind(row.names(train.miss)[train.miss$value>0], train.miss[train.miss$value>0,])
  
  >      [,1]       [,2]  
  >  [1,] "Age"      "263" 
  >  [2,] "Fare"     "1"   
  >  [3,] "Cabin"    "1014"
  >  [4,] "Embarked" "2"
  La variable "cabin" tiene demasiados valores perdidos o que no aplican por lo que se omitirá en el ejercicio, con las otras variables se puede obtener resultados y sustituir por los valores más comunes en cada una.
  Experiencia adquirida:  Preprocesado de datos, lectura de variables, reorganización de datos en función de su contenido. Una vez realizada la limpieza de los datos, el score se mantuvo en 0.78469, no hubo cambios en relación al randomForest.
  ```
  
####Prueba 5 sobre los datos
* Técnica usada: MissingValues
* Detalles: 
  * Creación de una nueva variable que posea los títulos de las personas
  ```
  > train$Title<-regmatches(as.character(train$Name),regexpr("\\,[A-z ]{1,20}\\.", as.character(train$Name)))
  > train$Title<-unlist(lapply(train$Title,FUN=function(x) substr(x, 3, nchar(x)-1)))
  > table(train$Title)
  Agrupar los titulos en iguales.
  > train$Title[which(train$Title %in% c("Mme", "Mlle"))] <- "Miss"
  > train$Title[which(train$Title %in% c("Lady", "Ms", "the Countess", "Dona"))] <- "Mrs"
  > train$Title[which(train$Title=="Dr" & train$Sex=="female")] <- "Mrs"
  >  train$Title[which(train$Title=="Dr" & train$Sex=="male")] <- "Mr"
  > train$Title[which(train$Title %in% c("Capt", "Col", "Don", "Jonkheer", "Major", "Rev", "Sir"))] <- "Mr"
  > train$Title<-as.factor(train$Title)
  ```
* Experiencia adquirida: Creación de nuevas variables a partir de la información, manipulación de una variable nueva. El score se mantuvo en 0.78469

####Prueba 6 sobre los datos
* Técnica usada: MissingValues
* Detalles: 
  * Dejar al capitán cómo un título más y no agregarlo a la categoría Mr.
* Experiencia adquirida: No favoreció ni perjudicó en nada. El score se mantuvo en 0.78469

####Prueba 7 sobre los datos
* Técnica usada: MissingValues y randomForest
* Detalles: 
  * Aplicación de un randomForest luego de valores perdidos
* Experiencia adquirida: El score bajó a 0.74641

####Prueba 8 sobre los datos
* Técnica usada: XGBoost
* Detalles: 
  * Usando la librería XGBoost para agrupar un conjunto de árboles de decisión que hasta ahora había sido lo que mejores resultados daba.
* Experiencia adquirida: El score bajó a 0.71770

####Prueba 9 sobre los datos
* Técnica usada: MissingValues y randomForest
* Detalles: 
  * Reagrupar los títulos de cada persona e intentar predecir en función de si es mujer o niño que según la historia se sabe que fueron los primeros en abordar los barcos salvavidas. Crear una variable que determine si la persona es madre en el caso de ser mayor de 18 años, que su título sea distinto a “Miss”, que su género sea mujer y que el número de parientes a bordo sea mayor a cero.
  * Introducir en un randomForest estos valores para luego predecir en función del título de cada persona y su condición de mujer o niño.
* Experiencia adquirida: Creación de nuevas variables que dependan de características en los datos. EL score subió a 0.80383

####Prueba 10 sobre los datos
* Técnica usada: MissingValues y randomForest
* Detalles: 
  * Eliminar la variable madre y estimar sólo en función de mujeres y niños.
* Experiencia adquirida: El score bajó a 0.76077, la variable madre combinada con la variable título es clave para avanzar.


####Prueba 11 sobre los datos
* Técnica usada: MissingValues y randomForest
* Detalles: 
  * Usar 200 árboles de decisión en al mismo ejemplo de la prueba 9
* Experiencia adquirida: Con más árboles, se tiende a sobre aprender y la solución se aleja de ser precisa.

####Prueba 12 sobre los datos
* Técnica usada: MissingValues y randomForest
* Detalles: 
  * Usar 50 árboles de decisión en al mismo ejemplo de la prueba 9 
* Experiencia adquirida: El score bajó, 100 árboles es la mejor opción cómo en la primer prueba de randomForest.

###Tabla de Resumen

Nº | Descripción de manipulación de datos | Resumen de algoritmos y software empleados | Fecha | Score | Posición |
:---:|:---:|:---:|:---:|:---:|:---:|
1 | Primer experimento con los datos en bruto y usando la clase Survived como clase objetivo. | randomForest con R | 17/04 | 0.78469 | 1977 |
2 | Repetición de randomForest con 50 árboles | randomForest con R | 17/04 | 0.77033 | 1979 |
3 | Repetición de randomForest con 300 árboles | randomForest con R | 17/04 | 0.77990 | 1979 |
4 | Pre procesadode los datos revisando los valores perdidos y agregando en su lugar el resultado más común en cada variable. | Valores perdidos con R | 5/05 | 0.78469 | 1981 |
5 | Crear nuevas variables de títulos a las personas, “Mr.”, “Mrs.”, “Cap.” | Valores perdidos con R | 5/05 | 0.78469 | 1981 |
6 | Dejar al capitán cómo un título más y no agregarlo a la categoría Mr. | Valores perdidos con R | 5/05 | 0.78469 | 1981 |
7 | Aplicación de un randomForest luego de valores perdidos | MissingValues y randomForest | 17/04 | 0.74641 | 1981 |
8 | agrupar un conjunto de árboles de decisión con XGBoost | XGBoost | 4/05 | 0.71770 | 1981 |
9 | Reagrupar los títulos de cada persona e intentar predecir en función de si es mujer o niño | MissingValues y randomForest | 4/05 | 0.80383 | 813 |
10 | Eliminar la variable madre y estimar sólo en función de mujeres y niños. | MissingValues y randomForest | 4/05 | 0.76077 | 813 |
11 | Usar 200 árboles de decisión en al mismo ejemplo de la prueba 9 | MissingValues y randomForest | 5/05 | 0.76077 | 813 |
12 | Usar 50 árboles de decisión en al mismo ejemplo de la prueba 9 | MissingValues y randomForest | 5/05 | 0.76077 | 813 |

###Bibliografía
* (s.f.). Obtenido de http://rstudio-pubs-static.s3.amazonaws.com/24969_894d890964fd4308ab537bfde1f784d2.html
* (s.f.). Obtenido de https://www.kaggle.com/benhamner/titanic/random-forest-benchmark-r/
* (s.f.). Obtenido de https://www.kaggle.com/mrisdal/titanic/exploring-survival-on-the-titanic/comments
* (s.f.). Obtenido de https://github.com/wehrley/wehrley.github.io/blob/master/SOUPTONUTS.md
* (s.f.). Obtenido de https://statsguys.wordpress.com/2014/01/03/first-post/
* (s.f.). Obtenido de http://trevorstephens.com/post/73770963794/titanic-getting-started-with-r-part-5-random
* (s.f.). Obtenido de http://trevorstephens.com/post/72916401642/titanic-getting-started-with-r
* (s.f.). Obtenido de https://www.datacamp.com/courses/kaggle-tutorial-on-machine-learing-the-sinking-of-the-titanic?utm_source=kaggle-ml-launch&utm_medium=blog&utm_campaign=kaggle-ml-launch

[*José Manuel Rodríguez*](http://twitter.com/Jose_M01)
