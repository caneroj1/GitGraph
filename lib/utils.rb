def require_files(directory)
  Dir.glob(directory).each do |file|
    if File.directory?(file)
      require_files(file << "/*")
    else
      require_relative file
    end
  end
end
