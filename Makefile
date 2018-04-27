include Makefile.settings

.PHONY: roles environment generate deploy delete

roles:
	${INFO} "Installing Ansible roles from roles/requirements.yml..."
	ansible-galaxy install -r roles/requirements.yml --force
	${INFO} "Installation complete"

generate/%:
	${INFO} "Generating templates for $*..."
	ansible-playbook site.yml -e 'Stack.Upload=false' -e 'Sts.Disabled=true' -e env=$* $(FLAGS) --tags generate
	${INFO} "Generation complete"

deploy/%:
	${INFO} "Deploying environment $*..."
	ansible-playbook site.yml -e env=$* $(FLAGS)
	${INFO} "Deployment complete"

delete/%:
	${INFO} "Deleting environment $*..."
	ansible-playbook site.yml -e env=$* -e 'Stack.Delete=true' $(FLAGS)
	${INFO} "Delete complete"

environment/%:
	set -e -o pipefail
	environment=$*
	touch inventory
	if ! grep -q "^\[$$environment\]" inventory
	then
		mkdir -p group_vars/$$environment
		echo -n > group_vars/$$environment/vars.yml
		echo -e "\n[$$environment]" >> inventory
		echo "$$environment ansible_connection=local" >> inventory
		tee group_vars/$$environment/vars.yml << EOF > /dev/null
		# STS settings
		Sts.Role: arn:aws:iam::$(ACCOUNT_ID):role/admin
		Sts.Region: $${REGION:-us-east-1}
		EOF
		tmp=$$(mktemp)
		cat buildspec.yml | yq ".phases.build.commands += [\"make generate/$$environment /codebuild\"]" -y > "$$tmp" && mv "$$tmp" buildspec.yml
		${INFO} "Created environment $$environment with account ID $(ACCOUNT_ID)"
	else
		${INFO} "Environment $$environment already exists"
	fi