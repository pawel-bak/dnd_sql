namespace: mssql_project.actions
flow:
  name: createWindowsVM
  inputs:
    - vmName_in: WinVM1
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
    - createWindowsVM:
        do:
          mssql_project.operations.azure.VM.createWindowsVM:
            - vmName: '${vmName_in}'
            - groupName: '${groupName}'
            - nicID: '${nicID}'
            - storageAccountName: '${storageAccountName}'
        publish:
          - vmName
        navigate:
          - SUCCESS: extendOSDisk
          - FAILURE: on_failure
    - extendOSDisk:
        do:
          mssql_project.operations.azure.storage.extendOSDisk:
            - vmName: '${vmName}'
            - groupName: '${groupName}'
            - extendSize: '50'
        navigate:
          - SUCCESS: startVM
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
            - nicName: testPub_1
            - groupName: '${groupName}'
        publish:
          - nicID
          - publicIPOut
        navigate:
          - SUCCESS: createWindowsVM
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
      startVM:
        x: 976
        'y': 304
        navigate:
          7008ee53-e966-0ac4-1ab2-00d68c7f5e52:
            targetId: 850294cc-d910-a82b-1024-d6ea1c8bf477
            port: SUCCESS
      createWindowsVM:
        x: 652
        'y': 292
      extendOSDisk:
        x: 806
        'y': 291
      createPublicNicEx:
        x: 472
        'y': 295
    results:
      SUCCESS:
        850294cc-d910-a82b-1024-d6ea1c8bf477:
          x: 1185
          'y': 289
