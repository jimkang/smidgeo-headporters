HOMEDIR = $(shell pwd)

pushall: sync remote-update-all
	git push origin master

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
	# run-ngram-seance \
	# run-file-grab-webhook \

update-images: \
	update-rapgamemetaphor

update-rapgamemetaphor:
	docker pull jkang/rapgamemetaphor

run-rapgame:
	docker run --rm \
		-v $(HOMEDIR)/configs/rapgamemetaphor:/usr/src/app/config \
		jkang/rapgamemetaphor make run

# run-daycare-provider-api:
# 	docker rm -f daycare-provider-api || \
# 		echo "daycare-provider-api did not need removal."
# 	docker run \
# 		-d \
# 		--restart=always \
# 		--name daycare-provider-api \
# 		-v $(HOMEDIR)/data/daycare-provider-api:/usr/src/app/data \
# 		-p 4999:4999 \
# 		jkang/daycare-provider-api \
# 		node daycare-provider-api.js

# USAGE: $ NAME=your-project-name make create-directories
create-directories:
	mkdir /var/apps/smh/configs/$(NAME) && \
		mkdir /var/apps/smh/data/$(NAME)

sync:
	rsync -a $(HOMEDIR) $(SMUSER)@smidgeo-headporters:/var/apps/
	ssh $(SMUSER)@smidgeo-headporters "cd /var/apps/smh && make install-cron"

remote-update-all:
	ssh $(SMUSER)@smidgeo-headporters "cd /var/apps/smh && make update-all"
