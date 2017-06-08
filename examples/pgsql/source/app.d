import std.stdio;
import db;

import std.experimental.logger;

void main()
{
	writeln("run...");

	Database db = new Database("pgsql://postgres:123456@10.1.11.44:5432/test?charset=utf-8");

	string sql = `INSERT INTO public.test(id, name) VALUES (1, 1);`;
	int result = db.execute(sql);
	writeln(result);
	
    Statement statement = db.query("SELECT * FROM public.test");

	ResultSet rs = statement.fetchAll();

	foreach(row;rs)
	{
		writeln(row);
	}

	db.close();
}
