require 'pg'

def init
  # TODO - make it so there can be more than one prat repository per postgres instance
  # TODO - allow database credentials
  conn = PG.connect( dbname: 'prat' )
  create_tables(conn)
end

def create_tables(conn)
  create_objects(conn)
  create_trees(conn)
  create_commits(conn)
  create_refs(conn)
end

def create_objects(conn)
  conn.exec( "create table if not exists objects (id text, value text)")
end

def create_trees(conn)
  conn.exec( "create table if not exists trees (id text, mode text, type text, object_id text, filename text)")
end

def create_commits(conn)
  conn.exec( "create table if not exists commits (id text, parent_id text, tree_id text, author text, message text)")
end

def create_refs(conn)
  conn.exec( "create table if not exists refs (name text, commit_id text)")
end


