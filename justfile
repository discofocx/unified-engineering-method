# Golden commands for the Deterministic Engineering OS

fmt:
    npx prettier --write "src/**/*.md"

lint:
    npx markdownlint-cli2 "src/**/*.md"

build:
    mdbook build

serve:
    mdbook serve --open

clean:
    mdbook clean

ci: fmt lint build
