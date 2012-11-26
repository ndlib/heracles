module IntegrationServerHelper
  require 'capybara/rspec'
  require 'capybara/rails'

  def boot_integration_server
    host = "127.0.0.1"
    port = 8080
    begin
      tcp_server = TCPServer.new(host, 0)
      port = tcp_server.addr[1]
    ensure
      tcp_server.close if tcp_server
    end
    Capybara.server_host = host
    Capybara.server_port = port
    @server = Capybara::Server.new(app).boot
  end
end
