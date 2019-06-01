# frozen_string_literal: true
module Taroxd
  class Importer

    attr_reader :language
    attr_reader :output_dir

    def self.derive(language, output_dir, &block)
      Class.new(self, &block).new(language, output_dir)
    end

    def initialize(language, output_dir)
      @language = language
      @output_dir = output_dir
    end

    def import(source_filenames)
      raise ArgumentError, 'No script to be imported!' if source_filenames.empty?
      mkdir output_dir
      source_filenames.each do |filename|
        new_filename = make_filename filename
        contents = File.open(filename, encoding: Encoding::UTF_8) do |file|
          make_contents file
        end
        File.write new_filename, contents, mode: 'wb', encoding: Encoding::UTF_8
       end
    end

    private

    def make_contents(file)
      "\n"\
      "```#{language}\n"\
      "#{file.read}\n"\
      "```\n"
    end

    def mkdir(dir)
      if File.directory?(dir)
        Dir.glob("#{dir}/*", &File.method(:delete))
      else
        Dir.mkdir(dir)
      end
    end

    def make_filename(filename)
      basename = File.basename filename, '.*'
      "#{ROOT}/#{output_dir}/1970-01-01-#{basename}#{extname}"
    end

    def extname
      '.md'
    end
  end
end
