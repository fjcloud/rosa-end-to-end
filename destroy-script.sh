export AWS_REGION=eu-west-1

oidc_config_id=`rosa describe cluster -c $NAME-hcp -o json | jq -r .aws.sts.oidc_config.id`

rosa delete cluster -c $NAME-hcp -y
echo "watch cluster uninstall"
rosa logs uninstall -c $NAME-hcp --watch


rosa delete operator-roles --prefix $NAME-hcp --mode auto -y
rosa delete account-roles --hosted-cp --mode auto --prefix $NAME-hcp -y
rosa delete oidc-provider --oidc-config-id $oidc_config_id --mode auto -y

terraform destroy -auto-approve
