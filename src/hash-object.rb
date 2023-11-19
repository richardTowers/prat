require 'digest/sha1'

def hash_object(content)
  # https://git-scm.com/book/en/v2/Git-Internals-Git-Objects#_object_storage
  header = "blob #{content.bytesize}\0"
  store = header + content
  Digest::SHA1.hexdigest(store)
end
