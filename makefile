.PHONY: test

test:
	@echo Running tests... && \
	RUBYLIB=./lib cutest test/*_test.rb

console:
	@echo Running console... && \
	RUBYLIB=./lib irb -r laboristo
