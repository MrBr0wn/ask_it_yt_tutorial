class UserBulkService < ApplicationService
  # Uploded user's archive
  attr_reader :archive

  # Getting temp-file of user's archive
  # rubocop:disable Lint/MissingSuper
  def initialize(archive_param)
    @archive = archive_param.tempfile
  end
  # rubocop:enable Lint/MissingSuper

  # Manipulatings with user's archive
  def call
    # Opening user's archive and getting each .xlsx-file
    Zip::File.open(@archive) do |zip_file|
      zip_file.glob('*.xlsx').each do |entry|
        # import all records from the .xlsx-file as one request to DB
        User.import(users_from(entry), ignore: true)
      end
    end
  end

  private

  # Parsing user's .xlsx-file and preparing for import to DB
  def users_from(entry)
    sheet = RubyXL::Parser.parse_buffer(entry.get_input_stream.read)[0]

    # Excluding data from the .xslx-file and creating User.new
    sheet.map do |row|
      cells = row.cells[0..2].map { |c| c&.value.to_s }
      User.new(name: cells[0],
               email: cells[1],
               password: cells[2],
               password_confirmation: cells[2])
    end
  end
end
