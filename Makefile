.PHONY: install dev test lint clean patch-pyric

install:           # Install production dependencies
	uv sync
	$(MAKE) patch-pyric

dev:               # Install development dependencies
	uv sync --dev
	$(MAKE) patch-pyric

test:              # Run tests
	uv run pytest

lint:              # Run linter
	uv run ruff check .

clean:             # Clean build artifacts
	rm -rf build dist *.egg-info uv.lock

patch-pyric:       # Patch pyric for Python 3.14+ compatibility
	PYRIC=$$(find .venv -name "rfkill.py" -path "*/pyric/*" 2>/dev/null | head -1); \
	if [ -n "$$PYRIC" ] && ! grep -q "decode.*ascii" "$$PYRIC" 2>/dev/null; then \
		sed -i '/rfke = rfkh.rfkill_event/a\        rfke = rfke.decode('"'"'ascii'"'"')' "$$PYRIC"; \
		echo "Patched pyric rfkill.py"; \
	fi
