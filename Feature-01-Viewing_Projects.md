# Requests: Viewing Projects

Tym razem uruchamiamy tylko tem plik spec:

    rspec spec/requests/viewing_projects_spec.rb

Zawartość tego pliku:

    require 'spec_helper'

    feature "Viewing projects" do
      scenario "Listing all projects" do
        project = FactoryGirl.create(:project, name: "Fortune")
        visit '/'
        click_link 'Fortune'
        page.current_url.should == project_url(project)
      end
    end

**Motywacja:** If you weren’t using factories, you’d have to use this
method to create the object instead:

    Project.create(:name => name)

While this code is about the same length as its Factory variant, it
isn’t future-proof. If you were to add another field to the projects
table and add a validation (say, a presence one) for that field, you’d
have to change all occurrences of the create method to contain this
new field. When you use factories, you can change it in one
place—where the factory is defined. (*Rails 4 in Action*)

W katalogu *spec/factories* powinien być plik *projects.rb*.
O mniej więcej takiej zawartości:

    FactoryGirl.define do
      factory :project do
        name "Fortune"
        description "A simple Rails 3 app"
      end
    end


1\. RED:

    1) Viewing projects Listing all projects
       Failure/Error: click_link 'Fortune'
       Capybara::ElementNotFound:
         no link with title, id or text 'Fortune' found

W pliku *index.html.erb* podmieniamy wiersz z `project.name` na:

    <td><%= link_to project.name, project %></td>

2\. GREEN
