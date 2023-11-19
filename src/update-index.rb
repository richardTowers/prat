def update_index(conn, mode, object_id, filename)
  # TODO - don't hardcode blob
  conn.exec_params("insert into index (mode, type, object_id, filename) values ($1, 'blob', $2, $3)", [mode, object_id, filename])
end
