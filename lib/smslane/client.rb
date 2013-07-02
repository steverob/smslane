

module Smslane

  class Client
    include HTTParty
    #include WebMock::API

    base_uri  'http://smslane.com'

    #Webmock stubs for testing
    
    # stub_request(:get, "http://smslane.com/vendorsms/CheckBalance.aspx?password=karimbenzema&user=steverob").to_return(:body => "Success#20000", :status => 200, :headers => { 'Content-Length' => 13 })
    # stub_request(:get, /http:\/\/smslane\.com\/vendorsms\/pushsms\.aspx?/).to_return(:body => lambda { |request| 
    #   nums = CGI::parse(request.uri.query)['msisdn'][0].split(',')
    #   response = ''
    #   nums.each do |num|
    #     if !(/^(\+91|91)[789][0-9]{9}$/.match(num).nil?)
    #       response += 'The Message Id : ' + num + '-' + SecureRandom.hex + '<br />'
    #     else
    #       response = 'Failed#Invalid Mobile Numbers'
    #       break
    #     end
    #   end
    #   response 
    # })
    

    def initialize(username,password)
      @auth = {user: username, password: password}
    end

    def check_balance
      options = {:query => @auth}
      response =  self.class.get '/vendorsms/CheckBalance.aspx?',options
      responses = response.split('#')
      {:result=>responses[0],:response=>responses[1]}
    end

    def send options
      self.class.get '/vendorsms/pushsms.aspx?',options  
    end

    def send_sms recipients, message, flash
      flash = flash ? 1 : 0
      responses = []
      recipients = recipients.each_slice(90).to_a
      recipients.each do |recipient_list|
        recipient_list.each_with_index do |number,i|
          recipient_list[i] = '91'+number[-10..-1]
          if /^(\+91|91)[789][0-9]{9}$/.match(recipient_list[i]).nil?
            recipient_list.delete_at(i)
          end
        end
        options = {:query => @auth.merge({:msisdn=>recipient_list.join(','), :sid=>'WebSMS', :fl => flash, :msg => message})}
        responses << send(options).parsed_response
      end
      
      responses.delete('Failed#Invalid Mobile Numbers')
      responses = responses.join().split('<br />')
      result = []
      responses.each do |response|
        res = response[-45..-1].split('-')
        result << {:number => res[0], :message_id=>res[1]}
      end
      result
    end

    def delivery_report number, unique_id
      options = {:query => @auth.merge({:MessageID => number+'-'+unique_id}) }
      response = self.class.get '/vendorsms/CheckDelivery.aspx?', options
      case response.code
        when 200 
          response.gsub('#','')
        when 404
          'Page Not Found'
        when 500
          'Server Error'
        when 500..600
          'HTTP Error #{response.code}'
      end
    end

  end


end