# Github Users

* Daniel Kehoe,
  [Rails Tutorial for OmniAuth with Mongoid](http://railsapps.github.com/tutorial-rails-mongoid-omniauth.html)

Dodajemy logowanie użytkowników via Github.

Model:

```sh
rails generate model user provider uid name nickname email
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
  attr_protected :provider, :uid, :name, :nickname, :email

  include Mongoid::Document

  field :provider, type: String
  field :uid, type: String

  field :name, type: String
  field :nickname, type: String
  field :email, type: String
end
```

## Rejestrujemy „Projekt Zespołowy” na *github.com*

Po zalogowaniu na *github.com* wpisujemy w przeglądarce adres:

    https://github.com/settings/applications

Tutaj rejestrujemy naszą aplikację.

Dla tej aplikacji, która rozwijamy póki co w trybie development wpisujemy
w pole *Callback URL* `http//localhost:3000`
(na Sigmie – `http://sigma.ug.edy.pl:numer_portu`).
W pole URL wpisujemy, na przykład adres swojej strony domowej.

Po rejstracji odszukujemy *key* (*Client ID*)
i *secret* (*Client Secret*). Będą na wkrótce potrzebne.


## Konfiguracja OmniAuth + Github

Dopisujemy do pliku *Gemfile* dwa gemy:

```ruby
gem 'omniauth', '~> 1.1.1'
gem 'omniauth-github', '~> 1.0.2'
```

oraz dwa gemy w grupie *assets* (wymagane przez nową wersję gemu
*twitter-bootstrap-rails*):

```ruby
gem 'less-rails', '~> 2.2.6'
gem 'therubyracer', '~> 0.10.2'
```

Kończymy konfigurację, tworząc plik *config/initializers/omniauth.rb*
o takiej zawartości:

```ruby
raw_config = File.read("#{ENV['HOME']}/.credentials/services.yml")
github = YAML.load(raw_config)['github']
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, github['key'], github['secret']
end
```

W ten sposób ukrywam swoje prywatne dane. Są one zapisane
w pliku *$HOME/.credentials/services.yml*, poza katalogiem aplikacji.

Same dane są zapisane w formacie YAML:

```yaml
github:
  key: 11111111111111111111                           # Client ID
  secret: 1111111111111111111111111111111111111111    # Client Secret
```


## Sesja

Zaczynamy od wygenerowania kontrolera:

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

OmniAuth ma wbudowany routing dla wspieranych dostawców
(providers). Dla Githuba jest to:

```
/auth/github           # przekierowanie na Github
/auth/github/callback  # przekierowanie po pomyślnej autentykacji
/auth/failure          # tutaj, w przeciwnym wypadku
```

Routing Rails:

```ruby
match '/auth/:provider/callback' => 'sessions#create'
match '/auth/failure' => 'sessions#failure'

match '/login' => 'sessions#new', :as => :login
match '/logout' => 'sessions#destroy', :as => :logout
```

W kontrolerze w metodzie *create* (na razie) zgłaszamy wyjątek,
aby podejrzeć dane wysyłane do aplikacji przez serwer *github.com*.


```ruby
class SessionController < ApplicationController
  def new
    redirect_to '/auth/github'
  end
  def create
    raise request.env["omniauth.auth"].to_yaml
  end
  def destroy
    reset_session
    redirect_to root_url, :notice => "User sign out!"
  end
  def failure
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end
...
```
Zobacz też [Auth Hash Schema](https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema).


## Github

Po tych zmianach można przetestować jak działa OmniAuth+Github.
W przeglądarce wpisuję:

    http://localhost:3000/auth/github

albo

    http://localhost:3000/login

Przy próbie logowania, na konsoli powinna się wyświetlić informacja
o użytkowniku. Na przykład:


```yaml
--- !ruby/hash:OmniAuth::AuthHash
provider: github
uid: '8049'
info: !ruby/hash:OmniAuth::AuthHash::InfoHash
  nickname: wbzyl
  email: [..ocenzurowano..]
  name: Wlodek Bzyl
  image: [..ocenzurowano link do gravatara..]
  urls: !ruby/hash:Hashie::Mash
    GitHub: https://github.com/wbzyl
    Blog: http://tao.inf.ug.edu.pl/
credentials: !ruby/hash:Hashie::Mash
  token: 1[..ocenzurowano 38 znaków..]1
  expires: false
extra: !ruby/hash:Hashie::Mash
  raw_info: !ruby/hash:Hashie::Mash
    followers: 122
    created_at: '2008-04-21T08:24:47Z'
    public_repos: 100
    location: Poland
    id: 8049
    login: wbzyl
```


# OmniAuth requests & RSpec

* [Easy Rails OAuth Integration Testing](http://blog.zerosum.org/2011/03/19/easy-rails-outh-integration-testing.html)
* [OmniAuth Wiki](https://github.com/intridea/omniauth/wiki)


## Store Authentication Data in the User Object

TODO

