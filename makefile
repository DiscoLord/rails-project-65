lint: 
	bundle exec rubocop
	bundle exec slim-lint app/views

lintfix:
	bundle exec rubocop -a

prepare_test_db:
	bin/rails db:test:prepare

test: prepare_test_db
	bin/rails test

integration_tests:
	bin/rails test test/integration

setup-env:
	cp .env.example .env