
run: stop start exec

start:
	docker run -it -d -v /var/run/docker.sock:/var/run/docker.sock -v $$(pwd):/work -v $$PWD/creds:/root/.aws -w /work --name pawst bryandollery/terraform-packer-aws-alpine

exec:
	docker exec -it pawst bash || true

stop:
	docker rm -f pawst 2> /dev/null || true

fmt:
	terraform fmt -recursive

plan:
	terraform plan -out plan.out -var-file=terraform.tfvars

apply:
	terraform apply plan.out 

up:
	terraform apply -auto-approve -var-file=terraform.tfvars

down:
	terraform destroy -auto-approve 

test:
	ssh -i ssh/id_rsa ubuntu@$$(terraform output -json | jq '.nodes.value[0]' | xargs)
init:
	rm -rf .terraform ssh
	mkdir ssh
	terraform init
	ssh-keygen -t rsa -f ./ssh/id_rsa -q -N ""	
