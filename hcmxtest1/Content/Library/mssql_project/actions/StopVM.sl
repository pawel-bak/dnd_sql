namespace: mssql_project.actions
flow:
  name: StopVM
  inputs:
    - VMName: testVM1
  workflow:
    - stopVM:
        do:
          mssql_project.operations.azure.VM.actions.stopVM:
            - vmName: '${VMName}'
            - groupName: "${get_sp('azure.GROUP_NAME')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      stopVM:
        x: 110
        'y': 218
        navigate:
          db01bba6-b12b-62f5-7f6c-7b715d53cbb0:
            targetId: cf3d1d6a-76c6-e4b2-3bf1-0e0bc409feda
            port: SUCCESS
    results:
      SUCCESS:
        cf3d1d6a-76c6-e4b2-3bf1-0e0bc409feda:
          x: 267
          'y': 217
