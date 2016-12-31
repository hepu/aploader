require 'uri'
require 'base64'

require "aploader/version"
require "aploader/tmp_file"

# Current Usage:
# filename = 'something'
# base64string = 'something'
# processed_bin = Aploader.find(filename) || Aploader.create(base64string, filename)
# if !processed_bin.nil?
#   processed_bin.file
# end

module Aploader
  TMP_DIR='tmp'

  class << self
    def create(url_or_file, filename=nil)
      bp = TmpFile.new(filename)
      bp.process!(url_or_file)
      return bp
    end

    def find(filename)
      path = self.generate_path(filename)
      if File.exists?(path)
        return TmpFile.new(path.split('/').last.split('.').first, :file)
      end
      return nil
    end

    def generate_path(filename)
      if filename.split('.').size > 1
        return "#{TMP_DIR}/#{filename}"
      else
        return "#{TMP_DIR}/#{filename}.jpg"
      end
    end
  end
end
