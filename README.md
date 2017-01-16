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


## 3.- PaaS


#### 3.1- Porqué heroku:
1. en primer lugar porque estaba desarrollado en ruby lo cual me daba la sensación que al desplegar una aplicación escrita en ruby sería más facil que en otros PaaS

2. En segundo lugar porque es muy conocido y por su buena documentación. Por ejemplo en los ejercicios he utilizado Bluemix, en Bluemix necesité un par de horas para comprender como se podía desplegar utilizando git y aun así aun no he conseguido comprender como hacer que solamente se despligue en Bluemix la aplicación cuando se pasan los test.

3. Por  la facilidad para añadir bases de datos a las aplicaciones tardas apenas  5 minutos.

#### 3.1- Despliegue:

En primer lugar nos descargamos la linea de comandos de heroku utilizando la orden

 ```
 wget -O- https://toolbelt.heroku.com/install-ubuntu.sh | sh
 ```
 
 Tras lo cual procedemos a loguearnos utilizando heroku login y creamos nuestra aplicación en Europa utilizando la orden:
 
 ```
 heroku apps:create --region eu queveobot
 ```
 
 Una vez hecho esto creamos el fichero Procfile donde describimos "tipo" de aplicación y como arrancarla. Como nuestra aplicación no está escuchando para recibir tráfico https pues la declaramos en el Procfile de la siguiente forma:
 
 ```
bot: ruby bin/queveo.rb
 ```
 
 Según la documentación de heroku lo que viene a la izquierda de los ":"  define la "tarea" que realiza, en mi caso  la tarea "bot" es el proceso que escucha y como por ahora no tengo subprocesos lo dejo asi.
 
 Como no queremos probar la aplicación antes de subirla hacemos uso del comando:
 ```
 heroku local bot
 ```
 
 Con lo cual comprobamos posibles fallos, como por ejemplo que se nos haya olvidado declarar las variables de entorno:
 ![img](https://i.sli.mg/GZCRHJ.png)
 

 
 Para que heroku local pueda conocer las variables de entorno hay que definirlas en un fichero .env poniendo cada token de la forma TOKEN=" " tras lo cual ya es posible probar nuestra aplicación en local antes de subirla utilizando heroku local.
 
 ![img](https://i.sli.mg/Z7sG4k.png)
 
 Una vez hecho esto definimos las variables de entorno que va a utilizar nuestra aplicación una vez la subamos en heroku con el comando:

 
 ```
 heroku config:set TOKEN1=nanana
 ```
 
Tras lo cual nos vamos en heroku.com al apartado settings de nuestra aplicación, nos vamos a la pestaña "Deploy"  marcamos como método de deploy "github", seleccionamos master y en deploy automático marcamos la casilla "wait for CI.." de tal manera que si Travis marca error no se lanze en heroku.

A continuación debido a que no estamos utilzando en el Procfile la tarea "web" tenemos que decirle a heroku que le asigne un dino a la tarea "bot"
:

![img](https://i.sli.mg/cpvf3S.png)


 La base de datos que utiliza el bot la habiamos creado anteriormente utilizando heroku.com y copiando la url que nos indicaban en le apartado settings config vars para que la utilizara nuestro bot.
 
 
 
#### 3.2.- Uso del bot:
 

Para agregar al bot accedemos a https://telegram.me/queveobot .
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
 El título tiene que estar en ingles, más adelante si da tiempo se pondrá en español. Ej:
 
 ![img](https://i.sli.mg/YbLCeH.png)
 
 
 Actualmente el bot guarda todos los mensajes que se le envian a la base de datos a modo de logs y más adelante se guardará información que le especifique el usuario como peliculas que ya ha visto para que no se muestren en las sugerencias.

Podemos observar todos los mensajes que tenemos registrados en nuestra base de datos que ha recibido el bot:

![img](https://i.sli.mg/SVyRUg.png)



## 4.- Contenedores.

#### 4.1.- Creación contenedor.
En este apartado describimos como creamos un contenedor en el cual esten contenido todo lo necesario para poder ejecutar nuestra aplicación.

Como vamos a utilizar docker necesitamos decirle a docker que acciones debe realizar para poder crear un contenedor en el cual estará confinada nuestra aplicación. Para ello creamos un archivo llamado Dockerfile:

```
FROM ubuntu:latest

MAINTAINER Luis Gil Guijarro <luisgguijarro9@gmail.com>


ARG TOKEN
ARG TOKEN_TASTEKID
ARG POSTGRES_DATABASE

ENV TOKEN=$TOKEN
ENV TOKEN_TASTEKID=$TOKEN_TASTEKID
ENV POSTGRES_DATABASE=$POSTGRES_DATABASE


RUN apt-get update
RUN apt-get install -y git ruby ruby-dev build-essential libpq-dev

RUN gem install bundler

RUN git clone https://github.com/LuisGi93/proyectoIV2016-2017
WORKDIR proyectoIV2016-2017
RUN bundle install

```

Con los ```ARG``` definimos los datos que se van a pasar como parámetros via linea de comandos, con ```ENV``` las variables de entorno que va a usar nuestra aplicación estas variables de entorno cogen el valor de los parámetros que se le pase al docker por linea de comandos, tras esto instalamos los paquetes que necesita nuestra aplicación, clonamos el repositorio de la aplicación, instalamos dependencias y echamos a andar a el bot.

Tras probar todo esto seguimos los pasos de la [documentación oficial](https://docs.docker.com/engine/getstarted/step_four/) y localmente construimos el contenedor con la orden: 
```
docker build -f Dockerfile -t queveobot .
```

Tras probar que funciona correctamente el contenedor creado lo subimos al dockerhub.

#### 4.2.- Dockerhub.

Una vez que nos hemos registrado en dockerhub y  hemos subido el Dockerfile al repositorio del proyecto ligamos nuestra cuenta de github a la de dockerhub y a continuación nos vamos a "Create Automated Build".

![img](https://i.sli.mg/GUp1l1.png)
<sup>Tras crear "Automated Build" para el repositorio de la asignatura.</sup>


Realizamos un push en nuestro repositorio del proyecto para que dockerhub lo detecte y comienze a crear la imagen.

![img](https://i.sli.mg/9KkNLI.png)
<sup>Tras realizar push y imagen se construye correctamente.</sup>

Tras comprobar que se ha construido correctamente la imagen docker a partir del código de nuestro proyecto nos la descargamos y comprobamos que funciona como debe.

![img](https://i.sli.mg/pHqOkR.png)
<sup>Nos descargamos la imagen a partir del repositorio de dockerhub.</sup>

Tras la descarga se ejecuta la aplicación mediante la orden:

```
docker run -e "TOKEN=xxx" -e "TOKEN_TASTEKID=xxx" -e "POSTGRES_DATABASE=xxx"  -i -t luisgi93/proyectoiv2016-2017 /bin/bash
```

y una vez se nos habre el shell en el contenedor ejecutamos:

```
ruby bin/run.rb
```


## 5.- Despliegue en IAAS: AWS.

#### 5.1.- Configuración aws:

En primer lugar nos descargamos el awscli utilizando pip:
```
pip install awscli
```

Tras lo cual es necesario darle nuestras credenciales para ello utilizamos el comando ``` aws configure ```el cual nos pedirá nuestra Access Key ID y Secret Access Key las cuales las podemos obtener en la página  https://qwiklabs.com/dashboard a la que accedemos tras hacer log in en qwiklabs.

![img](https://i.sli.mg/iqEXsz.png)

Tras esto consultamos la [pagina](https://github.com/mitchellh/vagrant-aws) de vagrant-aws y lo primero que hacemos es instalar el plugin vagrant-aws haciendo uso del comando ```vagrant plugin install vagrant-aws```.  Una vez realizado esto vemos como que necesitamos cuatro cosas:

 *   aws.access_key_id = "YOUR KEY"
 *   aws.secret_access_key = "YOUR SECRET KEY"
 *   aws.session_token = "SESSION TOKEN"
 *   aws.keypair_name = "KEYPAIR NAME"

Las tres primeras las podemos obtener utilizando el comando:

```
aws sts get-session-token
```
Que te da unas credenciales válidas por 48h. Tras esto siguiendo las instrucciones en la [documentación de aws](http://docs.aws.amazon.com/cli/latest/userguide/cli-ec2-keypairs.html) creamos un fichero .pem utilizando el comando:

```
 aws ec2 create-key-pair --key-name millave4 --query 'KeyMaterial' --output text > millave4.pem
```

Y le damos permisos 400 utilizando chmod. Por  último necesitamos crear un grupo de seguridad en aws y abrir los puertos que necesita nuestra aplicación en mi caso solamente el 22 para acceso ssh. Creamos el grupo utilizando la linea de comandos:

```
aws ec2 create-security-group  --group-name migruposeguro --description "Solo lo uso yo"

```
Tras lo cual procedemos a abrir los puertos yo he utilizado la página web para ello debido a que por alguna razón los cambios realizados con la terminal no se reflejaban en la web. Para abrirlos con la web no es más que irse a aws.amazon.com desde la página de qwiklabs y una vez en el dashboard ir a "Security Groups"


 Nos vamos  al apartado security groups en aws.amazon.com y le damos  editar "Inbound " ponemos tipo ssh puerto 22  source 0.0.0.0/0 y ya tenemos todo lo necesario.
 ![img](https://i.sli.mg/MHSUzX.png)


#### 5.2.- Vagrantfile:

Para poder desplegar en aws utilizando vagrant necesitamos un Vagrantfile:
```
Vagrant.configure("2") do |config|
  config.vm.box = "dummy"

  config.vm.define "queveobot-aws" do |host|
    host.vm.hostname = "queveobot-aws"
  end
  config.vm.provider :aws do |aws, override|
    aws.access_key_id = ""
    aws.secret_access_key = ""
    aws.session_token = ""
    aws.keypair_name = "millave4"
    aws.region= "us-west-2"
    aws.security_groups = "migruposeguro"
    aws.instance_type= 't2.micro'
   
    aws.ami = "ami-d57dcfb5"

    override.ssh.username = "ubuntu"
    override.ssh.private_key_path = "millave4.pem"
  end
  
    config.vm.provision :ansible do |ansible|
	ansible.playbook = "queveobot.yml"
	ansible.force_remote_user= true
	ansible.host_key_checking=false
  end
end
```
Donde :


* ```   host.vm.hostname = "queveobot-aws" ```: indica el nombre que va a tener nuestra máquina virtual.
* ```    aws.access_key_id = ""
    aws.secret_access_key = ""
    aws.session_token = "" ``` Son nuestras credenciales
* ```aws.keypair_name = "millave4"```  Indica el nombre indicado con  ... --key-name millave4 ...

* ```aws.region= "us-west-2" ``` las claves de amazon sumistradas solamente sirven para la región us-west-2 aka Oregon en amazon aws sino da fallo de autenticación. Es necesario también haber indicado us-west-2 a la hora de haber hecho el aws configure.

* ```aws.security_groups = "migruposeguro"``` "Security group" creado anteriormente con permiso de acceso ssh en el puerto 22.

* ```aws.instance_type= 't2.micro'```  se pueden ver en: [enlance](https://aws.amazon.com/ec2/instance-types/) el micro da un gb de ram y 6 cores suficientes para mi apliacón. No he probado si deja crear con otra arquitectura.

* ```aws.ami = "ami-d57dcfb5"``` La imagen que se va usar para crear la máquina virtual, podemos encontrar las imágenes basadas en ubuntu en [ubuntu amazon ec2](https://cloud-images.ubuntu.com/locator/ec2/). Importante filtrar por  las imagenes disponibles en la región us-west-2 y que el tipo sea ebs. La ami-d57dcfb5 pertenece a Ubuntu 14.04.

* ```override.ssh.username = "ubuntu"``` por defecto para las máquinas ubuntu. Es el usuario con el cual se puede acceder utilizando ssh a la máquina virtual una vez creada no es vagran@1.1.1.1 ni ec2-user@1.1.1.1

* ```override.ssh.private_key_path = "millave4.pem"``` El path donde se encuentra la .pem creada con aws ec2 create-key-pair .. > millave4.pem.

*   ```  config.vm.provision :ansible do |ansible| ```  para configurar el aprovisionador en mi caso ansible con ```ansible.playbook = "queveobot.yml" ``` indicamos el path del playbook que tiene que ejecutar ansible,  ```ansible.force_remote_user= true``` obliga a ansible a logearse via ssh con el usuario definido en ```override.ssh.username```  y por último ``` ansible.host_key_checking=false ``` para evitar que ansible se quede colgado cuando acceda utilizando ssh al saltar el mensaje "desea añadir esta clave con fingerprint: 1234 a los hosts conocidos. 


Con esto hecho ya es posible crear nuestra máquina virtual abriendo un shell en el directorio en el que se encuentra el Vagrantfile y ejecutar la orden vagrant up --provider=aws:
![img](https://i.sli.mg/bZxs3U.png)

Notese el "fallo" al llegar a la parte en la que comienza a ejecutarse ansible esto se debe a que en el campo hosts de nuestro playbook queveobot.yml le hemos indicado un valor diferente a queveobot-aws. En la siguiente sección se muestra ya todo correcto y el lanzamiento de ansible ejecutando la orden vagrant provision.


#### 5.3.- Ansible:

En primer debido a un fallo muy feo:

![img](https://i.sli.mg/Am26M4.jpg)

Creamos en el directorio en el que se encuentra el Vagrantfile un archivo llamado ansible.cfg y lo dejamos asi:


```
[defaults]
host_key_checking = False
[ssh_connection]
control_path = %(directory)s/%%h-%%p-%%r

```
Básicamente se debe que el tamaño que puede tener un path en unix es limitado y por alguna razón al ir ansible a crear un archivo el hostname que identifica a la máquina virtual en amazon es demasiado largo para crear ese path y da error ```control_path= ....``` ese fichero que crea se crea  con un nombre más pequeño.

A continuación creamos en .yml para aprovisionar a nuestra aplicación:

```


---
- hosts: queveobot-aws
  user: ubuntu
  sudo: yes    
  roles:
    - { role: rvm_io.ruby,
        tags: ruby,
        rvm1_rubies: ['ruby-2.3.1'],
        rvm1_user: 'ubuntu',
        becone: true
      }
      
  tasks:       



  -  name: Instalamos  paquetes necesarios
     become: true
     action: >
      {{ ansible_pkg_mgr }} name={{ item }} state=installed update_cache=yes
     with_items:
      - build-essential
      - ruby-dev
      - libpq-dev
      - ruby
      - git
      - libgdbm-dev
      - libncurses5-dev
      - automake
      - libtool
      - bison
      - libffi-dev
      

  -  gem: 
       name: bundler
       state: latest

  -  name: clonamos repo de la web
     become: true  
     become_user: ubuntu
     shell: git clone https://github.com/LuisGi93/proyectoIV2016-2017.git
     args:
       creates: proyectoIV2016-2017
       executable: /bin/bash

  -  name: Instalamos el proyecto
     become: true  
     become_user: ubuntu
     shell: source ~/.rvm/scripts/rvm && bundle install 
     args:
       chdir: proyectoIV2016-2017
       executable: /bin/bash
         
  
  -  name: Lo arrancamos
     become: true  
     become_user: ubuntu
     shell: source ~/.rvm/scripts/rvm && export TOKEN="" && export "TOKEN_TASTEKID="  && export POSTGRES_DATABASE="" && ruby bin/run_as_daemon.rb start
     args:
       chdir: proyectoIV2016-2017
       executable: /bin/bash
  
  ```
  
  
Como mi aplicación utiliza rvm para que se ejecute en la versión 2.3.1 de ruby necesitamos instalar un plugin para ansible mediante el comando:

```
sudo ansible-galaxy install rvm_io.ruby
```

y en el .yml poner:

```
  roles:
    - { role: rvm_io.ruby,
        tags: ruby,
        rvm1_rubies: ['ruby-2.3.1'],
        rvm1_user: 'ubuntu',
        becone: true
      }
```
Para que rvm se instale para el usuario ubuntu. Procedo a explicar el las tareas del .yml:

*  ```name: Instalamos  paquetes necesarios``` actualiza el repositorio y procede a instalar todos los paquetes listados más abajo.

*  ```gem ``` Se encarga de verificar que la gema bundler está instalada.

* ```    name: clonamos repo de la web```Clona el repostiorio de la web utilizando bash.


* ``` name: Instalamos el proyecto ``` Ejecuta bundler con la versión ruby-2.3.1 y se intalan todas las gemas que necesita la aplicación.


* ```    name: Lo arrancamos``` Lanza como demonio la aplicación.

Si se quiere una explicación más detallada de que hace exactamente cada modulo del .yml se puede ver el [ejercicio 2 del tema 6](https://github.com/LuisGi93/en-proceso/blob/master/IV/ejerciciosT6.md)

![img](https://i.sli.mg/cpzadC.png)

#### 5.4.- Capistrano:

Para lanzar y para la aplicación utilizo capistrano que entre otras  cosas me permite lanzar comandos via ssh con lo cual puedo para y ejecutar la aplicación de manera un tanto burda. 
 
En primer lugar lo instalamos haciendo ```gem install capistrano```,  ejecutamos en una carpeta vacia ```cap install``` esto nos creará una serie de directorio y ficheros. Modificamos el fichero config/dpeloy.rb y le indico que voy a utilizar fichero .pem para autenticarme via ssh:

```ruby
set :ssh_options, {
  forward_agent: true,
  auth_methods: ["publickey"],
  keys: ["/home/l/vagAWS2/millave4.pem"]
}

```

En capistrano se definen "tareas" donde defines que es lo que quieres que haga capistrano. Para crear la tarea creamos un fichero en lib/capistrano/tasks acabado en .rake y en el defino la siguiente tarea:

```ruby

require "resolv-replace.rb"

role :yoquese, "yoquese"


namespace :queveobot do
  desc "Iniciamos la aplicacion"

  task :daemon_start do
	on "ubuntu@algo.us-west-2.compute.amazonaws.com" do
		execute  'source ~/.rvm/scripts/rvm && export TOKEN="" && export "TOKEN_TASTEKID="  && export POSTGRES_DATABASE="" && ruby proyectoIV2016-2017/bin/run_as_daemon.rb start'
	end
  end
  
  desc "Paramos la aplicacion"  
  task :daemon_stop do
	on "ubuntu@algo.us-west-2.compute.amazonaws.com" do
		execute  'pkill ruby'
	end
  end
end


```

Pudiendo lanzar la aplicación con el comando:
```
cap production queveobot:daemon_start
```

y parala con:

```
cap production queveobot:daemon_stop
```

![img](https://i.sli.mg/vdFxKk.png)

