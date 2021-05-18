namespace: mssql_project.operations.azure.storage
operation:
  name: createStorageAccount
  inputs:
    - groupName
    - location: "${get_sp('azure.LOCATION')}"
    - sub_idVar: "${get_sp('azure.AZURE_SUBSCRIPTION_ID')}"
    - client_idVar: "${get_sp('azure.AZURE_CLIENT_ID')}"
    - client_secretVar: "${get_sp('azure.AZURE_CLIENT_SECRET')}"
    - tenant_idVar: "${get_sp('azure.AZURE_TENANT_ID')}"
  python_action:
    use_jython: false
    script: "import os\nfrom azure.common.credentials import ServicePrincipalCredentials\nfrom azure.mgmt.resource import ResourceManagementClient\nfrom azure.mgmt.storage import StorageManagementClient\nfrom azure.mgmt.network import NetworkManagementClient\nfrom azure.mgmt.compute import ComputeManagementClient\nfrom haikunator import Haikunator\n\n\n# do not remove the execute function \ndef execute(groupName, location, sub_idVar, client_idVar, client_secretVar, tenant_idVar ): \n    message = \"\"\n    result = \"\"\n    storageAccountName = \"\"\n    \n    try:\n        \n        haikunator = Haikunator()\n        \n        #\n        # Create all clients with an Application (service principal) token provider\n        #\n        subscription_id = sub_idVar  # your Azure Subscription Id\n        credentials = ServicePrincipalCredentials(\n            client_id=client_idVar,\n            secret=client_secretVar,\n            tenant=tenant_idVar\n        )\n        \n        resource_client = ResourceManagementClient(credentials, subscription_id)\n        compute_client = ComputeManagementClient(credentials, subscription_id)\n        storage_client = StorageManagementClient(credentials, subscription_id)\n        network_client = NetworkManagementClient(credentials, subscription_id)\n        storageAccountName = haikunator.haikunate(delimiter='')\n        \n        \n        # Create a storage account\n        message += 'Create a storage account'\n        storage_async_operation = storage_client.storage_accounts.create(\n            groupName,\n            storageAccountName,\n            {\n                'sku': {'name': 'standard_lrs'},\n                'kind': 'storage',\n                'location': location\n            }\n        )\n        storage_async_operation.wait()\n        message +=\"\\nCreated: {}\".format(storageAccountName)\n        \n        result = \"True\"\n    except Exception as e:\n        message = e\n        result = \"False\"\n    return {\"result\": result, \"message\": message, \"storageAccountName\":str(storageAccountName) }\n    # code goes here\n# you can add additional helper methods below."
  outputs:
    - result
    - message
    - storageAccountName
  results:
    - SUCCESS: '${result=="True"}'
    - FAILURE
