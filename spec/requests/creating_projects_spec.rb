# -*- coding: utf-8 -*-

require 'spec_helper'

feature 'Creating Projects' do
  before do
    visit '/'
    click_link 'New'
  end

  scenario "can create a project" do
    fill_in 'Name', :with => 'Fortune'
    fill_in 'Description', :with => "Sample Rails Apps"
    click_button 'Create Project'
    page.should have_content('Project has been created.')

    project = Project.find_by(name: "Fortune")      # Mongoid: Querying
    page.current_url.should == project_url(project)
    title = "Projekt Zespołowy | Fortune"
    find("title").should have_content(title)
  end

  scenario "can not create a project without a name" do
    click_button 'Create Project'
    page.should have_content("Project has not been created.")
    page.should have_content("can't be blank")
  end

end
