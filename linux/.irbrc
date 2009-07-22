# Just put this file in ~/.irbrc and your irb experience will be much better!

# --------------------------------
# added default require libs
# --------------------------------
require 'rubygems'

# --------------------------------
# use wirble
#   auto-completion
#   highlight
#   ri
# --------------------------------
begin
  require 'wirble'

  Wirble.init
  Wirble.colorize
  puts 'use wirble'
rescue LoadError => e
  puts 'default'

  # --------------------------------
  # Include tab-completion in irb
  # --------------------------------
  require 'irb/completion'

  # --------------------------------
  # Load and save each command in irb
  # so we don't have to re-type stuff
  #
  # Taken from ctran
  # http://snipplr.com/view/1026/my-irbrc/
  # --------------------------------
  HISTORY_FILE_PATH = "~/.irb_history"
  HISTORY_MAX_SIZE  = 100

  begin
    history_file = File::expand_path(HISTORY_FILE_PATH)

    if File::exists?(history_file)
      histoies = IO::readlines(history_file).collect { |history| history.chomp }
      Readline::HISTORY.push(*histoies)
    end

    Kernel::at_exit do
      histoies = Readline::HISTORY.to_a.reverse.uniq.reverse
      histoies = histoies[-HISTORY_MAX_SIZE, HISTORY_MAX_SIZE] if histoies.nitems > HISTORY_MAX_SIZE
      File::open(history_file , File::WRONLY|File::CREAT|File::TRUNC) do |f|
        histoies.each { |history| f.puts history }
      end
    end
  end

  # --------------------------------
  # Enable "ri" command inside irb.
  # Taken from Programming Ruby 2.
  # --------------------------------
  Kernel.class_eval do
    def ri(*names)
      system(%{ri #{names.map { |name| name.to_s }.join(" ")}})
    end
  end
end
