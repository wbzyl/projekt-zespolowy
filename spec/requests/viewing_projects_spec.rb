require 'spec_helper'

feature "Viewing projects" do

  scenario "Listing all projects" do
    project = FactoryGirl.create(:project, name: "Fortune")
    visit '/'
    click_link 'Fortune'
    page.current_url.should == project_url(project)
  end

end
