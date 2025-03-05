lint: 
	bundle exec slim-lint app/views
	bundle exec rubocop

prepare_test_db:
	bin/rails db:test:prepare

test: prepare_test_db
	bin/rails test

integration_tests:
	bin/rails test test/integration