# hnscraping
👩🏾‍💻📰🧽Hacker News hiring scraping

Extract jobs related to CNCF from Hacker News "Who is hiring?" post. Match jobs that contain _Kubernetes_ or _K8s_ and roles such as _SRE_, _Infrastructure Engineer_ or _DevOps Engineer_.

## Installation

* Install ruby (preferably with [rbenv](https://github.com/rbenv/rbenv))
* Clone repo and cd into directory.
* Install bundler `gem install bundler`
* Install dependencies: `bundle`

## Running development server

* Run server: `./bin.run-dev` 
* Visit http://localhost:9292/feed.xml or http://localhost:9292/debug.html

## Deployments

Deployments are done with a GitHub Webhook that executes `bin/provision` asynchronously.

## Vagrantfile

There's also a Vagrantfile to spin up a Ubuntu VM with the app running. It's been mostly used to try out the provision script in a Ubuntu VM like the one used in production. To run the VM install first Vagrant and Virtualbox and then execute: `vagrant up` from the root directory. The App should accessible from `http://localhost:8080`.
