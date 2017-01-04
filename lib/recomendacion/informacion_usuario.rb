require_relative '../../config/database'
require_relative 'sugerencias'
module Recomendacion
# Engloba los datos asociados a una solicitud de recomendacion.
  class Informacion_Usuario

    attr_reader :nombre_usuario
    attr_accessor :peliculas_vistas
    def initialize(id_usuario)
      @nombre_usuario=id_usuario
      @peliculas_vistas=Array.new
      @db=Configuracion::Base_Datos.new('datos_usuario').db;
      puts "Entrooo"
      inicializar_peliculas_vistas
    end

    def to_s
      return "#@titulo"
    end
#Evidentemente esta einformación es volatil si no se almacena en una base de datos
#es necesario que se guarden las peliculas que ha visto un usuario del bot
    def aniadir_pelicula_vista(titulo)
      @peliculas_vistas << titulo
    end

    def inicializar_peliculas_vistas
      usuarios=@db.from(:usuarios)
      peliculas_vistas=@db.from(:usuarios).where(:nombre_usuario => @nombre_usuario).all
      puts peliculas_vistas.size
      if peliculas_vistas.count != 0
        peliculas_vistas.each{ |pelicula|
          @peliculas_vistas << pelicula[:pelicula]
        }
      end
    end
    def obtener_peliculas_vistas
      return @peliculas_vistas
    end

    def generar_recomendaciones(titulo)
        sugerencias= Sugerencias.new(titulo)
        puts sugerencias.to_s
        sugerencias.obtener_sugerencias_tastekid
        lista=sugerencias.lista_sugerencias
        return lista
    end



  end
end
