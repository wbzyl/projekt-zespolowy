# Github Users

* Daniel Kehoe,
  [Rails Tutorial for OmniAuth with Mongoid](http://railsapps.github.com/tutorial-rails-mongoid-omniauth.html)

Dodajemy logowanie użytkowników via Github.

Model:

```sh
rails generate model user provider uid name email
  invoke  mongoid
  create    app/models/user.rb
  invoke    rspec
  create      spec/models/user_spec.rb
  invoke      factory_girl
  create        spec/factories/users.rb
```

Do wygenerowanego modelu dopisujemy linijkę kodu z *attr_accessible*:

```ruby
class User
  attr_protected :provider, :uid, :name, :email

  include Mongoid::Document
  field :provider, type: String
  field :uid, type: String
  field :name, type: String
  field :email, type: String
end
```


## Konfiguracja *OmniAuth*

**Uwaga:** *key* i *secret* znajdziemy w */settings/applications*
an swoim koncie na Githubie. (O ile wcześniej zarejstrowaliśmy
aplikację („Projekt Zespołowy”.
Dla aplikacji rozwijanej w development wpisujemy
w pole *Callback URL* `http//localhost:3000` albo
`http://sigma.ug.edy.pl:numer_portu` dla aplikacji uruchamianych na Sigmie.)

TODO *config/initializers/omniauth.rb*:

```ruby
raw_config = File.read("#{ENV['HOME']}/.credentials/services.yml")
github = YAML.load(raw_config)['github']
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, github['key'], github['secret']
end
```

Moje prywatne dane trzymam poza repozytorium w pliku
*$HOME/.credentials/services.yml*.
Dane są zapisane w formacie YAML:

```yaml
github:
  key: 11111111111111111111                           <- Client ID
  secret: 1111111111111111111111111111111111111111    <- Client Secret
```


## Sesja

TODO

```sh
rails generate controller sessions
  create  app/controllers/sessions_controller.rb
  invoke  erb
  create    app/views/sessions
  invoke  rspec
  create    spec/controllers/sessions_controller_spec.rb
  invoke  helper
  create    app/helpers/sessions_helper.rb
  invoke    rspec
  invoke  assets
  invoke    coffee
  create      app/assets/javascripts/sessions.js.coffee
  invoke    less
  create      app/assets/stylesheets/sessions.css.less
```

## Routing

TODO:

```ruby
# /auth/github
match '/auth/:provider/callback' => 'sessions#create'
match '/auth/failure' => 'sessions#failure'

match '/signin' => 'sessions#new', :as => :signin
match '/signout' => 'sessions#destroy', :as => :signout
```


## Github

Czego można się dowiedzieć o użytkowniku z Githuba?

```ruby
def create
  raise request.env["omniauth.auth"].to_yaml
end
```

Przy próbie logowania, na konsoli powinno się wyświetlić info:

```yaml
provider: github
uid: 8049
info:
  nickname: wbzyl
  email: ...
  name: Wlodek Bzyl
  urls:
    GitHub: https://github.com/wbzyl
```

## Store Authentication Data in the User Object

TODO
