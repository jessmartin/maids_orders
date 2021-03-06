require 'exifr'

Maid.rules do

  rule 'Update yourself' do
    `cd ~/.maid && git pull`
  end

  rule 'Sort Camera Uploads into Photos directory' do
    found = dir('~/Dropbox/Camera Uploads/*.jpg').select do |path|
      begin 
        taken_on = EXIFR::JPEG.new(path).date_time

        next unless taken_on && taken_on.respond_to?(:year) #not sure why there wouldn't be a year!

        if taken_on
          destination = "/Users/jessmartin/Dropbox/Photos/#{taken_on.year}/#{"%02d" % taken_on.month}/#{"%02d" % taken_on.day}/"
          FileUtils.mkdir_p destination
          move(path, destination)
        end
      rescue EXIFR::MalformedJPEG
        puts "MalformedJPEG"
      end
    end
  end

  #
  # Sample Rules
  #

  #rule 'Linux ISOs, etc' do
    #trash(dir('~/Downloads/*.iso'))
  #end

  #rule 'Linux applications in Debian packages' do
    #trash(dir('~/Downloads/*.deb'))
  #end

  #rule 'Mac OS X applications in disk images' do
    #trash(dir('~/Downloads/*.dmg'))
  #end

  #rule 'Mac OS X applications in zip files' do
    #found = dir('~/Downloads/*.zip').select { |path|
      #zipfile_contents(path).any? { |c| c.match(/\.app$/) }
    #}

    #trash(found)
  #end

  #rule 'Misc Screenshots' do
    #dir('~/Desktop/Screen shot *').each do |path|
      #if 1.week.since?(accessed_at(path))
        #move(path, '~/Documents/Misc Screenshots/')
      #end
    #end
  #end

  # NOTE: Currently, only Mac OS X supports `duration_s`.
  #rule 'MP3s likely to be music' do
    #dir('~/Downloads/*.mp3').each do |path|
      #if duration_s(path) > 30.0
        #move(path, '~/Music/iTunes/iTunes Media/Automatically Add to iTunes/')
      #end
    #end
  #end

  # NOTE: Currently, only Mac OS X supports `downloaded_from`.
  #rule 'Old files downloaded while developing/testing' do
    #dir('~/Downloads/*').each do |path|
      #if downloaded_from(path).any? { |u| u.match('http://localhost') || u.match('http://staging.yourcompany.com') } &&
          #1.week.since?(accessed_at(path))
        #trash(path)
      #end
    #end
  #end
end
