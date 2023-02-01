require 'set'
require 'open-uri' # consultar a la plataforma
require 'nokogiri' # formatear, parsear a html
require 'csv' # escribir y leer csv

puts "Scraper de autos en Mercadolibre"

#Limpiando el csv en cada ejecucion
CSV.open("autos.csv", "w") do |csv|
    csv << []
end

CSV.open('autos.csv', 'wb') do |csv|

    bandera=1
    pagina=""
    while(bandera<=2)
        link = 'https://autos.mercadolibre.com.ec/autos-camionetas/'+ pagina + '_NoIndex_True'
        # https://autos.mercadolibre.com.ec/autos-camionetas/_Desde_49_NoIndex_True
        datosHTML = URI.open(link) # Esto es una representacion de memoria
        datosParseados = Nokogiri::HTML(datosHTML)
        listaPeliculas = datosParseados.css('.ui-search-results')

        listaPeliculas.css('.ui-search-layout').each do |post|
            post.css('.ui-search-layout__item').each do |info|
                precio = info.css('.price-tag-text-sr-only').inner_text.split(" ")[0]
                unido= info.css('.ui-search-card-attributes__attribute').inner_text
                annio= unido.slice(0,4)
                kilometraje= unido.slice(4, unido.length).split(" ")[0].gsub(".", "")
                modelo= info.css('.ui-search-item__title').inner_text
                ubicacion= info.css('.ui-search-item__location').inner_text

                #Guardando en el csv 
                csv << [precio.to_s, annio.to_s, kilometraje.to_s, modelo.to_s, ubicacion.to_s]

                #modeloEspecifico=modelo.split(" ")[0]

                #puts modeloEspecifico
                #puts "\n"
            end
        end

        pagina="_Desde_49"
        bandera+=1
    end 
    
end 
puts "Scraping completo"



