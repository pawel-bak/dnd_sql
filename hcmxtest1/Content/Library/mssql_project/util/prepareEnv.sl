namespace: mssql_project.util
flow:
  name: prepareEnv
  workflow:
    - upgradePip:
        do:
          mssql_project.util.upgradePip: []
        navigate:
          - SUCCESS: installLib
          - FAILURE: on_failure
    - installLib:
        do:
          mssql_project.util.installLib:
            - lib: azure
        navigate:
          - FAILURE: on_failure
          - SUCCESS: installLib_1
    - installLib_1:
        do:
          mssql_project.util.installLib: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      upgradePip:
        x: 178
        'y': 234.2166748046875
      installLib:
        x: 366
        'y': 240
      installLib_1:
        x: 531
        'y': 243
        navigate:
          e2e43899-bd33-3e6e-f1e7-4fdd61b8851a:
            targetId: 9bccecdb-d5de-b47c-20d1-b39a80b1b763
            port: SUCCESS
    results:
      SUCCESS:
        9bccecdb-d5de-b47c-20d1-b39a80b1b763:
          x: 741
          'y': 248
