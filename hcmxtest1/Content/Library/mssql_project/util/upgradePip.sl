namespace: mssql_project.util
flow:
  name: upgradePip
  workflow:
    - upgradePip:
        do:
          mssql_project.operations.upgradePip: []
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      upgradePip:
        x: 123
        'y': 218
        navigate:
          9bc1d8ad-d077-de84-39fd-5be6efef0879:
            targetId: b8c09108-5584-1d9f-92b8-19b33428e534
            port: SUCCESS
    results:
      SUCCESS:
        b8c09108-5584-1d9f-92b8-19b33428e534:
          x: 259
          'y': 226
