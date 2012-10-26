require 'spec_helper'

feature "Deleting projects" do
  scenario "Deleting a project" do
    # http://www.scicombinator.com/
    FactoryGirl.create(:project, name: "SciCombinator")
    visit "/"
    click_link "SciCombinator"
    click_link "Destroy"
    page.should have_content("Project has been deleted.")
    visit "/"
    page.should_not have_content("SciCombinator")
  end
end
