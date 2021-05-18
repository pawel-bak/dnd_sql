namespace: mssql_project.actions
flow:
  name: StartVM
  inputs:
    - VMName: testVM1
  workflow:
    - startVM:
        do:
          mssql_project.operations.azure.VM.actions.startVM:
            - vmName: '${VMName}'
            - groupName: "${get_sp('azure.GROUP_NAME')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      startVM:
        x: 106
        'y': 217.2166748046875
        navigate:
          3059462d-e3b3-8ce8-ba4a-c814a84727b2:
            targetId: cf3d1d6a-76c6-e4b2-3bf1-0e0bc409feda
            port: SUCCESS
    results:
      SUCCESS:
        cf3d1d6a-76c6-e4b2-3bf1-0e0bc409feda:
          x: 267
          'y': 217
