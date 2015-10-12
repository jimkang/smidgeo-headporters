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
	$(ATTNBOTBASECMD) make mishear-quote

run-attnbot-popular:
	$(ATTNBOTBASECMD) make mishear-popular

run-attnbot-fact:
	$(ATTNBOTBASECMD) make mishear-fact

run-attnbot-news:
	$(ATTNBOTBASECMD) make mishear-news

run-attnbot-note-taker:
	docker run -d --restart=always \
		-v $(HOMEDIR)/configs/attnbot:/usr/src/app/config jkang/attnbot \
		node take-a-note-bot.js
