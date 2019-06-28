{application, master, [
  {description, "Property based testing"},
  {vsn, "1"},
  {modules,[
    master,
    logger_client, pbt_client,
    logger_logic, generator_logic, pbt_logic,
    logger, pbt_server,
    master_supervisor
  ]},
  {registered, []},
  {applications, [
    kernel,
    stdlib
  ]},
  {mod, {master, []}},
  {env, []}
]}.