def update_ref(conn, name, commit_id)
  conn.exec_params("insert into refs (name, commit_id) values ($1, $2)", [name, commit_id])
end
