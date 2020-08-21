# frozen_string_literal: true
require_relative 'importer'

importer = Taroxd::Importer.new 'javascript', 'mvmz-plugins/_posts'
source = 'C:/Users/taroxd/MVMZ-plugins'

namespace 'mvmz' do
  desc 'import mvmz plugins to _posts directory'
  task :import do
    files = Dir.chdir(source) { `git ls-files js` }.lines
    files.map! { |fn| "#{source}/#{fn}".chomp }
    importer.import(files)
  end

  desc 'import mvmz plugins and git add'
  task add: :import do
    `git add --all #{importer.output_dir}`
  end

  desc 'import mvmz plugins and git commit'
  task commit: :add do
    `git commit -m "update mvmz plugins"`
  end
end
