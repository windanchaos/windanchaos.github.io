#/bin/sh
#blog=$(ls *.md)
#for b in ${blog}
#do
#sed -i '' -e $'48 a\\\n''<!-- more -->' "${b}"
#done
cat line.txt|while read line
do
sed -i '' -e $'48 a\\\n''<!-- more -->' "${line}"
done 
