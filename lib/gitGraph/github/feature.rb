require_relative '../..utils'

module GitGraph
  module GitHub
    class Feature
      class << self
        require_files(File.dirname(__FILE__) << "/feature/*")
      end
    end
  end
end
