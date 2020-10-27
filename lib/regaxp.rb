require "regaxp/version"
require "zeitwerk"
Zeitwerk::Loader.for_gem.setup

module Regaxp
  def self.root
    Pathname.new File.expand_path("../", __FILE__)
  end
end
