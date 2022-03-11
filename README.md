# tf-azure-osm-seed

[WIP] For purpose and scope, see [Issue 1](https://github.com/hotosm/tf-azure-osm-seed/issues/1)

## Azure Setup

### Resources

To deploy OSM Seed from this repo to Microsoft Azure, some resources need to be manually created. These are used by Terraform to store the state.

1. A resource group. By default this is called `osmseedterraformdev`
2. A storage account. By default this is called `osmseedterraformstate`
3. A storage blob container. By default this is called `osmseed-dev`

### Secrets

For Github Actions to run the `scripts/cideploy` script, a few secrets need to be setup in this repo.

1. Service Principal
Create a service principal at the subscription level. `az ad sp create-for-rbac --name "osm-seed-terraform-deploy" --sdk-auth`. The secrets associated with this SP that should be added in the GH secrets are:
* `TERRAFORM_SERVICE_PRINCIPAL_ID` (client id)
* `TERRAFORM_SERVICE_PRINCIPAL_KEY` (client key)
* `TERRAFORM_SUBSCRIPTION_ID`
* `TERRAFORM_TENANT_ID`

2. Storage Key
For the storage account created earlier, go to the Azure Portal > Access Keys and copy a `key`. This should be supplied is `TERRAFORM_STORAGE_KEY`

3. Role assignment
To let Terraform create a role assignment for AKS to for network setup. It requires `service_principal_object_id` that was created in the previous step.

* First find the service principal object id `az ad sp list --display-name "osm-seed-terraform-deploy"`
* Then run:

```
az role assignment create --assignee "{service_principal_object_id}" \
--role "User Access Administrator" \
--scope "/subscriptions/{id}/resourceGroups/{osm-seed_rg_name}"
```

```
az role assignment create --assignee "{service_principal_object_id}" \
--role "Reader" \
--scope "/subscriptions/{id}/resourceGroups/{osm-seed_rg_name}"
```

```
az role assignment create --assignee "{service_principal_object_id}" \
--role "Azure Kubernetes Service RBAC Admin" \
--scope "/subscriptions/{id}/resourceGroups/{osm-seed_rg_name}"
```

Create a custom role to provide required access for creating and deploying a stack.

1. Save the following as osm-seed-role.json

```
{
    "Name": "OSM Seed Deployer",
    "IsCustom": true,
    "Description": "Can create and maintain an OSM Seed Stack.",
    "Actions": [
       "Microsoft.Authorization/roleAssignments/write"
    ],
    "NotActions": [
    ],
    "AssignableScopes": [
      "/subscriptions/{id}
    ]
}
```

2. Create the role definition

```
az role definition create --role-definition osm-seed-role.json
```

3. Assign the role to the subscription

```
az role assignment create --assignee "{service_principal_object_id}" \
--role "OSM Seed Deployer" \
--scope "/subscriptions/{id}/"
```