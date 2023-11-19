def log(conn, ref)
  sql = <<~SQL
  with recursive log(id, parent_id, author, message) AS (
      select commits.id, commits.parent_id, commits.author, commits.message
      from refs
      join commits on refs.commit_id = commits.id
      where refs.name=$1
    union all
      select commits.id, commits.parent_id, commits.author, commits.message
      from log
      join commits on log.parent_id = commits.id
  ) select * from log
  SQL

  res = conn.exec_params(sql, [ref])
  res.each_row do |row|
    puts <<~COMMIT
    \x1b[33mcommit #{row[0]}\x1b[m
    Author: #{row[2]}

    #{row[3].split("\n").map{|line| line.prepend("    ")}.join("\n") }
    COMMIT
  end
end
