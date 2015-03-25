require_relative "gitGraph/version"
require_relative "utils"

module GitGraph
  require_files(File.dirname(__FILE__) << "/gitGraph/*")
end
