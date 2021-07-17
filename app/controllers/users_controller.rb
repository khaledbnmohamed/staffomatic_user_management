class UsersController < ApplicationController
  before_action :set_paper_trail_whodunnit, only: [:archive, :unarchive]

  STATES_FILTERS = %w[archived unarchived].freeze

  def index
    user_state = params[:state]

    render jsonapi: user_state.blank? ? User.all : User.send(user_state.to_s) if validate_state!(user_state)
  end

  def archive
    user_to_archive = User.find_by(id: params[:user_id])
    user_to_archive.update(archived: true)
    UserMailer.with(user_to_archive: user_to_archive, user: current_user, action: "archive").user_changed.deliver_now

    render jsonapi: user_to_archive
  end


  def unarchive
    user_to_archive = User.find(params[:user_id])
    user_to_archive.update(archived: false)
    UserMailer.with(user_to_archive: user_to_archive, user: current_user, action: "unarchive").user_changed.deliver_now

    render jsonapi: user_to_archive
  end


  def validate_state!(user_state)
    return if user_state.blank?

    unless STATES_FILTERS.include?(user_state)
      render json: "State Error", status: :unprocessable_entity
      return false
    end
    true
  end
end
