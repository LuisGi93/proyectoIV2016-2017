#Bot de Telegram:  queveobot.

[![Build Status](https://travis-ci.org/LuisGi93/proyectoIV2016-2017.svg?branch=master)](https://travis-ci.org/LuisGi93/proyectoIV2016-2017)


[![Docker](http://i63.tinypic.com/2dqt74p.jpg)](https://hub.docker.com/r/luisgi93/proyectoiv2016-2017/)

### 1.- Descripción.


El proposito del proyecto es desarrollar un bot que aconseje peliculas según el titulo de una pelicula. Por ahora solo admite titulos en ingles.

Se pretende  desarrollar los siguientes servicios:

 -   Servicio de logs para poder almacenar todo lo que le ocurre al bot.
 -   Servicio de traducción de peliculas ya que ahora mismo solo reconoce peliculas en ingles.


Además se puede expandir con más funcionalidades como guardar las peliculas que ha visto el usuario, votar peliculas y mostra peliculas más populares entre los usuarios. También se puede estudiar crear un sistema interno de recomendación para no depender de [Tastekid](http://www.tastekid.com).



### 2.- Instalación 

#### 2.0- Prerequisitos:

- Ruby >2.1
- En distribuciones debian/ubuntu los siguientes paquetes : ruby ruby-dev build-essential libpq-dev
- Crear bot Telegram via Godfather. 
- Tener base de datos tipo postgres 
- Tener cuenta en  [Tastekid](http://www.tastekid.com). 



#### 2.1- Instalación a partir del código fuente:

1. Clonar el repositorio.
2.  Instalar bundler: 
```shell
$ gem install bundler
```


descomprimir y en el directorio donde se han descomprimido los fuentes ejecutar:

```shell
$ bundle install
```
Es necesario definir tres variables de entorno
TOKEN, TOKEN_TASTEKID y POSTGRES_DATABASE. La primera con el token asociado a nuestro bot de telegram y el segundo token es necesario solicitarlo en la web tastekid.com y la tercera es la variable de la base de datos tipo postgres.

Para ejecutar el bot:
```shell
$ ruby bin/run.rb
```

#### 2.2- Instalación a partir de imagen docker:

El proyecto cuenta con una imagen tipo docker para instalarla ejecutamos la orden:

```
docker pull luisgi93/proyectoiv2016-2017
```

Tras lo cual accedemos al contenedor utilizando la orden:

```
docker run -e "TOKEN=xxx" -e "TOKEN_TASTEKID=xxx" -e "POSTGRES_DATABASE=xxx"  -i -t luisgi93/proyectoiv2016-2017 /bin/bash
```
- TOKEN: Token obtenido al dar de alta nuestro bot en  Telegram.
- TOKEN_TASTEKID: Token obtenido al crearnos cuenta en tastekid y pedir acceso a su API.
- POSTGRES_DATABASE: dirección de base de datos tipo Postgres.

## 3.- Despliegue en heroku


Si se quiere desplegar en heroku es necesario en primer lugar descargase la linea de ordenes de heroku y después:

1.  Crear aplicación en heroku:

 ```
 heroku apps:create --region eu queveobot
 ```
 2.  Crear el fichero Procfile e insertar en el:
 
 ```
bot: ruby bin/queveo.rb
 ```
 3. Definir variables de entorno:

 
 ```
 heroku config:set TOKEN=nanana
 heroku config:set TOKEN_TASTEKID=nanana
 heroku config:set POSTGRES_DATABASE=nanana
 ```
 
 4. Definir en heroku deploy via github. En  "Settings" en el apartado de nuestra aplicación en heroku,  "Deploy"  "github", seleccionamos master.
 
 5. Arrancar la aplicación:

 ```
heroku ps:scale bot=1
 ```
 
 
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

 
 ![img](https://i.sli.mg/YbLCeH.png)
 
 

