require 'net/https'
require 'json'

class Otro

  def initialize
    info = user_information
    @settings = {
                  :subdomain  => "yuxipacific",
                  :ssl        => true,
                  :username   => info[:username],
                  :password   => info[:password]
                }
    @http = Net::HTTP.new("#{@settings[:subdomain]}.unfuddle.com", @settings[:ssl] ? 443 : 80)
    get_projects
    puts "settings..."
    p @settings

  end

  def user_information
    puts "Hello"
    puts "Please enter your unfuddle username: "
    username = gets.chomp
    puts "Please enter your password for Unfuddle: "
    password = gets.chomp
    { :username => username, :password => password }
  end

  def get_projects
    puts "get_projects..."

    # if using ssl, then set it up
    if @settings[:ssl]
      @http.use_ssl = true
      @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    # perform an HTTP GET
    begin
      # request = Net::HTTP::Get.new('/api/v1/account.xml')
      # request = Net::HTTP::Get.new('/api/v1/projects/38254/tickets/590155/time_entries')
      request = Net::HTTP::Get.new('/api/v1/projects.json')
      request.basic_auth @settings[:username], @settings[:password]

      response = @http.request(request)
      puts "antes del if"
      if response.code == "200"
        array = JSON.parse(response.body)
        array.each do |project|
          p project["title"]
        end
      else
        # hmmm...we must have done something wrong
        puts "HTTP Status Code: #{response.code}."
      end
    rescue => e
      # do something smart
    end


  end

  o = Otro.new

  # UNFUDDLE_SETTINGS = {
  #   :subdomain  => 'yuxipacific',
  #   :username   => 'jvidalba',
  #   :password   => 'vrpRMB96',
  #   :ssl        => true
  # }

  # http = Net::HTTP.new("#{UNFUDDLE_SETTINGS[:subdomain]}.unfuddle.com", UNFUDDLE_SETTINGS[:ssl] ? 443 : 80)

  # # if using ssl, then set it up
  # if UNFUDDLE_SETTINGS[:ssl]
  #   http.use_ssl = true
  #   http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  # end

  # perform an HTTP GET
  # begin
  #   # request = Net::HTTP::Get.new('/api/v1/account.xml')
  #   request = Net::HTTP::Get.new('/api/v1/projects/38254/tickets/590155/time_entries')
  #   request.basic_auth UNFUDDLE_SETTINGS[:username], UNFUDDLE_SETTINGS[:password]

  #   response = http.request(request)
  #   puts "antes del if"
  #   if response.code == "200"
  #     puts response.body
  #   else
  #     # hmmm...we must have done something wrong
  #     puts "HTTP Status Code: #{response.code}."
  #   end
  # rescue => e
  #   # do something smart
  # end

  # perform an HTTP POST
  # if testing, be sure to use a valid project id below
  # begin
  #   request = Net::HTTP::Post.new('/api/v1/projects/38254/tickets/590155/time_entries.json', {'Content-type' => 'application/xml'})
  #   request.basic_auth UNFUDDLE_SETTINGS[:username], UNFUDDLE_SETTINGS[:password]
  #   request.body = "<time-entry>
  #                     <date>2014-07-20</date>
  #                     <person-id>51714</person-id>
  #                     <description>Daily meeting</description>
  #                     <hours>1</hours>
  #                     <ticket-id>590155</ticket-id>
  #                   </time-entry>"

  #   response = http.request(request)
  #   if response.code == "201"
  #     puts "Message Created: #{response['Location']}"
  #   else
  #     # hmmm...we must have done something wrong
  #     puts "HTTP Status Code: #{response.code}."
  #   end
  # rescue => e
  #   # do something smart
  # end
end