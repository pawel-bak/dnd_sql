namespace: mssql_project.util
flow:
  name: installLib
  inputs:
    - lib: Haikunator
  workflow:
    - installViaPip:
        do:
          mssql_project.operations.installViaPip:
            - param: '${lib}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      installViaPip:
        x: 65
        'y': 205
        navigate:
          462e3a27-33c9-f73c-ad2f-dd53f89974c5:
            targetId: f67aaee7-fe87-b22c-f6e9-412ccfdf9a34
            port: SUCCESS
    results:
      SUCCESS:
        f67aaee7-fe87-b22c-f6e9-412ccfdf9a34:
          x: 235
          'y': 205
