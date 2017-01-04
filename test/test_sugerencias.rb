require 'test/unit'
require 'shoulda'

require_relative '../lib/recomendacion/sugerencias'


#Tests sobre la clase que se encarga de hacer sugerencias
#Todo: para un usuario no devolver aquellas peliculas que ya haya visto, variar el numero de peliculas a mostrar...
class SugerenciasTest < Test::Unit::TestCase

  context "Realiza test asociados a las recomendaciones sugeridas para un usuario en concreto" do
    ##Titulo para buscar peliculas parecidas el padrino, usuario asociado a las sugerencias Morgan Freeman
    setup do
      @sugerencias = Recomendacion::Sugerencias.new("The Godfather")
      lista_sugerencias=Array.new
      hash_sugerencia_prueba=Hash.new
      hash_sugerencia_prueba={"Name" => "Sunshine"}
      lista_sugerencias << hash_sugerencia_prueba
      hash_sugerencia_prueba={"Name" => "Oldboy"}
      lista_sugerencias << hash_sugerencia_prueba
      @sugerencias.rellenar_lista_sugerencias(lista_sugerencias)
     end

     should "Devuelve sugerencias" do
       @sugerencias.obtener_sugerencias_tastekid
       contiene_elementos=@sugerencias.lista_sugerencias.size > 0
       assert_equal contiene_elementos, true
     end
     should "Devuleve peliculas parecidas" do
       @sugerencias.obtener_sugerencias_tastekid
       assert_contains(@sugerencias.lista_sugerencias, "The Godfather Part III" , "No devuelve peliculas parecidas")
     end

    should "Debe de poder añadirse sugerencias:" do
      assert_contains @sugerencias.lista_sugerencias, "Sunshine"
      assert_contains @sugerencias.lista_sugerencias, "Oldboy"
    end

    should "Debe de respetarse el orden de las sugerencias:" do
      assert_operator @sugerencias.lista_sugerencias.index("Sunshine"), :<, @sugerencias.lista_sugerencias.index("Oldboy")

    end

   end



end
