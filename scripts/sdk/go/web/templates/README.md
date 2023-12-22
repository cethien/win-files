# Go Web App

## start development

install tools:

```bash
# bun
curl -fsSL https://bun.sh/install | bash -s

# templ, wgo, migrate
go install github.com/a-h/templ/cmd/templ@latest
go install github.com/bokwoon95/wgo@latest
go install -tags 'sqlite' github.com/golang-migrate/migrate/v4/cmd/migrate@latest
```

run:

```bash
    make default env dev
```
