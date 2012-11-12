# This can’t happen

**Jesteś tutaj:**

    git checkout -b 04-projects_controller bcbeadf0

> D. E. Knuth, „Computers & Typesetting”, p.40:
>
>      print_err("This can’t happen ("); print(s); print_char(")");
>      help1(I’m broken. Please show this to someone who can fix can fix");
>
>      print_err("I can’t go on metting you like this");
>      help2("One of your faux pas seems to have wounded me deeply...")
>      ("in fact, I’m barely conscious. Please fix it and try again.")

People sometimes poke around an application looking for things
that are no longer there […] try to navigate to

    http://localhost:3000/projects/⛔

In the development, you will see the exception:

    Mongoid::Errors::DocumentNotFound in ProjectsController#show

    Problem:
      Document(s) not found for class Project with id(s) ⛔.
    Summary:
      When calling Project.find with an id or array of ids,
      each parameter must match a document in the database
      or this error will be raised. The search was for the id(s): ⛔ ...
      (1 total) and the following ids were not found: ⛔.
    Resolution:
      Search for an id that is in the database or set
      the Mongoid.raise_not_found_error configuration option to false,
      which will cause a nil to be returned instead of raising
      this error when searching for a single id, or only
      the matched documents when searching for multiples

To see this error in production environment, run:

```sh
rake assets:precompile
rake db:migrate RAILS_ENV=production
```

Next, in *config/environments/production.rb* file change:

```ruby
config.serve_static_assets = false
```

to this:

```ruby
config.serve_static_assets = true
```

Finally, run the server in production environment:

```sh
rails server -e production
```

and visit the above URL once more.

![something went wrong](https://raw.github.com/wbzyl/projekt-zespolowy/master/public/something-went-wrong.png)

Na konsoli, więcej info:

    Started GET "/projects/%E2%9B%94" for 127.0.0.1 at 2012-11-10 20:55:56 +0100
    Processing by ProjectsController#show as HTML
      Parameters: {"id"=>"⛔"}
    Completed 500 Internal Server Error in 9ms

    Mongoid::Errors::NoSessionsConfig (
    Problem:
      No sessions configuration provided.
    Summary:
      Mongoid's configuration requires that you provide
      details about each session that can be connected to,
      and requires in the sessions config at least
      1 default session to exist.
    Resolution:
      Double check your mongoid.yml to make sure that you
      have a top-level sessions key with at least 1 default
      session configuration for it. You can regenerate
      a new mongoid.yml for assistance via `rails g mongoid:config`.

     Example:
       development:
         sessions:
           default:
             database: mongoid_dev
             hosts:
               - localhost:27017

    ):
      app/controllers/projects_controller.rb:23:in `show'

Zapomniałem o konfiguracji gemu Mongoid dla *production*. Poprawiam
konfigurację i ponownie wchodzę na stronę. Oto rezultat:

![something went wrong](https://raw.github.com/wbzyl/projekt-zespolowy/master/public/page-may-have-moved.png)

A na konsoli ten sam tekst co w trybie *development*.


# Obsługa wyjątku *Mongoid::Errors::DocumentNotFound*

Zamiast strony *404* przekierujemy użytkownika na stronę główną
aplikacji, na której umieścimy jakiś stosowny komunikat.

Testujemy *controller* a nie *request* ponieważ:

* takie testy łatwiej się pisze (?)
* testujemy to co użytkownik **może** zrobić,
  a nie to co **powinien** zrobić (?)

W katalogu *spec/controllers* powinniśmy znaleźć plik *projects_controller.rb*.
Został on wygenerowany przez generator *controller*.
Dopisujemy do bloku *describe* nieco kodu. Oto ten plik po tych zmianach:

```ruby
# -*- coding: utf-8 -*-
require 'spec_helper'
describe ProjectsController do
  describe ProjectsController do
    it "displays an error for a missing project" do
      get :show, :id => "⛔"
      response.should redirect_to(projects_path)
      message = "The project you were looking for could not be found."
      flash[:alert].should == message
    end
  end
end
```

Wykonujemy ten test:

```sh
 rspec spec/controllers/projects_controller_spec.rb
```

1\. RED

    1) ProjectsController ProjectsController displays an error for a missing project
       Failure/Error: get :show, :id => "⛔"
       Mongoid::Errors::DocumentNotFound:

         Problem:
           Document(s) not found for class Project with id(s) ⛔.
         Summary:
           ...
         Resolution:
           Search for an id that is in the database or set
           the Mongoid.raise_not_found_error configuration option to false,
           which will cause a nil to be returned instead of raising
           this error when searching for a single id,
           or only the matched documents when searching for multiples.

Poprawki w kodzie kontrolera:

```ruby
before_filter :find_project, :only => [:show, :edit, :update, :destroy]

[... bez zmian ...]

# z kodu metod usunięto jeden wiersz kodu:
#  @project = Project.find(params[:id])

def show
end

def edit
end

def update
  if @project.update_attributes(params[:project])
    redirect_to @project, notice: 'Project has been updated.'
  else
    flash[:alert] = "Project has not been updated."
    render action: "edit"
  end
end

def destroy
  @project.destroy
  flash[:notice] = "Project has been deleted."
  redirect_to projects_path
end

private

def find_project
  @project = Project.find(params[:id])
rescue Mongoid::Errors::DocumentNotFound
  flash[:alert] = "The project you were looking for could not be found."
  redirect_to projects_path
end
```

2\. GREEN
