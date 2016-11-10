#Bot de Telegram:  queveobot.

[![Build Status](https://travis-ci.org/LuisGi93/proyectoIV2016-2017.svg?branch=master)](https://travis-ci.org/LuisGi93/proyectoIV2016-2017)

### 1.- Descripción.

El proyecto a desarrollar es un bot de Telegram que recomendará peliculas a un usuario que contacte con el  en función del titulo de una pelicula. Este bot tiene que ser capaz de guardar que peliculas le ha pedido el usuario para no recomendarle peliculas que ya ha visto. También se están estudiando funcionalidades adicionales tales como hacer un sistema de votación para peliculas y mostrar las peliculas más populares entre los usuarios. 

Además se pretenden implementar los siguientes servicios:


 -   Servicio de logs para poder almacenar todo lo que le ocurre al bot.
 -  Servicio que monitorize el estado de todos los demás servicios y en caso de detectar fallo en alguno avise al responsable humano via email o via telegram.
 -  Primer servicio que reciba las peticiones y le pase la pelota al servicio correspondiente.
 -   Servicio de traducción de peliculas ya que ahora mismo solo reconoce peliculas en ingles.

El lenguaje elegido para desarrollar el bot es ~~python~~ Ruby.

###1.1.- Instalación.

Descargar desde github el proyecto como zip e instalar bundler:

```shell
$ gem install bundler
```


descomprimir y en el directorio donde se han descomprimido los fuentes ejecutar:

```shell
$ bundle install
```
Es necesario definir dos variables de entorno
TOKEN y TOKEN_TASTEKID. La primera con el token asociado a nuestro bot de telegram y el segundo token es necesario solicitarlo en la web tastekid.com


Actualmente el bot no se ejecuta automáticamente y por ahora solo responde cuando le mandas los comandos básicos.



## 3.- Despliegue en heroku



#### 3.1- Despliegue:

En primer lugar nos descargamos la linea de comandos de heroku utilizando la orden

 ```
 wget -O- https://toolbelt.heroku.com/install-ubuntu.sh | sh
 ```
 
 Tras lo cual procedemos a loguearnos utilizando heroku login y creamos nuestra aplicación utilizando la orden:
 
 ```
 heroku apps:create --region eu queveobot
 ```
 
 Una vez hecho esto creamos el fichero Procfile:
 
 ```
bot: ruby bin/queveo.rb
 ```
 

 
 Una vez hecho esto definimos las variables de entorno que va a utilizar nuestra aplicación una vez la subamos en heroku con el comando:

 
 ```
 heroku config:set TOKEN=nanana
 heroku config:set TOKEN_TASTEKID=nanana
 heroku config:set POSTGRES_DATABASE=nanana
 ```
 
Tras lo cual nos vamos en heroku.com al apartado settings de nuestra aplicación, nos vamos a la pestaña "Deploy"  marcamos como método de deploy "github", seleccionamos master.

A continuación debido a que no estamos utilzando en el Procfile la tarea "web" tenemos que decirle a heroku que le asigne un dino a la tarea "bot" para ello utilizamos el siguiente comando:

 ```
heroku ps:scale bot=1
 ```

Es necesario crear la base de datos que utliza el bot para ello nos vamos a heroku.com  y alli creamos una base de datos postgres 
y copiando la url que nos indicaban en le apartado settings config vars se la asignamos a POSTGRES_DATABASE.
 
 
 
#### 3.2.- Uso del bot:
 

El bot recomienda peliculas, música, libros basandose en un titulo  que le mandes, para ello hace falta mandar un mensaje  siguiendo el siguiente formato:
 
 ```
 /queveo el titutlo de lo que sea
 ```

Ejemplo:
 ```
 /queveo the godfather
 /queveo mozart
 /queveo Titanic
 ```
