# Requests: Editing Projects

![editing project](https://raw.github.com/wbzyl/projekt-zespolowy/master/public/editing_project.png)

    git checkout -b 02-editing_projects 9fcff060

Tak jak poprzednio uruchamiamy tylko jeden plik spec:

    rspec spec/requests/editing_projects_spec.rb

Tym razem plik zwiera dwa scenariusze. Kod wspólny dla obu
scenariuszy umieściłem w bloku *before*:

```ruby
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
```

1\. RED:

    1) Editing Projects Updating a project with invalid attributes is bad
       Failure/Error: page.should have_content("Project has not been updated.")
         expected there to be content "Project has not been updated." in "\n
       [.. cut ..]

Poprawiamy kod metody *update*:

```ruby
if @project.update_attributes(params[:project])
  redirect_to @project, notice: 'Project has been updated.'
else
  flash[:alert] = "Project has not been updated." #<-- NEW
  render action: "edit"
end
```

2\. GREEN
