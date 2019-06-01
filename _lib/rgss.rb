# frozen_string_literal: true
require_relative 'importer'
require 'rouge'
require 'cgi'

importer = Taroxd::Importer.derive 'ruby', 'rgss/_posts' do

  FORMATTER = Rouge::Formatters::HTML.new
  LEXER = Rouge::Lexers::Ruby.new
  COMMENT_TAG = '<span class="sd ge">#</span>'

  def wrap_metadata_key(key)
    %(<span class="sd">#{key}</span>)
  end

  def wrap_comment(comment)
    %(<span class="c1">#{comment}</span>)
  end

  def extname
    '.html'
  end

  def make_contents(file)
    metadata_html = String.new
    metadata_start = false
    title = nil
    while (line = file.gets)
      # only allow empty line before '# @taroxd metadata'
      if line.empty?
        metadata_html << "\n"
        next
      end
      if !metadata_start
        if line.start_with?('# @taroxd metadata')
          metadata_html << <<~EOF
            #{COMMENT_TAG} #{wrap_metadata_key(line[2..-2])}
          EOF
          metadata_start = true
          next
        else
          raise "Metadata not found from:\n#{contents}"
        end
      end
      break unless /^# @(?<key>\w+)(?: +(?<value>.+))?$/ =~ line
      value ||= ""
      if key == 'display'
        title = value
      end
      if key == 'require'
        metadata_html << <<~EOF
          #{COMMENT_TAG} #{wrap_metadata_key '@require'} <a href="/rgss/#{value}.html">#{value}</a>
        EOF
      else
        metadata_html << <<~EOF
          #{COMMENT_TAG} #{wrap_metadata_key "@#{key}"} #{wrap_comment CGI.escape_html value}</a>
        EOF
      end
    end
    <<~EOF
      ---
      title: #{title}
      ---
      <div class="language-ruby highlighter-rouge"><pre class="highlight"><code>#{metadata_html}#{FORMATTER.format(LEXER.lex(file.read))}</code></pre></div>
    EOF
  end
end

namespace 'rgss' do
  desc 'import rgss scripts to _posts directory'
  task :import do
    importer.import(Dir['C:/Users/taroxd/RGSS/rgss3/*.rb'])
  end

  desc 'import rgss scripts and git add'
  task add: :import do
    `git add --all #{importer.output_dir}`
  end

  desc 'import rgss scripts and git commit'
  task commit: :add do
    `git commit -m "update rgss scripts"`
  end
end
