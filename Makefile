diff:
	git add .
	git diff --cached > ~/diff
	echo -n "Lines: " && wc -l ~/diff
	git status

push:
	@if [ "$$(git rev-parse --abbrev-ref HEAD)" = "main" ] || [ "$$(git rev-parse --abbrev-ref HEAD)" = "master" ]; then \
		echo "🚫 You are on branch 'main' or 'master'. Push aborted."; \
		exit 1; \
	fi
	git add .
	git commit -F ~/commit.txt
	git push origin HEAD
	git checkout main

push_branch:
	@if [ "$$(git rev-parse --abbrev-ref HEAD)" = "main" ] || [ "$$(git rev-parse --abbrev-ref HEAD)" = "master" ]; then \
		echo "🚫 You are on branch 'main' or 'master'. Push aborted."; \
		exit 1; \
	fi
	git add .
	git commit -F ~/commit.txt
	git push origin HEAD

rebuild:
	flutter clean
	flutter pub get

test_coverage:
	flutter test --concurrency=1 --coverage

test_serial:
	flutter test --concurrency=1 --coverage

update_splash:
	dart run flutter_native_splash:create --path=flutter_native_splash.yaml

update_launcher_icons:
	flutter pub run flutter_launcher_icons