namespace: mssql_project.test
flow:
  name: testResourceGroup
  inputs:
    - resourceGroupName: testingGroup
  workflow:
    - createAzureGroup:
        do:
          mssql_project.operations.azure.resourceGroup.createAzureGroup:
            - groupName: '${resourceGroupName}'
        navigate:
          - SUCCESS: destroyAzureGroup
          - FAILURE: on_failure
    - destroyAzureGroup:
        do:
          mssql_project.operations.azure.resourceGroup.destroyAzureGroup:
            - groupName: '${resourceGroupName}'
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
        x: 157
        'y': 178.21665954589844
      destroyAzureGroup:
        x: 336
        'y': 182
        navigate:
          12ac246e-4795-f873-155f-30dd4ce0e730:
            targetId: 2ea6553b-5244-8f03-1e77-7fbf4c74e6c9
            port: SUCCESS
    results:
      SUCCESS:
        2ea6553b-5244-8f03-1e77-7fbf4c74e6c9:
          x: 519
          'y': 182
