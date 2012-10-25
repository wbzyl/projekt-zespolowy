# Projekt Zespołowy

* [rails3-bootstrap-devise-cancan](http://railsapps.github.com/tutorial-rails-mongoid-devise.html)

Generujemy rusztowanie:

    rails new projekt-zespolowy --skip-test-unit --skip-bundle --skip-active-record

Post-install:

    rails generate rspec:install
    rails generate mongoid:config

## Gdzie wdrożyć?

* [OpenShift](https://openshift.redhat.com/community/get-started/ruby-on-rails)
* [Heroku](http://www.heroku.com/)
* [MongoLab](https://mongolab.com/home/) (baza do 0.5GB)
* [MongoHQ](https://www.mongohq.com/home) (baza do 0.5GB)


## RSpec

* [mongoid-rspec](https://github.com/evansagge/mongoid-rspec)


### spec/requests/creating_projects_spec.rb

Pierwszy test:

    require 'spec_helper'

    feature 'Creating Projects' do
      scenario "can create a project" do
        visit '/'
        click_link 'New Project'
        fill_in 'Name', :with => 'Fortune'
        fill_in 'Description', :with => "Sample Rails Apps"
        click_button 'Create Project'
        page.should have_content('Project has been created.')
      end
    end


1\. RED:

    Failures:

      1) Creating Projects can create a project
         Failure/Error: visit '/'
         ActionController::RoutingError:
           No route matches [GET] "/"

2\. RED:

    Failures:

      1) Creating Projects can create a project
         Failure/Error: visit '/'
         ActionController::RoutingError:
           uninitialized constant ProjectsController

3\. RED:

    Failures:

      1) Creating Projects can create a project
         Failure/Error: visit '/'
         AbstractController::ActionNotFound:
           The action 'index' could not be found for ProjectsController

4\. RED:

    Failures:

      1) Creating Projects can create a project
         Failure/Error: visit '/'
         ActionView::MissingTemplate:
           Missing template projects/index, application/index with {
               :locale=>[:en], :formats=>[:html],
               :handlers=>[:erb, :builder, :coffee]}.
           Searched in:
             * "/home/wbzyl/repos/hello/projekt-zespolowy/app/views"
             * "/home/wbzyl/.rvm/gems/ruby-1.9.3-p194/gems/twitter-bootstrap-rails-2.1.4/app/views"
             * "/home/wbzyl/.rvm/gems/ruby-1.9.3-p194/gems/devise-2.1.2/app/views"

Tworzymy pusty plik na konsoli:

    touch app/views/projects/index.html.erb

5\. RED:

    Failures:

      1) Creating Projects can create a project
         Failure/Error: click_link 'New Project'
         Capybara::ElementNotFound:
           no link with title, id or text 'New Project' found

Dopisujemy do pliku *index.html.erb*:

    <%= link_to "New Project", new_project_path %>

6\. RED:

    Failures:

      1) Creating Projects can create a project
         Failure/Error: visit '/'
         ActionView::Template::Error:
           undefined local variable or method `new_project_path' for #<#<Class:0x000000047f6990>:0x000000048076a0>

Dopisujemy do *routes.rb*:

    resources :projects

7\. RED:

    Failures:

      1) Creating Projects can create a project
         Failure/Error: click_link 'New Project'
         AbstractController::ActionNotFound:
           The action 'new' could not be found for ProjectsController

Dopisujemy „pustą” metodę *new* do kontrolera.

8\. RED:

    Failures:

      1) Creating Projects can create a project
         Failure/Error: click_link 'New Project'
         ActionView::MissingTemplate:
           Missing template projects/new, application/new with {
               :locale=>[:en], :formats=>[:html], :handlers=>[:erb, :builder, :coffee]}.
           Searched in:
             * "/home/wbzyl/repos/hello/projekt-zespolowy/app/views"
             * "/home/wbzyl/.rvm/gems/ruby-1.9.3-p194/gems/twitter-bootstrap-rails-2.1.4/app/views"
             * "/home/wbzyl/.rvm/gems/ruby-1.9.3-p194/gems/devise-2.1.2/app/views"

Tworzymy pusty plik na konsoli:

    touch app/views/projects/new.html.erb

9\. **RED:** (dokumentacja Mongoid)

    Failures:

      1) Creating Projects can create a project
         Failure/Error: fill_in 'Name', :with => 'Fortune'
         Capybara::ElementNotFound:
           cannot fill in, no text field, text area or password field with id, name, or label 'Name' found

Zmieniamy definicję *new* na:

    def new
      @project = Project.new
    end

Generujemy model:

    rails g model project name:string description:text

Przygotowujemy środowisko *test*:

    rake db:test:prepare

10\. RED: (to samo co w 9.)

    Failures:

      1) Creating Projects can create a project
         Failure/Error: fill_in 'Name', :with => 'Fortune'
         Capybara::ElementNotFound:
           cannot fill in, no text field, text area or password field with id, name, or label 'Name' found

11\. RED:

    Failures:

      1) Creating Projects can create a project
         Failure/Error: click_button 'Create Project'
         AbstractController::ActionNotFound:
           The action 'create' could not be found for ProjectsController

Tworzymy metodę *create*:

    def create
      @project = Project.new(params[:project])
      if @project.save
        flash[:notice] = "Project has been created."
        redirect_to @project
      else
        # nothing, yet
      end
    end

12\. RED:

    Failures:

      1) Creating Projects can create a project
         Failure/Error: click_button 'Create Project'
         AbstractController::ActionNotFound:
           The action 'show' could not be found for ProjectsController

Dopisujemy do kontrolera „niepustą” metodę *show* (pusta metoda to za mało):

    def show
      @project = Project.find(params[:id])
    end

13\. RED:

    Failures:

      1) Creating Projects can create a project
         Failure/Error: click_button 'Create Project'
         ActionView::MissingTemplate:
           Missing template projects/show, application/show with {
               :locale=>[:en], :formats=>[:html], :handlers=>[:erb, :builder, :coffee]}.
           Searched in:
             * "/home/wbzyl/repos/hello/projekt-zespolowy/app/views"
             * "/home/wbzyl/.rvm/gems/ruby-1.9.3-p194/gems/twitter-bootstrap-rails-2.1.4/app/views"
             * "/home/wbzyl/.rvm/gems/ruby-1.9.3-p194/gems/devise-2.1.2/app/views"

Tworzymy pusty plik *show.html.erb*:

    touch app/views/projects/show.html.erb

14\. RED:

    Failures:

      1) Creating Projects can create a project
         Failure/Error: page.should have_content('Project has been created.')
           expected there to be content "Project has been created." in "ProjektZespolowy\n\n\n\n"

Dopisujemy w *show.html.erb*:

    <h2><%= @project.name %></h2>

Dopisujemy w layoucie aplikacji, w znaczniku *body*:

    <% flash.each do |key, value| %>
    <div class='flash' id='<%= key %>'>
      <%= value %>
    </div>
    <% end %>

15. **GREEN:**

    .
    Finished in 0.47093 seconds
    1 example, 0 failures

