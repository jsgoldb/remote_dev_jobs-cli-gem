require 'nokogiri'
require 'open-uri'
class RemoteDevJobs::Launch::AuthenticScraper
  def self.scrape_job_list
    data = Nokogiri::HTML(open("https://authenticjobs.com/#types=7,1,5,4&onlyremote=1"))
    base = "https://authenticjobs.com"
    data.css("div#listings-wrapper li").map do |job|
      job_link = URI.join(base, job.css("a").attribute('href').value.to_s)
      job_hash = {
        company: job.css("div.role h4").text,
        location: job.css("span.location").text,
        position: job.css("div.role h3").text,
        seniority: nil,
        job_url: job_link
      }
    end 
  end

  def self.scrape_job_page(job_url)
    data = Nokogiri::HTML(open(job_url))
    company_site = data.css("div.title a")
    company_site.empty? ? company_site = "Not listed." : company_site = company_site.attribute("href").value.to_s
    attributes = {
      description: data.css("div.role section#description p").text,
      company_site: company_site
    }
  end

  
end