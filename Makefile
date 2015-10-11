HOMEDIR = $(shell pwd)
GITDIR = /var/repos/smidgeo-headporters.git

pushall:
	git push origin master && git push origin server

sync-worktree-to-git:
	git --work-tree=$(HOMEDIR) --git-dir=$(GITDIR) checkout -f

install-cron:
	crontab schedule.cron

post-receive: sync-worktree-to-git install-cron

run-attnbot:
	docker run -v $(HOMEDIR)/config:/usr/src/app/config \
		jkang/attnbot make run-mishear-quote
