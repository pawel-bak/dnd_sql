namespace: mssql_project.test
flow:
  name: testPy
  workflow:
    - installViaPip:
        do:
          mssql_project.operations.installViaPip:
            - param: azure
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      installViaPip:
        x: 113
        'y': 183
        navigate:
          0c831be0-152b-35b6-b754-11d457fa9457:
            targetId: 66172808-3da1-e5f1-f271-03a012c0cbec
            port: SUCCESS
    results:
      SUCCESS:
        66172808-3da1-e5f1-f271-03a012c0cbec:
          x: 358
          'y': 194
