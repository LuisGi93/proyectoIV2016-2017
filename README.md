#Proyecto Infraestructura virtual. queveobot
[![Build Status](https://travis-ci.org/LuisGi93/proyectoIV2016-2017.svg?branch=master)](https://travis-ci.org/LuisGi93/proyectoIV2016-2017)

##1.- Descripción.

El fin del proyecto a desarrollar es ~~una web~~ un bot de Telegram que aconseje peliculas a un usuario que interaccione con el (él o el, objeto :?). Por tanto a traves de la interfaz de Telegram se llevará a cabo la interacción entre máquina y hombre de tal forma que ambos mutuamente comprendan que es lo que quieren de cada uno.

Los servicios *mínimos* que necesita el bot son:
 - Servicio que al recibir el nombre de una pelicula obtenga peliculas parecidas y responda. El usuario podrá indicar que peliculas ha visto y el bot devolverá el resultado en función de la información almacenada sobr el usuario. Actualemente se está estudiando que más funcionalidades se pueden expandir por aqui.

Otros servicios:
 - Servicio de logs para poder almacenar todo lo que le ocurre al bot.
 - Servicio que monitorize el estado de todos los demás servicios y en caso de detectar fallo en alguno avise al responsable humano via email o via telegram.
 - Primer servicio que reciba las peticiones y le pase la pelota al servicio correspondiente.

Idealmente se preveé el uso de un servidor para cada servicio pero probablemente se tendrá que aglutinar algunos de los servicios en el mismo. Será necesario almacenar que peliculas ha visto que usuario para lo cual se utilizará una base de datos y posiblemente otra base de datos para almacenar todos los logs que genere el bot. No se descarta la modificación de esta estructura ni de la eliminación de servicios o de añadir más en función del desarrollo del proyecto.

El lenguaje elegido para desarrollar el bot es ~~python~~ Ruby.
###1.1.- Que vamos a utilizar
Como es lógico para realizar el proyecto se utilizará el desarrollo basado en pruebas junto con integración continua para lo cual más adelante se especificarán que herramientas utilizaremos.  Las herramientas exactas a utilizar se verá conforme avanze el proyecto.

## 2.- Desarrollo basado en pruebas. Hito 2.<sub><sup>Entrega la he realizado a las 14:20 según el bot la hora tope era a las 14:30 sino tengo retraso :S la lié con el git</sup></sub>


### 2.1- Herramientas de desarrollo
Para controlar que la aplicación funciona para diferentes versiones de Ruby se utiliza RVM, actualmente se ha testeado que funciona tanto para la versión 2.3.1 de Ruby y para la 2.2.5.


![img](https://i.sli.mg/ZdCfmm.png)
### 2.2.- Construcción de la aplicación

Se utiliza [Bundler](http://bundler.io/) para especificar todas las dependencias asociadas a la aplicación y poder instalar todo lo necesario de manera automática.
En la parte de integración continua viene el contenido de nuestro [Gemfile](https://github.com/LuisGi93/proyectoIV2016-2017/blob/master/Gemfile) donde se detalla que hace Travis para instalar todo lo que necesita nuestra aplicación que básicamente es ejecutar:
```shell
$ bundle install
```
Esta orden lee el Gemfile:

```ruby
source 'https://rubygems.org'
gem 'telegram-bot-ruby'
gem 'yard'
gem 'nokogiri'
gem 'mechanize'
gem 'em-resolv-replace'
gem 'json'
gem 'test-unit'
gem 'shoulda'
gem 'rspec'
gem 'dbi'

group :test do
  gem 'rake'
end
```

Buscar todas las dependencias/gemas/librerias en las páginas que le indiquemos en mi caso: rubygems.org y a continuación procede a instalarlas. Ejemplos de dependencias como se ven  son la gema 'json', la de 'nokogiri'....

### 2.3.- Test

Utilizamos [Shoulda](https://github.com/thoughtbot/shoulda) y el framework para testing de Ruby  [Test::Unit](http://ruby-doc.org/stdlib-1.8.7/libdoc/test/unit/rdoc/Test/Unit.html) de Ruby para la creación de los test y para probar automáticamente que los test  se pasan correctamente utilizamos [Rake](https://github.com/ruby/rake).
Para que Rake pueda saber que hacer es necesario especificarselo en un fichero de configuración llamado [Rakefile](https://github.com/LuisGi93/proyectoIV2016-2017/blob/master/Rakefile):
```ruby
require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs << "lib"
  t.test_files = FileList['test/test_*.rb']
  t.verbose = true
  t.warning = false
end

task :default => :test
```

Que básicamente le está diciendo que cargue los ficheros fuents de la aplicación que se encuentran en el directorio lib, que cargue también todos los ficheros contenidos en la carpeta test de la aplicación que empiezan por la palaba test_ y acaben en .rb, tambien especifica que no se quiere que imprima warnings y que de detalles de lo que ha hecho como salida.
El `task :default => :test` es debido a que Rake suele ser muy utilizado para más cosas aparte de para el testeo como por ejemplo borrar, construir ficheros, empaquetar... en el se especifica mediante "tasks" todo lo que se desea que haga Rake cuando se le llama. En mi caso solamente quiero  que ejecute los tests asi que le especifico como la tarea por defecto que ejecute los test definidos.

Cada uno de los ficheros de testeo definidos dentro de la carpeta test tiene en su interior una serie de aserciones asociadas a una clase de ruby  y cada una de estas asercciones comprueba alguna función de la clase sobre la que versa el fichero.

La combinación de Shoulda y Test::Unit y no de otras herramientas para testeo de aplicaciones en Ruby a sido por su facilidad de uso, su utilización extendida para crear  los test y su claridad para expresar que es lo que hace el test.

Se pueden ejecutar los test con el comando:
```
rake test
```

![img](https://i.sli.mg/1jXIci.png)
### 2.4.- Integración continua.

Para comprobar que los cambios realizados en nuestra aplicación "funcionan" fuera de nuestro entorno de desarrolo y que la instalación de dependencias y la ejecución de los tests se realiza automáticamente utilizamos [Travis](https://travis-ci.org/). Para que Travis pueda "probar" nuestra aplicación escribimos en un fichero [.travis.yml](https://github.com/LuisGi93/proyectoIV2016-2017/blob/master/.travis.yml) la configuración que utiliza nuestra aplicación en el cual por ejemplo indicamos que nuestra aplicación utiliza el Lenguaje Ruby y las versiones de Ruby que utiliza nuestra aplicación. El contenido de nuestro fichero .travis.yml es el siguiente:
```
language: ruby
rvm:
  - "2.2.5"
  - "2.3.1"
environment:
  RUBYOPT: W0
```

En el se indica que la aplicación quiere que se ejecute para las versiones de Ruby 2.2.5 y para la 2.3.1 la variable RUBYOPT: W0 es para silenciar algunos warnings que aparecián debido a que la gema "DBI" utiliza funciones que estan "depreceated" y entorpecían la visibilidad de los tests.

Como bien se indica en la [documentación de Travis](https://docs.travis-ci.com/user/languages/ruby/) para ruby para que travis pueda ejecutar los tests asociados a nuestro proyecto es necesarios especificar que se utiliza Rake en la "gema" de nuestra aplicación:
```ruby
...
gem 'rspec'
gem 'dbi'

group :test do
  gem 'rake'
end
```

Como se puede ver en nuestra gema se especifica todas las "librerias" externas que necesita nuestro proyecto para funcionar y en el se incluye rake tal cual nos indica la documentación de Travis. Esta gema es también la utilizada por Bundler para instalar todas las dependencias  y lo que hace es buscar todas estas dependencias en las páginas que le indiquemos en mi caso: rubygems.org.

Cuando subimos el proyecto a Travis lo primero que hace es activar RVM, cargar la versión de ruby que le hemos descrito y ejecutar el comado:
```
bundle install
```

![img](https://i.sli.mg/OvlcRv.png)


Tras lo cual si se ha podido instalar todo correctamente ejecuta  Rake.A continuación utiliza Rake para la ejecución de los test especificados en nuestro fichero [Rakefile](https://github.com/LuisGi93/proyectoIV2016-2017/blob/master/Rakefile)

Travis por defecto cada vez que realizamos un commit a alguno de nuestros repositorios configurados:

![img](https://i.sli.mg/X3XzbT.png)
Ejecuta los tests y nos mostrará si los cambios en nuestro repositorio de github pasan los test que les hemos descrito:

![img](https://i.sli.mg/w1n6sc.png)



La utilización de Travis viene justificada por su uso extendido, su facil integración con cualquier cambio que hagas sobre tu repositorio de Github y su amigable utilización.


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
