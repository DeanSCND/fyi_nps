module Fluid
  class Api
    include HTTParty
    base_uri = 'fluidsurveys.com'
    
    def initialize(u, p)
      @auth = {:username => u, :password => p}
      @survey_id = '859623'
    end

    def get_results(date:, page:)
      options = {
        :basic_auth => @auth,
        :hehaders => { 'Content-Type' => 'application/json' }
      }      
      puts "URL: http://fluidsurveys.com/api/v3/surveys/#{@survey_id}/csv/?_created_at>#{date}&comma_separated=true"
      resp = self.class.get("http://fluidsurveys.com/api/v3/surveys/#{@survey_id}/csv/?_created_at>#{date}&comma_separated=true", options)

      return resp.body

    end      

    def create_collector(id, name)
      Rails.logger.debug("POSTING: " + name + " for " + id.to_s)
      options = {
      }
      resp = self.class.post('https://stream.watsonplatform.net/speech-to-text/api/v1/', options)
      Rails.logger.debug("RESPONSE: " + resp.to_s)
      Rails.logger.debug("DONE POSTING COLLECTOR")
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
      resp = self.class.post('/api/v3/contact-lists/', options)
      Rails.logger.debug("RESPONSE: " + resp.to_s)
      val = JSON.parse(resp.to_json)
      list_id = val["id"]

      Rails.logger.debug("DONE POSTING CLIST")

      return list_id
    end
    
    def create_contact_in_list(patient, run_name, list_id)
     
      contact = {
            "name"=> patient.name, 
            "email"=> patient.email, 
            "custom"=>[
                {
                    "Practice Id"=> patient.practice_id.to_s
                }, 
                {
                    "RUN"=> patient.RUN
                }, 
                {
                    "Practice Name"=> patient.practice_name
                }, 
                {
                    "Visit Date"=> patient.visit_date
                }
            ]
      }
      
      options = {
        :body => contact.to_json,
        :basic_auth => @auth,
        :headers => { 'Content-Type' => 'application/json' }
      }
      #options = { :body => {:contact => text}, :basic_auth => @auth }
      Rails.logger.debug("POSTING contact: " + options.to_json)
      resp1 = self.class.post('/api/v3/contacts/', options)
      Rails.logger.debug("RESPONSE: " + resp1.to_json)

      response_json = JSON.parse(resp1.to_json)

      if response_json["id"] != nil 
        options = {
          :basic_auth => @auth,
          :headers => { 'Content-Type' => 'application/xml' }
        }

        contact_id = response_json["id"]
        Rails.logger.debug("ADDING TO LIST")
        resp2 = self.class.post('/api/v3/contact-lists/' + list_id.to_s + '/contacts/?id=' + contact_id.to_s, options)
        Rails.logger.debug("RESPONSE: " + resp2.to_json)
      else
          log = Log.new
          log.type = "FLUID_CONTACT"
          log.message = "Patient with email " + patient.email + " not created: " + response_json["error"]
          log.save
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