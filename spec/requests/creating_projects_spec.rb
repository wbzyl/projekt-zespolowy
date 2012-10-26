# -*- coding: utf-8 -*-

require 'spec_helper'
feature 'Creating Projects' do
  scenario "can create a project" do
    visit '/'
    click_link 'New'
    fill_in 'Name', :with => 'Fortune'
    fill_in 'Description', :with => "Sample Rails Apps"
    click_button 'Create Project'
    page.should have_content('Project has been created.')

    project = Project.find_by(name: "Fortune")      # Mongoid: Querying
    page.current_url.should == project_url(project)
    title = "Projekt Zespołowy | Fortune"
    find("title").should have_content(title)
  end
end
