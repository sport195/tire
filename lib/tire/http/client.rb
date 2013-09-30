module Tire

  module HTTP

    module Client

      class RestClient
        ConnectionExceptions = [::RestClient::ServerBrokeConnection, ::RestClient::RequestTimeout]

        def self.get(url, data=nil)
          perform ::RestClient::Request.new(:method => :get, :url => url, :payload => data).execute
        rescue *ConnectionExceptions
          raise
        rescue ::RestClient::Exception => e
          Response.new e.http_body, e.http_code
        end

        def self.post(url, data)
          ::RestClient.post(url.gsub(Configuration.url, Configuration.secondary_url), data) if (!Configuration.secondary_url.blank?)
          perform ::RestClient.post(url, data)
        rescue *ConnectionExceptions
          raise
        rescue ::RestClient::Exception => e
          Response.new e.http_body, e.http_code
        end

        def self.put(url, data)
          ::RestClient.post(url.gsub(Configuration.url, Configuration.secondary_url), data) if (!Configuration.secondary_url.blank?)
          perform ::RestClient.put(url, data)
        rescue *ConnectionExceptions
          raise
        rescue ::RestClient::Exception => e
          Response.new e.http_body, e.http_code
        end

        def self.delete(url)
          ::RestClient.delete(url.gsub(Configuration.url, Configuration.secondary_url)) if (!Configuration.secondary_url.blank?)
          perform ::RestClient.delete(url)
        rescue *ConnectionExceptions
          raise
        rescue ::RestClient::Exception => e
          Response.new e.http_body, e.http_code
        end

        def self.head(url)
          perform ::RestClient.head(url)
        rescue *ConnectionExceptions
          raise
        rescue ::RestClient::Exception => e
          Response.new e.http_body, e.http_code
        end

        private

        def self.perform(response)
          Response.new response.body, response.code, response.headers
        end

      end

    end

  end

end
