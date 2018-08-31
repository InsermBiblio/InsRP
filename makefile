.PHONY: help
.DEFAULT_GOAL := help

help:
	@test -f /usr/bin/xmlstarlet || echo "Needs: sudo apt-get install --yes xmlstarlet"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

run-prod: cleanup-docker config ## run BibRP using environment variable
	docker-compose -f docker-compose.prod.yml up -d --force-recreate rp

config: ## patch shibboleth2.xml config file service provider entityID
	test -f /usr/bin/xmlstarlet || (echo "Needs: sudo apt-get install --yes xmlstarlet" && exit 1)
	cp -f ./shibboleth/shibboleth2.dist.xml ./shibboleth/shibboleth2.xml
	xmlstarlet ed --inplace \
		-N sp="urn:mace:shibboleth:2.0:native:sp:config" \
		-u "/sp:SPConfig/sp:ApplicationDefaults/@entityID" \
		-v $(ENTITY_ID) \
		shibboleth/shibboleth2.xml

run-dev: cleanup-docker config ## run BibRP for https://bib-preprod.cnrs.fr
	docker-compose -f docker-compose.dev.yml up --force-recreate rp

cleanup-docker: ## remove docker image (needed for updating it)
	test -z "$$(docker ps -a | grep bibrp_rp_1)" || \
	  docker rm --force $$(docker ps -a | grep bibrp_rp_1 | awk '{ print $$1 }')
