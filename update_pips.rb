system 'export PIPS_BASE_URI=https://api.test.bbc.co.uk/pips'
require 'pips'

# find version
vpid = ARGV[0]

puts "Finding version with pid: #{vpid}"
version = PIPS::XML::Version.new(pid: vpid)

# collect array of all parents .. until no more parents

parents = []

parent = version.parent
while parent do
  parents.unshift(parent)
  parent = parent.parent
end

# go through the array to update titles
parents.each do |programme|
	title = programme.title
	puts "Updating #{programme.class.to_s.split('::').last}: #{title}"
	programme.title = "#{title} "
	programme.commit_updates
	programme.title = title
	programme.commit_updates
end


# update duration on the version

duration = version.duration
puts "Updating Version: #{version.pid}"
version.duration = (duration == "00:00:01") ? "00:00:02" : "00:00:01"
version.commit_updates
version.duration = duration
version.commit_updates




# update source on all the media_assets

puts "Finding media assets"
media_assets = version.media_assets

media_assets.each_with_index do |media_asset, index|
	source = media_asset.source
	puts "Updating Media Asset: #{index + 1} of #{media_assets.size}"
	media_asset.source = "#{source} "
	media_asset.commit_updates
	media_asset.source = source
	media_asset.commit_updates
end



# update duration on all the ondemands

puts "Finding ondemands"
ondemands = version.ondemands

ondemands.each_with_index do |ondemand, index|
	duration = ondemand.duration
	puts "Updating OnDemand: #{index + 1} of #{ondemands.size}"
	ondemand.duration = (duration == "00:00:01") ? "00:00:02" : "00:00:01"
	ondemand.commit_updates
	ondemand.duration = duration
	ondemand.commit_updates
end