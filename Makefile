HOMEDIR = $(shell pwd)
GITDIR = /var/repos/smidgeo-headporters.git

pushall:
	git push origin master && git push origin server

sync-worktree-to-git:
	git --work-tree=$(HOMEDIR) --git-dir=$(GITDIR) checkout -f

start-docker-machine:
	docker-machine create --driver virtualbox dev

build-base-image:
	docker build -t jkang/headporters .

push-base-image:
	docker push jkang/headporters

install-cron:
	crontab schedule.cron

post-receive: sync-worktree-to-git install-cron servers

servers: run-attnbot-note-taker


ATTNBOTBASECMD = docker run --rm \
	-v $(HOMEDIR)/configs/attnbot:/usr/src/app/config jkang/attnbot 

run-attnbot-quote:
	$(ATTNBOTBASECMD) make run-mishear-quote

run-attnbot-popular:
	$(ATTNBOTBASECMD) make run-mishear-popular

run-attnbot-fact:
	$(ATTNBOTBASECMD) make run-mishear-fact

run-attnbot-news:
	$(ATTNBOTBASECMD) make run-mishear-news

run-attnbot-note-taker:
	$(ATTNBOTBASECMD) make run-note-taker
