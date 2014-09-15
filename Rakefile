#!/usr/bin/env rake

require 'bundler/setup'
Bundler::GemHelper.install_tasks

namespace :test do
  task :documentation do
    output = `yard doc --no-cache --no-stats`.strip
    if output.empty?
      puts "YARD documentation check successfully finished."
    else
      puts output
      raise "YARD documentation has complained."
    end
  end
end
