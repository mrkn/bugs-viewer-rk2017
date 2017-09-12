class UserStatsController < ApplicationController
  def index
    lookup_users
  end

  def create
    lookup_users
    @member_stats = MemberStats.new(Project.trunk.id, params[:member_id])
    render :index
  end

  private

  def lookup_users
    @users = Project.trunk.members.includes(:user).map { |m|
      OpenStruct.new(
        id: m.id,
        name: "#{m.id}: #{m.user.login} (#{m.user.firstname} #{m.user.lastname})"
      )
    }.sort_by(&:id)
  end
end
