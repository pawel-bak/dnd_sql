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
          - SUCCESS: createPublicNicEx
          - FAILURE: on_failure
    - createPublicNicEx:
        do:
          mssql_project.operations.azure.network.createPublicNicEx:
            - nicName: testPub_1
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
      createPublicNicEx:
        x: 453
        'y': 213
        navigate:
          d7b482ca-c465-1802-57b6-1d155d2ac3b3:
            targetId: 71251056-246b-7aaf-00d5-d35b3bdb9bf0
            port: SUCCESS
    results:
      SUCCESS:
        71251056-246b-7aaf-00d5-d35b3bdb9bf0:
          x: 646
          'y': 210
