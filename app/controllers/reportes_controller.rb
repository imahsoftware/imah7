class ReportesController < ApplicationController
  require 'csv'
  require 'find'
  require 'rubygems'
  require 'zip'
  require 'axlsx'

  def index
    isadmin = is_admin
    @infgrupostipos = Infgrupo.select("tipo").where(["id in (select infgrupo_id from usersreportes where user_id = #{isadmin})"]).group("tipo").order("tipo asc")
    @infgrupos = Infgrupo.where(["id in (select infgrupo_id from usersreportes where user_id = #{isadmin})"]).order(:id)
  end
end