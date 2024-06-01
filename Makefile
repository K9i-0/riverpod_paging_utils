prerelease_for_tagpr:
	@echo "Current version: $(TAGPR_CURRENT_VERSION)"
	@echo "Next version: $(TAGPR_NEXT_VERSION)"
	sed -i '' "s/version: $(TAGPR_CURRENT_VERSION)/version: $(TAGPR_NEXT_VERSION)/" pubspec.yaml
	git add pubspec.yaml