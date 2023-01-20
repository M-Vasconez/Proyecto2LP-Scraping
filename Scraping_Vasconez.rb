require 'open-uri' # consultar a la plataforma
require 'nokogiri' # formatear, parsear a html
require 'csv' # escribir y leer csv
require 'time' # convierte a tiempo
macro_brands=["Uniden","AcuRite","Spy","Hidden","Indoor","Google","Wireless","Light","Baby","Small","WiFi","FLIPPER"]

CSV.open('relojes.csv', 'wb') do |csv|
  conf=0; pagina=1
  while (pagina<5)
    puts "Scrapeando la url https://amazon.net/relojes_Hombres?page=#{pagina}..."
    link = "https://www.amazon.com/s?i=electronics-intl-ship&bbn=16225009011&rh=n%3A16225009011%2Cn%3A524136&page=#{pagina}&qid=1673195093&ref=sr_pg_#{pagina}"
  datosHTML = URI.open(link, 'User-Agent' => 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36')
  parsed_content = Nokogiri::HTML(datosHTML.read)
  parsed_content.css('.sg-col-inner').drop(1).drop(1).drop(1).each do |genre|
    enunciado = genre.css('.a-size-base-plus').inner_text.split(' ')
    rating = genre.css('.a-icon').css('.a-icon-alt').inner_text[0, 3]
    precio = genre.css('.a-price').css('.a-offscreen').inner_text.split('$')[1]
    if (!enunciado.empty? and !rating.empty? and !precio.to_s.empty?)
      if(macro_brands.include?enunciado[0])
        titulo = enunciado[0] + " " + enunciado[1]
        enunciado.delete_at(0)
        enunciado.delete_at(0)
        contenido = enunciado.join(" ")
      else
        titulo = enunciado[0]
        enunciado.delete_at(0)
        contenido = enunciado.join(" ")
      end
      puts "\n" + titulo, contenido, rating, '$'+precio.to_s
      csv << [titulo, contenido, rating, precio]
    end
    end
  pagina+=1
  end
end

