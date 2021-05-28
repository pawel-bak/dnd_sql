namespace: mssql_project.actions
flow:
  name: dummy_provision_test
  inputs:
    - API_URL
    - user
    - password
    - vm_name: TestVM1
  workflow:
    - do_nothing:
        do:
          io.cloudslang.base.utils.do_nothing: []
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - vm_name_out: '${vm_name}'
    - vm_public_ip: 192.168.1.111
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      do_nothing:
        x: 169
        'y': 176.0833282470703
        navigate:
          a172d677-d6a9-f309-e56f-3ddc33f7fe52:
            targetId: 5a233c32-7f8a-5189-438d-486a53f887cc
            port: SUCCESS
    results:
      SUCCESS:
        5a233c32-7f8a-5189-438d-486a53f887cc:
          x: 430
          'y': 173
