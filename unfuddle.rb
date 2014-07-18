require 'rubygems'
require 'httparty'

class Unfuddle

  # def tickets(options={})
  #   self.class.get("/projects/38254/tickets.xml",
  #                   :headers => {
  #                     "basic_auth" => "jvidalba:vrpRMB96",
  #                     'Content-Type' => 'application/xml',
  #                     "connection" => "keep-alive",
  #                     "host" => "yuxipacific.unfuddle.com",
  #                     "accept" => "application/xml"
  #                   }
  #                 )
  # end
  # UNFUDDLE = {
  #   :project    => 38254,
  #   :milestone  => 12345,  # the 'feedback' milestone

  #   :auth => {
  #     :username => "jvidalba",
  #     :password => "********"
  #   }
  # }

  # include HTTP
  puts "Before it"
  auth = {:username => "jvidalba", :password => "*******"}
  response = HTTParty.get("http://yuxipacific.unfuddle.com/api/v1/projects/38254/tickets/358883.xml",
        :basic_auth => auth,
        :connection => "keep-alive",
        :accept => "application/xml",
        :host => "yuxipacific.unfuddle.com",
        "content-type" => "application/xml"
      # :headers => {
      #               "basic_auth" => "jvidalba:*******",
      #               'Content-Type' => 'application/xml',
      #               "connection" => "keep-alive",
      #               "host" => "yuxipacific.unfuddle.com",
      #               "accept" => "application/xml"
      #             }
    )
  puts response.body, response.code, response.message, response.headers.inspect
end

unfu = Unfuddle.new
# p "Before it"
# p unfu.tickets
# u = Unfuddle.new


# curl -i -u jvidalba:******** -X GET \
#   -H 'Accept: application/json' \
#   -H 'Content-Type: application/xml' \
#   -d '<request><start-date>>5/5/2007</start-date><end-date>>5/12/2007</end-date></request>' \
#   http://yuxipacific.unfuddle.com/api/v1/account/activity.xml