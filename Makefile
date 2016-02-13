HOMEDIR = $(shell pwd)

pushall:
	git push origin master && git push server master

start-docker-machine:
	docker-machine create --driver virtualbox dev

build-base-image:
	docker build -t jkang/headporters .

push-base-image:
	docker push jkang/headporters

install-cron:
	crontab schedule.cron

update-all: install-cron update-images start-servers

start-servers: \
	run-namedlevels-api \
	run-kilwala \
	run-aw-yea-bot-responder \
	run-daycare-provider-api
	# run-ngram-seance \
	# run-file-grab-webhook \

update-images: \
	update-watching-very-closely \
	update-rapgamemetaphor \
	update-matchupbot \
	update-contingencybot \
	update-fact-bots \
	update-namedlevels-api \
	update-circlejams \
	update-a-tyranny-of-words \
	update-kilwala \
	update-aw-yea-bot \
	update-daycare-provider-api
	# update-ngram-seance \
	# update-file-grab-webhook \

update-watching-very-closely:
	docker pull jkang/watching-very-closely

update-rapgamemetaphor:
	docker pull jkang/rapgamemetaphor

# update-ngram-seance:
# 	docker pull jkang/ngram-seance

update-matchupbot:
	docker pull jkang/matchupbot

update-contingencybot:
	docker pull jkang/if-you-are-reading-this

# update-file-grab-webhook:
# 	docker pull jkang/file-grab-webhook

update-fact-bots:
	docker pull jkang/fact-bots

update-namedlevels-api:
	docker pull jkang/namedlevels-api

update-circlejams:
	docker pull jkang/circlejams

update-a-tyranny-of-words:
	docker pull jkang/a-tyranny-of-words

update-kilwala:
	docker pull jkang/kilwala

update-aw-yea-bot:
	docker pull jkang/aw-yea-bot

update-daycare-provider-api:
	docker pull jkang/daycare-provider-api

run-watching-very-closely:
	docker run --rm \
		-v $(HOMEDIR)/configs/watching-very-closely:/usr/src/app/config \
		-v $(HOMEDIR)/data/watching-very-closely:/usr/src/app/data \
		jkang/watching-very-closely make run

run-rapgame:
	docker run --rm \
		-v $(HOMEDIR)/configs/rapgamemetaphor:/usr/src/app/config \
		jkang/rapgamemetaphor make run

# run-ngram-seance:
# 	docker rm -f ngram-seance || echo "ngram-seance did not need removal."
# 	docker run \
# 		-d \
# 		--restart=always \
# 		--name ngram-seance \
# 		-v $(HOMEDIR)/configs/ngram-seance:/usr/src/app/config \
# 		-v $(HOMEDIR)/data/ngram-seance:/usr/src/app/data \
# 		jkang/ngram-seance

# run-ngram-seance-followback:
# 	docker run \
# 		-v $(HOMEDIR)/configs/ngram-seance:/usr/src/app/config \
# 		jkang/ngram-seance make followback

# run-ngram-seance-tweet-unprompted:
# 	docker run \
# 		-v $(HOMEDIR)/configs/ngram-seance:/usr/src/app/config \
# 		jkang/ngram-seance make tweet-unprompted

run-matchupbot:
	docker run -v $(HOMEDIR)/configs/matchupbot:/usr/src/app/config \
		jkang/matchupbot make run

run-contingencybot:
	docker run -v $(HOMEDIR)/configs/if-you-are-reading-this:/usr/src/app/config \
		-v $(HOMEDIR)/data/if-you-are-reading-this:/usr/src/app/data \
		jkang/if-you-are-reading-this make run

# run-file-grab-webhook:
# 	docker rm -f file-grab-webhook || echo "file-grab-webhook did not need removal."
# 	docker run \
# 		-d \
# 		--restart=always \
# 		--name file-grab-webhook \
# 		-v $(HOMEDIR)/configs/file-grab-webhook:/usr/src/app/config \
# 		-v $(HOMEDIR)/data/if-you-are-reading-this:/usr/src/app/data \
# 		-p 3489:3489 \
# 		jkang/file-grab-webhook

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

run-a-tyranny-of-words:
	docker run -v $(HOMEDIR)/configs/a-tyranny-of-words:/usr/src/app/config \
		-v $(HOMEDIR)/data/a-tyranny-of-words:/usr/src/app/data \
		jkang/a-tyranny-of-words node post-collective-noun.js

run-kilwala:
	docker rm -f kilwala || \
		echo "kilwala did not need removal."
	docker run \
		-d \
		--restart=always \
		--name kilwala \
		-v $(HOMEDIR)/configs/kilwala:/usr/src/app/config \
		-v $(HOMEDIR)/data/kilwala:/usr/src/app/data \
		jkang/kilwala \
		node kilwala-responder.js

run-aw-yea-bot-responder:
	docker rm -f aw-yea-bot-responder || \
		echo "aw-yea-bot-responder did not need removal."
	docker run \
		-d \
		--restart=always \
		--name aw-yea-bot-responder \
		-v $(HOMEDIR)/configs/aw-yea-bot:/usr/src/app/config \
		-v $(HOMEDIR)/data/aw-yea-bot:/usr/src/app/data \
		jkang/aw-yea-bot \
		node aw-yea-responder.js

run-aw-yea-bot:
	docker run -v $(HOMEDIR)/configs/aw-yea-bot:/usr/src/app/config \
		-v $(HOMEDIR)/data/aw-yea-bot:/usr/src/app/data \
		jkang/aw-yea-bot node aw-yea-post.js

run-daycare-provider-api:
	docker rm -f daycare-provider-api || \
		echo "daycare-provider-api did not need removal."
	docker run \
		-d \
		--restart=always \
		--name daycare-provider-api \
		-v $(HOMEDIR)/data/daycare-provider-api:/usr/src/app/data \
		-p 4999:4999 \
		jkang/daycare-provider-api \
		node daycare-provider-api.js
#		-v $(HOMEDIR)/configs/daycare-provider-api:/usr/src/app/config \

# USAGE: $ NAME=your-project-name make create-directories
create-directories:
	mkdir /var/apps/smh/configs/$(NAME) && \
		mkdir /var/apps/smh/data/$(NAME)

sync:
	rsync -a $(HOMEDIR) $(SMUSER)@smidgeo-headporters:/var/apps/

remote-update-all:
	ssh $(SMUSER)@smidgeo-headporters "cd /var/apps/smh && make update-all"
