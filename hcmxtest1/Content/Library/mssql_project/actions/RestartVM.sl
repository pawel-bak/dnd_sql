namespace: mssql_project.actions
flow:
  name: RestartVM
  inputs:
    - VMName: testVM1
  workflow:
    - restartVM:
        do:
          mssql_project.operations.azure.VM.actions.restartVM:
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
      restartVM:
        x: 108
        'y': 209
        navigate:
          83450d17-acdb-9b47-72b3-7027f0c32d65:
            targetId: cf3d1d6a-76c6-e4b2-3bf1-0e0bc409feda
            port: SUCCESS
    results:
      SUCCESS:
        cf3d1d6a-76c6-e4b2-3bf1-0e0bc409feda:
          x: 267
          'y': 217
