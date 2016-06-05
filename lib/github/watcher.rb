require "github/watcher/version"
require 'octokit'
require 'liquid'
require 'date'
require 'json'

module Github
  module Watcher
    class Client
      
      def initialize(key)
        Octokit.configure do |c|
          c.access_token = key
          c.connection_options[:ssl] = { :verify => false }
        end
      end
      
      # Retrieve top repositories
      def search(terms, language)
        res = Octokit.search_repositories("#{terms} in:name,description,readme pushed:>=#{Date.today-30} language:#{language}").items.map{|r| {name: r[:name], description: r[:description], url: r[:html_url], stars: r[:stargazers_count]}}.select{|r| r[:stars] > 0 }.sort {|r1,r2|  r2[:stars] <=> r1[:stars]}
        export({'repositories' => JSON.parse(res.to_json), 'terms' => terms, 'language' => language})
        return res
      end
      
      # Export HTML
      def export(data)        
        File.open("tmp/export.html", 'w') do |f|
          f.write(Liquid::Template.parse(File.open('templates/feed.html', "r:UTF-8").read).render(data))
        end
      end
    end
  end
end
