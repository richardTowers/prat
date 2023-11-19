require 'digest/sha1'

def hash_object(content, conn, type="blob")
  # https://git-scm.com/book/en/v2/Git-Internals-Git-Objects#_object_storage
  header = "#{type} #{content.bytesize}\0"
  store = header + content
  hash = Digest::SHA1.hexdigest(store)

  conn.exec_params("insert into objects (id, value) values ($1, $2)", [hash, content])

  hash
end
