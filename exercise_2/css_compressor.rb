class CSSCompressor

  def initialize(filename)
    @original_file = filename
  end

  def compress_to(new_filename)
    File.open(new_filename, "w") do |new_file|
      File.open(@original_file, 'r').each do |line|
        new_file.write(line) if should_print(line)
      end
    end
  end

  private
  
  def should_print(line)
    return false if line.strip =~ %r(^/\*.*\*/$)
    return false if line.strip == ''
    true
  end
  
  css_compressor = CSSCompressor.new("./original_css.css")
  css_compressor.compress_to("./new1_css.css")

end


