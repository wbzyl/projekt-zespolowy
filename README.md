# Projekt Zespołowy

Przykładowa aplikacja Rails 3.2 korzystająca z bazy MongoDB
(gem Mongoid) z autentykacją OAuth (via Github), autoryzacją
(gem CanCan) i z testami RSpec.

Zaczynamy od wygenerowania rusztowania dla aplikacji:

    rails new projekt-zespolowy --skip-test-unit --skip-bundle --skip-active-record

oraz procedury „post-install”:

    rails generate rspec:install
    rails generate mongoid:config

Linki do dokumentacji (gemów, Twitter Bootstrap, etc.):

* [mongoid-rspec](https://github.com/evansagge/mongoid-rspec)
* [rspec-rails](http://rubydoc.info/github/rspec/rspec-rails/file/README.md)
* [capybara](http://rubydoc.info/github/jnicklas/capybara/file/README.md)
* [simple_form](https://github.com/plataformatec/simple_form)
* [omniauth](https://github.com/intridea/omniauth/wiki)
* [omniauth-github](https://github.com/intridea/omniauth-github)
* [Twitter Bootstrap](http://twitter.github.com/bootstrap/)

Przyspieszamy wykonywanie testów (z JavaScript, remote):

– [Testing JavaScript with PhantomJS](http://railscasts.com/episodes/391-testing-javascript-with-phantomjs)

W katalogu *doc* umieściłem kilka plików generowanych przez
generator *scaffold*. (Użyteczna ściąga?)

RSpec konfigurowałem korzystając z samouczka Daniela Kehoe:

* [Rails Tutorial for Devise with Mongoid](http://railsapps.github.com/tutorial-rails-mongoid-devise.html)

OmniAuth z innego samouczka tego samego autora:

* [Rails Tutorial for OmniAuth with Mongoid](http://railsapps.github.com/tutorial-rails-mongoid-omniauth.html)


## RSpec

Poniżej wkleiłem kod testów *requests* (dawniej nazywanych integration)
oraz testów *controllers*.

Wszystkie testy uruchamiamy wpisując na konsoli:

    rake spec:requests

albo, uruchamiając konkretny test, w taki sposób:

    rspec spec/requests/creating_projects_spec.rb

*Uwaga:* Generatory Mongoid wgenerowały nieco zbędnego kodu.
Na przykład w widokach pojawiają się niepotrzebne *_id* i *_type*.
Usunąłem te rzeczy oraz przy okazji poprawiłem nieco kod formularzy.


## spec/requests/creating_projects_spec.rb

Pierwszy test:

```ruby
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
```

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

```rhtml
<%= link_to "New Project", new_project_path %>
```

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

```ruby
def new
  @project = Project.new
end
```

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

```ruby
def create
  @project = Project.new(params[:project])
  if @project.save
    flash[:notice] = "Project has been created."
    redirect_to @project
  else
    # nothing, yet
  end
end
```

12\. RED:

    Failures:

      1) Creating Projects can create a project
         Failure/Error: click_button 'Create Project'
         AbstractController::ActionNotFound:
           The action 'show' could not be found for ProjectsController

Dopisujemy do kontrolera „niepustą” metodę *show* (pusta metoda to za mało):

```ruby
def show
  @project = Project.find(params[:id])
end
```

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

```rhtml
<h2><%= @project.name %></h2>
```

Dopisujemy w layoucie aplikacji, w znaczniku *body*:

```rhtml
<% flash.each do |key, value| %>
<div class='flash' id='<%= key %>'>
  <%= value %>
</div>
<% end %>
```

15\. **GREEN:**

    .
    Finished in 0.47093 seconds
    1 example, 0 failures


## Dodajemy Bootstrap + SimpleForm

Tak jak to opisano na stronie wykładu.

1\. RED:

    Failures:

      1) Creating Projects can create a project
         Failure/Error: visit '/'
         ActionView::Template::Error:
           undefined method `each' for nil:NilClass

Dopisujemy w metodzie *index*:

```ruby
def index
  @projects = Project.all
end
```

2\. RED:

    Failures:

      1) Creating Projects can create a project
         Failure/Error: click_link 'New Project'
         Capybara::ElementNotFound:
           no link with title, id or text 'New Project' found

Wymieniamy w linijkę z `click_link` w pliku *spec/requests/creating_projects_spec.rb*:

```ruby
click_link 'New'
```

Zmiany z gałęzi *add-bootstrap* scaliłem z *master*.


### kontynuacja spec/requests/creating_projects_spec.rb

Tytuł strony. Do istniejącego scenariusza dopisujemy cztery wiersze kodu:

```ruby
feature 'Creating Projects' do
  scenario "can create a project" do
    visit '/'
    click_link 'New Project'
    fill_in 'Name', :with => 'Fortune'
    fill_in 'Description', :with => "Sample Rails Apps"
    click_button 'Create Project'
    page.should have_content('Project has been created.')

    # NEW
    project = Project.find_by(name: "Fortune")
    page.current_url.should == project_url(project)
    title = "Projekt Zespołowy | Fortune"
    find("title").should have_content(title)
  end
end
```

1\. RED:

    Failures:

      1) Creating Projects can create a project
         Failure/Error: find("title").should have_content(title)
           expected there to be content "Projekt Zespołowy | Fortune" in "Projekt Zespolowy 2012/13"

W layoucie aplikacji podmieniamy element *title* na:

```rhtml
<title><%= @title || "Projekt Zespołowy 2012/13" %></title>
```

W pliku *show.html.erb* dopisujemy:

```rhtml
<% @title = "Projekt Zespołowy | Fortune" %>
```

2\. GREEN: **Refaktoryzacja**

Tytuł nie zmienia się przy zmianie nazwy projektu. Oczywiście nazwa
w tytule musi zmieniać się ze zmianą nazwy projektu.

Definiujemy metodę pomocniczą aplikacji:

```ruby
module ApplicationHelper
  def title(*parts)
    unless parts.empty?
      content_for :title do
        parts.unshift("Projekt Zespołowy").join(" | ")
      end
    end
  end
end
```

Ponownie podmieniamy znacznik *title* w layoucie aplikacji:

```rhtml
<title>
<% if content_for?(:title) %>
  <%= yield(:title) %>
<% else %>
  Projekt Zespołowy 2012/13
<% end %>
</title>
```

3\. **GREEN**.


## walidacja spec/requests/creating_projects_spec.rb

Dodajemy drugi scenariusz:

```ruby
scenario "can not create a project without a name" do
  visit '/'
  click_link 'New'
  click_button 'Create Project'
  page.should have_content("Project has not been created.")
  page.should have_content("can't be blank")
end
```

Pierwsze dwie linijki obu scenariuszy są takie same. Przenosimy je
do bloku *before*:

```ruby
feature 'Creating Projects' do
  before do
    visit '/'
    click_link 'New'
  end
```

i usuwamy ze scenariuszy.

1\. RED:

    Failures:

      1) Creating Projects can not create a project without a name
         Failure/Error: page.should have_content("Project has not been created.")
           expected there to be content "Project has not been created." in "\n
      [.. cut ..]

W kodzie kontrolera poprawiamy kod metody *create*:

```ruby
def create
  @project = Project.new(params[:project])
  if @project.save
    flash[:notice] = "Project has been created."
    redirect_to @project
  else
    flash[:alert] = "Project has not been created."
    render :action => "new"
  end
end
```

W kodzie modelu dopisujemy:

```ruby
attr_accessible :name, :description
validates :name, :presence => true
```

2\. GREEN


# Więcej testów…

1. [viewing projects](https://github.com/wbzyl/projekt-zespolowy/blob/master/Feature-01-Viewing_Projects.md)
2. [editing projects](https://github.com/wbzyl/projekt-zespolowy/blob/master/Feature-02-Editing_Projects.md)
3. [deleting projects](https://github.com/wbzyl/projekt-zespolowy/blob/master/Feature-03-Deleting_Projects.md)


# Gdzie można wdrożyć naszą aplikację?

* [OpenShift](https://openshift.redhat.com/community/get-started/ruby-on-rails)
* [Heroku](http://www.heroku.com/)
* [MongoLab](https://mongolab.com/home/) (baza do 0.5GB)
* [MongoHQ](https://www.mongohq.com/home) (baza do 0.5GB)


# Miss stuff

* [Absolutely Dead Simple Login System for Rails With Omniauth and Facebook](http://blog.ragingstudios.com/blog/2012/10/24/absolutely-dead-simple-login-system-for-rails-with-omniauth-and-facebook/)
* [Render your http errors in your layout reducing the need for static files.](https://github.com/eric1234/better_exception_app)
