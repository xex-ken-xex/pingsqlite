# -*- coding: utf-8 -*-
require 'date'
require 'net/ping'
require 'sqlite3'

address = 'www.google.com'
sqlitefile = './test.db'
repertcount = 100

db = SQLite3::Database.new sqlitefile
sql = <<-SQL
  create table ping (
    id INTEGER primary key,
    creat_at TEXT,
    hostname TEXT,
    duration REAL 
  );
SQL
begin
    db.execute(sql)
rescue => e
    p e
end

pinger = Net::Ping::External.new(address)

begin
    repertcount.times { |count|
        if pinger.ping?
            db.execute('insert into ping (creat_at,hostname,duration) values (?,?,?)', DateTime.now.to_s, pinger.host, pinger.duration)
            print("#{count} / #{repertcount} host:#{pinger.host} duration:#{pinger.duration}ms\n")
            sleep(1)
        else
            print("#{count} / #{repertcount} host:#{pinger.host} unreachable...\n")
        end
    }
rescue => e
    p e
end

db.execute('select * from ping') do |row|
    p row
end
