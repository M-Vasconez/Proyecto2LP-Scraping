require 'open-uri' # consultar a la plataforma
require 'nokogiri' # formatear, parsear a html
require 'csv' # escribir y leer csv
require 'time' # convierte a tiempo


CSV.open('relojes.csv', 'wb') do |csv|
  conf=0; pagina=1
  while (pagina<5)
    puts "Scrapeando la url https://confiesalo.net/?page=#{pagina}..."
    link = "https://www.amazon.com/s?i=electronics-intl-ship&bbn=16225009011&rh=n%3A16225009011%2Cn%3A524136&page=#{pagina}&qid=1673195093&ref=sr_pg_#{pagina}"
  datosHTML = URI.open(link, 'User-Agent' => 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36')
  parsed_content = Nokogiri::HTML(datosHTML.read)
  parsed_content.css('.sg-col-inner').drop(1).drop(1).drop(1).each do |genre|
    title = genre.css('.a-size-base-plus').inner_text
    rating = genre.css('.a-icon').css('.a-icon-alt').inner_text[0, 3]
    price = genre.css('.a-price').css('.a-offscreen').inner_text.split('$')[1]
    puts "\n" + title, rating, '$'+price.to_s
    csv << [title,rating,price]
    end
  pagina+=1
  end
end
