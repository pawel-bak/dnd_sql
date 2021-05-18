namespace: mssql_project.actions
flow:
  name: destroyVM
  inputs:
    - vmName
    - groupName
  workflow:
    - stopVM:
        do:
          mssql_project.operations.azure.VM.actions.stopVM:
            - vmName: '${vmName}'
            - groupName: '${groupName}'
        navigate:
          - SUCCESS: deleteVM
          - FAILURE: on_failure
    - deleteVM:
        do:
          mssql_project.operations.azure.VM.deleteVM:
            - vmName: '${vmName}'
            - groupName: '${groupName}'
        navigate:
          - SUCCESS: destroyAzureGroup
          - FAILURE: on_failure
    - destroyAzureGroup:
        do:
          mssql_project.operations.azure.resourceGroup.destroyAzureGroup:
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
      stopVM:
        x: 123
        'y': 140
      deleteVM:
        x: 324
        'y': 145
      destroyAzureGroup:
        x: 516
        'y': 145
        navigate:
          8fd8ceca-4daf-f34f-c332-6ff6ff425d49:
            targetId: c1a79244-6c88-3cda-d288-1d3a327aaed0
            port: SUCCESS
    results:
      SUCCESS:
        c1a79244-6c88-3cda-d288-1d3a327aaed0:
          x: 722
          'y': 142
