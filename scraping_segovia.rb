require 'set'
require 'open-uri' # consultar a la plataforma
require 'nokogiri' # formatear, parsear a html
require 'csv' # escribir y leer csv

puts "Mi Primer Scraper de autos"

CSV.open('autos.csv', 'wb') do |csv|
    
    link = 'https://autos.mercadolibre.com.ec/autos-camionetas/_NoIndex_True'
    datosHTML = URI.open(link) # Esto es una representacion de memoria
    datosParseados = Nokogiri::HTML(datosHTML)
    listaPeliculas = datosParseados.css('.ui-search-results')

    listaPeliculas.css('.ui-search-layout').each do |post|
        post.css('.ui-search-layout__item').each do |info|
            precio = info.css('.price-tag-text-sr-only').inner_text
            unido= info.css('.ui-search-card-attributes__attribute').inner_text
            annio= unido.slice(0,4)
            kilometraje= unido.slice(4, unido.length)
            modelo= info.css('.ui-search-item__title').inner_text
            ubicacion= info.css('.ui-search-item__location').inner_text

            #Guardando en el csv 
            csv << [precio.to_s, annio.to_s, kilometraje.to_s, modelo.to_s, ubicacion.to_s]

            puts precio
            puts annio
            puts kilometraje
            puts modelo
            puts ubicacion
            puts "\n"
        end
    end
end 


