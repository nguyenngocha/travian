class SendResource
  require "rest-client"
  require "nokogiri"

  def initialize cookies, myvillage, active, send_resource
    @cookies = cookies
    @myvillage = myvillage
    @active = active
    @send_resource = send_resource
  end

  def execute
    puts "https://ts6.travian.com.vn/build.php#{@myvillage.link}&id=#{@send_resource.market_id}&t=5&gid=17"
    response = RestClient.get "https://ts6.travian.com.vn/build.php#{@myvillage.link}&id=#{@send_resource.market_id}&gid=17", cookies: @cookies
    page = Nokogiri::HTML response

    link = "https://ts6.travian.com.vn/ajax.php?cmd=prepareMarketplace"
    @ajaxToken = page.css("head > script:nth-child(21)").to_s.split("return")[1].split("'")[1]
    puts "RestClient.post(link, {cmd: prepareMarketplace, r1: #{@send_resource.wood}, r2: #{@send_resource.clay}, r3: #{@send_resource.iron}, r4: #{@send_resource.paddy},
      dname: ,x: #{@send_resource.target_x}, y: #{@send_resource.target_y}, id: #{@send_resource.market_id}, t: 5, x2: 1, ajaxToken: #{@ajaxToken}}, cookies: @cookies)"

    response = RestClient.post(link, {cmd: "prepareMarketplace", r1: @send_resource.wood, r2: @send_resource.clay, r3: @send_resource.iron, r4: @send_resource.paddy,
      dname: "", x: @send_resource.target_x, y: @send_resource.target_y, id: @send_resource.market_id, t: "5", x2: "1", ajaxToken: @ajaxToken}, cookies: @cookies)

    page = Nokogiri::HTML response
    inputs = page.css("input @value")

    @sz = inputs[4].to_s.gsub!(/[^0-9A-Za-z]/, '')
    @kid = inputs[5].to_s.gsub!(/[^0-9A-Za-z]/, '')
    @c = inputs[6].to_s.gsub!(/[^0-9A-Za-z]/, '')
    @x2 = inputs[7].to_s.gsub!(/[^0-9A-Za-z]/, '')
    @village_id = @myvillage.link.gsub!(/[^0-9]/, '')

    puts "RestClient.post(#{link}, {cmd: prepareMarketplace, r1: #{@send_resource.wood}, r2: #{@send_resource.clay}, r3: #{@send_resource.iron}, r4: #{@send_resource.paddy},
      id: #{@send_resource.market_id}, a: #{@village_id}, sz: #{@sz}, kid: #{@kid}, c: #{@c}, t: 5, x2: #{@x2}, ajaxToken: #{@ajaxToken}}, cookies: #{@cookies})"
    response = RestClient.post(link, {cmd: "prepareMarketplace", r1: @send_resource.wood, r2: @send_resource.clay, r3: @send_resource.iron, r4: @send_resource.paddy,
      id: @send_resource.market_id, a: @village_id, sz: @sz, kid: @kid, c: @c, t: "5", x2: @x2, ajaxToken: @ajaxToken}, cookies: @cookies)

  end
end

#7 c: 9105e2
#8 x2: 1
# ajaxToken: 2ec429cf820a2944e861cb17213881d8


#1 cmd: prepareMarketplace
#2 t: 5
#3 id: 28
#4 a: 647
#5 sz: 4020
#6 kid: 82848
#7 c: 9105e2
#8 x2: 1
#9 r1: 200
#10 r2: 350
#11 r3: 200
#11 r4: 
# ajaxToken: 2ec429cf820a2944e861cb17213881d8