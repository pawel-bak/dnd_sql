namespace: mssql_project.operations.azure.network
operation:
  name: createPublicNic
  inputs:
    - pubAddressName: public_ip_address1
    - groupName
    - location: "${get_sp('azure.LOCATION')}"
    - sub_idVar: "${get_sp('azure.AZURE_SUBSCRIPTION_ID')}"
    - client_idVar: "${get_sp('azure.AZURE_CLIENT_ID')}"
    - client_secretVar: "${get_sp('azure.AZURE_CLIENT_SECRET')}"
    - tenant_idVar: "${get_sp('azure.AZURE_TENANT_ID')}"
  python_action:
    use_jython: false
    script: "import os\nfrom azure.common.credentials import ServicePrincipalCredentials\nfrom azure.mgmt.resource import ResourceManagementClient\nfrom azure.mgmt.storage import StorageManagementClient\nfrom azure.mgmt.network import NetworkManagementClient\nfrom azure.mgmt.compute import ComputeManagementClient\nfrom haikunator import Haikunator\n\n\n# do not remove the execute function \ndef execute(pubAddressName, groupName, location, sub_idVar, client_idVar, client_secretVar, tenant_idVar ): \n    message = \"\"\n    result = \"\"\n    nicID = \"\"\n    try:\n        \n        #\n        # Create all clients with an Application (service principal) token provider\n        #\n        subscription_id = sub_idVar  # your Azure Subscription Id\n        credentials = ServicePrincipalCredentials(\n            client_id=client_idVar,\n            secret=client_secretVar,\n            tenant=tenant_idVar\n        )\n        \n        resource_client = ResourceManagementClient(credentials, subscription_id)\n        compute_client = ComputeManagementClient(credentials, subscription_id)\n        storage_client = StorageManagementClient(credentials, subscription_id)\n        network_client = NetworkManagementClient(credentials, subscription_id)\n        \n        GROUP_NAME = groupName\n        PUBLIC_IP_ADDRESS = pubAddressName\n        \n        # Create Public IP Address\n        public_ip_address = network_client.public_ip_addresses.create_or_update(\n            GROUP_NAME,\n            PUBLIC_IP_ADDRESS,\n            {\n              \"location\": location\n            }\n        ).result()\n        message += \"Create Public IP Address:\\n{}\".format(public_ip_address)\n        \n        nicID = str(public_ip_address.id)\n        \n        result = \"True\"\n    except Exception as e:\n        message = e\n        result = \"False\"\n    return {\"result\": result, \"message\": message, \"nicID\": nicID }\n    # code goes here\n    \n# you can add additional helper methods below.\n\ndef create_nic(network_client, LOCATION, GROUP_NAME, VNET_NAME, SUBNET_NAME, NIC_NAME, IP_CONFIG_NAME):\n    \"\"\"Create a Network Interface for a VM.\n    \"\"\"\n    message=\"\"\n    \n    # Create VNet\n    message+='\\nCreate Vnet'\n    async_vnet_creation = network_client.virtual_networks.create_or_update(\n        GROUP_NAME,\n        VNET_NAME,\n        {\n            'location': LOCATION,\n            'address_space': {\n                'address_prefixes': ['10.0.0.0/16']\n            }\n        }\n    )\n    async_vnet_creation.wait()\n\n    # Create Subnet\n    message+='\\nCreate Subnet'\n    async_subnet_creation = network_client.subnets.create_or_update(\n        GROUP_NAME,\n        VNET_NAME,\n        SUBNET_NAME,\n        {'address_prefix': '10.0.0.0/24'}\n    )\n    subnet_info = async_subnet_creation.result()\n\n    # Create NIC\n    message+='\\nCreate NIC'\n    async_nic_creation = network_client.network_interfaces.create_or_update(\n        GROUP_NAME,\n        NIC_NAME,\n        {\n            'location': LOCATION,\n            'ip_configurations': [{\n                'name': IP_CONFIG_NAME,\n                'subnet': {\n                    'id': subnet_info.id\n                }\n            }]\n        }\n    )\n    return {\"result\": async_nic_creation.result(), \"message\": message}"
  outputs:
    - result
    - message
    - nicID
  results:
    - SUCCESS: '${result=="True"}'
    - FAILURE
