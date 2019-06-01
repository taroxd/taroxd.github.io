# frozen_string_literal: true
require_relative 'importer'

importer = Taroxd::Importer.new 'javascript', 'rpgmv-plugins/_posts'
source = 'C:/Users/taroxd/RPGMV-plugins'

namespace 'rpgmv' do
  desc 'import rpgmv plugins to _posts directory'
  task :import do
    files = Dir.chdir(source) { `git ls-files js` }.lines
    files.map! { |fn| "#{source}/#{fn}".chomp }
    importer.import(files)
  end

  desc 'import rpgmv plugins and git add'
  task add: :import do
    `git add --all #{importer.output_dir}`
  end

  desc 'import rpgmv plugins and git commit'
  task commit: :add do
    `git commit -m "update rpgmv plugins"`
  end
end
