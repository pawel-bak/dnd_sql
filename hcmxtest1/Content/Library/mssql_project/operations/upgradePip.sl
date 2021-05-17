namespace: mssql_project.operations
operation:
  name: upgradePip
  python_action:
    use_jython: false
    script: "import sys, os\nimport subprocess\n\n# do not remove the execute function \ndef execute(): \n    message = \"\"\n    result = \"\"\n    try:\n        \n        pathname = os.path.dirname(sys.argv[0])\n        message = os.path.abspath(pathname)\n        #subprocess.check_call([sys.executable, \"-m\", \"pip\", \"install\", param])\n        message = subprocess.call([sys.executable, \"-m\", \"pip\", \"list\"])\n        message = subprocess.run([sys.executable, \"-m\", \"pip\", \"install\", \"install\", \"--upgrade\", \"pip\"], capture_output=True)\n        result = \"True\"\n    except Exception as e:\n        message = e\n        result = \"False\"\n    return {\"result\": result, \"message\": message }\n    # code goes here\n# you can add additional helper methods below."
  outputs:
    - result
    - message
  results:
    - SUCCESS: '${result=="True"}'
    - FAILURE
