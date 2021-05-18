namespace: mssql_project.test
flow:
  name: testPy
  workflow:
    - createWindowsVM:
        do:
          mssql_project.actions.createWindowsVM: []
        publish:
          - outVMName
          - outGroupName
        navigate:
          - FAILURE: on_failure
          - SUCCESS: destroyVM
    - destroyVM:
        do:
          mssql_project.actions.destroyVM:
            - vmName: '${outVMName}'
            - groupName: '${outGroupName}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      createWindowsVM:
        x: 130
        'y': 187.71665954589844
      destroyVM:
        x: 390
        'y': 180.71665954589844
        navigate:
          b4e644df-4839-e830-904f-205e10e01b51:
            targetId: 66172808-3da1-e5f1-f271-03a012c0cbec
            port: SUCCESS
    results:
      SUCCESS:
        66172808-3da1-e5f1-f271-03a012c0cbec:
          x: 599
          'y': 181
