require 'open-uri' # consultar a la plataforma
require 'nokogiri' # formatear, parsear a html
require 'csv' # escribir y leer csv

$dominio = 'https://www.bestbuy.com'
url1 = 'https://www.bestbuy.com/site/searchpage.jsp?_dyncharset=UTF-8&browsedCategory=pcmcat138500050001&id=pcat17071&iht=n&ks=960&list=y&qp=currentoffers_facet%3DCurrent%20Deals~On%20Sale&sc=Global&st=categoryid%24pcmcat138500050001&type=page&usc=All%20Categories'

File.delete("laptops.csv") if File.exist?("laptops.csv")
CSV.open("laptops.csv", 'a') do |csv|
  csv<<["MARCA", "DISCO", "RAM", "PULGADAS", "PRECIO"]
end

def scrap(url)
  datosHTML = URI.open(url)
  datosParseados = Nokogiri::HTML(datosHTML.read)
  listLaptops = datosParseados.css('.sku-item-list')
  contador = 0
  tamanio = listLaptops.css('.shop-sku-list-item').length

  listLaptops.css('.shop-sku-list-item').each do |post|
    nombre = post.css('.information').css('.sku-title').css('a').text
    precioLbl = post.css('.price-block').css('.priceView-hero-price').css('.sr-only').text
    indexPrecio = precioLbl.index(/\$/)
    precio = precioLbl[indexPrecio+1..precioLbl.length]
    link = $dominio + post.css('.information').css('.sku-title').css('a').attr('href')
    nombre = nombre.gsub('–', '-')
    nombre = nombre.downcase
    puts link
    index = nombre.index(/[^\s]-\s+/)
    atributos = nombre.split('-', -1) # –
    marca = ''
disco = ''
pulg = ''
ram = ''
i = 0
atributos.each do |attr|
  if i == 0
    if attr.include? 'macbook'
      marca = 'apple'
    elsif attr.include? 'surface'
      marca = 'microsoft'
    elsif attr.length > 20
      marc = attr.split(' ', -1)
      marca = marc[0]
    else
      marca = attr
    end
  elsif attr.index(/[1-8]{1,3}\s*[|g|t]/)
    memSplit = attr.split(' ', -1)
    unless attr.include? 'rtx'
      if attr.include?('ssd') || attr.include?('emmc') || attr.include?('solid state drive') || attr.include?('flash')
        disco = memSplit[0]
      elsif attr.index(/[1-8]{3}/) || memSplit[0].index(/^[1-2]{1}$/)
        disco = memSplit[0]
      else
        ram = memSplit[0]
      end
    end
  end
  indexDisc = disco.index(/t|g/)
  indexRam = ram.index(/g/)
  disco = disco[0..indexDisc] unless indexDisc == disco.length || indexDisc == disco.length - 1
  ram = ram[0..indexRam] unless indexRam == ram.length || indexRam == ram.length - 1

  index = attr.index(/"|”|-inch| ips/)
  unless index.nil?
    pulg = if attr[index - 2].include? '.'
             attr[index - 4..index - 1]
           else
             attr[index - 2..index - 1]
           end
  end
  i += 1
end
unless disco.include?('gb') || disco.include?('tb')
  if disco.include?('g')
    disco = disco.gsub('g', 'gb')
  elsif disco.include?('t')
    disco = disco.gsub('t', 'tb')
  elsif disco.index(/^\d$/)
    disco += 'tb'
  else
    disco += 'gb'
  end
end
unless ram.include?('gb')
  if ram.include?('g')
    ram = ram.gsub('g', 'gb')
  else
    ram += 'gb'
  end
end
    laptop = Laptop.new(marca, disco, ram, pulg, precio, link)
    laptop.guardar()
    contador += 1
    next unless contador == tamanio
    linkNext = datosParseados.css('.footer-pagination').css('.sku-list-page-next').attr('href')
    next if linkNext.nil?
    nextPage = $dominio + linkNext
    puts nextPage
    scrap(nextPage)
  end
end
scrap(url1)

BEGIN{
class Laptop
  attr_accessor :marca, :disco, :ram, :pulg, :precio, :link
  def initialize(marca, disco, ram, pulg, precio, link)
    @marca = marca
    @disco = disco
    @ram = ram
    @pulg = pulg
    @precio = precio
    @link = link
  end
  def guardar()
    CSV.open('laptops.csv', 'a') do |csv|
      csv<<[@marca, @disco, @ram, @pulg, @precio]
    end
  end
end
}