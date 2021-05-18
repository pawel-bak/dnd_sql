namespace: mssql_project.operations.azure.VM
operation:
  name: createLinuxVM
  inputs:
    - vmName
    - username: "${get_sp('azure.VM_USERNAME')}"
    - password: "${get_sp('azure.VM_PASSWORD')}"
    - osDiskName: "${get_sp('azure.OS_DISK_NAME')}"
    - groupName
    - location: "${get_sp('azure.LOCATION')}"
    - nicID
    - storageAccountName
    - sub_idVar: "${get_sp('azure.AZURE_SUBSCRIPTION_ID')}"
    - client_idVar: "${get_sp('azure.AZURE_CLIENT_ID')}"
    - client_secretVar: "${get_sp('azure.AZURE_CLIENT_SECRET')}"
    - tenant_idVar: "${get_sp('azure.AZURE_TENANT_ID')}"
  python_action:
    use_jython: false
    script: "import os\nfrom azure.common.credentials import ServicePrincipalCredentials\nfrom azure.mgmt.resource import ResourceManagementClient\nfrom azure.mgmt.storage import StorageManagementClient\nfrom azure.mgmt.network import NetworkManagementClient\nfrom azure.mgmt.compute import ComputeManagementClient\nfrom haikunator import Haikunator\n\n\n# do not remove the execute function \ndef execute(vmName, username, password, osDiskName, groupName, location, nicID, storageAccountName, sub_idVar, client_idVar, client_secretVar, tenant_idVar ): \n    message = \"\"\n    result = \"\"\n    \n    VM_REFERENCE = {\n        'linux': {\n            'publisher': 'Canonical',\n            'offer': 'UbuntuServer',\n            'sku': '16.04.0-LTS',\n            'version': 'latest'\n        },\n        'windows': {\n            'publisher': 'MicrosoftWindowsServer',\n            'offer': 'WindowsServer',\n            'sku': '2019-Datacenter',\n            'version': 'latest'\n        }\n    }\n        \n    \n    try:\n\n        #\n        # Create all clients with an Application (service principal) token provider\n        #\n        subscription_id = sub_idVar  # your Azure Subscription Id\n        credentials = ServicePrincipalCredentials(\n            client_id=client_idVar,\n            secret=client_secretVar,\n            tenant=tenant_idVar\n        )\n        \n        resource_client = ResourceManagementClient(credentials, subscription_id)\n        compute_client = ComputeManagementClient(credentials, subscription_id)\n        storage_client = StorageManagementClient(credentials, subscription_id)\n        network_client = NetworkManagementClient(credentials, subscription_id)\n        \n        # Create Linux VM\n        message += 'Creating Linux Virtual Machine'\n        vm_parameters = create_vm_parameters(nicID, VM_REFERENCE['linux'], location, vmName, username, password, osDiskName, storageAccountName)\n        \n        message += '\\n' + str(vm_parameters)\n        async_vm_creation = compute_client.virtual_machines.create_or_update(\n            groupName, vmName, vm_parameters)\n        async_vm_creation.wait()\n        message +=\"\\nCreated: {}\".format(storageAccountName)\n        \n        \n        result = \"True\"\n    except Exception as e:\n        message += '\\n' + str(e)\n        result = \"False\"\n    return {\"result\": result, \"message\": message }\n    # code goes here\n# you can add additional helper methods below.\n\n\ndef create_vm_parameters(nic_id, vm_reference, LOCATION, VM_NAME, USERNAME, PASSWORD, OS_DISK_NAME, STORAGE_ACCOUNT_NAME):\n    \"\"\"Create the VM parameters structure.\n    \"\"\"\n    haikunator = Haikunator()\n    \n    return {\n        'location': LOCATION,\n        'os_profile': {\n            'computer_name': VM_NAME,\n            'admin_username': USERNAME,\n            'admin_password': PASSWORD\n        },\n        'hardware_profile': {\n            'vm_size': 'Standard_DS1'\n        },\n        'storage_profile': {\n            'image_reference': {\n                'publisher': vm_reference['publisher'],\n                'offer': vm_reference['offer'],\n                'sku': vm_reference['sku'],\n                'version': vm_reference['version']\n            },\n            'os_disk': {\n                'name': OS_DISK_NAME,\n                'caching': 'None',\n                'create_option': 'fromImage',\n                'vhd': {\n                    'uri': 'https://{}.blob.core.windows.net/vhds/{}.vhd'.format(\n                        STORAGE_ACCOUNT_NAME, VM_NAME+haikunator.haikunate())\n                }\n            },\n        },\n        'network_profile': {\n            'network_interfaces': [{\n                'id': nic_id,\n            }]\n        },\n    }"
  outputs:
    - result
    - message
  results:
    - SUCCESS: '${result=="True"}'
    - FAILURE
