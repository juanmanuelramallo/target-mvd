# Target MVD

[![CircleCI](https://circleci.com/gh/juanmanuelramallo/target-mvd.svg?style=shield)](https://circleci.com/gh/juanmanuelramallo/target-mvd)
[![Maintainability](https://api.codeclimate.com/v1/badges/f6ad49ec60622ef25624/maintainability)](https://codeclimate.com/github/juanmanuelramallo/target-mvd/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/f6ad49ec60622ef25624/test_coverage)](https://codeclimate.com/github/juanmanuelramallo/target-mvd/test_coverage)

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


