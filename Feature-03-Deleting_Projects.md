# Requests: Deleting Projects

Testujemy uruchamiając ten plik spec:

    rspec spec/requests/deleting_projects_spec.rb

Zawartość tego pliku:

    feature "Deleting projects" do
      scenario "Deleting a project" do
        FactoryGirl.create(:project, name: "SciCombinator")
        visit "/"
        click_link "SciCombinator"
        click_link "Destroy"
        page.should have_content("Project has been deleted.")
        visit "/"
        page.should_not have_content("SciCombinator")
      end
    end

1\. RED:

    1) Deleting projects Deleting a project
       Failure/Error: page.should have_content("Project has been deleted.")
         expected there to be content "Project has been deleted." in "\n
       ...

Poprawki w kodzie metody *destroy*:

    def destroy
      @project = Project.find(params[:id])
      @project.destroy
      flash[:notice] = "Project has been deleted."
      redirect_to projects_path
    end

2\. GREEN
