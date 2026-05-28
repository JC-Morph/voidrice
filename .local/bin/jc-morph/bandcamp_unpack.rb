#!/usr/bin/env ruby

require 'fileutils'
require 'ruby-progressbar'

def grab_tracks( folder )
  Dir.glob(File.join(folder, '*.*'))
end

def cover_img?( file )
  file[/cover\.(jpe?g|png|gif)/]
end

def rename_tracks( folder_name, album_name )
  grab_tracks(folder_name).each do |track|
    next if cover_img?(track)
    begin
      File.rename(track, track.sub(/.*\K#{album_name}/, ''))
    rescue Errno::ENOENT
      album_name = album_name.sub(/(?<=\w)-/, ',')
      retry
    end
  end
end

def mp3_convert( folder_name )
  mp3_dir = File.join('mp3', folder_name)
  FileUtils.makedirs mp3_dir
  tracks = grab_tracks(folder_name)
  @bar = ProgressBar.create(title: "Converting tracks", total: tracks.size)
  tracks.each do |track|
    ext = File.extname(track)
    if cover_img?(track)
      FileUtils.cp(track, mp3_dir)
      @bar.increment
      next
    end
    unless ext[/(wav|flac)/]
      @bar.increment
      next
    end
    mp3_name = File.join('mp3', track.sub(ext, '.mp3'))
    `ffmpeg -loglevel error -i "#{track}" -c:a libmp3lame -q:a 0 "#{mp3_name}"`
    @bar.increment
  end
  remove_instance_variable :@bar
end

def process_dirs
  Dir.glob('*/').each do |folder|
    puts "\n#{folder.chop}"
    mp3_convert folder
  end
end

def bandcamp_unpack( convert_to_mp3 = true, dirs = false, remove_zip = false )
  return process_dirs if dirs
  Dir.glob('*.zip').each do |zip_file|
    folder = File.basename(zip_file, '.zip')
    album_name  = zip_file[/ - .+(?=\.zip)/]

    puts "\nunzipping #{folder}"
    `unzip "#{zip_file}" -d "#{folder}"`
    rename_tracks(folder, album_name)

    File.delete(zip_file) if remove_zip
    mp3_convert(folder)   if convert_to_mp3
  end
end

bandcamp_unpack *ARGV
