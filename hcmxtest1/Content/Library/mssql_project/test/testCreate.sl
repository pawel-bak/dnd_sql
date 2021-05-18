namespace: mssql_project.test
flow:
  name: testCreate
  workflow:
    - createAzureGroup:
        do:
          mssql_project.operations.azure.resourceGroup.createAzureGroup:
            - groupName: "${get_sp('azure.GROUP_NAME')}"
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
          - SUCCESS: createLinuxVM
          - FAILURE: on_failure
    - createLinuxVM:
        do:
          mssql_project.operations.azure.VM.createLinuxVM:
            - vmName: testVM1
            - groupName: '${groupName}'
            - nicID: '${nicID}'
            - storageAccountName: '${storageAccountName}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
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
      createLinuxVM:
        x: 623
        'y': 299
        navigate:
          96791487-21c6-79d9-d2c7-41e860614e25:
            targetId: 850294cc-d910-a82b-1024-d6ea1c8bf477
            port: SUCCESS
    results:
      SUCCESS:
        850294cc-d910-a82b-1024-d6ea1c8bf477:
          x: 798
          'y': 298
