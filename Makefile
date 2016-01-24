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

start-servers: \
	run-attnbot-note-taker \
	run-ngram-seance \
	run-file-grab-webhook \
	run-namedlevels-api

update-images: \
	update-attnbot \
	update-watching-very-closely \
	update-rapgamemetaphor \
	update-ngram-seance \
	update-matchupbot \
	update-contingencybot \
	update-file-grab-webhook \
	update-fact-bots \
	update-namedlevels-api \
	update-circlejams

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

update-file-grab-webhook:
	docker pull jkang/file-grab-webhook

update-fact-bots:
	docker pull jkang/fact-bots

update-namedlevels-api:
	docker pull jkang/namedlevels-api

update-circlejams:
	docker pull jkang/circlejams

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
		-v $(HOMEDIR)/data/if-you-are-reading-this:/usr/src/app/data \
		jkang/if-you-are-reading-this make run

run-file-grab-webhook:
	docker rm -f file-grab-webhook || echo "file-grab-webhook did not need removal."
	docker run \
		-d \
		--restart=always \
		--name file-grab-webhook \
		-v $(HOMEDIR)/configs/file-grab-webhook:/usr/src/app/config \
		-v $(HOMEDIR)/data/if-you-are-reading-this:/usr/src/app/data \
		-p 3489:3489 \
		jkang/file-grab-webhook

run-fact-bots:
	docker run -v $(HOMEDIR)/configs/fact-bots:/usr/src/app/config \
		jkang/fact-bots make run

run-namedlevels-api:
	docker rm -f namedlevels-api || \
		echo "namedlevels-api did not need removal."
	docker run \
		-d \
		--restart=always \
		--name namedlevels-api \
		-v $(HOMEDIR)/configs/namedlevels-api:/usr/src/app/config \
		-v $(HOMEDIR)/data/namedlevels-api:/usr/src/app/data \
		-p 8080:8080 \
		jkang/namedlevels-api \
		node namedlevels-api.js

run-circlejams:
	docker run -v $(HOMEDIR)/configs/circlejams:/usr/src/app/config \
		-v $(HOMEDIR)/data/circlejams:/usr/src/app/data \
		jkang/circlejams node post-verse.js

run-circlejams-followback:
	docker run \
		-v $(HOMEDIR)/configs/circlejams:/usr/src/app/config \
		jkang/circlejams make followback

# USAGE: $ NAME=your-project-name make create-directories
create-directories:
	mkdir /var/apps/smidgeo-headporters/configs/$(NAME) && \
		mkdir /var/apps/smidgeo-headporters/data/$(NAME)
