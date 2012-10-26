require 'spec_helper'

feature "Editing Projects" do

  before do
    FactoryGirl.create(:project, name: "Deploy Button")
    visit "/"
    click_link "Deploy Button"
    click_link "Edit"
  end

  scenario "Updating a project" do
    fill_in "Name", with: "Deploy Button (beta)"
    click_button "Update Project"
    page.should have_content("Project has been updated.")
  end

  scenario "Updating a project with invalid attributes is bad" do
    fill_in "Name", with: ""
    click_button "Update Project"
    page.should have_content("Project has not been updated.")
  end

end
