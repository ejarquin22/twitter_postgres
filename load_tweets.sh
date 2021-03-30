files='
test-data.zip
'

for file in $files; do
    # call the load_tweets.py file to load data into pg_normalized
    python3 load_tweets.py --db postgresql://postgres:pass@localhost:16969/postgres --inputs test-data.zip
done

for file in $files; do
    # use SQL's COPY command to load data into pg_denormalized
    unzip -p test-data.zip | sed 's/\\u0000//g' | psql postgresql://postgres:pass@localhost:16939/postgres -c "COPY tweets_jsonb (data) FROM STDIN csv quote e'\x01' delimiter e'\x02';"
done
