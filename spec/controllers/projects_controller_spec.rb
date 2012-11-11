# -*- coding: utf-8 -*-

require 'spec_helper'

describe ProjectsController do
  describe ProjectsController do
    it "displays an error for a missing project" do
      get :show, :id => "⛔"
      response.should redirect_to(projects_path)
      message = "The project you were looking for could not be found."
      flash[:alert].should == message
    end
  end
end
