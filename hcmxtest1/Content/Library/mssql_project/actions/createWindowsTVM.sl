namespace: mssql_project.actions
flow:
  name: createWindowsTVM
  inputs:
    - vmName_in: WinVM2
    - groupName_in: "${get_sp('azure.GROUP_NAME')}"
  workflow:
    - createAzureGroup:
        do:
          mssql_project.operations.azure.resourceGroup.createAzureGroup:
            - groupName: '${groupName_in}'
        publish:
          - groupName
        navigate:
          - SUCCESS: createStorageAccount
          - FAILURE: on_failure
    - createStorageAccount:
        do:
          mssql_project.operations.azure.storage.createStorageAccount:
            - groupName: '${groupName}'
        publish:
          - storageAccountName
        navigate:
          - SUCCESS: createPublicNicEx
          - FAILURE: on_failure
    - startVM:
        do:
          mssql_project.operations.azure.VM.actions.startVM:
            - vmName: '${vmName}'
            - groupName: '${groupName}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - createPublicNicEx:
        do:
          mssql_project.operations.azure.network.createPublicNicEx:
            - nicName: testPub_2
            - ipName: TestIP1
            - subnetName: testSubnet2
            - vnetName: TestVnet2
            - ipConfigName: TestIPConfName1
            - groupName: '${groupName}'
        publish:
          - nicID
          - publicIPOut
        navigate:
          - SUCCESS: createWindowsFromTemplateVM
          - FAILURE: on_failure
    - createWindowsFromTemplateVM:
        do:
          mssql_project.operations.azure.VM.createWindowsFromTemplateVM:
            - vmName: '${vmName_in}'
            - groupName: '${groupName}'
            - nicID: '${nicID}'
            - storageAccountName: '${storageAccountName}'
        publish:
          - vmName
        navigate:
          - SUCCESS: startVM
          - FAILURE: on_failure
  outputs:
    - outVMName: '${vmName}'
    - outGroupName: '${groupName}'
    - publicIP: '${publicIPOut}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      createAzureGroup:
        x: 80
        'y': 286
      createStorageAccount:
        x: 306
        'y': 286
      createPublicNicEx:
        x: 472
        'y': 295
      startVM:
        x: 976
        'y': 304
        navigate:
          7008ee53-e966-0ac4-1ab2-00d68c7f5e52:
            targetId: 850294cc-d910-a82b-1024-d6ea1c8bf477
            port: SUCCESS
      createWindowsFromTemplateVM:
        x: 725
        'y': 301
    results:
      SUCCESS:
        850294cc-d910-a82b-1024-d6ea1c8bf477:
          x: 1185
          'y': 289
