require 'net/https'
require 'json'
require 'highline/import'
require 'terminal-table'

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
    # puts "settings..."
    # p @settings
  end

  def user_information
    puts "Hello"
    puts "Please enter your unfuddle username: "
    username = gets.chomp
    password = ask("Enter your password for unfuddle: ") { |q| q.echo = "x" }
    { :username => username, :password => password }
  end

  def get_projects
    puts "Getting projects... this can take a while..."
    puts "=========="
    puts "Choose a project by id showed in the following table"
    rows = []
    ids = []
    projects = resquest_for_projects
    projects.each do |project|
      rows << [project["id"], project["title"]]
    end
    table = Terminal::Table.new :headings => ['Id', 'Title'], :rows => rows
    puts table
    puts "=========="
    puts "Project id: "
    @project_id = gets.chomp
    project_found = false

    projects.each do |project|
      if project["id"].eql? @project_id.to_i
        @project_selected = project 
        project_found = true
      end

      if not project_found
        puts table
        puts "please choose a valid project id: "
        @project_id = gets.chomp
      else
        break
      end
    end

    if project_found
      puts "You selected project #{@project_selected['title']}"    
      get_tickets
    else
      puts "Sorry, try again"    
    end  
    
  end

  def get_tickets  
    puts "=========="
    puts "Choose a ticket by id showed in the following table"
    rows = []
    ids = []
    tickets = resquest_for_tickets
    tickets.each do |ticket|
      rows << [ticket["id"], ticket["summary"]]
    end
    table = Terminal::Table.new :headings => ['Id', 'Summary'], :rows => rows
    puts table
    puts "=========="
    puts "Ticket id: "
    @ticket_id = gets.chomp
    ticket_found = false

  end

  def resquest_for_tickets

    # if using ssl, then set it up
    if @settings[:ssl]
      @http.use_ssl = true
      @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    # perform an HTTP GET
    begin
      puts "Getting tickets for project #{@project_id} ..."
      request = Net::HTTP::Get.new("/api/v1/projects/#{@project_id}/tickets.json")
      request.basic_auth @settings[:username], @settings[:password]
      
      response = @http.request(request)
      tickets = []
      if response.code == "200" 
        tickets = JSON.parse(response.body)
        tickets
      elsif response.code == "401"
        puts "You are not unauthorized to do this"
      else
        puts "Error"
      end
    rescue => e
      puts "Sorry, we have a communication error"
    end

  end

  def resquest_for_projects

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
      projects = []
      if response.code == "200" 
        projects = JSON.parse(response.body)
        projects
      elsif response.code == "401"
        puts "You are not unauthorized to do this"
      else
        puts "Error"
      end
    rescue => e
      puts "Sorry, we have a communication error"
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