require 'open-uri'
require 'nokogiri'
require 'fileutils'

print "Enter the website URL: "
url = gets.chomp

print "Enter the archive name: "
archive_name = gets.chomp

FileUtils.mkdir_p("#{archive_name}")

html = open(url).read

doc = Nokogiri::HTML(html)
doc.css("img, link[rel='stylesheet'], script").each do |node|
  asset_url = node["src"] || node["href"]
  next if asset_url.nil? || asset_url.start_with?("http")

  asset_path = "#{archive_name}/#{File.basename(asset_url)}"
  open(asset_path, "wb") do |file|
    file << open("#{url}/#{asset_url}").read
  end
end

File.write("#{archive_name}/index.html", html)

system("tar -cvzf #{archive_name}.tar.gz #{archive_name} && rm -r #{archive_name}")
