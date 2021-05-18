namespace: mssql_project.test
flow:
  name: testPublicIP
  workflow:
    - createAzureGroup:
        do:
          mssql_project.operations.azure.resourceGroup.createAzureGroup:
            - groupName: "${get_sp('azure.GROUP_NAME')}"
        publish:
          - groupName
        navigate:
          - SUCCESS: createPublicNic
          - FAILURE: on_failure
    - createPublicNic:
        do:
          mssql_project.operations.azure.network.createPublicNic:
            - groupName: '${groupName}'
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
        x: 288
        'y': 204
      createPublicNic:
        x: 459
        'y': 208
        navigate:
          0caf7a1c-4745-bd71-5f60-fb58a12e6e7f:
            targetId: 71251056-246b-7aaf-00d5-d35b3bdb9bf0
            port: SUCCESS
    results:
      SUCCESS:
        71251056-246b-7aaf-00d5-d35b3bdb9bf0:
          x: 646
          'y': 210
