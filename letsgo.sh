#!/bin/bash
year=2011
echo "Running DUBSTEP.FM Ripper"

echo "Retrieving page source variables"
pagesource=$(wget archive.dubstep.fm/$year -q -O -)

echo "Extracting page count"
pageno=($(echo $pagesource | sed -n '/pagination.*/{ s/<div class="pagination"><div><ul><li><span>/%%%/;s/^.*%%%//; s/<\/span.*//; p; }'))
pageno=${pageno[2]}

echo "There are $pageno pages in total"

pagelinks=()

for (( i=1; i<$((pageno+1)); i++  ))
do
	echo "Obtaining page $i links"
	tmp_page=$(wget archive.dubstep.fm/$year/page/$i -q -O - | sed -n '/<div class="post-thumb"><a href=".*/{ s/<div class="post-thumb"><a href="/%%%/;s/^.*%%%//; s/".*//; p; }')
	pagelinks+=($(echo $tmp_page | tr " " " "))
done

# go through all links and extract/download mp3..
echo "Starting downloads"
for i in "${pagelinks[@]}"
do
	mp3=$(wget "$i" -q -O - | sed -n '/source type="audio\/mpeg" src=".*/{ s/source type="audio\/mpeg" src="/%%%/;s/^.*%%%//; s/".*//; p; }')
	wget "$mp3"
done
