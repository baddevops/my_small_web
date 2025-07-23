require "http/server"

server = HTTP::Server.new do |context|
  begin
    context.response.content_type = "text/plain"  
    context.response.print "REQUEST PATH\n"
    path = context.request.path
    path = path.rstrip("/") unless path == "/"
    context.response.print "Request path: #{path}\n"  

    case path
    when "/"
      context.response.print "Root page\n"
    when "/folder1"
      context.response.print "You are in /folder1\n"
    when "/folder1/folder2"
      context.response.print "Welcome to /folder1/folder2\n"
    else
      context.response.status_code = 404
      context.response.print "Not found\n"
    end

    
    now = Time.local
    context.response.print "The time is #{now}\n"
    puts "The time is #{now}"

    x_forwarded_for = context.request.headers["X-Forwarded-For"]?
    if x_forwarded_for
      puts "X-Forwarded-For: #{x_forwarded_for}"
      context.response.print "X_forwarded_for: #{x_forwarded_for}\n"
    else
      puts "X-Forwarded-For not found"
      context.response.print "X-Forwarded-For not found\n"
    end

    real_ip = context.request.remote_address.to_s
    if real_ip
      context.response.print "Real-IP/remote_address: #{real_ip}\n"
      puts "Real-IP/remote_address: #{real_ip}"
    else
      context.response.print "No Real-IP/remote_address\n"
      puts "No Real-IP/remote_address"
    end


  
  context.response.print "\n"  
  context.response.print "ALL REQUEST HEDERI\n"
    headers = context.request.headers
    headers.each do |key, value|
  context.response.print "#{key}: #{value}\n"
   end

  context.response.print "\n"
  context.response.print "ALL REQUEST BODY\n" 
  body = context.request.body
    if body
      text = body.gets_to_end
      context.response.print "-------BODY-------\n"
      context.response.print text
      context.response.print "\n-----END-BODY-----\n"
    else
      context.response.print "------BODY------\n"
      context.response.print "\n----NO-BODY-----\n"
    end

  context.response.print "\n"  
  context.response.print "ALL RESPONSE HEDERS\n"
    headers = context.response.headers
    headers.each do |key, value|
  context.response.print "#{key}: #{value}\n"
   end
   

  rescue ex
    # Выведем причину 500-й ошибки в консоль
    puts "Error: #{ex.message}"
    ex.backtrace.each { |ln| puts ln }
    context.response.status_code = 500
    context.response.print "Internal Server Error: #{ex.message}"
  end
end

port = (ENV["PORT"]? || "8080").to_i
address = server.bind_tcp "0.0.0.0", port
puts "Listening at http://#{address}"
server.listen
