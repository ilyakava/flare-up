require 'flare_up'

host_name = 'flare-up-test.cskjnp4xvaje.us-west-2.redshift.amazonaws.com'
db_name = 'dev'
table_name = 'hearthstone_cards'
data_source = 's3://slif-redshift/hearthstone_cards_short_list.csv'

conn = FlareUp::Connection.new(host_name, db_name, ENV['REDSHIFT_USERNAME'], ENV['REDSHIFT_PASSWORD'])

copy = FlareUp::CopyCommand.new(table_name, data_source, ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
copy.columns = ['name', 'cost', 'attack', 'health', 'description']
copy.options = "REGION 'us-east-1' CSV"

result = copy.execute(conn)
