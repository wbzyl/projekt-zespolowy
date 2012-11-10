# This can’t happen

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
