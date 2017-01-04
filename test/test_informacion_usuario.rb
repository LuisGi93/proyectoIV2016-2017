require 'test/unit'
require 'shoulda'

require_relative '../lib/recomendacion/informacion_usuario'


class InformacionUsuarioTest < Test::Unit::TestCase

  context "Test informacion relativa usuario" do
    setup do
      @id=rand(0...100000)
      @usuario= Recomendacion::Informacion_Usuario.new(@id)

     end

     should "Debe de tener el nombre introducido en el constructor:" do
       assert_equal @id, @usuario.nombre_usuario
     end



   end



end
