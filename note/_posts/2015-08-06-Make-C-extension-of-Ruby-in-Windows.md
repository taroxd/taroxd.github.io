---
title: Windows 下 Ruby 编译 C 扩展
---

注：大部分代码来源于 [rubyinline](https://github.com/seattlerb/rubyinline)。

```ruby
#!/usr/bin/env ruby -wKU

# usage: ruby path/to/this/script path/to/your/c/source

require "rbconfig"

class MKCMD

  def self.cmd(base_name)
    new("#{base_name}.c", "#{base_name}.so").cmd
  end

  def initialize(src_name, so_name)
    @src_name = src_name
    @so_name  = so_name
  end

  def cmd
    hdrdir = %w(srcdir includedir archdir rubyhdrdir).map { |name|
      RbConfig::CONFIG[name]
    }.find { |dir|
      dir and File.exist? File.join(dir, "ruby.h")
    } or abort "ERROR: Can't find header dir for ruby. Exiting..."

    config_hdrdir = if RbConfig::CONFIG['rubyarchhdrdir']
      "-I #{RbConfig::CONFIG['rubyarchhdrdir']}"
    elsif RUBY_VERSION > '1.9'
      "-I #{File.join hdrdir, RbConfig::CONFIG['arch']}"
    end

    cmd = [
      RbConfig::CONFIG['LDSHARED'],
      RbConfig::CONFIG['CFLAGS'],
      '-I', hdrdir,
      config_hdrdir,
      '-I', RbConfig::CONFIG['includedir'],
      File.expand_path(@src_name).inspect,
      crap_for_windoze,
      RbConfig::CONFIG['LDFLAGS'],
      RbConfig::CONFIG['CCDLFLAGS'],
    ].compact.join(' ')

    # odd compilation error on clang + freebsd 10. Ruby built w/ rbenv.
    cmd.gsub!(/-Wl,-soname,\$@/, "-Wl,-soname,#{File.basename @so_name}")

    # strip off some makefile macros for mingw 1.9
    cmd.gsub!(/\$\(.*\)/, '') if RUBY_PLATFORM =~ /mingw/

    cmd
  end


  private

  def crap_for_windoze
    # gawd windoze land sucks
    case RUBY_PLATFORM
    when /mswin32/ then
      " -link /OUT:\"#{self.so_name}\" /LIBPATH:\"#{RbConfig::CONFIG['libdir']}\" /DEFAULTLIB:\"#{RbConfig::CONFIG['LIBRUBY']}\" /INCREMENTAL:no /EXPORT:Init_#{module_name}"
    when /mingw32/ then
      c = RbConfig::CONFIG
      " -Wl,--enable-auto-import -L#{c['libdir']} -l#{c['RUBY_SO_NAME']} -o #{@so_name.inspect}"
    when /i386-cygwin/ then
      ' -L/usr/local/lib -lruby.dll'
    else
      ''
    end
  end
end

system MKCMD.cmd((ARGV[0] || gets.chomp).chomp('.c')) if $0 == __FILE__
```