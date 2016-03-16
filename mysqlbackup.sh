# /usr/bin/env bash
# Mysql backup script by Ercan TOPALAK

DBLIST="dblist.txt"

DAT=`date +%Y-%m-%d`

if [ ! -f $DBLIST ]; then
        echo $DBLIST not found
        exit 0
fi 

if [ ! -f ~/.my.cnf ]; then
        echo .my.cnf not found
        exit 0
fi 



schemaexport () {
for i in $(cat $DBLIST); do
        echo "$i Schema Export"
        mysqldump --databases --no-data $i > $i.schema.$DAT.sql
        echo "$i Schema Export Done"
done

}

schemaimport () {

for i in $(cat $DBLIST); do
        echo "$i Schema Import"
        mysql < $i.schema.$DAT.sql
        echo "$i Schema Import Done"

done
}

dataimport () {
for i in $(cat $DBLIST); do
        echo "$i Data import Import"
        zcat $i.data.$DAT.sql.gz | mysql $i
        echo "$i Data Import Done"

done
}

dbrestore () {

for i in $(cat $DBLIST); do
        echo "Restoring Database $i RUNNING!"
        zcat $i.backup.$DAT.sql.gz | mysql $i
        echo "Restore $i Done OK!"

done
}

dataexport_masterdata () {
for i in $(cat $DBLIST); do
        echo "$i Data with Master-data Export"
        mysqldump -nt --master-data=2 --single-transaction --quick $i  |  gzip -c > $i.data.$DAT.sql.gz
        echo "$i Data with Master-data Export Done"

done
}

dataexport () {
for i in $(cat $DBLIST); do
        echo "$i Data Export"
        mysqldump -nt --single-transaction --quick $i  |  gzip -c > $i.data.$DAT.sql.gz
        echo "$i Data Export Done"

done
}

dbbackup () {
for i in $(cat $DBLIST); do
        echo "Backup running $i Database RUNNING!"
        mysqldump --single-transaction --databases --quick $i  |  gzip -c > $i.backup.$DAT.sql.gz
        echo "Backup $i database done. OK!"

done
}

innocheck () {
for i in $(cat $DBLIST); do
        echo "$i innocheck"
        sed -i s/MyISAM/InnoDB/g $i.schema.$DAT.sql
        echo "$i innocheck Done"

done
}

IN="$1"

if [[ -z $IN ]]; then

echo -e "
Select Fuctions
1. Schema Export 
2. Data Export 
3. Data Export With Master Data
4. Specific DB Backup 
5. Scheme Restores 
6. Data Restore 
7. Specific DB Restore 
8. InnoDB Check 
"
echo "Choose a fuctions : " 
read FUNC

        if [[ "$FUNC" = 1 ]]; then 
                schemaexport
                elif [[ "$FUNC" = 2 ]]; then
                dataexport
                elif [[ "$FUNC" = 3 ]]; then
                dataexport_masterdata
                elif [[ "$FUNC" = 4 ]]; then
                dbbackup
                elif [[ "$FUNC" = 5 ]]; then
                schemaimport
                elif [[ "$FUNC" = 6 ]]; then
                dataimport
                elif [[ "$FUNC" = 7 ]]; then
                dbrestore
                elif [[ "$FUNC" = 8 ]]; then
                innocheck

                else 
                echo "Incorrect Input."

        fi
else 


                if [[ "$1" = schemaexport ]]; then
                schemaexport
                elif [[ "$1" = schemaimport ]]; then
                schemaimport
                elif [[ "$1" = dataimport ]]; then
                dataimport
                elif [[ "$1" = dbrestore ]]; then
                dbrestore
                elif [[ "$1" = dataexport_masterdata ]]; then
                dataexport_masterdata
                elif [[ "$1" = dataexport ]]; then
                dataexport                
                elif [[ "$1" = dbbackup ]]; then
                dbbackup   
                elif [[ "$1" = innocheck ]]; then
                innocheck   

                else
                        echo "Wrong Fuction. Please select one fuction
schemaexport | schemaimport | dataimport | dbrestore | dataexport_masterdata | dataexport | dbbackup | innocheck"
                fi



fi







#schemaexport
#dataexport