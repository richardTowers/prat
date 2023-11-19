require 'date'
require_relative 'hash-object.rb'

def commit_tree(conn, parent_id, tree_id, author, message)
  commit = ""
  commit << "tree #{tree_id}\n"
  commit << "parent #{parent_id}\n" unless parent_id.nil?
  timestamp = "#{Date.today().to_time.to_i} +000"
  commit << "author #{author} #{timestamp}\n"
  commit << "committer #{author} #{timestamp}\n"
  commit << ""
  commit << message

  id = hash_object(commit, conn, type="commit")

  conn.exec_params(
    "insert into commits (id, parent_id, tree_id, author, message) values ($1, $2, $3, $4, $5)",
    [id, parent_id, tree_id, author, message]
  )

  id
end
