require 'open-uri' # consultar a la plataforma
require 'nokogiri' # formatear, parsear a html
require 'csv' # escribir y leer csv
require 'time' # convierte a tiempo

macro_brands=["UNIDEN","ACURITE","SPY","HIDDEN","INDOOR","GOOGLE","WIRELESS","LIGHT","BABY","SMALL","WIFI","FLIPPER"]

CSV.open('camaras.csv', 'wb') do |csv|
  csv << %w[NOMBRE RATING PRECIO FULLHD NIGHTVISION]
  conf=0; pagina=1
  while (pagina<4)
    puts "Scrapeando la url https://www.amazon.com/camaras_seguridad?page=#{pagina}..."
    link = "https://www.amazon.com/s?i=electronics-intl-ship&bbn=16225009011&rh=n%3A16225009011%2Cn%3A524136&page=#{pagina}&qid=1673195093&ref=sr_pg_#{pagina}"
  datosHTML = URI.open(link, 'User-Agent' => 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36')
  parsed_content = Nokogiri::HTML(datosHTML.read)
  parsed_content.css('.sg-col-inner').drop(1).drop(1).drop(1).each do |genre|
    enunciado = genre.css('.a-size-base-plus').inner_text.split(' ')
    rating = genre.css('.a-icon').css('.a-icon-alt').inner_text[0, 3]
    precio = genre.css('.a-price').css('.a-offscreen').inner_text.split('$')[1]
    if (!enunciado.empty? and !rating.empty? and !precio.to_s.empty?)
      if(macro_brands.include?enunciado[0].upcase)
        titulo = enunciado[0] + " " + enunciado[1]
        enunciado.delete_at(0)
        enunciado.delete_at(0)
        contenido = enunciado.join(" ")
        fullHD=false
        if contenido.match(/1080P?/)
          fullHD=true
        end

        nightVision = false
        if contenido.match(/Night Vision/i)
          nightVision = true
        end

      else
        titulo = enunciado[0]
        enunciado.delete_at(0)
        contenido = enunciado.join(" ")

        fullHD=false
        if contenido.match(/1080P?/)
          fullHD=true
        end

        nightVision = false
        if contenido.match(/Night Vision/i)
          nightVision = true
        end
      end
      puts "\n" + titulo, contenido, rating, '$'+precio.to_s,fullHD, nightVision
      csv << [titulo.upcase, rating, precio,fullHD,nightVision]
    end
    end
  pagina+=1
  end
end

