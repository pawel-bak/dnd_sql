namespace: mssql_project.operations.azure.network
operation:
  name: createPublicNicEx
  inputs:
    - nicName
    - ipName: "${get_sp('azure.IP_NAME')}"
    - subnetName: "${get_sp('azure.SUBNET_NAME')}"
    - vnetName: "${get_sp('azure.VNET_NAME')}"
    - ipConfigName: "${get_sp('azure.IP_CONFIG_NAME')}"
    - groupName
    - location: "${get_sp('azure.LOCATION')}"
    - sub_idVar: "${get_sp('azure.AZURE_SUBSCRIPTION_ID')}"
    - client_idVar: "${get_sp('azure.AZURE_CLIENT_ID')}"
    - client_secretVar: "${get_sp('azure.AZURE_CLIENT_SECRET')}"
    - tenant_idVar: "${get_sp('azure.AZURE_TENANT_ID')}"
    - os_type: Windows
    - nameIn: test-nsg
  python_action:
    use_jython: false
    script: "import os\nfrom azure.common.credentials import ServicePrincipalCredentials\nfrom azure.mgmt.resource import ResourceManagementClient\nfrom azure.mgmt.storage import StorageManagementClient\nfrom azure.mgmt.network import NetworkManagementClient\nfrom azure.mgmt.compute import ComputeManagementClient\nfrom azure.mgmt.network.models import NetworkSecurityGroup, SecurityRule\nfrom haikunator import Haikunator\n\n\n# do not remove the execute function \ndef execute(nicName, ipName, subnetName, vnetName, ipConfigName, os_type, nameIn,  groupName, location, sub_idVar, client_idVar, client_secretVar, tenant_idVar ): \n    message = \"\"\n    result = \"\"\n    nicID = \"\"\n    publicIPOut = \"\"\n    try:\n        \n        #\n        # Create all clients with an Application (service principal) token provider\n        #\n        subscription_id = sub_idVar  # your Azure Subscription Id\n        credentials = ServicePrincipalCredentials(\n            client_id=client_idVar,\n            secret=client_secretVar,\n            tenant=tenant_idVar\n        )\n        \n        resource_client = ResourceManagementClient(credentials, subscription_id)\n        compute_client = ComputeManagementClient(credentials, subscription_id)\n        storage_client = StorageManagementClient(credentials, subscription_id)\n        network_client = NetworkManagementClient(credentials, subscription_id)\n        \n        # Step 2: provision a virtual network\n\n        # A virtual machine requires a network interface client (NIC). A NIC requires\n        # a virtual network and subnet along with an IP address. Therefore we must provision\n        # these downstream components first, then provision the NIC, after which we\n        # can provision the VM.\n        \n        # Network and IP address names\n        VNET_NAME = vnetName\n        SUBNET_NAME = subnetName\n        IP_NAME = ipName\n        IP_CONFIG_NAME = ipConfigName\n        NIC_NAME = nicName\n        RESOURCE_GROUP_NAME = groupName\n        LOCATION = location\n\n        # Provision the virtual network and wait for completion\n        poller = network_client.virtual_networks.create_or_update(RESOURCE_GROUP_NAME,\n            VNET_NAME,\n            {\n                \"location\": LOCATION,\n                \"address_space\": {\n                    \"address_prefixes\": [\"10.0.0.0/16\"]\n                }\n            }\n        )\n        \n        vnet_result = poller.result()\n        \n        message += f\"Provisioned virtual network {vnet_result.name} with address prefixes {vnet_result.address_space.address_prefixes}\"\n        \n        # Step 3: Provision the subnet and wait for completion\n        poller = network_client.subnets.create_or_update(RESOURCE_GROUP_NAME, \n            VNET_NAME, SUBNET_NAME,\n            { \"address_prefix\": \"10.0.0.0/24\" }\n        )\n        subnet_result = poller.result()\n        \n        message += f\"Provisioned virtual subnet {subnet_result.name} with address prefix {subnet_result.address_prefix}\"\n        \n        # Step 4: Provision an IP address and wait for completion\n        poller = network_client.public_ip_addresses.create_or_update(RESOURCE_GROUP_NAME,\n            IP_NAME,\n            {\n                \"location\": LOCATION,\n                \"sku\": { \"name\": \"Standard\" },\n                \"public_ip_allocation_method\": \"Static\",\n                \"public_ip_address_version\" : \"IPV4\"\n            }\n        )\n        \n        ip_address_result = poller.result()\n        \n        message += f\"Provisioned public IP address {ip_address_result.name} with address {ip_address_result.ip_address}\"\n        \n        publicIPOut = str(ip_address_result.ip_address)\n        \n        secGroupRes = create_default_securitygroup(network_client, groupName, location, nameIn, os_type, None)\n        \n        # Step 5: Provision the network interface client\n        poller = network_client.network_interfaces.create_or_update(RESOURCE_GROUP_NAME,\n            NIC_NAME, \n            {\n                \"location\": LOCATION,\n                \"ip_configurations\": [ {\n                    \"name\": IP_CONFIG_NAME,\n                    \"subnet\": { \"id\": subnet_result.id },\n                    \"public_ip_address\": {\"id\": ip_address_result.id },\n                    \"networkSecurityGroup\": {\"id\": secGroupRes[\"security_group_name_id\"] }\n                }]\n            }\n        )\n        \n        nic_result = poller.result()\n        \n        message += f\"Provisioned network interface client {nic_result.name}\"\n\n        nicID = str(nic_result.id)\n        \n        result = \"True\"\n    except Exception as e:\n        message = e\n        result = \"False\"\n    return {\"result\": result, \"message\": message, \"nicID\": nicID, \"publicIPOut\": publicIPOut }\n    # code goes here\n    \n# you can add additional helper methods below.\n\ndef create_nic(network_client, LOCATION, GROUP_NAME, VNET_NAME, SUBNET_NAME, NIC_NAME, IP_CONFIG_NAME):\n    \"\"\"Create a Network Interface for a VM.\n    \"\"\"\n    message=\"\"\n    \n    # Create VNet\n    message+='\\nCreate Vnet'\n    async_vnet_creation = network_client.virtual_networks.create_or_update(\n        GROUP_NAME,\n        VNET_NAME,\n        {\n            'location': LOCATION,\n            'address_space': {\n                'address_prefixes': ['10.0.0.0/16']\n            }\n        }\n    )\n    async_vnet_creation.wait()\n\n    # Create Subnet\n    message+='\\nCreate Subnet'\n    async_subnet_creation = network_client.subnets.create_or_update(\n        GROUP_NAME,\n        VNET_NAME,\n        SUBNET_NAME,\n        {'address_prefix': '10.0.0.0/24'}\n    )\n    subnet_info = async_subnet_creation.result()\n\n    # Create NIC\n    message+='\\nCreate NIC'\n    async_nic_creation = network_client.network_interfaces.create_or_update(\n        GROUP_NAME,\n        NIC_NAME,\n        {\n            'location': LOCATION,\n            'ip_configurations': [{\n                'name': IP_CONFIG_NAME,\n                'subnet': {\n                    'id': subnet_info.id\n                }\n            }]\n        }\n    )\n    return {\"result\": async_nic_creation.result(), \"message\": message}\n    \ndef create_default_securitygroup(network_client, resource_group, location, name, os_type, open_ports):\n    '''\n    Create a default security group <name>01 to associate with a network interface. If a security group matching\n    <name>01 exists, return it. Otherwise, create one.\n    :param resource_group: Resource group name\n    :param location: azure location name\n    :param name: base name to use for the security group\n    :param os_type: one of 'Windows' or 'Linux'. Determins any default rules added to the security group.\n    :param ssh_port: for os_type 'Linux' port used in rule allowing SSH access.\n    :param rdp_port: for os_type 'Windows' port used in rule allowing RDP access.\n    :return: security_group object\n    '''\n    result = False\n    message = \"\"\n    security_group_name = name + '01'\n    group = None\n    group_id = \"\"\n    message += \"Create security group {0}\\n\".format(security_group_name)\n    message += \"Check to see if security group {0} exists\\n\".format(security_group_name)\n    try:\n        group = network_client.network_security_groups.get(resource_group, security_group_name)\n    except:\n        pass\n\n    if group:\n        message += \"Security group {0} found.\\n\".format(security_group_name)\n        #check_provisioning_state(group)\n        group_id = str(group.id)\n        return {\"result\": True, \"message\": message, \"security_group_name\": security_group_name, \"security_group_name_id\": group_id }\n\n    parameters = NetworkSecurityGroup()\n    parameters.location = location\n\n    if not open_ports:\n        # Open default ports based on OS type\n        if os_type == 'Linux':\n            # add an inbound SSH rule\n            parameters.security_rules = [\n                SecurityRule(protocol='Tcp', source_address_prefix='*', destination_address_prefix='*', access='Allow', direction='Inbound', description='Allow SSH Access',\n                                source_port_range='*', destination_port_range='22', priority=100, name='SSH')\n            ]\n            parameters.location = location\n        else:\n            # for windows add inbound RDP rules\n            parameters.security_rules = [\n                SecurityRule(protocol='Tcp', source_address_prefix='*', destination_address_prefix='*', access='Allow', direction='Inbound', description='Allow RDP port 3389',\n                                source_port_range='*', destination_port_range='3389', priority=100, name='RDP01'),\n                SecurityRule(protocol='Tcp', source_address_prefix='*', destination_address_prefix='*', access='Allow', direction='Inbound', description='Allow RDP port 5986',\n                                source_port_range='*', destination_port_range='5986', priority=101, name='Winrm01'),\n                SecurityRule(protocol='Tcp', source_address_prefix='*', destination_address_prefix='*', access='Allow', direction='Inbound', description='Allow RDP port 5985',\n                                source_port_range='*', destination_port_range='5985', priority=102, name='Winrm02')\n            ]\n    else:\n        # Open custom ports\n        parameters.security_rules = []\n        priority = 100\n        for port in open_ports:\n            priority += 1\n            rule_name = \"Rule_{0}\".format(priority)\n            parameters.security_rules.append(\n                SecurityRule('Tcp', '*', '*', 'Allow', 'Inbound', source_port_range='*',\n                                destination_port_range=str(port), priority=priority, name=rule_name)\n            )\n\n    message += 'Creating default security group {0}\\n'.format(security_group_name)\n    try:\n        poller = network_client.network_security_groups.create_or_update(resource_group,\n                                                                                security_group_name,\n                                                                                parameters)\n        group_id = str(poller.id)\n        result = True\n    except Exception as exc:\n        message += \"Error creating default security rule {0} - {1}\\n\".format(security_group_name, str(exc))\n        result = False\n        \n    return {\"result\": result, \"message\": message, \"security_group_name\": security_group_name, \"security_group_name_id\": group_id }"
  outputs:
    - result
    - message
    - nicID
    - publicIPOut
  results:
    - SUCCESS: '${result=="True"}'
    - FAILURE
