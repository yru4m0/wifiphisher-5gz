.PHONY: install dev test lint clean

install:           # Install production dependencies
	uv sync

dev:               # Install development dependencies
	uv sync --dev

test:              # Run tests
	uv run pytest

lint:              # Run linter
	uv run ruff check .

clean:             # Clean build artifacts
	rm -rf build dist *.egg-info uv.lock
