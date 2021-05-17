namespace: mssql_project.subflows
flow:
  name: generate_parameters
  workflow:
    - do_nothing:
        do:
          io.cloudslang.base.utils.do_nothing: []
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      do_nothing:
        x: 143
        'y': 133
        navigate:
          445fe8e3-8571-81a3-742a-3ca41a423e4e:
            targetId: d0265ac9-2bee-228c-542a-e51fb8a71424
            port: SUCCESS
    results:
      SUCCESS:
        d0265ac9-2bee-228c-542a-e51fb8a71424:
          x: 350
          'y': 135
