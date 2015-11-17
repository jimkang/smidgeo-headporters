HOMEDIR = $(shell pwd)
GITDIR = /var/repos/smidgeo-headporters.git

pushall:
	git push origin master && git push server master

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

post-receive: sync-worktree-to-git install-cron update-images start-servers

start-servers: run-attnbot-note-taker run-ngram-seance

update-images: \
	update-attnbot \
	update-watching-very-closely \
	update-rapgamemetaphor \
	update-ngram-seance \
	update-matchupbot \
	update-contingencybot

update-attnbot:
	docker pull jkang/attnbot

update-watching-very-closely:
	docker pull jkang/watching-very-closely

update-rapgamemetaphor:
	docker pull jkang/rapgamemetaphor

update-ngram-seance:
	docker pull jkang/ngram-seance

update-matchupbot:
	docker pull jkang/matchupbot

update-contingencybot:
	docker pull jkang/if-you-are-reading-this

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
	docker rm -f attnbot-note-taker || \
		echo "attnbot-note-taker did not need removal."
	docker run -d --restart=always \
		--name attnbot-note-taker \
		-v $(HOMEDIR)/configs/attnbot:/usr/src/app/config jkang/attnbot \
		node take-a-note-bot.js

run-attnbot-shakespeare:
	$(ATTNBOTBASECMD) make mishear-shakespeare

run-attnbot-bible:
	$(ATTNBOTBASECMD) make mishear-bible

run-watching-very-closely:
	docker run --rm \
		-v $(HOMEDIR)/configs/watching-very-closely:/usr/src/app/config \
		-v $(HOMEDIR)/data/watching-very-closely:/usr/src/app/data \
		jkang/watching-very-closely make run

run-rapgame:
	docker run --rm \
		-v $(HOMEDIR)/configs/rapgamemetaphor:/usr/src/app/config \
		jkang/rapgamemetaphor make run

run-ngram-seance:
	docker rm -f ngram-seance || echo "ngram-seance did not need removal."
	docker run \
		-d \
		--restart=always \
		--name ngram-seance \
		-v $(HOMEDIR)/configs/ngram-seance:/usr/src/app/config \
		-v $(HOMEDIR)/data/ngram-seance:/usr/src/app/data \
		jkang/ngram-seance

run-ngram-seance-followback:
	docker run \
		-v $(HOMEDIR)/configs/ngram-seance:/usr/src/app/config \
		jkang/ngram-seance make followback

run-ngram-seance-tweet-unprompted:
	docker run \
		-v $(HOMEDIR)/configs/ngram-seance:/usr/src/app/config \
		jkang/ngram-seance make tweet-unprompted

run-matchupbot:
	docker run -v $(HOMEDIR)/configs/matchupbot:/usr/src/app/config \
		jkang/matchupbot make run

run-contingencybot:
	docker run -v $(HOMEDIR)/configs/if-you-are-reading-this:/usr/src/app/config \
		jkang/if-you-are-reading-this make run
