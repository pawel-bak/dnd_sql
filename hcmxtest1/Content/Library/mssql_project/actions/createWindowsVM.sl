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
          - SUCCESS: createNic
          - FAILURE: on_failure
    - createNic:
        do:
          mssql_project.operations.azure.network.createNic:
            - nicName: azure-sample-nic1
            - groupName: '${groupName}'
        publish:
          - nicID
        navigate:
          - SUCCESS: createWindowsVM
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
  outputs:
    - outVMName: '${vmName}'
    - outGroupName: '${groupName}'
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
      createNic:
        x: 449
        'y': 292
      createWindowsVM:
        x: 652
        'y': 292
      extendOSDisk:
        x: 805
        'y': 291
      startVM:
        x: 976
        'y': 304
        navigate:
          7008ee53-e966-0ac4-1ab2-00d68c7f5e52:
            targetId: 850294cc-d910-a82b-1024-d6ea1c8bf477
            port: SUCCESS
    results:
      SUCCESS:
        850294cc-d910-a82b-1024-d6ea1c8bf477:
          x: 1185
          'y': 289
