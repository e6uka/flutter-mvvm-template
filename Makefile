FLUTTER  := fvm flutter
STAGE    ?= dev
DEVICE   ?=
DEFINES   = --dart-define STAGE=$(STAGE)
DEVICE_FLAG = $(if $(DEVICE),-d $(DEVICE),)

.DEFAULT_GOAL := help
.PHONY: help setup get clean run run-staging run-prod test analyze format fix \
        outdated upgrade pods doctor devices build-apk build-appbundle build-ios reset

help: ## Show this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m [STAGE=dev|staging|prod] [DEVICE=…]\n\nTargets:\n"} \
		/^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

setup: ## Install the Flutter SDK pinned in .fvmrc and fetch packages.
	fvm install
	$(FLUTTER) pub get

get: ## flutter pub get
	$(FLUTTER) pub get

clean: ## Wipe build output and refetch packages.
	$(FLUTTER) clean
	$(FLUTTER) pub get

run: ## Run on a device/simulator (STAGE=dev by default).
	$(FLUTTER) run $(DEVICE_FLAG) $(DEFINES)

run-staging: STAGE=staging
run-staging: run ## Run against staging.

run-prod: STAGE=prod
run-prod: run ## Run against prod.

test: ## Run all tests.
	$(FLUTTER) test

analyze: ## Static analysis.
	$(FLUTTER) analyze

format: ## Format Dart sources.
	fvm dart format lib test

fix: ## Apply dart fix suggestions.
	fvm dart fix --apply

outdated: ## Show outdated packages.
	$(FLUTTER) pub outdated

upgrade: ## Upgrade packages within constraints.
	$(FLUTTER) pub upgrade

pods: ## Reinstall iOS CocoaPods.
	cd ios && pod install --repo-update

doctor: ## flutter doctor -v
	$(FLUTTER) doctor -v

devices: ## List devices and simulators.
	$(FLUTTER) devices

build-apk: STAGE:=prod
build-apk: ## Release APK.
	$(FLUTTER) build apk --release $(DEFINES)

build-appbundle: STAGE:=prod
build-appbundle: ## Release AAB for the Play Store.
	$(FLUTTER) build appbundle --release $(DEFINES)

build-ios: STAGE:=prod
build-ios: ## Release iOS build.
	$(FLUTTER) build ios --release $(DEFINES)

reset: ## Remove Pods, build output and .dart_tool, then reinstall.
	$(FLUTTER) clean
	rm -rf ios/Pods ios/Podfile.lock ios/.symlinks
	$(FLUTTER) pub get
