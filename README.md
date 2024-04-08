# container-juggler
**container-juggler** is a wrapper/config-generator for **docker-compose** to manage different development-scenarios.

> :Note: This is a fork maintained by Netconomy.  
> Build with up to date go version and slightly updated dependencies.  
> Compatible with ARM on MacOS.

It preruns a *docker-compose.yml*-file-generator, which renders based on *scenarios* defined in *container-juggler.yml*.  
This means you define multiple *scenarios* (scenario *all* is required, which is also the base for other scenarios).  
Other scenarios must be subsets of the *all*-scenario.  
The renderer will detect missing services by diffing the selected with the all-*scenario* and adds them as */etc/hosts*-entries (via docker's extra-hosts-option) in each of the services. So requests to missing services will be routed to your host-machine. If you wish not to automatically detect the IP for your extra hosts, you can add the *-ip-for-missing-services* param which will override it.
Now you are able to run parts of your multi-tier-application directly on your host-machine (parts you're currently working on) and all others in docker with docker compose.  

## Installation
todo
## Project-Configuration
- create a **container-juggler.yml** in the root-folder of your project
- add at least the *all*-scenario, e.g.:

```yaml
templateFolderPath: ./templates/
scenarios:
  all:
    - frontend
    - app
    - db
```
- *container-juggler* will lookup the service-templates in **./templates/\<service-name\>.yml**. So create your service-templates (like in the example above *frontend.yml*, *app.yml* and *db.yml*) as you know from [docker-compose-file-reference](https://docs.docker.com/compose/compose-file/) in that folder. e.g.:

```yaml
image: nginx
ports:
  - "80:80"
```
## Additional Configuration
### volume-init
If you run *docker compose up* your database and all other docker-volumes will be empty. So you may want to provide initial-data-zips for your docker-volumes.  
*container-juggler init* will download the specified zip and extracts it to your specified target-dir. If target-dir is not empty, *container-juggler* will skip this volume-init.  
You can define a *volume-init*-section in your *container-juggler.yml* to achieve that, e.g.:

```yaml
volume-init:
    - name: app-data-dir
      source: http://example.org/app-data.zip
      target: ./data/app
    - name: mysql-data-dir
      source: /path/to/file.zip 
      target: ./data/mysql
```

> **Note!**  
> - Don't forget to add this data-directory to .gitignore-file ;-)  

## Sample Configuration
### container-juggler.yml

```yaml
scenarios:
  all:
    - frontend
    - app
    - db
  backend:
    - frontend
    - db
  frontend:
    - app
    - db
volume-init:
    - name: app-data-dir
      source: http://example.org/app-data.zip
      target: ./data/app
    - name: mysql-data-dir
      source: http://example.org/db-data.zip
      target: ./data/mysql
```

### ./templates/db.yml

```yaml
image: mysql
ports:
    - "3306:3306"
volumes:
    - ./data/mysql:/var/lib/mysql
```

## RUN
please check:
```bash
container-juggler help
```

## Examples

There are examples available in the `examples` folder, showcasing how different configurations could look like.

The `basic` example contains a configuration for a simple setup with a `frontend (nginx)`, `backend (nodejs)` and `db (mongodb)`.

In order to generate and run the `basic` example with the `all` scenario, you need to execute the following commands from the repository root:

```
cd examples/basic
container-juggler generate all
container-juggler run all
```

## Development setup

In order to use the same versions of the dependencies we provide a
`vendor/vendor.json` file which you can use with [go mod][]

```bash
go mod vendor
```

Once you have all dependencies inside the `vendor` folder, you can run the tests
with `make test`.

[go mod]: https://go.dev/ref/mod#go-mod-vendor

## TODOS

- [x] ~~detect required extra-hosts by diffing all-scenario with current-scenario~~
- [x] ~~stability-adjustments (no args, ...)~~
- [ ] add template-loading from remote-server
- [ ] test on windows
- [ ] add static extra-hosts to container-juggler.yml
- [x] ~~check scenario "all" is present (in configuration)~~
- [x] ~~check all template-files of scenario "all" are present~~
- [x] ~~detect missing services (against "all"-scenario)~~
- [x] ~~add extra-hosts for missing scenarios~~
- [ ] add extra-hosts for global external-services
- [x] ~~add all services to compose-data-map~~
- [x] ~~gen yaml and write it to docker-compose.yml~~
- [ ] build dependency-tree to generate depends_on-entries in docker-compose.yml
- [ ] autocompletion for bash and zsh
- [ ] add flag to generate-cmd to write generated docker-compose.yml to stdout only
- [ ] run init on empty data-dirs
