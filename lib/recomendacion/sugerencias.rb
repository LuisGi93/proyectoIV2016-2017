require 'net/http'
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'mechanize'
require "resolv-replace.rb"
require 'json'
require_relative '../../config/database'

module Recomendacion
# Genera recomendaciones a partir del titulo de la pelicula y de los datos de un usuario

  class Sugerencias

    attr_reader :titulo, :lista_sugerencias

    def initialize(titulo)
      @titulo=titulo
      @lista_sugerencias=Array.new
      #@db=Configuracion::Base_Datos.new('datos_usuario').db;
    end

    def to_s
      return "#@titulo"
    end

#Obtiene una lista de sugerencias de la web tastekid
    def obtener_sugerencias_tastekid

      uri = URI('https://www.tastekid.com/api/similar')
      params = { :q => @titulo, :k => ENV['TOKEN_TASTEKID'] }
      uri.query = URI.encode_www_form(params)
      page = Net::HTTP.get(uri)

      my_hash = JSON.parse(page)
      keys = my_hash.keys
      array_resultados=my_hash["Similar"]["Results"]
      if array_resultados
        rellenar_lista_sugerencias(array_resultados)
      end


    end

    def rellenar_lista_sugerencias(lista)

      lista.each{ |sugerencia|
        @lista_sugerencias << sugerencia["Name"]
        puts sugerencia["Name"]

      }

    end


    end





  end

