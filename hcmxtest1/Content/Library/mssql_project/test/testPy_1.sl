namespace: mssql_project.test
flow:
  name: testPy_1
  workflow:
    - createNetworkSecurityGroupe_OpenPort:
        do:
          mssql_project.operations.azure.network.security.createNetworkSecurityGroupe_OpenPort:
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
      createNetworkSecurityGroupe_OpenPort:
        x: 189
        'y': 125.18333435058594
        navigate:
          cc4f7b80-80b5-b6c2-9667-7c8777e92166:
            targetId: 66172808-3da1-e5f1-f271-03a012c0cbec
            port: SUCCESS
    results:
      SUCCESS:
        66172808-3da1-e5f1-f271-03a012c0cbec:
          x: 599
          'y': 181
