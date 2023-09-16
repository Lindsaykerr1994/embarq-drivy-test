# frozen_string_literal: true

require 'json'

# A service that can import and export data to specified location
class FileService
  DEFAULT_INPUT_PATH = 'data/input.json'
  DEFAULT_OUTPUT_PATH = 'data/output.json'

  attr_reader :base_folder

  def import_data
    JSON.parse(File.read(DEFAULT_INPUT_PATH))
  rescue TypeError
    {}
  end

  def export_data(obj)
    File.write(DEFAULT_OUTPUT_PATH, obj.to_json)
  end
end
