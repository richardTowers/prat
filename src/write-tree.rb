require_relative 'hash-object.rb'

def write_tree(conn)
  conn.transaction do |conn|
    tree = ""
    res = conn.exec("select mode, type, object_id, filename from index")
    return if res.num_tuples.zero?

    res.each_row do |row|
       tree << "#{row[0]} #{row[1]} #{row[2]}\t#{row[3]}\n"
    end
    id = hash_object(tree, conn, "tree")
    sql = <<~SQL
    insert into trees (id, mode, type, object_id, filename)
    select $1, mode, type, object_id, filename from index
    SQL
    conn.exec_params sql, [id]
    conn.exec "delete from index"
    id
  end
end

