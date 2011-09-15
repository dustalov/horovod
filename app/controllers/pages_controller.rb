# encoding: utf-8

class PagesController < ApplicationController
  respond_to :html, :js

  def general
    respond_to do |format|
      format.html { render :partial => 'general', :layout => false }
      format.js
    end
  end

  def song
    respond_to do |format|
      format.html { render :partial => 'song', :layout => false }
      format.js
    end
  end

  def schedule
    respond_to do |format|
      format.html { render :partial => 'schedule', :layout => false }
      format.js
    end
  end
end
