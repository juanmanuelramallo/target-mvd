# Target MVD

## Up and running
It uses ruby 2.6.2
- `gem install bundler` (if necessary)
- `bundle install`
- `bundle exec rails db:setup` (it uses postgres)

### For sidekiq
Redis is needed to be installed and running a server (in mac `brew install redis` and `brew services start redis`).

### Environment variables
```bash
cp ./config/application.yml.dist ./config/application.yml
```

### Run the app
```bash
./bin/start
```

[Foreman](http://ddollar.github.io/foreman/) is used to manage the processes of the application.
Update them in the `./Procfile.dev` file.

## Tests
```bash
bundle exec rspec
```

## [API Blueprint](https://targetmvd2.docs.apiary.io/)
```bash
./bin/docs
```

[RSpec api documentation](https://github.com/juanmanuelramallo/target-mvd/pull/22) is used to generate the blueprint.
Add the specs inside the `./spec/acceptance/` folder.


