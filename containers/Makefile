PWD=$(shell pwd)
TAG=v0.0.1
DOCKER_USER=kristinagagalova
BASE_IMAGE=$(DOCKER_USER)/base:$(TAG)

INSTALL_BASE=/opt

define make_image_name
$(DOCKER_USER)/$(notdir $1):$(TAG)
endef

clean:
	docker stop $(shell docker ps -aq) || true
	docker rm $(shell docker ps -a -q) || true
	docker rmi $(shell docker images -q) || true
	singularity cache clean -f
	rm -rf -- tmp
	rm -rf -- docker

tidy:
	# Just removes untagged images to free up space
	rm -rf -- tmp
	docker image prune -f

# Generic rules
singularity/%.sif: docker/%
	@mkdir -p "$(dir $@)"
	@mkdir -p tmp tmp/cache
	SINGULARITY_TMPDIR="${PWD}/tmp" SINGULARITY_CACHEDIR="${PWD}/tmp/cache" singularity build \
	  --force \
	  --tmpdir "${PWD}/tmp" \
	  "$@" \
	  "docker-daemon://$(call make_image_name,$(notdir $(basename $@)))"

docker/%.tar.gz: docker/%
	@mkdir -p "$(dir $@)"
	docker save "$(call make_image_name,$(basename $(basename $@)))" | gzip > $@

docker/ont-tools: ont-tools.Dockerfile env.yml
	docker build \
	  --file $< \
	  -t "$(call make_image_name,$@)" \
	  .
	@mkdir -p "$(dir $@)"
	@touch $@




