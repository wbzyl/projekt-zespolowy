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

You will see the exception:

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
