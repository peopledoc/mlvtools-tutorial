.PHONY: help setup

#: help - Display callable targets.
help:
	@echo "Reference card for usual actions in development environment."
	@echo "Here are available targets:"
	@egrep -o "^#: (.+)" [Mm]akefile  | sed 's/#: /* /'


#: setup - Install dependencies.
setup:
	pip install cython
	pip install -e . -r ./requirements.txt