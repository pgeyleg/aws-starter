include Makefile.settings

.PHONY: roles generate environment deploy

roles:
	${INFO} "Installing Ansible roles from roles/requirement..."
	@ ansible-galaxy install -r roles/requirements.yml --force
	${INFO} "Installation complete"

environment/%:
	@ mkdir -p group_vars/$*
	@ touch group_vars/$*/vars.yml
	@ echo >> inventory
	@ echo '[$*]' >> inventory
	@ echo '$* ansible_connection=local' >> inventory
	${INFO} "Created environment $*"

generate/%:
	${INFO} "Generating templates for $*..."
	@ ansible-playbook site.yml -e 'Sts.Disabled=true' -e env=$* $(FLAGS) --tags generate
	${INFO} "Generation complete"

deploy/%:
	${INFO} "Deploying environment $*..."
	@ ansible-playbook site.yml -e env=$* $(FLAGS)
	${INFO} "Deployment complete"

destroy/%:
	${INFO} "Destroying environment $*..."
	@ ansible-playbook site.yml -e env=$* -e 'Stack.Delete=true' $(FLAGS)
	${INFO} "Destroy complete"