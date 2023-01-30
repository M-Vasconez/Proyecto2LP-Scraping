require 'open-uri' # consultar a la plataforma
require 'nokogiri' # formatear, parsear a html
require 'csv' # escribir y leer csv

$dominio = 'https://www.bestbuy.com'
url1 = 'https://www.bestbuy.com/site/searchpage.jsp?_dyncharset=UTF-8&browsedCategory=pcmcat138500050001&id=pcat17071&iht=n&ks=960&list=y&qp=currentoffers_facet%3DCurrent%20Deals~On%20Sale&sc=Global&st=categoryid%24pcmcat138500050001&type=page&usc=All%20Categories'

File.delete('laptops.csv') if File.exist?('laptops.csv')
CSV.open('laptops.csv', 'a') do |csv|
  csv << %w[MARCA DISCO RAM PULGADAS PRECIO MODELO PROCESADOR LINK]
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
    precio = precioLbl[indexPrecio + 1..precioLbl.length]
    indComa = precio.index(/,/)
    if indComa
      precio[indComa]=''
    end
    
    link = $dominio + post.css('.information').css('.sku-title').css('a').attr('href')
    nombre = nombre.gsub('–', '-')
    nombre = nombre.downcase
    index = nombre.index(/[^\s]-\s+/)
    atributos = nombre.split('-', -1) # –
    marca = ''
    disco = ''
    pulg = ''
    ram = ''
    modelo = ''
    procesador = ''
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
        marca = marca.strip
      elsif attr.index(/apple.*chip/)
        proSplit = attr.split(' ', -1)
        tipo = proSplit[1]
        procesador = 'apple ' + tipo unless tipo.nil?
      elsif attr.index(/ryzen/)
        amdSplit = attr.split(' ', -1)
        ryzen = amdSplit.find_index('ryzen')
        procesador = 'amd ryzen ' + amdSplit[ryzen + 1] if !ryzen.nil? && !amdSplit[ryzen + 1].nil?
      elsif attr.index(/core|celeron|pentium/)
        intelSplit = attr.split(' ', -1)
        core = intelSplit.find_index('core')
        celeron = intelSplit.find_index('celeron')
        pentium = intelSplit.find_index('pentium')
        if !core.nil? && !intelSplit[core + 1].nil?
          procesador = 'intel core ' + intelSplit[core + 1]
        elsif !celeron.nil?
          procesador = 'intel ' + intelSplit[celeron]
        elsif !pentium.nil?
          procesador = 'intel ' + intelSplit[pentium]
        end
      elsif attr.index(/mediatek/)
        procesador = 'mediatek' if procesador == ''
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
      if i == 1
        modeloSplit = attr.split(' ', -1)
        galaxy = modeloSplit.find_index('galaxy')
        macbook = modeloSplit.find_index('macbook')
        surface = modeloSplit.find_index('surface')
        blade = modeloSplit.find_index('blade')
        chromebook = modeloSplit.find_index('chromebook')
        modelo = if !galaxy.nil? && !modeloSplit[galaxy + 1].nil?
                   modeloSplit[galaxy] + ' ' + modeloSplit[galaxy + 1]
                 elsif !macbook.nil? && !modeloSplit[macbook + 1].nil?
                   modeloSplit[macbook] + ' ' + modeloSplit[macbook + 1]
                 elsif !surface.nil? && !modeloSplit[surface + 1].nil? && !modeloSplit[surface + 2].nil?
                   if modeloSplit[surface + 1] == 'laptop'
                     modeloSplit[surface] + ' ' + modeloSplit[surface + 1] + ' ' + modeloSplit[surface + 2]
                   else
                     modeloSplit[surface] + ' ' + modeloSplit[surface + 1]
                   end
                 elsif !blade.nil? && !modeloSplit[blade + 1].nil?
                   modeloSplit[blade] + ' ' + modeloSplit[blade + 1]
                 elsif !chromebook.nil? && !modeloSplit[chromebook + 1].nil?
                   modeloSplit[chromebook] + ' ' + modeloSplit[chromebook + 1]
                 elsif (marca == modeloSplit[0]) && !modeloSplit[1].nil?
                   modeloSplit[1]
                 else
                   modeloSplit[0]
                 end
        ind = modelo.index(/"|”/)
        modelo[ind] = '' if ind
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
    disco = disco.gsub('g', '')
    disco = disco.to_i
  elsif disco.include?('t')
    disco = disco.gsub('t', '')
    disco = disco.to_i
    disco = disco*1024
  elsif disco.index(/^\d$/)
    disco = disco.to_i
    disco = disco*1024
  else
    disco = disco.to_i
  end
end
unless ram.include?('gb')
  if ram.include?('g')
    ram = ram.gsub('g', '')
    ram = ram.to_i
  end
end
    
    laptop = Laptop.new(marca, disco, ram, pulg, precio, link, modelo, procesador)
    laptop.guardar
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

BEGIN {
class Laptop
  attr_accessor :marca, :disco, :ram, :pulg, :precio, :link, :modelo, :procesador
  def initialize(marca, disco, ram, pulg, precio, link, modelo, procesador)
    @marca = marca
    @disco = disco
    @ram = ram
    @pulg = pulg
    @precio = precio
    @link = link
    @modelo = modelo
    @procesador = procesador
  end

  def guardar
    if (marca != '') && (disco != '') && (ram != '') && (pulg != '') && (precio != '') && (link != '') && (modelo != '') && (procesador != '')
      CSV.open('laptops.csv', 'a') do |csv|
        csv << [@marca, @disco, @ram, @pulg, @precio, @modelo, @procesador, @link]
      end
    end
  end
end
}
