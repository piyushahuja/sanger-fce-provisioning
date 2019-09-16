

deploy (){
	source hgi-openrc.sh
	cd terraform && terraform apply
	cd ..
	ansible-playbook -i fce_provisioning/ansible/inventory fce_provisioning/ansible/playbook.yml
}


destroy(){
	cd terraform && terraform destroy
}

