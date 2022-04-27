class Admin::UsersController < ApplicationController
  before_action :require_authentication

  def index
    respond_to do |format|
      format.html do
        @pagy, @users = pagy User.order(created_at: :desc)
      end

      format.zip do
        respond_with_zipped_users
      end
    end
  end

  def create
    if params[:archive].present?
      UserBulkService.call(params[:archive])
      flash[:success] = 'Users imported!'
    end

    redirect_to admin_users_path
  end

  private

  # Generating a zip file containinng an .xlsx document and
  # sending it to the user
  def respond_with_zipped_users
    # object compressed_filestram as temp-file of archive
    compressed_filestram = Zip::OutputStream.write_buffer do |zos|
      # preparing data for writing to the archive
      User.order(created_at: :desc).each do |user|
        # putting data (.xlsx-file)
        zos.put_next_entry("user_#{user.id}.xlsx")

        # creating .xlsx-file (#print) from string from memory (#render_to_string)
        zos.print(render_to_string(
                    layout: false, handlers: [:axlsx], formats: [:xlsx],
                    template: 'admin/users/user',
                    locals: { user: }
                  ))
      end
    end

    # returning poiner to start
    compressed_filestram.rewind

    # sending archive to the user
    send_data(compressed_filestram.read, filename: 'users.zip')
  end
end
