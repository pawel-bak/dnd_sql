namespace: mssql_project.operations.azure.storage
operation:
  name: extendOSDisk
  inputs:
    - vmName
    - groupName
    - location: "${get_sp('azure.LOCATION')}"
    - extendSize: '10'
    - sub_idVar: "${get_sp('azure.AZURE_SUBSCRIPTION_ID')}"
    - client_idVar: "${get_sp('azure.AZURE_CLIENT_ID')}"
    - client_secretVar: "${get_sp('azure.AZURE_CLIENT_SECRET')}"
    - tenant_idVar: "${get_sp('azure.AZURE_TENANT_ID')}"
  python_action:
    use_jython: false
    script: "import os\nfrom azure.common.credentials import ServicePrincipalCredentials\nfrom azure.mgmt.resource import ResourceManagementClient\nfrom azure.mgmt.storage import StorageManagementClient\nfrom azure.mgmt.network import NetworkManagementClient\nfrom azure.mgmt.compute import ComputeManagementClient\nfrom haikunator import Haikunator\n\n\n# do not remove the execute function \ndef execute(vmName, groupName, location, extendSize, sub_idVar, client_idVar, client_secretVar, tenant_idVar ): \n    message = \"\"\n    result = \"\"\n    \n    \n    try:\n        \n        haikunator = Haikunator()\n        \n        #\n        # Create all clients with an Application (service principal) token provider\n        #\n        subscription_id = sub_idVar  # your Azure Subscription Id\n        credentials = ServicePrincipalCredentials(\n            client_id=client_idVar,\n            secret=client_secretVar,\n            tenant=tenant_idVar\n        )\n        \n        resource_client = ResourceManagementClient(credentials, subscription_id)\n        compute_client = ComputeManagementClient(credentials, subscription_id)\n        storage_client = StorageManagementClient(credentials, subscription_id)\n        network_client = NetworkManagementClient(credentials, subscription_id)\n        storageAccountName = haikunator.haikunate(delimiter='')\n        \n        \n        # Get one the virtual machine by name\n        message += 'Get Virtual Machine by Name'\n        virtual_machine = compute_client.virtual_machines.get(\n            groupName,\n            vmName\n        )\n\n        # Deallocating the VM (resize prepare)\n        message += '\\nDeallocating the VM (resize prepare)'\n        async_vm_deallocate = compute_client.virtual_machines.deallocate(\n            groupName, vmName)\n        async_vm_deallocate.wait()\n        \n        # Update OS disk size by 10Gb\n        message += '\\nUpdate OS disk size'\n        # Server is not returning the OS Disk size (None), possible bug in server\n        if not virtual_machine.storage_profile.os_disk.disk_size_gb:\n            print(\"\\tServer is not returning the OS disk size, possible bug in the server?\")\n            print(\"\\tAssuming that the OS disk size is 256 GB\")\n            virtual_machine.storage_profile.os_disk.disk_size_gb = 256\n    \n        virtual_machine.storage_profile.os_disk.disk_size_gb += int(extendSize)\n        async_vm_update = compute_client.virtual_machines.create_or_update(\n            groupName,\n            vmName,\n            virtual_machine\n        )\n        virtual_machine = async_vm_update.result()\n        message += '\\nUpdate OS disk size - DONE'\n        \n        result = \"True\"\n    except Exception as e:\n        message = e\n        result = \"False\"\n    return {\"result\": result, \"message\": message }\n    # code goes here\n# you can add additional helper methods below.-"
  outputs:
    - result
    - message
  results:
    - SUCCESS: '${result=="True"}'
    - FAILURE
