class Aploader::TmpFile
  attr_accessor :type, :filename

  def initialize(filename, type=nil)
    @type = type
    @filename = filename
    @path = Aploader.generate_path(@filename)
  end

  def process!(url_or_file)
    if url_or_file.empty? || url_or_file.nil?
      return nil
    else
      @filename ||= SecureRandom.urlsafe_base64(16)
      @path = Aploader.generate_path(@filename)

      if url_or_file =~ URI::regexp
        @type = :url
        @url = url_or_file
        uri = URI.parse(url_or_file)
        response = Net::HTTP.get_response(uri)
        payload = Base64.decode64(response.body)
      else
        @type = :file
        payload = Base64.decode64(url_or_file)
      end

      begin
        Dir.mkdir(Aploader::TMP_DIR)
      rescue => e
      end

      begin
        File.open(@path, 'wb'){|f| f.write(payload) }
      rescue => e
        return nil
      end

      return true
    end
  end

  # If a file is created, it must be deleted to empty space
  def flush!
    begin
      File.delete(@path)
    rescue => e
    end
  end

  def file
    begin
      return File.open(@path)
    rescue => e
      return nil
    end
  end

  def info
    "Filename: #{@filename}\nType: #{@type}\nPath: #{@path}\nExternal URL: #{@url}"
  end
end
