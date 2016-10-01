class Farms
  require "rest-client"
  require "nokogiri"

  def initialize cookies
    @cookies = cookies
  end

  def send_request1
  	response = RestClient.get("http://ts19.travian.com.vn/build.php?newdid=30788&id=39&tt=2&gid=16",
      cookies: @cookies)  	
    write_log response  
  end
  private
  def write_log response
    fptr = File.open "/home/ngocha/log.html", "w"
    fptr.puts response
  end
end