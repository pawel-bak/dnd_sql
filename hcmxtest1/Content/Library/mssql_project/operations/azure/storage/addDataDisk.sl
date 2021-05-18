namespace: mssql_project.operations.azure.storage
operation:
  name: addDataDisk
  inputs:
    - vmName
    - groupName
    - location: "${get_sp('azure.LOCATION')}"
    - storageAccountName
    - dataDiskName: vmdiskname1
    - dataDiskSize: '100'
    - sub_idVar: "${get_sp('azure.AZURE_SUBSCRIPTION_ID')}"
    - client_idVar: "${get_sp('azure.AZURE_CLIENT_ID')}"
    - client_secretVar: "${get_sp('azure.AZURE_CLIENT_SECRET')}"
    - tenant_idVar: "${get_sp('azure.AZURE_TENANT_ID')}"
  python_action:
    use_jython: false
    script: "import os\nfrom azure.common.credentials import ServicePrincipalCredentials\nfrom azure.mgmt.resource import ResourceManagementClient\nfrom azure.mgmt.storage import StorageManagementClient\nfrom azure.mgmt.network import NetworkManagementClient\nfrom azure.mgmt.compute import ComputeManagementClient\nfrom haikunator import Haikunator\n\n\n# do not remove the execute function \ndef execute(vmName, groupName, location, storageAccountName, dataDiskName, dataDiskSize, sub_idVar, client_idVar, client_secretVar, tenant_idVar ): \n    message = \"\"\n    result = \"\"\n    \n    \n    try:\n        \n        haikunator = Haikunator()\n        \n        #\n        # Create all clients with an Application (service principal) token provider\n        #\n        subscription_id = sub_idVar  # your Azure Subscription Id\n        credentials = ServicePrincipalCredentials(\n            client_id=client_idVar,\n            secret=client_secretVar,\n            tenant=tenant_idVar\n        )\n        \n        resource_client = ResourceManagementClient(credentials, subscription_id)\n        compute_client = ComputeManagementClient(credentials, subscription_id)\n        storage_client = StorageManagementClient(credentials, subscription_id)\n        network_client = NetworkManagementClient(credentials, subscription_id)\n        storageAccountName = haikunator.haikunate(delimiter='')\n        \n        # Attach data disk\n        message += 'Attach Data Disk'\n        async_vm_update = compute_client.virtual_machines.create_or_update(\n            groupName,\n            vmName,\n            {\n                'location': location,\n                'storage_profile': {\n                    'data_disks': [{\n                        'name': dataDiskName,\n                        'disk_size_gb': int(dataDiskSize),\n                        'lun': 0,\n                        'vhd': {\n                            'uri': \"http://{}.blob.core.windows.net/vhds/{}.vhd\".format(\n                                storageAccountName, dataDiskName)\n                        },\n                        'create_option': 'Empty'\n                    }]\n                }\n            }\n        )\n        async_vm_update.wait()\n        message += 'Data Disk attach'\n        \n        result = \"True\"\n    except Exception as e:\n        message = e\n        result = \"False\"\n    return {\"result\": result, \"message\": message }\n    # code goes here\n# you can add additional helper methods below."
  outputs:
    - result
    - message
  results:
    - SUCCESS: '${result=="True"}'
    - FAILURE
