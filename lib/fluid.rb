module Fluid
  class Api
    include HTTParty
    base_uri = 'fluidsurveys.com'
    
    def initialize(u, p)
      @auth = {:username => u, :password => p}
      @survey_id = '859623'
    end

    def get_results(date)
      options = {
        :basic_auth => @auth,
        :hehaders => { 'Content-Type' => 'application/json' }
      }      
      puts "URL: http://fluidsurveys.com/api/v3/surveys/#{@survey_id}/csv/?_created_at>#{date}&comma_separated=true"
      resp = self.class.get("http://fluidsurveys.com/api/v3/surveys/#{@survey_id}/csv/?_created_at>#{date}&comma_separated=true", options)
     
      return resp.body
    end      

    def create_collector(id, name)
      # check for collector's existence first
      puts "CREATING COLLECTOR:  " + name

      options = {
        :basic_auth => @auth,
        :hehaders => { 'Content-Type' => 'application/json' }
      }

      resp = self.class.get('http://fluidsurveys.com/api/v3/surveys/' + id.to_s + '/collectors/?name=' + name, options)
      collectors = JSON.parse(resp.to_json)

      collectors["results"].each do |collector|
        if collector["name"] == name
          return false
        end
      end

      resp = self.class.post('http://fluidsurveys.com/api/v3/surveys/' + id.to_s + '/collectors/?name=' + name, options)
      Rails.logger.debug("RESPONSE: " + resp.to_s)
      
      return true
    end

    def clear_lists() 
      puts "CLEARING LISTS"
      options = {
        :basic_auth => @auth,
        :hehaders => { 'Content-Type' => 'application/json' }
      }
      resp = self.class.get('http://fluidsurveys.com/api/v3/contact-lists/', options)
      lists = JSON.parse(resp.to_json)

      lists["results"].each do |list|
        puts "DELETING: " + list["name"]
        if list["name"].include? "_RUN_"
          resp = self.class.delete('http://fluidsurveys.com/api/v3/contact-lists/'+list["id"].to_s+'/', options)
          puts "DELETE: " + resp.to_s
        end
      end

    end

    def create_list(name)
      options = {
        :body => 
        contact_list = {
          "name" => name
        }.to_json,
        :basic_auth => @auth,
        :headers => { 'Content-Type' => 'application/json' }
      }
      #options = { :body => {:contact => text}, :basic_auth => @auth }
      Rails.logger.debug("POSTING CLIST: " + name)
      resp = self.class.post('http://fluidsurveys.com/api/v3/contact-lists/', options)
      Rails.logger.debug("RESPONSE: " + resp.to_s)
      val = JSON.parse(resp.to_json)
      
      if val["error"] != nil
        puts "List Exists"
        list_id = nil
      else
        list_id = val["id"]
      end

      Rails.logger.debug("DONE POSTING CLIST : " + list_id.to_s)

      return list_id
    end
    
    def create_contact_in_list(patient, practice_name, run_name, list_id)
      puts "PUTTING: " + patient.to_s

      contact = { 
        "name"=> patient.name, 
        "email"=> patient.email,
        "custom_run" => run_name,
        "custom_Practice Id" => patient.practice_id,
        "custom_Practice Name" => practice_name,
        "custom_Visit Date" => patient.visitDate.strftime("%B %e,  %Y")
      }    
      options = {
        :basic_auth => @auth,
        :headers => { 'Content-Type' => 'application/json' },
        :body => contact.to_json
      }
      puts 'URL : http://fluidsurveys.com/api/v2/contact-lists/' + list_id.to_s + '/contacts/'
      Rails.logger.debug("POSTING contact: " + options.to_json)
      resp1 = self.class.post('http://fluidsurveys.com/api/v2/contact-lists/' + list_id.to_s + '/contacts/', options)
      Rails.logger.debug("RESPONSE: " + resp1.to_json)

      response_json = JSON.parse(resp1.to_json)
      puts "RETURN: " + response_json.to_s
      if response_json["success"] == false
        puts "ERROR Creating contact"
      end
      return resp1
    end
    
    def create_contact(json)
      options = {
        :body => json,
        :basic_auth => @auth,
        :headers => { 'Content-Type' => 'application/json' }
      }
      #options = { :body => {:contact => text}, :basic_auth => @auth }
      self.class.post('/api/v3/contacts/', options)
    end
  end
end