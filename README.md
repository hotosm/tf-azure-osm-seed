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
   Create a service principal at the subscription level. `az ad sp create-for-rbac --name "osm-seed-terraform-deploy" --sdk-auth`. The output should look like:

```json
{
  "clientId": "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "clientSecret": "xxxx.xxxxxxxxxxxx",
  "subscriptionId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxx",
  "tenantId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxx",
  ...
}
```

The secrets associated with this SP that should be added in the GH secrets are:

- `TERRAFORM_SERVICE_PRINCIPAL_ID` (clientId)
- `TERRAFORM_SERVICE_PRINCIPAL_KEY` (clientSecret)
- `TERRAFORM_SUBSCRIPTION_ID` (subscriptionId)
- `TERRAFORM_TENANT_ID` (tenantId)

also export some values that is going to be require for next steps: 

```sh
export resource_group_name=osmseedterraformdev
export subscriptionId=<subscriptionId>
export service_principal_object_id=<clientId>
# export service_principal_object_id=$(az ad sp list --display-name "osm-seed-terraform-deploy" | jq .[].appId)

```

2. Storage Key
   For the storage account created earlier, go to the [Azure Portal > Access Keys]((https://user-images.githubusercontent.com/1152236/160679936-7f245d40-994b-4e6b-aaa1-f54eadc61207.png)) and copy a `key`. This should be supplied is `TERRAFORM_STORAGE_KEY`

3. Role assignment
   To let Terraform create a role assignment for AKS to for network setup. It requires run the following command lines


```sh
az role assignment create --assignee "${service_principal_object_id}" \
  --role "User Access Administrator" \
  --scope "/subscriptions/${subscriptionId}/resourceGroups/${resource_group_name}"
```

```sh
az role assignment create --assignee "${service_principal_object_id}" \
  --role "Reader" \
  --scope "/subscriptions/${subscriptionId}/resourceGroups/${resource_group_name}"
```

```sh
az role assignment create --assignee "${service_principal_object_id}" \
  --role "Azure Kubernetes Service RBAC Admin" \
  --scope "/subscriptions/${subscriptionId}/resourceGroups/${resource_group_name}"
```

Create a custom role to provide required access for creating and deploying a stack.

1. Save the following as osm-seed-role.json

```sh
echo '''{
    "Name": "OSM Seed Deployer",
    "IsCustom": true,
    "Description": "Can create and maintain an OSM Seed Stack.",
    "Actions": [
       "Microsoft.Authorization/roleAssignments/write"
    ],
    "NotActions": [
    ],
    "AssignableScopes": [
      "/subscriptions/'${subscriptionId}'"
    ]
}''' > osm-seed-role.json
```

2. Create the role definition

```
az role definition create --role-definition osm-seed-role.json
```

3. Assign the role to the subscription

```sh
az role assignment create --assignee "${service_principal_object_id}" \
  --role "OSM Seed Deployer" \
  --scope "/subscriptions/${subscriptionId}"
```

## Configure an external iD instance

OSM Seed comes with the default iD version as part of the OSM rails application. It is possible to use a custom instance like RapiD to point to the OSM Seed API.
To do this:

- Signing into the OSM Seed instance and creatgea new OAuth Application and get a Consumer Key and Secret.
- Modify the relevant values in your iD instance: https://github.com/facebookincubator/RapiD/blob/main/index.html#L50


## Configuration options in values.yaml

There are several things that can be configured by editing the `values.yaml` file, found in `deployment/terraform/resources`. These are various options passed to the `osm-seed` helm chart, that will control enabling and disabling various services and jobs, as well as managing things like data imports.

### Configuring your domain name

To point a domain name to your osm-seed instance:

For this example, let's say you want to point the domain `osm-seed.example.com` to your osm-seed instance. This would mean that the Helm templates would make the web service accessible at `web.osm-seed.example.com`. If you have other services enabled, they would be available at their respective subdomains - for eg. Overpass would be available at `overpass.osm-seed.example.com`.

You will need to edit the `domain` definition in your `values.yaml` file with the domain that is being pointed. So, for our example, that would be `osm-seed.example.com`. You should also edit the `adminEmail` value in the `values.yaml` file with your email address. This will be used as the email address when registering Lets Encrypt SSL certificates.

Additionally, you will need to create a single `A` record pointing a wildcard record for your domain name to the IP address of your kubernetes cluster. You can find out the IP address of your cluster by checking for the External Cluster IP when doing `kubectl get ingress` or by looking at the Ingress definitions in Lens. So, if the IP address of the cluster is 123.123.123.123 you would create an `A` record for `*.osm-seed.example.com` that points to `123.123.123.123`. The `osm-seed` helm chart should then handle configuring the domain names to point to the correct services as well as provisioning SSL. You should now be able to visit `web.osm-seed.example.com` in your browser.


### Importing data

You will often want to import data into your osm-seed instance from a PBF file. This can be accomplished by:

 - Edit the `values.yaml` to set `populateApiDb.enabled` to `true`
 - Set `populateApiDb.env.URL_FILE_TO_IMPORT` to a publicly accessible URL of the PBF file you wish to import
 - Deploy the stack with this configuration
 - A container should be spun up that imports the PBF. You can check the container logs by looking at `kubectl get pods` or the pods in Lens.
 - The process should complete and your data should be imported.
 - After the data is imported, we recommend setting `populateApiDb.enabled` to `false` and re-deploying, to prevent accidentally re-importing the same data.
 - You can also repeat the process for a different PBF file to import more data.

