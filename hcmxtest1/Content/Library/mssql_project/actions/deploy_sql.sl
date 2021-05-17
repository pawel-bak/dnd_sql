namespace: mssql_project.actions
flow:
  name: deploy_sql
  workflow:
    - generate_parameters:
        do:
          mssql_project.subflows.generate_parameters: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      generate_parameters:
        x: 86
        'y': 111
        navigate:
          c8e0f4f7-2f07-521f-a431-e5b1efaeca64:
            targetId: c59c391a-5fe0-46fe-a13e-ad8a79791c84
            port: SUCCESS
    results:
      SUCCESS:
        c59c391a-5fe0-46fe-a13e-ad8a79791c84:
          x: 434
          'y': 117
